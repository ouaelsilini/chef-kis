current_dir = Chef::Config[:cookbook_path]
gdal_version = '1.11.3'
gdal_folder = "#{current_dir}/#{cookbook_name}/sources"
tarball_gz = "gdal-#{gdal_version}.tar.gz"

execute "extract_gdal_#{gdal_version}" do
  not_if { ::File.exist?("/usr/local/bin/gdal-config") }
  sensitive true
  command "tar xzvf #{gdal_folder}/#{tarball_gz} -C #{gdal_folder}"
  action :run
end

execute "check_extraction_ok_gdal_#{gdal_version}" do  
  not_if { ::File.exist?("/usr/local/bin/gdal-config") }
  cwd "#{gdal_folder}/gdal-#{gdal_version}"
  not_if { Dir.exists?("#{gdal_folder}/gdal-#{gdal_version}") }
end

execute "install_gdal_#{gdal_version}" do  
  not_if { ::File.exist?("/usr/local/bin/gdal-config") }
  cwd "#{gdal_folder}/gdal-#{gdal_version}"
  sensitive true
  command "./configure && make && make install && ldconfig"
end

raise "no gdal config file" if !::File.exist?("/usr/local/bin/gdal-config")
