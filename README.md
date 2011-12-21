# Konf

**Konf** is a simple configuration reader. 

## Setup

Simply install the gem and/or plug this into the Gemfile:

    gem 'konf'
    
## Usage

Assuming you have a configuration file like this:

    development:
      admin:
        name: Dev
        email: dev@test.test
    production:
      admin:
        name: Pro
        email: pro@test.test

You can load a YAML file, or provide a simple Hash and read configuration values like this:
    
    >> conf = Konf.new('configuration.yml')
    >> conf.development.name
    => 'Dev'
    
If you try to read a configuration that wasn't defined:

    >> conf.development.invalid
    => Konf::NotFound: No configuration found for 'invalid'
    
You can check if configuration exists:

    >> conf.development.admin?
    => true
    >> conf.development.invalid?
    => false
    
You can namespace your configuration:

    >> conf = Konf.new('configuration.yml', 'production')
    >> conf.admin.name
    => 'Pro'

## Author

(c) 2011 Oleg Khabarov, released under the MIT license
