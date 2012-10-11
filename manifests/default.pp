class kuali {
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

}

include kuali
include java
include eclipse