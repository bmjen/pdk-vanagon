component 'pdk-runtime' do |pkg, settings, platform|
  pkg.version settings[:pdk_runtime_version]
  #pkg.sha1sum "http://builds.puppetlabs.lan/puppet-runtime/#{pkg.get_version}/artifacts/#{pkg.get_name}-#{pkg.get_version}.#{platform.name}.tar.gz.sha1"
  #pkg.url "http://builds.puppetlabs.lan/puppet-runtime/#{pkg.get_version}/artifacts/#{pkg.get_name}-#{pkg.get_version}.#{platform.name}.tar.gz"
  pkg.sha1sum "https://builds.delivery.puppetlabs.net/pdk-runtime/93fd24ac49b2c3a1447f41938636032ec1279dcd/artifacts/pdk-runtime-201806131.131.g93fd24a.#{platform.name}.tar.gz.sha1"
  pkg.url     "https://builds.delivery.puppetlabs.net/pdk-runtime/93fd24ac49b2c3a1447f41938636032ec1279dcd/artifacts/pdk-runtime-201806131.131.g93fd24a.#{platform.name}.tar.gz"
  pkg.install_only true

  install_commands = ["gunzip -c pdk-runtime-201806131.131.g93fd24a.#{platform.name}.tar.gz | tar -C / -xf -"]

  if platform.is_windows?
    # We need to make sure we're setting permissions correctly for the executables
    # in the ruby bindir since preserving permissions in archives in windows is
    # ... weird, and we need to be able to use cygwin environment variable use
    # so cmd.exe was not working as expected.
    install_commands = [
      #"gunzip -c #{pkg.get_name}-#{pkg.get_version}.#{platform.name}.tar.gz | tar -C /cygdrive/c/ -xf -",
      "gunzip -c pdk-runtime-201806131.131.g93fd24a.#{platform.name}.tar.gz | tar -C /cygdrive/c/ -xf -",
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
