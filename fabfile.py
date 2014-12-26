from fabric.api import *
from fabric.decorators import task
from fabric.tasks import Task

from paramiko import Transport
from socket import getdefaulttimeout, setdefaulttimeout

env.user = 'core'

class SkipIfOfflineTask(Task):
    def __init__(self, func, *args, **kwargs):
        super(SkipIfOfflineTask, self).__init__(*args, **kwargs)
        self.func = func

    def run(self, *args, **kwargs):
        original_timeout = getdefaulttimeout()
        setdefaulttimeout(3)
        try:
            Transport((env.host, int(env.port)))
            return self.func(*args, **kwargs)
        except:
            print "Skipping offline host: " + env.host_string
        setdefaulttimeout(original_timeout)

@task
def set_hosts(hostfile='allhosts'):
    """ read and set up server list from file """

    remote_servers = []

    file = open(hostfile, 'r')
    for line in file.readlines():
        remote_servers.append(line.strip('\r\n'))

    env.hosts = remote_servers

@task(task_class=SkipIfOfflineTask)
def bootstrap():
    """ init world """

    with settings(warn_only=True):
        run("docker pull tomlanyon/flannel-install >/dev/null 2>&1")
        run("docker run --rm -v /opt/bin:/host tomlanyon/flannel-install")

@task(task_class=SkipIfOfflineTask)
def deploy_binaries():
    """ deploy pre-built executables """
    sudo('mkdir -p /opt/bin')
    put('./bin/*', '/opt/bin', use_sudo=True, mirror_local_mode=True)
    put('./scripts/*', '/opt/bin', use_sudo=True, mirror_local_mode=True)

@task(task_class=SkipIfOfflineTask)
def deploy_common_services():
    """ deploy common service files """
    put('./minion/*', '/etc/systemd/system', use_sudo=True)
    sudo('source /etc/environment')
    sudo('/opt/bin/substitute_private_ipv4.sh /etc/systemd/system/flannel.service')
    sudo('/opt/bin/substitute_private_ipv4.sh /etc/systemd/system/kubelet.service')

    sudo('systemctl enable /etc/systemd/system/flannel.service')
    sudo('systemctl enable /etc/systemd/system/docker.service')
    sudo('systemctl enable /etc/systemd/system/kube-proxy.service')
    sudo('systemctl enable /etc/systemd/system/kubelet.service')

    sudo('systemctl daemon-reload')

    sudo('systemctl start flannel')
    sudo('systemctl start docker')
    sudo('systemctl start kube-proxy')
    sudo('systemctl start kubelet')

@task(task_class=SkipIfOfflineTask)
def deploy_minion():
    """ deploy minion node """
    deploy_binaries()
    deploy_common_services()

@task(task_class=SkipIfOfflineTask)
def deploy_master():
    """ deploy master node """
    put('./master/*', '/etc/systemd/system', use_sudo=True)
    sudo('/opt/bin/substitute_machines.sh /etc/systemd/system/kube-apiserver.service')

    sudo('systemctl enable /etc/systemd/system/kube-apiserver.service')
    sudo('systemctl enable /etc/systemd/system/kube-controller-manager.service')

    sudo('systemctl daemon-reload')

    sudo('systemctl start kube-apiserver')
    sudo('systemctl start kube-controller-manager')
