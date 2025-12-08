#!/bin/env ruby

# Union-Find (Disjoint Set Union) para gerenciar circuitos
class UnionFind
  def initialize(n)
    @parent = (0...n).to_a
    @size = Array.new(n, 1)
  end

  def find(x)
    if @parent[x] != x
      @parent[x] = find(@parent[x])  # path compression
    end
    @parent[x]
  end

  def union(x, y)
    root_x = find(x)
    root_y = find(y)

    return false if root_x == root_y  # já estão no mesmo circuito

    # union by size
    if @size[root_x] < @size[root_y]
      @parent[root_x] = root_y
      @size[root_y] += @size[root_x]
    else
      @parent[root_y] = root_x
      @size[root_x] += @size[root_y]
    end

    true
  end

  def circuit_sizes
    circuits = Hash.new(0)
    @parent.each_index do |i|
      root = find(i)
      circuits[root] += 1
    end
    circuits.values
  end
end

# Calcular distância euclidiana ao quadrado (evita sqrt)
def distance_squared(p1, p2)
  (p1[0] - p2[0])**2 + (p1[1] - p2[1])**2 + (p1[2] - p2[2])**2
end

# Ler input
filename = ARGV[0] || 'input_teste.txt'
num_connections = ARGV[1]&.to_i || 10  # 10 para teste, 1000 para input real

points = File.readlines(filename).map do |line|
  line.strip.split(',').map(&:to_i)
end

n = points.size
puts "Total de junction boxes: #{n}"
puts "Número de conexões a fazer: #{num_connections}"

# Calcular TODAS as distâncias entre todos os pares (só uma vez!)
# Isso é O(n²) mas necessário
puts "Calculando distâncias entre todos os pares..."
distances = []
(0...n).each do |i|
  (i+1...n).each do |j|
    dist_sq = distance_squared(points[i], points[j])
    distances << [dist_sq, i, j]
  end
end

puts "Total de pares: #{distances.size}"

# Ordenar por distância (O(n² log n))
puts "Ordenando distâncias..."
distances.sort!

# Union-Find
uf = UnionFind.new(n)

# Conectar os pares mais próximos
# Fazer exatamente num_connections tentativas (algumas podem falhar)
attempts = 0
successful_connections = 0
distances.each do |dist_sq, i, j|
  break if attempts >= num_connections

  if uf.union(i, j)
    successful_connections += 1
  end
  attempts += 1
end

puts "Tentativas: #{attempts}"
puts "Conexões bem-sucedidas: #{successful_connections}"

# Pegar os tamanhos dos circuitos
circuit_sizes = uf.circuit_sizes.sort.reverse

puts "Número de circuitos: #{circuit_sizes.size}"
puts "3 maiores circuitos: #{circuit_sizes[0..2].inspect}"

# Multiplicar os 3 maiores
result = circuit_sizes[0..2].reduce(:*)
puts "Resultado: #{result}"
