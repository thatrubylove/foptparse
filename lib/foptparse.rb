require 'ruby_love'
require 'options'

module RubyLove::OptionParser
  extend self

  def parse(text="")
    help = Options::HelpCommandOption.command
    return help if empty?(text)

    split_argument_and_options(text)
  end
  alias_method :call, :parse

private

  def empty?(text)
    text.size == 0
  end

  def extract_options(options)
    options.each_slice(2).map do |slice|
      [slice[0], slice[1]]
    end
  end

  def split_argument_and_options(text)
    array = split_by_space(text)
    [ array[-1], array[0..-2] ]
  end

  def split_by_space(args)
    args.split(" ")
  end

end
