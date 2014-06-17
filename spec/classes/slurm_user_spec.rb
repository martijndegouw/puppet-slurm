require 'spec_helper'

describe 'slurm::user' do
  let(:facts) { default_facts }

  let(:pre_condition) { "class { 'slurm': }" }

  it { should create_class('slurm::user') }
  it { should contain_class('slurm') }

  it { should have_group_resource_count(1) }
  it { should have_user_resource_count(1) }

  it do
    should contain_group('slurm').with({
      :ensure => 'present',
      :name   => 'slurm',
      :gid    => nil,
    })
  end

  it do
    should contain_user('slurm').with({
      :ensure     => 'present',
      :name       => 'slurm',
      :uid        => nil,
      :gid        => 'slurm',
      :shell      => '/bin/false',
      :home       => '/home/slurm',
      :managehome => 'false',
      :comment    => 'SLURM User',
      :before     => 'File[/home/slurm]',
    })
  end

  it do
    should contain_file('/home/slurm').with({
      :ensure => 'directory',
      :mode   => '0755',
    })
  end

  context 'when slurm_group_gid => 400' do
    let(:pre_condition) { "class { 'slurm': slurm_group_gid => 400 }" }

    it { should contain_group('slurm').with_gid('400') }
  end

  context 'when slurm_user_uid => 400' do
    let(:pre_condition) { "class { 'slurm': slurm_user_uid => 400 }" }

    it { should contain_user('slurm').with_uid('400') }
  end

  context 'when manage_slurm_user => false' do
    let(:pre_condition) { "class { 'slurm': manage_slurm_user => false }" }

    it { should have_group_resource_count(0) }
    it { should have_user_resource_count(0) }
    it { should_not contain_group('slurm') }
    it { should_not contain_user('slurm') }
  end
end
