# RubyLove OptionParser
## Because DSLs suck

The sickening trend towards creating a DSL for everything is disgusting to me. Yes, that was a highly loaded and charged sentence.

I don't want to learn your damn DSL. I know Ruby, and I have spent years and years understanding her and I don't now need to get into 'your mind' to do my job.

In that end, I was annoyed (yes, I frequently am annoyed by things) at how ugly the Ruby Stdlib OptionParser was. It is a procedural piece of garbage that belongs in the museum.

What is wrong with it?

### So what the hell is wrong with OptionParser

It works, it is well tested. Sure. So is a horse. Do you want to ride a horse to work every day? (Cowboys need not answer).

Here is the cononical example:

```
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end
end.parse!
```

Remember, that is with just a single option. It gets MUCH worse:

```ruby
options = OpenStruct.new
options.library = []
options.inplace = false
options.encoding = "utf8"
options.transfer_type = :auto
options.verbose = false

opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.separator ""
  opts.separator "Specific options:"

  # Mandatory argument.
  opts.on("-r", "--require LIBRARY",
          "Require the LIBRARY before executing your script") do |lib|
    options.library << lib
  end

  # Optional argument; multi-line description.
  opts.on("-i", "--inplace [EXTENSION]",
          "Edit ARGV files in place",
          "  (make backup if EXTENSION supplied)") do |ext|
    options.inplace = true
    options.extension = ext || ''
    options.extension.sub!(/\A\.?(?=.)/, ".")  # Ensure extension begins with dot.
  end

  # Cast 'delay' argument to a Float.
  opts.on("--delay N", Float, "Delay N seconds before executing") do |n|
    options.delay = n
  end

  # Cast 'time' argument to a Time object.
  opts.on("-t", "--time [TIME]", Time, "Begin execution at given time") do |time|
    options.time = time
  end

  # Cast to octal integer.
  opts.on("-F", "--irs [OCTAL]", OptionParser::OctalInteger,
          "Specify record separator (default \\0)") do |rs|
    options.record_separator = rs
  end

  # List of arguments.
  opts.on("--list x,y,z", Array, "Example 'list' of arguments") do |list|
    options.list = list
  end

  # Keyword completion.  We are specifying a specific set of arguments (CODES
  # and CODE_ALIASES - notice the latter is a Hash), and the user may provide
  # the shortest unambiguous text.
  code_list = (CODE_ALIASES.keys + CODES).join(',')
  opts.on("--code CODE", CODES, CODE_ALIASES, "Select encoding",
          "  (#{code_list})") do |encoding|
    options.encoding = encoding
  end

  # Optional argument with keyword completion.
  opts.on("--type [TYPE]", [:text, :binary, :auto],
          "Select transfer type (text, binary, auto)") do |t|
    options.transfer_type = t
  end

  # Boolean switch.
  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options.verbose = v
  end

  opts.separator ""
  opts.separator "Common options:"

  # No argument, shows at tail.  This will print an options summary.
  # Try it and see!
  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end

  # Another typical switch to print the version.
  opts.on_tail("--version", "Show version") do
    puts ::Version.join('.')
    exit
  end
end

opt_parser.parse!(args)
```

Who the hell would want that kind of procedural filthiness in their codebase is beyond me. But hey, maybe I am the ultimate code snob. I have eyes and taste, and therefore I would not give this code to an enemy.

### So Sherlock. Can YOU do better?

Probably not if the Judges be everyone. I long, long ago stopped giving a shit what people think when they are hell bent on not agreeing with me.

If I say exersize is good and being fat is bad, you can make all the excuses you want. Medical science is behind my statement, because it IS NOT my statement. It is something that I agree with after looking at the alarming about of evidence. If you don't want to see that point, then put yourself in the group of people I do not waste my time with.

If however, you are the type of person that values evidence, reason, and the scientific process. Then this code just might be for you. If you hate bloated procedural code littered with type checks and conditional, then this code might be for you.

And finally, if you don't like a bunch of shit in your way, that realistically has VERY LITTLE to do with you domain... yeah, this code might be for you.

### Open Closed Principle

When you re-edit code you are creating churn. Churn is not a great metric to score high on. I wont go into that here, but I am sure you can imagine how easy it is to introdice a bug by eiditing pre-existing functionality.

The open/closed principle is meant to combat chrun. It is simply the _art_ of add new functionality to an existing codebase, without _changing_ existing files.

To create new behavior, you create a new file, and that new behavior definition will be automatically available to the code for use.

Ruby is exceptionally good at this due to her reflective, dynamic nature.

I find the original implementation of the OptionParser to be very much in violation of this principle, and honestly, after going through the source code, I find that it violates just about every common sense restriction I use.

### Supporting the OptionParser interface

My goal here is to support everything that is supported in OptionParser, but I don't want to use it's interaction interface at all, except maybe as a guide of how NOT to implement an interface.

* (http://www.ruby-doc.org/stdlib-2.1.1/libdoc/optparse/rdoc/OptionParser.html)[Original doc]

1.) The argument specification and the code to handle it are written in the same place.
2.) It can output an option summary; you don’t need to maintain this string separately.
3.) Optional and mandatory arguments are specified very gracefully.
4.) Arguments can be automatically converted to a specified class.
5.) Arguments can be restricted to a certain set.

