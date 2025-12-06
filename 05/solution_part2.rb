#!/usr/bin/env ruby

# Day 5 Part 2: Count all unique fresh ingredient IDs

# Read the input file
input = ARGF.read.strip

# Split into ranges section only (ignore IDs section)
sections = input.split(/\n\s*\n/)
ranges_lines = sections[0].split("\n")

# Parse the fresh ingredient ranges
ranges = ranges_lines.map do |line|
  start_val, end_val = line.split('-').map(&:to_i)
  [start_val, end_val]
end

# Sort ranges by start position
ranges.sort_by! { |r| r[0] }

# Merge overlapping or adjacent ranges
def merge_ranges(ranges)
  return [] if ranges.empty?

  merged = [ranges.first]

  ranges[1..].each do |current_start, current_end|
    last_start, last_end = merged.last

    # Check if current range overlaps or is adjacent to the last merged range
    # Adjacent means current_start == last_end + 1
    if current_start <= last_end + 1
      # Merge: extend the last range if current extends beyond it
      merged[-1] = [last_start, [last_end, current_end].max]
    else
      # No overlap: add as new range
      merged << [current_start, current_end]
    end
  end

  merged
end

# Merge the ranges
merged_ranges = merge_ranges(ranges)

# Count total unique IDs covered
total_fresh_ids = merged_ranges.sum do |start_val, end_val|
  end_val - start_val + 1
end

puts "Original ranges: #{ranges.size}"
puts "Merged ranges: #{merged_ranges.size}"
puts
puts "Sample merged ranges:"
merged_ranges.first(5).each do |s, e|
  puts "  #{s}-#{e} (#{e - s + 1} IDs)"
end
puts "  ..."
puts
puts "Total unique fresh IDs: #{total_fresh_ids}"
puts
puts "Answer: #{total_fresh_ids}"
