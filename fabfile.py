from fabric.api import env, run, sudo, local
import time, os


def production():
    print '!! Connecting to \033[1;42m PRODUCTION \033[0m'


def test():
    print '!! Connecting to TEST SERVER.'
    env.local_folder = '/home/something/project'
    env.server_folder = '/var/www/html/'
    env.host = '192.168.1.11'
    env.server_user = 'serveradmin'


def sync():
	rsync = "rsync -vauz %(local_folder)s %(server_user)s@%(host)s:%(server_folder)s" % env
	print rsync
	os.system(rsync)


def update():
    for cmd in env.extra_cmds:
        run(cmd)

    for f in env.wsgi_files:
        env.wsgi_file = f
        sudo('kill -HUP `cat %s`' % f) # restart the uwsgi
# up = update


def setup():
   # if sudo('mkdir -p %(path)s;' % env):
   if sudo('cd %(root)s; git clone %(git)s %(folder)s' % env):
       sudo('chown -R %(user)s:%(group)s %(path)s;' % env)
   sudo('cd %(path)s; cd ../; virtualenv .;' % env)
   install_requirements()


def install_requirements():
    """Install the required packages using pip & requirements.txt"""
    sudo('cd %(root)s; pip install -E . --enable-site-packages -r %(folder)s/requirements.txt' % env)