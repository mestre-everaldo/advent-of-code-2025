#!/usr/bin/env ruby

# Day 5 Part 1: Fresh Ingredients

# Read the input file
input = ARGF.read.strip

# Split into ranges section and IDs section
sections = input.split(/\n\s*\n/)
ranges_lines = sections[0].split("\n")
ids_lines = sections[1].split("\n")

# Parse the fresh ingredient ranges
fresh_ranges = ranges_lines.map do |line|
  start_val, end_val = line.split('-').map(&:to_i)
  Range.new(start_val, end_val)
end

# Parse the available ingredient IDs
available_ids = ids_lines.map(&:to_i)

# Count how many available IDs are fresh (covered by at least one range)
fresh_count = available_ids.count do |id|
  fresh_ranges.any? { |range| range.cover?(id) }
end

puts "Total available IDs: #{available_ids.size}"
puts "Fresh IDs: #{fresh_count}"
puts "Spoiled IDs: #{available_ids.size - fresh_count}"
puts
puts "Answer: #{fresh_count}"
