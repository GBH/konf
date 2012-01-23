require 'yaml'
require 'erb'

class Konf < Hash
  class NotFound  < StandardError; end
  class Invalid   < StandardError; end
  
  def initialize(source, root = nil)
    hash = case source
    when Hash
      source
    else
      if File.exists?(source.to_s) && yaml = YAML.load(ERB.new(File.read(source.to_s)).result)
        yaml.to_hash
      else
        raise Invalid, "Invalid configuration input: #{source}"
      end
    end
    if root
      hash = hash[root] or raise NotFound, "No configuration found for '#{root}'"
    end
    self.replace hash
  end
  
  def method_missing(name, *args, &block)
    key = name.to_s
    if key.gsub!(/\?$/, '')
      has_key? key
    else
      raise NotFound, "No configuration found for '#{name}'" unless has_key?(key)
      value = fetch key
      value.is_a?(Hash) ? Konf.new(value) : value
    end
  end
  
end