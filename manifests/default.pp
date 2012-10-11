class kuali {
	$home      = "/home/kuali"
	$workspace = "${home}/workspace"

    Exec {
         path => "/home/vagrant/.rvm/gems/ruby-1.9.3-p194/bin:/home/vagrant/.rvm/gems/ruby-1.9.3-p194@global/bin:/home/vagrant/.rvm/rubies/ruby-1.9.3-p194/bin:/home/vagrant/.rvm/bin:/usr/lib64/ccache:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/vagrant/.rvm/bin:/sbin:/usr/sbin:/home/vagrant/.local/bin:/home/vagrant/bin"
     }

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