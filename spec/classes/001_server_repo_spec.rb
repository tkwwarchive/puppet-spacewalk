
require 'spec_helper'

describe 'spacewalk::repo::server' do
  default_params = {
    spacewalk_repo_enabled: '1',
    spacewalk_repo_gpgcheck: '1',
    spacewalk_repo_release: 'latest',
    spacewalk_repo_gpgkey: 'http://yum.spacewalkproject.org/RPM-GPG-KEY-spacewalk-2015',
    copr_repo_enabled: '1',
    copr_repo_gpgcheck: '1',
    copr_repo_gpgkey: 'https://copr-be.cloud.fedoraproject.org/results/@spacewalkproject/java-packages/pubkey.gpg'
  }

  on_supported_os(supported_os: [
                    {
                      'operatingsystem' => 'CentOS',
                      'operatingsystemrelease' => %w(6 7)
                    },
                    {
                      'operatingsystem' => 'RedHat',
                      'operatingsystemrelease' => %w(6 7)
                    }
                  ]).each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:params) do
        default_params
      end
      it { is_expected.to contain_class('spacewalk::repo::server') }
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_yumrepo('copr-java') }

      case facts[:operatingsystemmajrelease]
      when '6'
        context 'has yum repo for 6 release' do
          it { is_expected.to contain_yumrepo('spacewalk').with(baseurl: 'http://yum.spacewalkproject.org/latest/RHEL/6/$basearch/') }
        end
      when '7'
        context 'has yum repo for 7 release' do
          it { is_expected.to contain_yumrepo('spacewalk').with(baseurl: 'http://yum.spacewalkproject.org/latest/RHEL/7/$basearch/') }
        end
      end
      context 'with defined spacewalk repo release' do
        let(:params) do
          default_params.merge(spacewalk_repo_release: '2.2')
        end

        case facts[:operatingsystemmajrelease]
        when '6'
          context 'has spacewalk 2.2 repo for release 6' do
            it { is_expected.to contain_yumrepo('spacewalk').with(baseurl: 'http://yum.spacewalkproject.org/2.2/RHEL/6/$basearch/') }
          end
        when '7'
          context 'has spacewalk 2.2 repo for release 7' do
            it { is_expected.to contain_yumrepo('spacewalk').with(baseurl: 'http://yum.spacewalkproject.org/2.2/RHEL/7/$basearch/') }
          end
        end
      end
    end
  end
end
