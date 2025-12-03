#!/usr/bin/env ruby

# Day 2: Gift Shop - Invalid Product IDs

def invalid_part1?(num)
  str = num.to_s
  len = str.length

  # Must be even length to be split in half
  return false if len.odd?

  # Check if it's exactly two repetitions
  mid = len / 2
  str[0...mid] == str[mid..-1]
end

def invalid_part2?(num)
  str = num.to_s
  len = str.length

  # Try all possible pattern lengths (from 1 to len/2)
  (1..len/2).each do |pattern_len|
    # Check if the string can be divided by this pattern length
    next if len % pattern_len != 0

    repetitions = len / pattern_len
    next if repetitions < 2

    pattern = str[0...pattern_len]
    if str == pattern * repetitions
      return true
    end
  end

  false
end

def solve(ranges_str, part2: false)
  total = 0

  ranges_str.strip.split(',').each do |range_str|
    next if range_str.strip.empty?

    start_id, end_id = range_str.strip.split('-').map(&:to_i)

    (start_id..end_id).each do |id|
      is_invalid = part2 ? invalid_part2?(id) : invalid_part1?(id)
      total += id if is_invalid
    end
  end

  total
end

# Read input
input_file = File.join(__dir__, 'input.txt')
input = File.read(input_file)

# Solve Part 1
puts "Part 1: #{solve(input)}"

# Solve Part 2
puts "Part 2: #{solve(input, part2: true)}"
