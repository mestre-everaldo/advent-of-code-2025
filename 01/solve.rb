#!/usr/bin/env ruby

# Advent of Code 2025 - Day 1: Secret Entrance
# Solve the dial combination puzzle

def solve_dial_puzzle(input_file)
  # Start position
  position = 50
  zero_count = 0

  # Read and process each rotation
  File.readlines(input_file).each do |line|
    line = line.strip
    next if line.empty?

    # Parse direction and distance
    direction = line[0]
    distance = line[1..-1].to_i

    # Apply rotation (modulo 100 handles values > 100)
    if direction == 'L'
      position = (position - distance) % 100
    elsif direction == 'R'
      position = (position + distance) % 100
    end

    # Count if position is 0
    zero_count += 1 if position == 0
  end

  zero_count
end

# Main execution
if __FILE__ == $0
  input_file = 'input.txt'

  unless File.exist?(input_file)
    puts "Error: #{input_file} not found!"
    exit 1
  end

  result = solve_dial_puzzle(input_file)
  puts "Password: #{result}"
end
