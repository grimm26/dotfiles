#!/usr/bin/env ruby
#
require 'ptools'
require 'find'
require 'optparse'
require 'ostruct'

class Parser
  def self.parse(options)
    args = OpenStruct.new(:directory => '.')
    args.directory = '.'
    args.debug = false

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: find_and_replace.rb [options]"

      opts.on("-d DIRECTORY", "--directory DIRECTORY", "Directory to run in") do |d|
        args.directory = d
      end

      opts.on("-f STRING", "--find STRING", "STRING to find") do |s|
        args.find = s
      end

      opts.on("-r STRING", "--replace STRING", "STRING to replace") do |s|
        args.replace = s
      end

      opts.on("--debug", "Print debug info") do |d|
        args.debug = true
      end

      opts.on("-h", "--help", "Prints this help") do
        puts opts
        exit
      end
    end

    opt_parser.parse!(options)
    return args
  end
end
options = Parser.parse(ARGV)

find_re = Regexp.new(options.find)

Find.find(options.directory) do |f|
  puts "Checking #{f}" if options.debug
  changed = false
  if FileTest.directory?(f)
    if File.basename(f).eql?('.git')
      Find.prune
    elsif File.basename(f).eql?('.terraform')
      Find.prune
    end
  elsif FileTest.file?(f)
    if File.binary?(f)
      puts "Skipping binary file #{f}"
    elsif f =~ /\.zip|\.gz|\.bz2|\.tar/
      puts "Skipping archive file #{f}"
    else
      newpath = "#{f}.#{$$}"
      File.open(newpath, "w") do |newfile|
        IO.foreach(f) do |line|
          if line.gsub!(find_re, options.replace)
            changed = true
          end
          newfile.print line
        end
      end
      if changed
        # replace file
        puts "File #{f} changed"
        File.rename(newpath, f)
      else
        # delete new file
        File.delete(newpath)
      end
    end
  end
end
