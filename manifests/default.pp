class kuali {
	user { "kuali":
		groups     => 'kuali',
		password   => 'kuali',
		comment    => 'This user was created by Puppet',
		ensure     => present,
		provider   => 'useradd',
		managehome => true
	}
}

include kuali