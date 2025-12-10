#!/usr/bin/env ruby
# Advent of Code 2025 - Day 9 - Part 2
# Encontrar o maior retângulo contido no polígono formado pelos tiles vermelhos

INPUT_FILE = File.join(__dir__, "input.txt")

# Ray casting: verifica se ponto está dentro do polígono
def point_inside?(px, py, polygon)
  inside = false
  polygon.each_cons(2) do |(x1, y1), (x2, y2)|
    if (y1 > py) != (y2 > py)
      x_intersect = x1 + (py - y1).to_f * (x2 - x1) / (y2 - y1)
      inside = !inside if px < x_intersect
    end
  end
  inside
end

# Verifica se ponto está na borda do polígono (linhas horizontais/verticais)
def point_on_edge?(px, py, polygon)
  polygon.each_cons(2) do |(x1, y1), (x2, y2)|
    if y1 == y2 # horizontal
      min_x, max_x = [x1, x2].minmax
      return true if py == y1 && px >= min_x && px <= max_x
    elsif x1 == x2 # vertical
      min_y, max_y = [y1, y2].minmax
      return true if px == x1 && py >= min_y && py <= max_y
    end
  end
  false
end

# Cross product para orientação
def cross(ox, oy, ax, ay, bx, by)
  (ax - ox) * (by - oy) - (ay - oy) * (bx - ox)
end

# Verifica se dois segmentos se cruzam (não apenas tocam)
def segments_cross?(x1, y1, x2, y2, x3, y3, x4, y4)
  d1 = cross(x3, y3, x4, y4, x1, y1)
  d2 = cross(x3, y3, x4, y4, x2, y2)
  d3 = cross(x1, y1, x2, y2, x3, y3)
  d4 = cross(x1, y1, x2, y2, x4, y4)

  ((d1 > 0 && d2 < 0) || (d1 < 0 && d2 > 0)) &&
  ((d3 > 0 && d4 < 0) || (d3 < 0 && d4 > 0))
end

# Verifica se retângulo está completamente contido no polígono
def rectangle_in_polygon?(min_x, min_y, max_x, max_y, polygon)
  # 1. Verifica os 4 cantos (devem estar dentro ou na borda)
  corners = [[min_x, min_y], [max_x, min_y], [min_x, max_y], [max_x, max_y]]
  corners.each do |px, py|
    return false unless point_inside?(px, py, polygon) || point_on_edge?(px, py, polygon)
  end

  # 2. Verifica se bordas do retângulo não cruzam bordas do polígono
  rect_edges = [
    [min_x, min_y, max_x, min_y],
    [max_x, min_y, max_x, max_y],
    [max_x, max_y, min_x, max_y],
    [min_x, max_y, min_x, min_y]
  ]

  polygon.each_cons(2) do |(px1, py1), (px2, py2)|
    rect_edges.each do |rx1, ry1, rx2, ry2|
      return false if segments_cross?(rx1, ry1, rx2, ry2, px1, py1, px2, py2)
    end
  end

  true
end

# === MAIN ===

tiles = File.readlines(ARGV[0] || INPUT_FILE, chomp: true).map do |line|
  line.split(",").map(&:to_i)
end

# Fecha o polígono (último conecta ao primeiro)
polygon = tiles + [tiles.first]

# Gera retângulos, ordena do maior para menor
rectangles = tiles.combination(2).map do |(x1, y1), (x2, y2)|
  min_x, max_x = [x1, x2].minmax
  min_y, max_y = [y1, y2].minmax
  area = (max_x - min_x + 1) * (max_y - min_y + 1)
  [area, min_x, min_y, max_x, max_y]
end.sort_by { |a| -a[0] }

# Encontra o maior válido
max_area = 0
rectangles.each do |area, min_x, min_y, max_x, max_y|
  break if area <= max_area  # Otimização: para se já encontrou maior

  if rectangle_in_polygon?(min_x, min_y, max_x, max_y, polygon)
    max_area = area
  end
end

puts max_area
