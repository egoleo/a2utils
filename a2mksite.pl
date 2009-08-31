#! /usr/bin/perl

use strict;
use warnings;

my $template = <<EOT;
EOT

my $usage = <<EOU;
usage: $0 host

Sets up a new virtual host. 
EOU

die $usage unless scalar(@ARGV) == 1;

my $host = $ARGV[0];
mkdir "/srv/www/$host";
mkdir "/srv/www/$host/htdocs";
# TODO: chown htdocs directory

open FILE, ">/etc/apache2/sites-available/$host" or die $!;

print FILE <<EOT;
<VirtualHost *>
    ServerAdmin		postmaster\@$host
    ServerName		$host

    DocumentRoot	/srv/www/$host/htdocs

    <Directory>
	Options		Indexes FollowSymLinks MultiViews
	AllowOverride	None
	Order		allow,deny
	allow from all
    </Directory>

    ErrorLog		/var/log/apache2/$host-error.log
    CustomLog		/var/log/apache2/$host-access.log combined
</VirtualHost>
EOT

close FILE;

my $ret = system("a2ensite", $host);
system("/etc/init.d/apache2", "reload");
