Vagrant.configure(2) do |config|
	config.vm.box = "centos/7"
	
	config.vm.provider "virtualbox" do |v|
	  v.customize ["modifyvm", :id, "--memory", 4096]
	end

	config.vm.synced_folder ".", "/home/vagrant/sync", disabled: true
	config.vm.synced_folder ".", "/vagrant", type: "virtualbox", mount_options: ["dmode=777,fmode=777"]


	###---Os X Yosemite specific------
	config.trigger.after [:provision, :up, :reload] do
		system('
		echo "rdr pass on lo0 inet proto tcp from any to 127.0.0.1 port 80 -> 127.0.0.1 port 8080" | sudo pfctl -ef - > /dev/null 2>&1; echo "==> Forwarding ports & Enabling pf"
		')
	end
	###

	# Apache
	# config.vm.network "forwarded_port", guest: 80, host: 80, auto_correct: true

	###---Os X specific------
	config.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true
	###
	
	# MySQL
	config.vm.network "forwarded_port", guest: 3306, host: 3306, auto_correct: true

	config.vm.provision :shell, path: "bootstrap.sh"
end
