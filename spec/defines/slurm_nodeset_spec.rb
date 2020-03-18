require 'spec_helper'

describe 'slurm::nodeset' do
  on_supported_os(supported_os: [
                    {
                      'operatingsystem'        => 'RedHat',
                      'operatingsystemrelease' => ['7'],
                    },
                  ]).each do |_os, os_facts|
    let(:facts) { os_facts }
    let(:title) { 'test' }
    let(:params) { { feature: 'gpu' } }

    it { is_expected.to create_slurm__nodeset('test') }
    it { is_expected.to contain_class('slurm') }

    it do
      is_expected.to contain_concat__fragment('slurm-partitions.conf-nodeset-test').with(
        target: 'slurm-partitions.conf',
        content: 'NodeSet=test Feature=gpu',
        order: '40',
      )
    end
  end
end
