Install Rails production environment on Ubuntu
==============================================

# curl -L get.rvm.io | bash -s stable
# source /etc/profile.d/rvm.sh
# usermod -a -G rvm USERNAME

# rvm requirements
# rvm list known # pick your ruby
# rvm install 1.9.3
# rvm --default use 1.9.3 # to use that as default

# gem install passenger
# passenger-install-apache2-module # (or nginx if you're lucky)
# # follow instructions, run apt-get to satisfy requirements, edit confs, etc.
