module Options::HelpCommandOption
  extend self

  def flags
   ["-h", "--help"]
  end

  def command
    built_help_message
  end
  alias_method :help, :command

private

  def built_help_message
    lines = []
    lines << "This is the default help"
    lines << "It will grow as options are added"
    lines << show_options
  end

  def commands
    Options.constants.select {|cmd| cmd != default_help_option }
  end

  def default_help_option
    :HelpCommandOption
  end

  def show_options
    commands.each do |cmd|
      obj = Object.const_get("Options::#{cmd}")
      obj.help
    end
  end

end
