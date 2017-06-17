# Vagrant Box for default WordPress instance with CLI

The following steps will describe how to install a new Virtual machine using Vagrant. This machine contains:

- Apache 2 web server
- MySQL
- PHP 7
- phpMySQL
- Git
- Composer
- WordPress

## Requirements
Oracle VirtualBox: https://www.virtualbox.org/wiki/Downloads
Vagrant: https://www.vagrantup.com/downloads.html


## First run 

1. In your hosts file, add the following entries:

	`192.168.56.111     wp-cli.local`

	`192.168.56.111     phpmyadmin.wp-cli.local`

	Choose the IP address to be something unique! (but both should be the same)

2. Create a folder in which to place your project, e.g. **C:\Projects\WP-CLI**

3. Clone this repo (https://github.com/senff/wp-cli.git) into the this folder

4. OPTIONAL: if you're not using 192.168.56.111 as the IP address for your site, open **Vagrantfile** in a text editor, and edit line 12 to reflect the IP address you chose in step 1:

	`config.vm.network "private_network", ip: "192.168.56.111"`

5. OPTIONAL: if you're not using `wp-cli.local` as the URL for your site, open **config/wordpress.conf** in a text editor and change line 2 to reflect the URL you chose in step 1:

	`ServerName wp-cli.local`

	Also change it on line 134 of **/vagrant/shellprovider.sh**

6. OPTIONAL: if you're not using `phpmyadmin.wp-cli.local` as the URL for phpMyAdmin, open **config/phpmyadmin.conf** in a text editor and change line 2 to reflect the URL you chose in step 1:

	`ServerName phpmyadmin.wp-cli.local`

7. On the command line, go to your vagrant folder, e.g. **C:\Projects\WP-CLI\vagrant** and type `vagrant up` to build the machine. 

	After the system is done configuring (5-10 minutes), you should be able to access your site in your browser at http://wp-cli.local (or whatever URL you set in step 1).



## Default usernames and passwords

* To access your server using SSH (or FTP), use username `vagrant` with password `vagrant`.

* To access your WordPress admin, use username `wp` with password `wp`.

* To access phpMyAdmin, use username `root` with no password.

* Database: `wordpress` - user: `wordpress` - password: `JRTsZneZyrc2`


## Where to change the default usernames and passwords

For added security, change the usernames and passwords before you install the virtual machine.

* WordPress admin: **/vagrant/shellprovider.sh**, line 134
* Database details: **/vagrant/shellprovider.sh**, lines 120, 121, 122, 133

