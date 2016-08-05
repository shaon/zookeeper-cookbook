#
# Cookbook Name:: zookeeper-cookbook
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

pkg_list = %w{java-1.8.0-openjdk-headless zookeeper zkdump nmap-ncat}

pkg_list.each do |pkg|
  yum_package pkg do
    action :install
  end
end

servers = node['zookeeper']['topology']
zookeepers = servers.map.with_index(1){ |*x| x.reverse }.to_h

node.set['zookeeper']['servers'] = zookeepers
node.save

if node['zookeeper']['server-index'].nil?
  zookeepers.each do |index, zk|
    if zk.eql? node['ipaddress']
      node.set['zookeeper']['server-index'] = index
      node.save
      break
    end
  end
end

directory '/var/lib/zookeeper/data' do
  owner 'zookeeper'
  group 'zookeeper'
  action :create
end

file '/var/lib/zookeeper/data/myid' do
  content "#{node['zookeeper']['server-index']}\n"
end

directory '/usr/java/default/bin' do
  recursive true
  action :create
end

link '/usr/java/default/bin/java' do
  to '/usr/lib/jvm/jre-1.8.0-openjdk/bin/java'
  action :create
end

template '/etc/zookeeper/zoo.cfg' do
  source 'zoo.cfg.erb'
  variables(
    :zookeepers => zookeepers
  )
  action :create
  notifies :restart, 'service[restart-zookeeper]', :immediately
end

service "restart-zookeeper" do
  service_name "zookeeper"
  supports :status => true, :start => true, :stop => true, :restart => true
  action :nothing
  only_if { File.exists?('/var/lib/zookeeper/data/zookeeper_server.pid') }
end

service "zookeeper" do
  service_name "zookeeper"
  supports :status => true, :start => true, :stop => true, :restart => true
  action [ :enable, :start ]
  not_if { File.exists?('/var/lib/zookeeper/data/zookeeper_server.pid') }
end

# add check for zookeeper installation
# http://serverfault.com/questions/601409/what-command-needs-to-be-issued-to-check-whether-a-zookeeper-server-is-a-leader
