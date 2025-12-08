#!/bin/env ruby

# Union-Find (Disjoint Set Union) para gerenciar circuitos
class UnionFind
  def initialize(n)
    @parent = (0...n).to_a
    @size = Array.new(n, 1)
    @num_components = n
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

    @num_components -= 1
    true
  end

  def num_components
    @num_components
  end
end

# Calcular distância euclidiana ao quadrado (evita sqrt)
def distance_squared(p1, p2)
  (p1[0] - p2[0])**2 + (p1[1] - p2[1])**2 + (p1[2] - p2[2])**2
end

# Ler input
filename = ARGV[0] || 'input_teste.txt'

points = File.readlines(filename).map do |line|
  line.strip.split(',').map(&:to_i)
end

n = points.size
puts "Total de junction boxes: #{n}"

# Calcular TODAS as distâncias entre todos os pares (só uma vez!)
puts "Calculando distâncias entre todos os pares..."
distances = []
(0...n).each do |i|
  (i+1...n).each do |j|
    dist_sq = distance_squared(points[i], points[j])
    distances << [dist_sq, i, j]
  end
end

puts "Total de pares: #{distances.size}"

# Ordenar por distância
puts "Ordenando distâncias..."
distances.sort!

# Union-Find
uf = UnionFind.new(n)

# Conectar até formar um único circuito
last_i = nil
last_j = nil
connections_made = 0

distances.each do |dist_sq, i, j|
  if uf.union(i, j)
    connections_made += 1
    last_i = i
    last_j = j

    # Parar quando todos estiverem em um único circuito
    break if uf.num_components == 1
  end
end

puts "Conexões feitas: #{connections_made}"
puts "Circuitos restantes: #{uf.num_components}"

if last_i && last_j
  x1 = points[last_i][0]
  x2 = points[last_j][0]

  puts "Última conexão: ponto #{last_i} (#{points[last_i].join(',')}) com ponto #{last_j} (#{points[last_j].join(',')})"
  puts "Coordenadas X: #{x1} e #{x2}"

  result = x1 * x2
  puts "Resultado: #{result}"
else
  puts "ERRO: Não foi possível conectar todos os circuitos!"
end
