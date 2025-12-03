#!/usr/bin/env ruby

# Day 3: Lobby - Battery Joltage Problem

def find_max_joltage(digits, count)
  # Select 'count' digits that form the largest possible number
  # Using greedy approach: keep the largest digits in order
  n = digits.length
  to_remove = n - count
  result = digits.dup

  removed = 0
  while removed < to_remove
    # Find leftmost digit that is smaller than a digit to its right
    i = 0
    found = false
    while i < result.length - 1
      if result[i] < result[i + 1]
        result.delete_at(i)
        removed += 1
        found = true
        break
      end
      i += 1
    end

    # If no such digit found, remove from the end
    unless found
      result.delete_at(-1)
      removed += 1
    end
  end

  result.join.to_i
end

def part1(lines)
  total = 0
  lines.each do |line|
    line = line.strip
    next if line.empty?

    digits = line.chars
    joltage = find_max_joltage(digits, 2)
    total += joltage
  end
  total
end

def part2(lines)
  total = 0
  lines.each do |line|
    line = line.strip
    next if line.empty?

    digits = line.chars
    joltage = find_max_joltage(digits, 12)
    total += joltage
  end
  total
end

# Read input
input_file = File.join(__dir__, 'input.txt')
lines = File.readlines(input_file)

# Solve Part 1
puts "Part 1: #{part1(lines)}"

# Solve Part 2
puts "Part 2: #{part2(lines)}"
