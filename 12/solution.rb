#!/usr/bin/env ruby

# Advent of Code 2025 - Day 12: Christmas Tree Farm

def parse_input(filename)
  content = File.read(filename)

  presents_regexp = /(\d+):\n([#.]{3}\n[#.]{3}\n[#.]{3})/
  sections_regexp = /(\d+)x(\d+): ([\d ]+)/

  presents_raw = content.scan(presents_regexp)
  presents = presents_raw.map do |p|
    id = p[0].to_i
    shape = p[1].split("\n").map { |line| line.chars.map { |c| c == '#' } }
    { id: id, shape: shape }
  end

  sections_raw = content.scan(sections_regexp)
  sections = sections_raw.map do |s|
    {
      width: s[0].to_i,
      height: s[1].to_i,
      counts: s[2].split.map(&:to_i)
    }
  end

  [presents, sections]
end

def rotate(shape)
  shape.transpose.map(&:reverse)
end

def flip_h(shape)
  shape.map(&:reverse)
end

def flip_v(shape)
  shape.reverse
end

def shape_to_s(shape)
  shape.map { |row| row.map { |c| c ? '#' : '.' }.join }.join("\n")
end

def generate_variations(shape)
  variations = []
  current = shape

  4.times do
    variations << current
    variations << flip_h(current)
    variations << flip_v(current)
    current = rotate(current)
  end

  variations.uniq { |s| shape_to_s(s) }
end

def analyze_section(section)
  area = section[:width] * section[:height]
  total_presents = section[:counts].sum
  max_space = total_presents * 9  # bounding box 3x3
  min_space = total_presents * 7  # área real mínima

  if area >= max_space
    :yes
  elsif area < min_space
    :no
  else
    :maybe
  end
end

def can_place?(grid, shape, x, y, width, height)
  size = shape.size
  return false if x + size > width || y + size > height

  size.times do |dy|
    size.times do |dx|
      if shape[dy][dx] && grid[y + dy][x + dx]
        return false
      end
    end
  end
  true
end

def place_shape!(grid, shape, x, y)
  size = shape.size
  size.times do |dy|
    size.times do |dx|
      grid[y + dy][x + dx] = true if shape[dy][dx]
    end
  end
end

def remove_shape!(grid, shape, x, y)
  size = shape.size
  size.times do |dy|
    size.times do |dx|
      grid[y + dy][x + dx] = false if shape[dy][dx]
    end
  end
end

def find_first_fit(grid, shape, width, height)
  size = shape.size
  (0..height - size).each do |y|
    (0..width - size).each do |x|
      return [x, y] if can_place?(grid, shape, x, y, width, height)
    end
  end
  nil
end

def solve(grid, presents, counts, all_variations, width, height)
  # Encontrar próximo presente a colocar
  present_idx = counts.find_index { |c| c > 0 }
  return true if present_idx.nil?  # Todos colocados

  variations = all_variations[present_idx]

  variations.each do |variation|
    coords = find_first_fit(grid, variation, width, height)
    next unless coords

    x, y = coords
    place_shape!(grid, variation, x, y)
    new_counts = counts.dup
    new_counts[present_idx] -= 1

    if solve(grid, presents, new_counts, all_variations, width, height)
      return true
    end

    remove_shape!(grid, variation, x, y)
  end

  false
end

def can_fit_section?(presents, all_variations, section)
  width = section[:width]
  height = section[:height]
  counts = section[:counts].dup

  grid = Array.new(height) { Array.new(width, false) }

  solve(grid, presents, counts, all_variations, width, height)
end

def main
  filename = ARGV[0] || 'input.txt'
  presents, sections = parse_input(filename)

  # Pré-computar todas as variações
  all_variations = presents.map { |p| generate_variations(p[:shape]) }

  count = 0
  sections.each_with_index do |section, idx|
    result = analyze_section(section)

    case result
    when :yes
      count += 1
    when :no
      # não conta
    when :maybe
      count += 1 if can_fit_section?(presents, all_variations, section)
    end

    print "\rProcessando #{idx + 1}/#{sections.size}..." if (idx + 1) % 10 == 0
  end
  puts

  puts "Resposta: #{count}"
end

main if __FILE__ == $0
