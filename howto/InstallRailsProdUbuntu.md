Install Rails production environment on Ubuntu
==============================================

$ curl -L get.rvm.io | sudo bash -s stable
$ sudo usermod -a -G rvm lauri
$ sudo rvm requirements
$ rvm install 1.9.3
$ rvm --default use 1.9.3 # to use that as default
$ gem install passenger
$ sudo passenger-install-apache2-module

(# passenger-install-apache2-module # (or nginx if you're lucky))
# # follow instructions, run apt-get to satisfy requirements, edit confs, etc.

you will probably need to install execjs supported runtime such as
therubyracer (add to Gemfile) or nodeJS

mysql.h needs to be installed for Mysql support

git maybe for git-based gems
