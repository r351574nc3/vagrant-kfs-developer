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

	package { "mysql-server" :
		ensure => installed
	}

	service { "mysqld" :
		ensure  => running,
		enable  => true,
		require => Package["mysql-server"]
	}

    file { "${workspace}" : 
        ensure  => directory,
        owner   => "kuali",
        notify  => Exec['svn-checkout-kfs']
    }		

    exec { "svn-checkout-kfs" :
	    command  => "svn co https://svn.kuali.org/repos/kfs/trunk ${workspace}/kfs-5.0",
	    creates  => "${workspace}/kfs-5.0",
	    timeout  => "720",
	    require  => File["${workspace}"]
    }

    exec { "svn-checkout-impex" :
	    command  => "svn co https://svn.kuali.org/repos/foundation/db-utils/branches/comment-extraction ${workspace}/kul-cfg-dbs",
	    creates  => "${workspace}/kul-cfg-dbs",
	    timeout  => "720",
	    require  => File["${workspace}"]
    }

    exec { "svn-checkout-kfs-cfg-dbs" :
	    command  => "svn co http://svn.kuali.org/repos/kfs/legacy/cfg-dbs/branches/release-5-0/ ${workspace}/kfs-cfg-dbs",
	    creates  => "${workspace}/kfs-cfg-dbs",
	    timeout  => "720",
	    require  => File["${workspace}"]
    }

    exec { "chown-workspace" :
        command => "chown -R kuali:kuali ${workspace}",
        unless  => "[ `stat -c %U ${workspace}` == kuali ]",
        require => Exec['svn-checkout-kfs-cfg-dbs'],
    }


    archive::download { "apache-maven-3.0.4-bin.tar.gz":
	    ensure        => present,
	    url           => "http://apache.osuosl.org/maven/maven-3/3.0.4/binaries/apache-maven-3.0.4-bin.tar.gz",
	    digest_string => "e513740978238cb9e4d482103751f6b7"
    }

    archive::extract { "apache-maven-3.0.4-bin":
        ensure     => present,
        target     => "/usr/java",
        require    => Archive::Download["apache-maven-3.0.4-bin.tar.gz"]
    }

    file { "/usr/java/apache-maven" :
    	ensure => link,
    	target => "/usr/java/apache-maven-3.0.4"
    }

    file { "/usr/bin/mvn" :
    	ensure => link,
    	target => "/usr/java/apache-maven/bin/mvn"
    }

    archive::download { "apache-ant-1.8.4-bin.tar.gz":
	    ensure        => present,
	    url           => "http://apache.osuosl.org//ant/binaries/apache-ant-1.8.4-bin.tar.gz",
	    digest_string => "f5975145d90efbbafdcabece600f716b"
    }

    archive::extract { "apache-ant-1.8.4-bin" :
        ensure     => present,
        target     => "/usr/java",
        require    => Archive::Download["apache-ant-1.8.4-bin.tar.gz"]
    }

    file { "/usr/java/apache-ant" :
    	ensure => link,
    	target => "/usr/java/apache-ant-1.8.4"
    }

    file { "/usr/bin/ant" :
    	ensure => link,
    	target => "/usr/java/apache-ant/bin/ant"
    }

    exec { "cleanup-usr-src" :
        command => "rm /usr/src/*.tar.gz",
        require => Archive::Extract["apache-ant-1.8.4-bin"]
    }
}

include kuali
include java
include eclipse