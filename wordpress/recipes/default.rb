#
# Cookbook:: wordpress
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
execute 'packageupdate' do
command 'apt-get update'
end
package 'mysql-server' do
action :install
end
service "mysql" do
action [:enable, :start]
end

package 'php5' do
action :install 
end

package 'libapache2-mod-php5' do
action :install
end

package 'php5-mcrypt' do
action :install
end

package 'php5-mysql' do
action :install
end

package 'apache2' do
action :install
end
service "apache2" do
action [:enable, :start]
end
execute 'sql_passwd' do
command 'mysqladmin -u root password abcd1234 && touch /tmp/done'
not_if {File.exists?("/tmp/done")}
end
cookbook_file '/tmp/mysqlcommands' do 
source 'mysqlcommands' 
end

execute 'sql_exe' do
command 'mysql -uroot -pabcd1234 < /tmp/mysqlcommands && touch /tmp/done1'
not_if {File.exists?("/tmp/done1")}
end
remote_file '/tmp/latest.zip' do
 source 'https://wordpress.org/latest.zip'
not_if {File.exists?("/tmp/latest.zip")}
end
package 'unzip' do
action :install
end
execute 'unzip_file' do
command 'unzip /tmp/latest.zip -d /var/www/html'
not_if {File.exists?("/var/www/html/wordpress/index.php")}
end
directory '/var/www/html/wordpress' do
 mode '0755'
 owner 'www-data'
 group 'www-data'
end
cookbook_file '/var/www/html/wordpress/wp-config.php' do 
source 'wp-config-sample.php' 
action :create 
end
