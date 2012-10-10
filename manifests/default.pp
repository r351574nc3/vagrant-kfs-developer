class kfs {
	user { "kfs":
		groups => 'kfs',
		commend => 'This user was created by Puppet',
		ensure => present,
		managed_home => true
	}
}