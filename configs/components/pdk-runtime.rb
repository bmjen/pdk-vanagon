component 'pdk-runtime' do |pkg, settings, platform|
  pkg.version settings[:pdk_runtime_version]
  pkg.sha1sum "https://builds.delivery.puppetlabs.net/pdk-runtime/5e5b7c779c534d07af87ba8d3c17d03373645b46/artifacts/pdk-runtime-201806131.112.g5e5b7c7.#{platform.name}.tar.gz.sha1"
  pkg.url "https://builds.delivery.puppetlabs.net/pdk-runtime/5e5b7c779c534d07af87ba8d3c17d03373645b46/artifacts/pdk-runtime-201806131.112.g5e5b7c7.#{platform.name}.tar.gz"
  # pkg.sha1sum "http://builds.puppetlabs.lan/puppet-runtime/#{pkg.get_version}/artifacts/#{pkg.get_name}-#{pkg.get_version}.#{platform.name}.tar.gz.sha1"
  # pkg.url "http://builds.puppetlabs.lan/puppet-runtime/#{pkg.get_version}/artifacts/#{pkg.get_name}-#{pkg.get_version}.#{platform.name}.tar.gz"
  pkg.install_only true

  install_commands = ["gunzip -c pdk-runtime-201806131.112.g5e5b7c7.#{platform.name}.tar.gz | tar -C / -xf -"]

  if platform.is_windows?
    # We need to make sure we're setting permissions correctly for the executables
    # in the ruby bindir since preserving permissions in archives in windows is
    # ... weird, and we need to be able to use cygwin environment variable use
    # so cmd.exe was not working as expected.
    install_commands = [
      "gunzip -c pdk-runtime-201806131.112.g5e5b7c7.#{platform.name}.tar.gz | tar -C /cygdrive/c/ -xf -",
      "chmod 755 #{settings[:ruby_bindir].sub(/C:/, '/cygdrive/c')}/*"
    ]

    settings[:additional_rubies].each do |rubyver, local_settings|
      install_commands << "chmod 755 #{local_settings[:ruby_bindir].sub(/C:/, '/cygdrive/c')}/*"
    end
  end

  pkg.install do
    install_commands
  end
end
