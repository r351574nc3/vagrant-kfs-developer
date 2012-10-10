class kuali {
	user { "kuali":
		groups          => 'kuali',
		comment         => 'This user was created by Puppet',
		ensure          => present,
		provider        => 'useradd',
		manages_homedir => true
	}
}

include kuali