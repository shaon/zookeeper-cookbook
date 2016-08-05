default['zookeeper']['config']['tickTime'] = 2000
default['zookeeper']['config']['initLimit'] = 10
default['zookeeper']['config']['syncLimit'] = 5
default['zookeeper']['config']['clientPort'] = 2181
default['zookeeper']['config']['dataDir'] = "/var/lib/zookeeper/data"
default['zookeeper']['config']['autopurge.snapRetainCount'] = nil
default['zookeeper']['config']['autopurge.purgeInterval'] = nil

default['zookeeper']['port-first'] = 2888
default['zookeeper']['port-second'] = 3888
default['zookeeper']['server-index'] = nil
