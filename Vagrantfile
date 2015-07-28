# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # CentOS 7.0
  config.vm.box = "hfm4/centos7"
  config.vm.box_url = "https://vagrantcloud.com/hfm4/centos7"

  # hostname
  config.vm.hostname = "vagrant.centos7.jp"

  # memory and cpus
  config.vm.provider "virtualbox" do |v|
    v.customize ['modifyvm', :id, '--memory', 1024, '--cpus', 1]
  end

  # private network ip address
  config.vm.network :private_network, ip: "10.10.10.25"

  # provisioning shell
  config.vm.provision :shell, :path => "bootstrap.sh"
  if Vagrant.has_plugin?("vagrant-reload")
    config.vm.provision :reload
  else
    config.vm.provision :shell, :inline => <<-CMD
      echo 'You need restart vm.'
    CMD
  end

  # sync src
  config.vm.synced_folder "./apps", "/var/apps"
end
