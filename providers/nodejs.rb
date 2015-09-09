#
# Author:: Conrad Kramer <conrad@kramerapps.com>
# Cookbook Name:: application_node
# Resource:: node
#
# Copyright:: 2013, Kramer Software Productions, LLC. <conrad@kramerapps.com>
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include Chef::DSL::IncludeRecipe

action :before_compile do
  new_resource.updated_by_last_action(true)
end

action :before_deploy do
  include_recipe 'nodejs::install'

  include_recipe 'nodejs::npm' if new_resource.npm

  r = new_resource
  unless r.restart_command
    r.restart_command do
      poise_service "#{service_name}_nodejs" do
        action [:enable, :restart]
      end
    end
  end

  new_resource.environment['NODE_ENV'] = new_resource.environment_name
  new_resource.updated_by_last_action(true)
end

action :before_migrate do
  nodejs_npm service_name do
    path new_resource.release_path
    json true
    user new_resource.owner
    group new_resource.group
    not_if { new_resource.npm.nil? }
  end
  new_resource.updated_by_last_action(true)
end

action :before_symlink do
  new_resource.updated_by_last_action(true)
end

action :before_restart do
  node_binary = ::File.join(node['nodejs']['dir'], 'bin', 'node')

  poise_service_user new_resource.owner

  poise_service "#{service_name}_nodejs" do
    user new_resource.owner
    group new_resource.group
    command "#{node_binary} #{new_resource.entry_point}"
    directory ::File.join(new_resource.path, 'current')
    environment new_resource.environment
  end
  new_resource.updated_by_last_action(true)
end

action :after_restart do
  new_resource.updated_by_last_action(true)
end

protected

def service_name
  if new_resource.application.name.nil?
    return new_resource.application.name
  else
    return new_resource.service_name
  end

  'michaelburns'
end
