#!/usr/bin/env ruby

# Advent of Code 2025 - Day 1: Secret Entrance - Part 2
# Count all times the dial crosses 0 during rotations (method 0x434C49434B)

def solve_dial_puzzle_part2(input_file)
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

    # Count how many times the dial points at 0 during this rotation
    # Each click moves the dial by 1, we count values: pos+1, pos+2, ..., pos+dist (for R)
    # or pos-1, pos-2, ..., pos-dist (for L)
    if direction == 'R'
      # Count multiples of 100 in range [position+1, position+distance]
      zero_count += (position + distance) / 100 - position / 100
    elsif direction == 'L'
      # Count multiples of 100 in range [position-1, position-distance]
      # Including the endpoint: use (position - distance - 1) as the boundary
      zero_count += (position - 1) / 100 - (position - distance - 1) / 100
    end

    # Update position for next rotation
    if direction == 'L'
      position = (position - distance) % 100
    elsif direction == 'R'
      position = (position + distance) % 100
    end
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

  result = solve_dial_puzzle_part2(input_file)
  puts "Password (Part 2): #{result}"
end
