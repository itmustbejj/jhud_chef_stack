#
# Chef Server Tunables
#
# For a complete list see:
# https://docs.chef.io/config_rb_server.html
# https://docs.chef.io/config_rb_server_optional_settings.html
#
# Example:
#
# In a recipe:
#
#     node.override['chef-server']['configuration']['nginx']['ssl_port'] = 4433
#
# In a role:
#
#     override_attributes(
#       'chef-server' => {
#         'configuration' => {
#           'nginx' => {
#             'ssl_port' => 4433
#           }
#         }
#       }
#     )
#

default['chef_stack']['admin'] = 'jhud'
default['chef_server']['automate_host'] = nil
config = default['chef-server']['configuration'] = {}

config['use_chef_backend'] = true
config['chef_backend_members'] = ['10.0.2.15'] # needs to be discovered in recipe

config['haproxy'] = {}
config['haproxy']['remote_postgresql_port'] = 5432
config['haproxy']['remote_elasticsearch_port'] = 9200

# Specify that postgresql is an external database, and provide the
# VIP of this cluster.  This prevents the chef-server instance
# from creating it's own local postgresql instance.
config['postgresql'] = {}
config['postgresql']['external'] = true
config['postgresql']['vip'] = '127.0.0.1'
config['postgresql']['db_superuser'] = 'chef_pgsql'
config['postgresql']['db_superuser_password'] = '22c056a25228b48c3160b90cebb50f62a29e5dd6faed861c77a873b79150e1b055f208b1d3fb6776ae8a3eee08fcada0753c'

# These settings ensure that we use remote elasticsearch
# instead of local solr for search.  This also
# set search_queue_mode to 'batch' to remove the indexing
# dependency on rabbitmq, which is not supported in this HA configuration.
config['opscode_solr4'] = {}
config['opscode_solr4']['external'] = true
config['opscode_solr4']['external_url'] = 'http://127.0.0.1:9200'
config['opscode_erchef']['search_provider'] = 'elasticsearch'
config['opscode_erchef']['search_queue_mode'] = 'batch'

# HA mode requires sql-backed storage for bookshelf.
config['bookshelf'] = {}
config['bookshelf']['storage_type'] = :sql

# RabbitMQ settings
# At this time we are not providing a rabbit backend. Note that this makes
# this incompatible with reporting and analytics unless you're bringing in
# an external rabbitmq.
config['rabbitmq'] = {}
config['rabbitmq']['enable'] = false
config['rabbitmq']['management_enabled'] = false
config['rabbitmq']['queue_length_monitor_enabled'] = false

# Opscode Expander
# opscode-expander isn't used when the search_queue_mode is batch.  It
# also doesn't support the elasticsearch backend.
config['opscode_expander'] = {}
config['opscode_expander']['enable'] = false

# Prevent startup failures due to missing rabbit host
config['dark_launch'] = {}
config['dark_launch']['actions'] = false

# Cookbook Caching
config['opscode_erchef'] = {}
config['opscode_erchef']['nginx_bookshelf_caching'] = :on
config['opscode_erchef']['s3_url_expiry_window_size'] = '50%'
