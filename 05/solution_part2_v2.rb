#!/usr/bin/env ruby

# Day 5 Part 2: Count all unique fresh ingredient IDs
# Version 2: WITHOUT sorting ranges (more challenging!)

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

# Process ranges WITHOUT sorting, merging as we go
def merge_with_existing(new_range, merged_ranges)
  return [new_range] if merged_ranges.empty?

  new_start, new_end = new_range
  overlapping = []
  non_overlapping = []

  # Separate ranges that overlap with new_range from those that don't
  merged_ranges.each do |existing_start, existing_end|
    # Check if ranges overlap or are adjacent
    if new_start <= existing_end + 1 && existing_start <= new_end + 1
      overlapping << [existing_start, existing_end]
    else
      non_overlapping << [existing_start, existing_end]
    end
  end

  # If no overlaps, just add the new range
  if overlapping.empty?
    return merged_ranges + [new_range]
  end

  # Merge all overlapping ranges with the new range
  all_starts = overlapping.map { |s, _| s } + [new_start]
  all_ends = overlapping.map { |_, e| e } + [new_end]
  merged = [all_starts.min, all_ends.max]

  # Return non-overlapping ranges plus the merged range
  non_overlapping + [merged]
end

# Process each range in original order, merging as we go
merged_ranges = []
ranges.each do |range|
  merged_ranges = merge_with_existing(range, merged_ranges)
end

# Count total unique IDs covered
total_fresh_ids = merged_ranges.sum do |start_val, end_val|
  end_val - start_val + 1
end

puts "Original ranges: #{ranges.size}"
puts "Merged ranges: #{merged_ranges.size}"
puts
puts "Sample merged ranges:"
merged_ranges.first([5, merged_ranges.size].min).each do |s, e|
  puts "  #{s}-#{e} (#{e - s + 1} IDs)"
end
puts "  ..." if merged_ranges.size > 5
puts
puts "Total unique fresh IDs: #{total_fresh_ids}"
puts
puts "Answer: #{total_fresh_ids}"
