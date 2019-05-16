# # encoding: utf-8

# Inspec test for recipe opendistroforelasticsearch::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  # This is an example test, replace with your own test.
  describe user('root'), :skip do
    it { should exist }
  end
end

# This is an example test, replace it with your own test.
describe port(80), :skip do
  it { should_not be_listening }
end

%w(elasticsearch-6.x opendistroforelasticsearch-artifacts-repo).each do |repo|
  describe yum.repo(repo) do
    it { should be_enabled }
  end
end

%w(java-11-openjdk-devel opendistroforelasticsearch opendistroforelasticsearch-kibana).each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

%w(elasticsearch kibana).each do |svc|
  describe service(svc) do
    it { should be_running }
  end
end

describe 'Skipping elasticsearch checks' do
  skip 'elasticsearch starts up too slowly for for kitchen to verify immediately after a converge'
end

describe port(5601), :skip do
  it { should be_listening }
end

describe port(9200), :skip do
  it { should be_listening, retry: 60, retry_wait: 5 }
end

describe http('https://localhost:9200', auth: { user: 'admin', pass: 'admin' }, ssl_verify: false), :skip do
  its('status') { should cmp 200 }
  its('body') { should match '/elasticsearch/' }
end
