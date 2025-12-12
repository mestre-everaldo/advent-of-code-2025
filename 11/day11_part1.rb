#!/bin/env ruby

# Advent of Code 2025 - Day 11 Part 1
# Contar todos os caminhos de "you" até "out"

def parse_input(filename)
  graph = Hash.new { |h, k| h[k] = [] }

  File.readlines(filename).each do |line|
    line = line.strip
    next if line.empty?

    parts = line.split(': ')
    source = parts[0]
    destinations = parts[1].split(' ')

    destinations.each do |dest|
      graph[source] << dest
    end
  end

  graph
end

def count_paths(graph, current, target, visited)
  return 1 if current == target
  return 0 if visited.include?(current)
  return 0 unless graph.key?(current)

  visited.add(current)
  count = 0

  graph[current].each do |next_node|
    count += count_paths(graph, next_node, target, visited)
  end

  visited.delete(current)
  count
end

# Main
filename = ARGV[0] || 'input_teste.txt'
graph = parse_input(filename)

result = count_paths(graph, 'you', 'out', Set.new)
puts result
