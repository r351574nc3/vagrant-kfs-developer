Vagrant::Config.run do |config|
	config.vm.box     = "KFSDev"
	config.vm.box_url = "https://dl.dropboxusercontent.com/u/883064/F19.box"
  	config.vm.provision :puppet, :module_path => "modules", :options => [ "--templatedir", "/tmp/vagrant-puppet/templates" ]
    config.vm.share_folder("templates", "/tmp/vagrant-puppet/templates", "templates")
    config.vm.share_folder("files", "/tmp/vagrant-puppet/files", "files")
end
