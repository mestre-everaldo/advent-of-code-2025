#!/bin/env ruby

# Advent of Code 2025 - Day 10 Part 1
# Encontrar o mínimo de botões para configurar as luzes
# Problema de álgebra linear sobre GF(2) - cada botão é 0 ou 1 vez

def parse_line(line)
  # Extrai o diagrama [.##.]
  diagram = line.match(/\[([.#]+)\]/)[1]
  target = diagram.chars.map { |c| c == '#' ? 1 : 0 }

  # Extrai os botões (0,1,2) ou (3)
  buttons = line.scan(/\(([^)]+)\)/).map do |match|
    match[0].split(',').map(&:to_i)
  end

  [target, buttons, diagram.length]
end

def min_presses(target, buttons, n_lights)
  n_buttons = buttons.size

  # Converte botões para vetores binários
  button_vectors = buttons.map do |btn|
    vec = Array.new(n_lights, 0)
    btn.each { |i| vec[i] = 1 }
    vec
  end

  # Força bruta: testa todas as combinações de botões (2^n_buttons)
  # Cada botão é pressionado 0 ou 1 vez (mais que 1 é equivalente a mod 2)
  min_count = Float::INFINITY

  (0...(1 << n_buttons)).each do |mask|
    # Calcula o estado resultante
    state = Array.new(n_lights, 0)
    count = 0

    n_buttons.times do |i|
      if (mask >> i) & 1 == 1
        count += 1
        n_lights.times do |j|
          state[j] ^= button_vectors[i][j]
        end
      end
    end

    if state == target && count < min_count
      min_count = count
    end
  end

  min_count == Float::INFINITY ? -1 : min_count
end

# Main
filename = ARGV[0] || 'input_teste.txt'
total = 0

File.readlines(filename).each do |line|
  line = line.strip
  next if line.empty?

  target, buttons, n_lights = parse_line(line)
  presses = min_presses(target, buttons, n_lights)

  if presses == -1
    puts "Impossível: #{line}"
  else
    total += presses
  end
end

puts total
