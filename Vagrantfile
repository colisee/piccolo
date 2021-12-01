# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "generic/debian10"
  config.vm.synced_folder ".", "/vagrant"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y docker.io
    apt-get install -y --no-install-recommends quilt parted coreutils qemu-user-static debootstrap zerofree zip \
      dosfstools libarchive-tools libcap2-bin rsync grep udev xz-utils curl xxd file kmod bc \
      binfmt-support ca-certificates qemu-utils kpartx
  SHELL
end
