# @summary
#   Private class declared by Class[splunk::edgeprocessor] to contain the required steps
#   for successfully installing the Splunk Edge Processor
#
class splunk::edgeprocessor::install (
  #String[1] $archive_name = regsubst($splunk::edgeprocessor::package_url, '([^\\/]+\\.tar\\.gz)$', '\\1'),
  String[1] $archive_name = regsubst($splunk::edgeprocessor::package_url, '(\\S*\\/)([^\\/]+\\.tar\\.gz$)', '\\2'),
  Stdlib::UnixPath $extract_path = regsubst($splunk::edgeprocessor::splunk_homedir, '(^.*\\/)[^\\/]*.$','\\1'),
  #String[1] $archive_name = $splunk::edgeprocessor::package_url.match(),
  #String[1] $archive_name = match($splunk::edgeprocessor::package_url, '([^\/]+\.tar\.gz)$')
) {
  #Download and unpack the Splunk Edge Processor
  notify { 'homedir':
    message => "variable homedir is: ${splunk::edgeprocessor::splunk_homedir}|",
  }
  notify { 'extract_path':
    message => "variable extract_path is: ${extract_path}|",
  }
  archive { $archive_name:
    path          => "/tmp/${archive_name}",
    source        => $splunk::edgeprocessor::package_url,
    checksum      => $splunk::edgeprocessor::splunk_package_checksum,
    checksum_type => $splunk::edgeprocessor::checksum_type,
    extract       => true,
    extract_path  => $extract_path,
    creates       => $splunk::edgeprocessor::splunk_homedir,
    cleanup       => true,
    # user          => $splunk::edgeprocessor::splunk_user,
    # group         => $splunk::edgeprocessor::splunk_user,
  }
  file { "${splunk::edgeprocessor::splunk_homedir}/var/log":
    ensure => directory,
    owner  => $splunk::edgeprocessor::splunk_user,
    group  => $splunk::edgeprocessor::splunk_user,
  }
}
