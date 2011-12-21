require 'yaml'
require 'erb'

class Konf < Hash
  class NotFound < StandardError; end
  
  def initialize(source, root = nil)
    hash = case source
    when Hash
      source
    else
      YAML.load(ERB.new(File.read(source)).result).to_hash
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