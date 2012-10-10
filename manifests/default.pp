class kuali {
	user { "kuali":
		groups       => 'kuali',
		comment      => 'This user was created by Puppet',
		ensure       => present,
		managed_home => true
	}
}

include kuali