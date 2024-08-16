Vagrant.configure('2') do |config|
  config.vm.box = 'archlinux/archlinux'
  config.ssh.insert_key = true

  config.vm.provider "virtualbox" do |v|
    #    v.linked_clone = true
    v.memory = 4096
    v.cpus = 4
    v.gui = true
  end

  # edgex runtime node
  config.vm.define 'scriptsvm' do |machine|
    machine.vm.hostname = 'scriptsvm'
    machine.vm.network 'forwarded_port', id: 'ssh', host: 2221, guest: 22
  end
  config.vm.synced_folder ".", "/home/vagrant/scripts"
# provisioning
  $script = <<-'SCRIPT'
  sudo pacman -Syu git --noconfirm
  git  clone https://github.com/carnivuth/toolbox
  cd ~/toolbox
  ./toolbox
  SCRIPT
  config.vm.provision "shell", inline: $script, privileged: false
end
