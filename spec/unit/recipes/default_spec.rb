#
# Cookbook:: opendistroforelasticsearch
# Spec:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'opendistroforelasticsearch::default' do
  context 'When all attributes are default, on CentOS 7.4.1708' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7.4.1708')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    # install repo file for opendistroyforelasticsearch

    it 'installs java-11-opendjk-devel package' do
      expect { chef_run }.to install_package 'java-11-openjdk-devel'
    end

    it 'installs opendistroforelasticsearch package' do
      expect { chef_run }.to install_package 'opendistroforelasticsearch'
    end

    it 'enables and starts opendistroforelasticsearch ' do
      expect(chef_run).to enable_service 'elasticsearch'
      expect(chef_run).to start_service 'elasticsearch'
    end

  end
end
