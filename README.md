Forked following this http://bitdrift.com/post/4534738938/fork-your-own-project-on-github

Install rvm, nvm

```sh
sudo apt-get install imagemagick
nvm install 0.12
nvm use 0.12
rvm install 2.2
rvm use 2.2
gem install bundle
bundle install
cd _generate
./launch_jekyll.sh
```

To test:
```sh
sudo apt-get install apache2
```

Sample config file (`/etc/apache2/sites-available/001-gatillos.conf`)
```
<VirtualHost *:80>
	ServerAdmin webmaster@localhost
        ServerName gatillos.127.0.0.1.xip.io
	ErrorLog ${APACHE_LOG_DIR}/error-gatillos.log
	CustomLog ${APACHE_LOG_DIR}/access-gatillos.log combined
        Alias "/yay/" "/home/osuka/Documents/code/gatillos.com-private/_site/"
	<Directory /home/osuka/Documents/code/gatillos.com-private/_site/>
          Order allow,deny
          Allow from 127.0.0.1
          AllowOverride All
          Require all granted
        </Directory>
</VirtualHost>
```
