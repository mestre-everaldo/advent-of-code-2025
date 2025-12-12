#!/bin/env ruby

# Advent of Code 2025 - Day 11 Part 2
# Contar todos os caminhos de "svr" até "out" que passam por "dac" E "fft"
# Usando memoização eficiente assumindo DAG (sem ciclos)

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

# Memoização: memo[nó][dac][fft] = número de caminhos até 'out'
$memo = {}

def count_paths(graph, current, visited_dac, visited_fft)
  # Atualiza flags se estamos em dac ou fft
  visited_dac = true if current == 'dac'
  visited_fft = true if current == 'fft'

  # Se chegamos ao destino, só conta se passou por ambos
  if current == 'out'
    return (visited_dac && visited_fft) ? 1 : 0
  end

  return 0 unless graph.key?(current)

  # Chave de memoização - apenas (nó, dac, fft)
  key = [current, visited_dac, visited_fft]
  return $memo[key] if $memo.key?(key)

  count = 0
  graph[current].each do |next_node|
    count += count_paths(graph, next_node, visited_dac, visited_fft)
  end

  $memo[key] = count
  count
end

# Main
filename = ARGV[0] || 'input_ex02_teste.txt'
graph = parse_input(filename)

result = count_paths(graph, 'svr', false, false)
puts result
