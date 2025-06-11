# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  ###
  # Any macOS Mojave will be created from this Vagrant VM configuration
  ##
  @vmname = ENV['VM_NAME']
  config.vm.define "mojave", primary: true do |mojave|
    # Every Vagrant development environment requires a box. You can search for
    # boxes at https://vagrantcloud.com/search.
    mojave.vm.box = "ramsey/macos-mojave"

    # VirtualBox doesn't have Guest additions for Mac OS X, so you can't have shared folders. Instead you can use normal network shared folders.
    mojave.vm.synced_folder ".", "/vagrant", disabled: true

    # Share an additional folder to the guest VM via Network Shared Folder.
    # You can find it at `/vagrant` on guest VM.
    system "mkdir", "-p", "./synced-folder/#{@vmname}"
    mojave.vm.synced_folder "./synced-folder/#{@vmname}", "/vagrant",
      id: "vagrant-root",
      :nfs => true,
      :mount_options => ['nolock,vers=3,udp,noatime,actimeo=1,resvport'],
      :export_options => ['async,insecure,no_subtree_check,no_acl,no_root_squash']
    
    mojave.vm.provider "virtualbox" do |vb|
      vb.name = @vmname
      
      # If your VM freezes with hfs mounted macintosh hd on device root_device then you need to set cpuidset
      #vb.customize ["modifyvm", :id, "--cpuidset", "1","000206a7","02100800","1fbae3bf","bfebfbff"]

      # Customize the OS type to reduce the footprint on the host with a 32bit VM type
      vb.customize ["modifyvm", :id, "--ostype", "MacOS"]
      
      # Customize the amount of memory on the VM:
      vb.memory = "2048"
      vb.cpus = 2
      # Customize motherboard chipset
      # vb.customize ["modifyvm", :id, "--chipset", "ich9"]
  
      # Customize NAT DNS
      # vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      # vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      
      # Display the VirtualBox GUI when booting the machine. You might want to turn 3D accelerating to speed-up VM GUI.
      vb.gui = true
      vb.customize ['setextradata', :id, 'GUI/ScaleFactor', '1']
      # Set resolution on macOS
      # Values: 0 = 640x480, 1 = 800x600, 2 = 1024x768, 3 = 1280x1024, 4 = 1440x900, 5 = 1920x1200
      # vb.customize ["setextradata", :id, "VBoxInternal2/EfiGopMode", "4"]
      # OR
      vb.customize ["setextradata", :id, "VBoxInternal2/EfiGraphicsResolution", "1440x900"]
      vb.customize ["setextradata", :id, "CustomVideoMode1", "1440x900x32"]
      vb.customize ["setextradata", :id, "GUI/CustomVideoMode1", "1440x900x32"]
    end

    # mojave.vm.provision "shell", inline: <<-SHELL
    #   sudo chown -R vagrant:admin /Library/Caches/Homebrew
    #   brew update
    #   npm update
    #   echo 'vagrant' | brew cask update
      
    #   # When OSX is trying to prompt graphically for password (i.e when using swift REPL), 
    #   # it will raise the error error:process exited with status -1) (lost connection) because there is no
    #   # graphical output when using vagrant via ssh login, enable the develop mode can solve this situation
    #   sudo /usr/sbin/DevToolsSecurity --enable
    # SHELL
  end
  
  ###
  # Any macOS Catalina will be created from this Vagrant VM configuration
  ###
  @vmname = ENV['VM_NAME']
  config.vm.define "catalina" do |catalina|
    # Every Vagrant development environment requires a box. You can search for
    # boxes at https://vagrantcloud.com/search.
    catalina.vm.box = "ramsey/macos-catalina"

    # VirtualBox doesn't have Guest additions for Mac OS X, so you can't have shared folders. Instead you can use normal network shared folders.
    catalina.vm.synced_folder ".", "/vagrant", disabled: true

    # Share an additional folder to the guest VM via Network Shared Folder.
    # You can find it at `/vagrant` on guest VM.
    system "mkdir", "-p", "./synced-folder/#{@vmname}"
    catalina.vm.synced_folder "./synced-folder/#{@vmname}", "/vagrant",
      id: "vagrant-root",
      :nfs => true,
      :mount_options => ['nolock,vers=3,udp,noatime,actimeo=1,resvport'],
      :export_options => ['async,insecure,no_subtree_check,no_acl,no_root_squash']
    
    catalina.vm.provider "virtualbox" do |vb|
      vb.name = @vmname
      
      # If your VM freezes with hfs mounted macintosh hd on device root_device then you need to set cpuidset
      #vb.customize ["modifyvm", :id, "--cpuidset", "1","000206a7","02100800","1fbae3bf","bfebfbff"]

      # Customize the OS type to reduce the footprint on the host with a 32bit VM type
      vb.customize ["modifyvm", :id, "--ostype", "MacOS"]
      
      # Customize the amount of memory on the VM:
      vb.memory = "2048"
      vb.cpus = 2
      # Customize motherboard chipset
      # vb.customize ["modifyvm", :id, "--chipset", "ich9"]
  
      # Customize NAT DNS
      # vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      # vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      
      # Display the VirtualBox GUI when booting the machine. You might want to turn 3D accelerating to speed-up VM GUI.
      vb.gui = true
      vb.customize ['setextradata', :id, 'GUI/ScaleFactor', '1']
      # Set resolution on macOS
      # Values: 0 = 640x480, 1 = 800x600, 2 = 1024x768, 3 = 1280x1024, 4 = 1440x900, 5 = 1920x1200
      # vb.customize ["setextradata", :id, "VBoxInternal2/EfiGopMode", "4"]
      # OR
      vb.customize ["setextradata", :id, "VBoxInternal2/EfiGraphicsResolution", "1440x900"]
      vb.customize ["setextradata", :id, "CustomVideoMode1", "1440x900x32"]
      vb.customize ["setextradata", :id, "GUI/CustomVideoMode1", "1440x900x32"]
    end

    # catalina.vm.provision "shell", inline: <<-SHELL
    #   sudo chown -R vagrant:admin /Library/Caches/Homebrew
    #   brew update
    #   npm update
    #   echo 'vagrant' | brew cask update
      
    #   # When OSX is trying to prompt graphically for password (i.e when using swift REPL), 
    #   # it will raise the error error:process exited with status -1) (lost connection) because there is no
    #   # graphical output when using vagrant via ssh login, enable the develop mode can solve this situation
    #   sudo /usr/sbin/DevToolsSecurity --enable
    # SHELL
  end

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end
