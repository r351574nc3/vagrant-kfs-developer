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
		comment    => 'kuali',
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

    file { "${workspace}" : 
        ensure  => directory,
        owner   => "kuali",
        notify  => Exec['svn-checkout-kfs']
    }		

    exec { "svn-checkout-kfs" :
	    command  => "svn co https://svn.kuali.org/repos/kfs/trunk ${workspace}/kfs-5.0",
	    creates  => "${workspace}/kfs-5.0",
	    require  => File["${workspace}"]
    }

    exec { "svn-checkout-impex" :
	    command  => "svn co https://svn.kuali.org/repos/foundation/db-utils/branches/comment-extraction ${workspace}/kul-cfg-dbs",
	    creates  => "${workspace}/kul-cfg-dbs",
	    require  => File["${workspace}"]
    }

    exec { "svn-checkout-kfs-cfg-dbs" :
	    command  => "svn co http://svn.kuali.org/repos/kfs/legacy/cfg-dbs/branches/release-5-0/ ${workspace}/kfs-cfg-dbs",
	    creates  => "${workspace}/kfs-cfg-dbs",
	    require  => File["${workspace}"]
    }

    exec { "chown-workspace" :
        command => "chown -R kuali:kuali ${workspace}",
        unless  => "[ `stat -c %U ${workspace}` == kuali ]",
        require => Exec['svn-checkout-kfs-cfg-dbs'],
    }
}

include kuali
include java
include eclipse