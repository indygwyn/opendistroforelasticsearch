#
# Cookbook:: opendistroforelasticsearch
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.
#

yum_repository 'elasticsearch' do
  repositoryid 'elasticsearch-6.x'
  description 'Elasticsearch repository for 6.x packages'
  baseurl 'https://artifacts.elastic.co/packages/oss-6.x/yum'
  gpgkey 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
end

yum_repository 'opendistroforelasticsearch' do
  repositoryid 'opendistroforelasticsearch-artifacts-repo'
  description 'Release RPM artifacts of OpenDistroForElasticsearch'
  baseurl 'https://d3g5vo6xdbdb9a.cloudfront.net/yum/noarch/'
  gpgkey 'https://d3g5vo6xdbdb9a.cloudfront.net/GPG-KEY-opendistroforelasticsearch'
  repo_gpgcheck true
end

%w(java-11-openjdk-devel opendistroforelasticsearch opendistroforelasticsearch-kibana).each do |pkg|
  package pkg do
    action :install
  end
end

%w(elasticsearch kibana).each do |svc|
  service svc do
    action [ :enable, :start ]
  end
end
