class kfs {
	user { "kuali":
		groups => 'kuali',
		commend => 'This user was created by Puppet',
		ensure => present,
		managed_home => true
	}
}

include kuali