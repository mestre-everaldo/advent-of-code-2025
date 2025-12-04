#!/usr/bin/env ruby
# Advent of Code 2025 - Day 4, Part 1
# Count how many paper rolls can be accessed by forklifts.
# A roll can be accessed if it has fewer than 4 adjacent rolls.

def count_adjacent_rolls(grid, row, col)
  # Count how many '@' symbols are in the 8 adjacent positions
  directions = [
    [-1, -1], [-1, 0], [-1, 1],
    [0, -1],           [0, 1],
    [1, -1],  [1, 0],  [1, 1]
  ]

  count = 0
  rows = grid.length
  cols = rows > 0 ? grid[0].length : 0

  directions.each do |dr, dc|
    new_row = row + dr
    new_col = col + dc

    # Check if position is within bounds
    if new_row >= 0 && new_row < rows && new_col >= 0 && new_col < cols
      count += 1 if grid[new_row][new_col] == '@'
    end
  end

  count
end

def count_accessible_rolls(grid)
  # Count how many rolls can be accessed (have < 4 adjacent rolls)
  accessible = 0

  grid.each_with_index do |line, row|
    line.chars.each_with_index do |char, col|
      if char == '@'
        adjacent = count_adjacent_rolls(grid, row, col)
        accessible += 1 if adjacent < 4
      end
    end
  end

  accessible
end

# Read the input file
grid = File.readlines('input.txt', chomp: true)

# Count accessible rolls
result = count_accessible_rolls(grid)

puts "Number of accessible rolls: #{result}"
