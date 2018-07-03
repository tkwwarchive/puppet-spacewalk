class spacewalk::repo::client (
  $client_repo_enabled  = '1',
  $client_repo_gpgcheck = '1',
  $client_repo_release  = 'latest',
  $client_repo_gpgkey   = 'https://copr-be.cloud.fedoraproject.org/results/@spacewalkproject/java-packages/pubkey.gpg',
){

  case $::osfamily {
    'RedHat': {

      yumrepo {'spacewalk-client':
        enabled  => $client_repo_enabled,
        descr    => "Spacewalk Client ${client_repo_release} Repository",
        gpgcheck => $client_repo_gpgcheck,
        gpgkey   => $client_repo_gpgkey,
        baseurl =>  "https://copr-be.cloud.fedoraproject.org/results/@spacewalkproject/spacewalk-2.8/fedora-${::operatingsystemmajrelease}-\$basearch/",
      }
    }

    default: {
      fail("OS ${::operatingsystem} not supported")
    }
  }
}
