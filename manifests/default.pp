class kuali {
	$home      = "/home/kuali"
	$workspace = "${home}/workspace"

    group { "eclipse":
        ensure => present,
    }

	user { "kuali":
		groups     => 'kuali',
		password   => ['kuali', 'wheel', 'admin', 'eclipse'],
		comment    => 'This user was created by Puppet',
		ensure     => present,
		provider   => 'useradd',
		managehome => true
	}

	package { "subversion" : 
		ensure => installed
	}

	package { "tomcat" :
		ensure => installed
	}

    file { $workspace: 
        ensure  => directory,
        require => Exec["svn-checkout-kfs"],
    }		

    exec { "svn-checkout" :
	    command => "svn co https://svn.kuali.org/repos/kfs/trunk ${workspace}/kfs-5.0",
	    creates => "${workspace}/kfs-5.0",
	    refreshonly => true,
    }
}

include kuali
include java
include eclipse