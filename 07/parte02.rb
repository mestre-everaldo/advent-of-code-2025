#!/usr/bin/env ruby

# Read the grid
grid = File.readlines(ARGV[0] || 'input.txt').map(&:chomp)

# Find starting position (S)
start_row = nil
start_col = nil
grid.each_with_index do |row, r|
  c = row.index('S')
  if c
    start_row = r
    start_col = c
    break
  end
end

# Cache for memoization
$cache = {}
$grid = grid

# Count how many timelines (paths) exist from a given position
def count_timelines(row, col)
  # Out of bounds - path exits the manifold (1 timeline ends)
  return 1 if row < 0 || row >= $grid.length || col < 0 || col >= $grid[0].length

  # Check cache
  key = [row, col]
  return $cache[key] if $cache.key?(key)

  cell = $grid[row][col]

  result = if cell == '^'
    # Splitter: particle takes both paths (left and right)
    # Each path continues downward from the new position
    count_timelines(row + 1, col - 1) + count_timelines(row + 1, col + 1)
  else
    # Empty space or S: continue downward
    count_timelines(row + 1, col)
  end

  # Cache the result
  $cache[key] = result
  result
end

# Start counting from S
timelines = count_timelines(start_row, start_col)
puts timelines
