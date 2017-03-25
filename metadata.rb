name 'application_nodejs'
maintainer 'Michael Burns'
maintainer_email 'michael@mirwin.net'
license 'Apache 2.0'
description 'Deploys and configures Node.js applications'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '2.0.3'
source_url 'https://github.com/mburns/application_nodejs' if respond_to?(:source_url)
issues_url 'https://github.com/mburns/application_nodejs/issues' if respond_to?(:issues_url)

depends 'apache2'
depends 'application'
depends 'nginx'
depends 'nodejs'
depends 'passenger_apache2'

supports 'ubuntu', '>= 12.04'
supports 'debian'
