# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.synced_folder ".", "/home/vagrant/shared"
  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
    vb.memory = "8192"
    vb.customize [
      "modifyvm", :id,
      "--vram", "256", # ビデオメモリ確保（フルスクリーンモードにするため）
      "--clipboard", "bidirectional", # クリップボードの共有
      "--draganddrop", "bidirectional", # ドラッグアンドドロップ可能に
      "--cpus", "2", # CPUは2つ
      "--ioapic", "on" # I/O APICを有効化
    ]
  end
end
