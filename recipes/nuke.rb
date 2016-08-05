service 'zookeeper' do
  action [ :stop ]
end

pkg_list = %w{zookeeper zkdump nmap-ncat zookeeper-lib}

pkg_list.each do |pkg|
  yum_package pkg do
    action :purge
    ignore_failure true
  end
end

directory_list = %w{/etc/zookeeper /var/lib/zookeeper /var/log/zookeeper /usr/share/zookeeper}

directory_list.each do |dir|
  directory dir do
    recursive true
    action :delete
  end
end
