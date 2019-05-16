# # encoding: utf-8

# Inspec test for recipe opendistroforelasticsearch::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

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

describe port(5601) do
  it { should be_listening }
end

control 'Elasticsearch Listening' do
  only_if('uptime greater than 120') do
    command('awk \'{printf "%d", $1}\' < /proc/uptime').stdout.to_i > 120
  end

  describe port(9200) do
    it { should be_listening }
  end
end

control 'Elasticsearch HTTP' do
  only_if('uptime greater than 120') do
    command('awk \'{printf "%d", $1}\' < /proc/uptime').stdout.to_i > 120
  end

  describe http('https://localhost:9200', auth: { user: 'admin', pass: 'admin' }, ssl_verify: false) do
    its('status') { should cmp 200 }
  end
end

describe 'Skipping elasticsearch checks' do
  skip 'elasticsearch checks are skipped if the uptime < 120'
end
