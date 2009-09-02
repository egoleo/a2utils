#! /usr/bin/perl

use strict;
use warnings;

my %config = (
    'vhost_dir' => '/srv/www'
);

my $usage = <<EOU;
usage: $0 host

Sets up a new virtual host. 
EOU

die $usage unless scalar(@ARGV) == 1;

my $host = $ARGV[0];
my $host_dir = $config{'vhost_dir'} . "/$host";
my $docroot = $host_dir . "/htdocs";
mkdir $host_dir;
mkdir $docroot;

my (undef, undef, $uid, $gid) = getpwnam("www-data");
chown $uid, $gid, $docroot;

open FILE, ">/etc/apache2/sites-available/$host" or die $!;

print FILE <<EOT;
<VirtualHost *>
    ServerAdmin		postmaster\@$host
    ServerName		$host

    DocumentRoot	$docroot

    <Directory $docroot>
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
