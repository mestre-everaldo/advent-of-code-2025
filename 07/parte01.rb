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

# Track beams to process: [row, col]
beams = [[start_row, start_col]]
# Track visited positions to avoid processing same beam twice
visited = Set.new
splits = 0

# Process beams using BFS
while !beams.empty?
  row, col = beams.shift

  # Skip if out of bounds or already visited
  next if row < 0 || row >= grid.length || col < 0 || col >= grid[0].length
  next if visited.include?([row, col])

  visited.add([row, col])

  # Check current cell
  cell = grid[row][col]

  if cell == '^'
    # Split! Count this split and create two new beams
    splits += 1
    # New beams start from left and right of the splitter and continue downward
    beams << [row + 1, col - 1]
    beams << [row + 1, col + 1]
  else
    # Empty space or S, continue downward
    beams << [row + 1, col]
  end
end

puts splits
