#coding=utf-8
# Change these settings to reflect the production location
# and where the code is. 

# Ensure that LIVE and TEST users have the public key of deploy@git.foo.fi
# in their .ssh/authorized_keys so that the deploy user can copy the latest files
# without asking for password each time

# Possible future plans (TODO)
# - detect package.json presence and run npm install on deployment server
# - same for rails and python

ENVIRONMENTS = {

    'live': {
        'user': None, # set to None to use your username written in lowercase
        # 'user': 'myuser',
        'server': 'dev.foo.fi',
        'path': '/var/www/foo-dev/deploy-test-live',
        # Set this to True if the server does not have rsync installed and we'll need to retreat to scp
        'use_scp': False
    },

    'test': {
        'user': None, # set to None to use your username written in lowercase
        'server': 'dev.foo.fi',
        'path': '/var/www/foo-dev/deploy-test-test',
        'use_scp': False
    },

    'playground': {
        'user': 'deploy',
        'server': 'playground.foo.fi',
        'path': '/var/www/deploy-test',
        'use_scp': False
        # Define extra SSH Options (currently only supported for RSYNC, so no scp, no ftp).
        # Here changes port to 8022, ignores hosts file checks
        # 'ssh-options': '-p 8022 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
    },

    # FTP support!
    'myftpserver': {
        'user': 'fptusername',
        'server': 'ftp://ftp.foo.com', # ftp:// required to detect protocol!
        'path': '/ftpdirectory/foo/baz',
        # password needed (no public key auth for ftp), but fabfile won't be copied
        # so credentials are not on the other server
        'ftp_password': 'mysecret'
    }

}

# The git repository
GIT = {
    'repo': 'BlackBox.git',

    # Set this if you don't want to deploy the whole git repo, but just a subfolder.
    # If not needed, set to ''.
    'subfolder': 'recipe_printer'
}


############################## HERE BE DRAGONS ######################
# How this works: 
# Git repository on the GIT server is cloned to a temporary directory
# and rsynced to the production server. This has several benefits to
# cloning directly on the production server:
# - no need for git install on production
# - no version data, clean directory on production
# - no access from production server to the git server
#
# Some considerations:
# - deploy user needs to be installed on git server and needs to have
#   NOPASSWD access to commands "git" and "mkdir" under the git user
# - rsyncing the files requires that PRODUCTION_SERVER_USER has the
#   public key of GIT_SERVER_DEPLOY_USER to allow passwordless login
#
# /etc/sudoers change:
# deploy          ALL=(git) NOPASSWD: /usr/bin/git, /bin/mkdir

from fabric.api import local, run, abort, cd, env, settings, hide
from fabric.colors import *

# Location of Git server (usually you don't need to change this)
GIT_SERVER = 'git.foo.fi'
GIT_LOCAL_REPOSITORIES_PATH = '/home/git/repositories'
GIT_SERVER_DEPLOY_USER = 'deploy'

# use the current username if no server user is given
for key, e in ENVIRONMENTS.items():
    if not e['user']:
        import os
        e['user'] = os.environ.get('USER')
        if not e['user']:
            e['user'] = os.environ.get('USERNAME') 
        e['user'] = e['user'].lower()
        e['user'] = e['user'].replace('.', '') # for windows users who might have a dot in their usernames

env.hosts = ["%s@%s" % (GIT_SERVER_DEPLOY_USER, GIT_SERVER)]
# env.cwd = GIT_LOCAL_REPOSITORIES_PATH # affects direct commands like "fab -- ls"


def run_tests():
    local('ls')
    raise NotImplementedError('should code')


def _get_deploy_env(environment=None):
    if not environment or not ENVIRONMENTS.has_key(environment):
        abort("You didn't tell me where to deploy. Please say deploy:ENVIRONMENT, where ENVIRONMENT can be one of: %s." % ", ".join(ENVIRONMENTS.keys()))
    return ENVIRONMENTS[environment]


def npm_install(environment=None):
    """ Run npm install inside the destination directory of the given deployment environment """
    env_settings = _get_deploy_env(environment)
    npm_path = env_settings['npm_path'] if env_settings.has_key('npm_path') else '/usr/bin/npm'
    production_server = "%s@%s" % (env_settings['user'], env_settings['server'])
    run("ssh %s 'pushd %s && hostname && %s install'" % (production_server, env_settings['path'], npm_path))


def deploy(environment=None):
    """ Clone the git into a tmp folder (or pull latest changes if folder exists)
        and rsync the content to the deployment location """

    env_settings = _get_deploy_env(environment)

    if environment == 'live':
        print(red("### Yeeehaaa! Using LIVE settings ###"))

    # check that our root location exists
    tmp_root = '/tmp/checkouts'
    with settings(hide('warnings'), warn_only=True):
        if run("test -d %s" % tmp_root).failed:
            run("sudo -u git mkdir %s" % tmp_root)

    # clone or pull latest from git
    tmp_clone = "%s/%s" % (tmp_root, GIT['repo'])
    git_path = "%s/%s" % (GIT_LOCAL_REPOSITORIES_PATH, GIT['repo'])
    cloned_new_path = False
    with settings(hide('warnings'), warn_only=True): 
        if run("test -d %s" % tmp_clone).failed:
            print(yellow("Cloning a new repository under %s..." % tmp_clone))
            run("sudo -u git git clone %s %s" % (git_path, tmp_clone))
            cloned_new_path = True
            
    if not cloned_new_path:
        print(yellow("Pulling latest changes into %s..." % tmp_clone))
        with cd(tmp_clone):
            run('sudo -u git git pull')
    
    # now we can start to deal with the product to the deployed
    if GIT['subfolder']:
        tmp_clone = "%s/%s" % (tmp_clone, GIT['subfolder'])
        
    # write out a RELEASE file to allow checking the currently active version
    print(yellow("Writing version information to RELEASE file..."))
    with cd(tmp_clone):
        run('sudo -u git git log -n 1 --oneline | sudo -u git tee RELEASE')
    
    print(green("Successfully fetched the latest version"))
      
    # we have the newest shait, now just rsync it to the production server
    production_path = "%s@%s:%s" % (env_settings['user'], env_settings['server'], env_settings['path'])
    if env_settings['server'].startswith('ftp://'):
        print "Using (L)FTP instead of Rsync :("
        run("lftp -e 'lcd %s; mirror -R -e -x ^.git/$ -x fabfile.py*; bye' -u %s,%s %s%s" %
            (tmp_clone, env_settings['user'], env_settings['ftp_password'], env_settings['server'], env_settings['path']))
    if env_settings.has_key('use_scp') and env_settings['use_scp']:
        print "Using SCP instead of Rsync :("
        run('scp -r %s/* %s' % (tmp_clone, production_path))
        # clean up by removing fabfile.py from the destination server
        # .git is not picked up by scp, so no worries there
        run('ssh %s@%s \'rm %s/fabfile.py\'' % (env_settings['user'], env_settings['server'], env_settings['path']))
    else:
        if env_settings.has_key('ssh-options'):
            ssh_cmd = '-e "ssh %s" ' % env_settings['ssh-options']
        else:
            ssh_cmd = ""
        run('rsync -auz --no-p --exclude=.git* --exclude=fabfile.py ' + 
            ssh_cmd + 
            '%s/* %s' % 
            (tmp_clone, production_path))

    print(green('Deployed successfully'))
