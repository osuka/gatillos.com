gatillos.com website
====================

This is the source code to generate the files in [https://gatillos.com](https://gatillos.com).

Setting up the environment
--------------------------

This site is all static HTML pages, and it's generated using [Jekyll](https://jekyllrb.com/).

There's a fair bit of preparation need to be able to generate it:

```sh

# There's a number of image conversions going on,
# including thumbnail generation - we use imagemagick for that

# Install imagemagick on linux (check their site for other systems)
sudo apt-get install imagemagick

# Install ruby (using [rvm](https://rvm.io/))
rvm install 2.4
rvm use 2.4

# Install jekyll and other ruby dependencies
gem install bundle
bundle install
```

Generating the site
-------------------

In order to actually generate the site, run the following
```
cd _generate
./launch_jekyll.sh
```

The site is generated under the folder `_site`.

Configuring apache to run the site locally
------------------------------------------

To test locally, install a web server like apache
```sh
sudo apt-get install apache2
```

Add a configuration file pointing to the `_site` folder generated above.
You will need to configure apache to support SSL as the `.htaccess` file
contains a redirect to ssl (you can also just edit that file to disable it).

Sample config file (`/etc/apache2/sites-available/gatillos.conf`)
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

Sample config file (`/etc/apache2/sites-available/gatillos.conf`)
```
<VirtualHost *:443>
	ServerAdmin webmaster@localhost
        ServerName gatillos.127.0.0.1.xip.io
	ErrorLog ${APACHE_LOG_DIR}/error-gatillos.log
	CustomLog ${APACHE_LOG_DIR}/access-gatillos.log combined
        Alias "/yay/" "/home/oamat/Documents/code/gatillos.com-private/_site/"
	<Directory /home/osuka/Documents/code/gatillos.com-private/_site/>
          Order allow,deny
          Allow from 127.0.0.1
          AllowOverride All
          Require all granted
        </Directory>
        SSLEngine on

        # Ubuntu/debian have a self-signed (snakeoil) certificate installed
        # via the ssl-cert package. We use that for testing
        SSLCertificateFile	/etc/ssl/certs/ssl-cert-snakeoil.pem
        SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key
</VirtualHost>
```

Now we can access the site at [https://gatillos.127.0.0.1.xip.io/yay/](https://gatillos.127.0.0.1.xip.io/yay/).

> xip.io is a very simple DNS-based service that returns a fixed IP extracted from the name you lookup. So in this case it is returning '127.0.0.1' (=localhost). Check [xip.io's site](http://xip.io) for more details. It is a nice way to have multiple sites running on the same IP address for testing but being able to use the same port and different ServerName entries in Apache.
