#!/usr/bin/env ruby
# Advent of Code 2025 - Day 9 - Part 1
# Encontrar o maior retângulo usando dois tiles vermelhos como cantos opostos

INPUT_FILE = File.join(__dir__, "input.txt")

tiles = File.readlines(ARGV[0] || INPUT_FILE, chomp: true).map do |line|
  line.split(",").map(&:to_i)
end

max_area = tiles.combination(2).map do |(x1, y1), (x2, y2)|
  width = (x1 - x2).abs + 1
  height = (y1 - y2).abs + 1
  width * height
end.max

puts max_area
