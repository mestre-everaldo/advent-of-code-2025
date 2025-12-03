#!/usr/bin/env ruby

# Test with the example from ex02.txt
def test_example
  position = 50
  zero_count = 0

  rotations = [
    ['L', 68],
    ['L', 30],
    ['R', 48],
    ['L', 5],
    ['R', 60],
    ['L', 55],
    ['L', 1],
    ['L', 99],
    ['R', 14],
    ['L', 82]
  ]

  rotations.each_with_index do |(dir, dist), i|
    old_pos = position

    if dir == 'R'
      # Count zeros in values: old_pos+1, old_pos+2, ..., old_pos+dist
      crosses = (old_pos + dist) / 100 - old_pos / 100
    else # 'L'
      # Count zeros in values: old_pos-1, old_pos-2, ..., old_pos-dist
      # Need to include the endpoint, so use (old_pos - dist - 1)
      crosses = (old_pos - 1) / 100 - (old_pos - dist - 1) / 100
    end

    zero_count += crosses

    # Update position
    position = (position + (dir == 'R' ? dist : -dist)) % 100

    puts "#{i+1}. #{dir}#{dist}: #{old_pos} -> #{position}, crosses=#{crosses}, total=#{zero_count}"
  end

  puts "\nExpected: 6"
  puts "Got: #{zero_count}"
end

test_example
