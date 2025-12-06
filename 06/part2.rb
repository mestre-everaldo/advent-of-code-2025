#!/usr/bin/env ruby

# Read all lines from input
input_file = ARGV[0] || 'input.txt'
lines = File.readlines(input_file, chomp: true)

# Get maximum line length to handle all columns
max_length = lines.map(&:length).max

# Normalize all lines to same length (pad with spaces)
lines.map! { |line| line.ljust(max_length) }

# Separate operator line (last line) from number lines
operator_line = lines.last
number_lines = lines[0..-2]

# Find all columns that are NOT completely empty (separators)
problem_columns = []
(0...max_length).each do |col|
  has_content = lines.any? { |line| line[col] != ' ' }
  if has_content
    problem_columns << col
  end
end

# Group consecutive columns into problems
problems = []
current_problem_cols = []

problem_columns.each do |col|
  if current_problem_cols.empty?
    current_problem_cols << col
  elsif col == current_problem_cols.last + 1
    # Consecutive column, same problem
    current_problem_cols << col
  else
    # Gap detected, finish current problem and start new one
    problems << current_problem_cols
    current_problem_cols = [col]
  end
end
problems << current_problem_cols unless current_problem_cols.empty?

# Process each problem
grand_total = 0

problems.each_with_index do |cols, prob_idx|
  # Get operator for this problem
  operator = cols.map { |c| operator_line[c] }.join.strip[0]

  # Process columns from RIGHT to LEFT (reverse order)
  # Each column represents ONE number
  numbers = []

  cols.reverse.each do |col|
    # Read this column vertically (top to bottom) to form a number
    digits = []
    number_lines.each do |line|
      char = line[col]
      digits << char if char != ' '
    end

    # Join digits to form the number (top = most significant)
    if digits.any?
      number = digits.join.to_i
      numbers << number
    end
  end

  # Calculate result
  if numbers.any?
    result = numbers.first
    numbers[1..-1].each do |num|
      if operator == '*'
        result *= num
      else
        result += num
      end
    end

    puts "Problem #{prob_idx + 1}: #{numbers.join(" #{operator} ")} = #{result}"
    grand_total += result
  end
end

puts "\nGrand Total: #{grand_total}"
