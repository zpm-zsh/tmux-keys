require 'yaml'
require 'digest/md5'

class Parser
  def self.call(*args)
    new(*args).call
  end

  def initialize(file_path = ENV['HOME']+'/.zsh-f-shortcuts.yaml')
    @file_path = file_path
  end

  def call
    [].tap do |code|
      code << "set_state '#{Digest::MD5.hexdigest(config['default_view'])}'"
      code << "set_state_name '#{config['default_view']}'"
      code << views_functions
      code << define_views_functions
      code << main_function
      code << 'autoload -Uz add-zsh-hook'
      code << "add-zsh-hook precmd precmd_apple_touchbar\n"
    end.join("\n\n")
  end

  private

  attr_reader :file_path

  def create_key_pattern(key, value)
    command = value['view'] ? "#{Digest::MD5.hexdigest(value['view'])}_view" : value['command']

    "\tcreate_key #{key} '#{value['text']}' '#{command}'".tap do |code|
      code << " '-s'" if value['command']
    end if (1..12).include?(key)
  end

  def function_pattern(view, commands)
    [].tap do |code|
      code << "function #{Digest::MD5.hexdigest(view)}_view() {"
      code << "\tset_state '#{Digest::MD5.hexdigest(view)}'"
      code << "\tset_state_name '#{view}'\n"
      code << "\tremove_and_unbind_keys\n"
      code << commands.join("\n")
      code << "\n\tzle && zle reset-prompt" 
      code << "}"

    end.join("\n")
  end

  def views_functions
    config['views'].map do |view, keys|
      commands = keys.map { |k, v| create_key_pattern(k, v) }.compact

      function_pattern(view, commands)
    end.join("\n\n")
  end

  def define_views_functions
    config['views'].keys.map do |view|
      "zle -N #{Digest::MD5.hexdigest(view)}_view"
    end.join("\n")
  end

  def main_function
    [].tap do |code|
      code << 'precmd_apple_touchbar() {'
      code << "\tcase $state in"
      code << config['views'].keys.map { |view| "\t\t#{Digest::MD5.hexdigest(view)}) #{Digest::MD5.hexdigest(view)}_view ;;"}.join("\n")
      code << "\tesac"
      code << '}'
    end.join("\n")
  end

  def config
    @config ||= YAML.load(File.read(file_path))
  end
end

File.open('/tmp/zpm-zsh-f-shorcuts.' + ENV['USER'] + '.zsh', 'w') {|f| f.write(Parser.call) }
