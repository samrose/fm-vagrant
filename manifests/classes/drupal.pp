class drupal {
	include fm_mysql
	include fm_apache_php
	include fm_compass


	# create the main web directory parent
	file { "/var/www":
		ensure => "directory"
	}

	# Create an apache virtual host
	apache::vhost { $fqdn:
		priority        => '10',
		vhost_name      => '*',
		port            => '80',
		docroot         => "/var/www/${fqdn}/",
    override        => 'All',
		serveradmin     => "admin@${fqdn}",
		serveraliases   => ["www.${fqdn}",],
		notify => Exec['reload apache']
	}


	# reload apache
	exec {'reload apache':
		command => "/etc/init.d/apache2 reload",
		refreshonly => true,
	}

	# update /etc/hosts file
	host { '/etc/hosts clean':
		ip => '127.0.1.1',
		name => $hostname,
		ensure => absent
	}

	# set the aliased virtual host to the first network interface. vagrant sets this
	# If you need this externally accessible ensure you have a working setup on
	# eth1 (via bridged networking and change ip to $ipaddress_eth1)
	host { '/etc/hosts drupal':
		ip => $ipaddress_eth0,
		ensure => present,
		name => $fqdn,
		host_aliases => ["www.${fqdn}", $hostname],
	}
}
