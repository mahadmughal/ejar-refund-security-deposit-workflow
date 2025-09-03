#!/usr/bin/env ruby


script_path = "/Users/mahadasif/Desktop/wareef-scripts/#{ARGV[0]}.rb"

puts "arguments"
pp ARGV[1]

begin
  # Check if argument is provided
  if ARGV[0].nil? || ARGV[0].empty?
    puts "❌ Error: No input data provided"
    puts "Usage: ruby update_script.rb 'input_params = [...]'"
    exit 1
  end

  # Check if script file exists
  unless File.exist?(script_path)
    puts "❌ Error: Script file not found at #{script_path}"
    exit 1
  end

  # Read the current script
  content = File.read(script_path)
  
  # Check if input_params exists in the file
  unless content.match(/input_params\s*=\s*\[.*?\]/m)
    puts "❌ Error: input_params array not found in the script"
    exit 1
  end
  
  # Replace the input_params array with new data
  updated = content.gsub(/input_params\s*=\s*\[.*?\]/m, ARGV[1])
  
  # Write back to file
  File.write(script_path, updated)
  
  puts "✅ Script updated successfully"
  puts " File: #{script_path}"
  
rescue Errno::EACCES
  puts "❌ Error: Permission denied. Cannot write to #{script_path}"
  exit 1
rescue Errno::ENOENT
  puts "❌ Error: File not found at #{script_path}"
  exit 1
rescue => e
  puts "❌ Error: #{e.message}"
  puts "📍 Backtrace: #{e.backtrace.first}"
  exit 1
end