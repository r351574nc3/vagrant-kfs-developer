Vagrant::Config.run do |config|
	config.vm.box     = "F17"
	config.vm.box_url = "http://dl.dropbox.com/u/883064/F17.box"
  	config.vm.provision :puppet, :module_path => "modules"
end
