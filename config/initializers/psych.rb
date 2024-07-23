require 'yaml'
YAML.safe_load(File.read(Rails.root.join('config/database.yml')), aliases: true)

# require 'yaml'
# puts YAML.load_file('path/to/your/config_file.yml')
