#!/usr/bin/env ruby

# Advent of Code 2025 - Day 10 - Part 2
# Encontrar o mínimo de pressionamentos de botões para configurar os contadores
# Usando Simplex + Branch and Bound para resolver ILP

INF = Float::INFINITY
EPS = 1e-9

def simplex(a, c)
  m = a.size
  n = a[0].size - 1

  n_arr = (0...n).to_a + [-1]
  b_arr = (n...(n + m)).to_a

  # Cria matriz D
  d = a.map { |row| row.dup + [-1] }
  d << c.dup + [0, 0]
  d << Array.new(n + 2, 0)

  # Swap últimas duas colunas de cada linha de a
  m.times { |i| d[i][-2], d[i][-1] = d[i][-1], d[i][-2] }

  d[-1][n] = 1

  pivot = lambda do |r, s|
    k = 1.0 / d[r][s]
    (m + 2).times do |i|
      next if i == r
      (n + 2).times do |j|
        next if j == s
        d[i][j] -= d[r][j] * d[i][s] * k
      end
    end
    (n + 2).times { |i| d[r][i] *= k }
    (m + 2).times { |i| d[i][s] *= -k }
    d[r][s] = k
    n_arr[s], b_arr[r] = b_arr[r], n_arr[s]
  end

  find = lambda do |p|
    loop do
      candidates = (0..n).select { |i| p == 1 || n_arr[i] != -1 }
      s = candidates.min_by { |x| [d[m + p][x], n_arr[x]] }

      return true if d[m + p][s] > -EPS

      valid_rows = (0...m).select { |i| d[i][s] > EPS }
      return false if valid_rows.empty?

      r = valid_rows.min_by { |x| [d[x][-1] / d[x][s], b_arr[x]] }
      pivot.call(r, s)
    end
  end

  r = (0...m).min_by { |x| d[x][-1] }

  if d[r][-1] < -EPS
    pivot.call(r, n)
    return [-INF, nil] unless find.call(1)
    return [-INF, nil] if d[-1][-1] < -EPS
  end

  m.times do |i|
    if b_arr[i] == -1
      s = (0...n).min_by { |x| [d[i][x], n_arr[x]] }
      pivot.call(i, s)
    end
  end

  if find.call(0)
    x = Array.new(n, 0)
    m.times do |i|
      x[b_arr[i]] = d[i][-1] if b_arr[i] >= 0 && b_arr[i] < n
    end
    val = (0...n).sum { |i| c[i] * x[i] }
    [val, x]
  else
    [-INF, nil]
  end
end

def solve_ilp(a)
  n = a[0].size - 1
  bval = INF
  bsol = nil

  branch = lambda do |a_curr|
    val, x = simplex(a_curr, Array.new(n, 1))

    return if val + EPS >= bval || val == -INF

    # Procura variável fracionária
    k = -1
    v = 0
    x.each_with_index do |e, i|
      if (e - e.round).abs > EPS
        k = i
        v = e.to_i
        break
      end
    end

    if k == -1
      # Solução inteira encontrada
      if val + EPS < bval
        bval = val
        bsol = x.map { |e| e.round }
      end
    else
      # Branch: x[k] <= v
      s1 = Array.new(n, 0) + [v]
      s1[k] = 1
      branch.call(a_curr + [s1])

      # Branch: x[k] >= v+1  =>  -x[k] <= -(v+1)
      s2 = Array.new(n, 0) + [-(v + 1)]
      s2[k] = -1
      branch.call(a_curr + [s2])
    end
  end

  branch.call(a)
  bval.round
end

def parse_line(line)
  parts = line.split
  m = parts[0]
  c_str = parts[-1]
  p_strs = parts[1...-1]

  n = m.size - 2  # número de contadores (exclui [ e ])

  # Parse buttons
  q = p_strs.map do |s|
    s.gsub(/[()]/, '').split(',').map(&:to_i)
  end

  # Parse requirements
  c = c_str.gsub(/[{}]/, '').split(',').map(&:to_i)

  [n, q, c]
end

# Lê o arquivo de entrada
input_file = ARGV[0] || 'input.txt'
lines = File.readlines(input_file).map(&:strip).reject(&:empty?)

p2 = 0

lines.each do |line|
  n, q, c = parse_line(line)
  num_buttons = q.size

  # Monta matriz A para ILP
  # Linhas: 2*n restrições de igualdade (>= e <=) + num_buttons restrições de não-negatividade
  # Colunas: num_buttons variáveis + 1 coluna RHS

  a = Array.new(2 * n + num_buttons) { Array.new(num_buttons + 1, 0) }

  # Para cada botão i (seguindo exatamente a solução Python)
  num_buttons.times do |i|
    # Restrição de não-negatividade: x[i] >= 0  =>  -x[i] <= 0
    # Python usa A[~i][i] = -1, que é A[-(i+1)][i]
    a[-(i + 1)][i] = -1

    # Para cada contador que o botão afeta
    q[i].each do |e|
      a[e][i] = 1        # soma dos botões que afetam contador e >= c[e]
      a[e + n][i] = -1   # soma dos botões que afetam contador e <= c[e]
    end
  end

  # RHS: c[i] para >=, -c[i] para <=
  n.times do |i|
    a[i][-1] = c[i]
    a[i + n][-1] = -c[i]
  end

  p2 += solve_ilp(a)
end

puts p2
