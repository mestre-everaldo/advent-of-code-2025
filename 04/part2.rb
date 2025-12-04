#!/usr/bin/env ruby
# Advent of Code 2025 - Day 4, Part 2
# Remove paper rolls iteratively and count total removed.
# Keep removing accessible rolls (with < 4 adjacent rolls) until none remain.

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

def find_accessible_rolls(grid)
  # Find all rolls that can be accessed (have < 4 adjacent rolls)
  accessible = []

  grid.each_with_index do |line, row|
    line.chars.each_with_index do |char, col|
      if char == '@'
        adjacent = count_adjacent_rolls(grid, row, col)
        accessible << [row, col] if adjacent < 4
      end
    end
  end

  accessible
end

def remove_rolls(grid, positions)
  # Remove rolls at specified positions by converting them to '.'
  # We need to work with mutable strings, so convert each line to array of chars
  new_grid = grid.map { |line| line.chars }

  positions.each do |row, col|
    new_grid[row][col] = '.'
  end

  # Convert back to strings
  new_grid.map(&:join)
end

def count_total_removable(grid)
  # Keep removing accessible rolls until none remain
  total_removed = 0
  current_grid = grid.dup

  loop do
    accessible = find_accessible_rolls(current_grid)
    break if accessible.empty?

    removed_count = accessible.length
    total_removed += removed_count

    puts "Removing #{removed_count} rolls... (Total so far: #{total_removed})"

    current_grid = remove_rolls(current_grid, accessible)
  end

  total_removed
end

# Read the input file
grid = File.readlines('input.txt', chomp: true)

# Count total removable rolls
result = count_total_removable(grid)

puts "\nTotal rolls removed: #{result}"
