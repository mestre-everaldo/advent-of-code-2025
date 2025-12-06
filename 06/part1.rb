#!/usr/bin/env ruby

# Read all lines from input
lines = File.readlines('input.txt', chomp: true)

# Get maximum line length to handle all columns
max_length = lines.map(&:length).max

# Normalize all lines to same length (pad with spaces)
lines.map! { |line| line.ljust(max_length) }

# Separate operator line (last line) from number lines
operator_line = lines.last
number_lines = lines[0..-2]

# Find all columns that are NOT completely empty (separators)
# A column is a problem column if it has at least one non-space character
problem_columns = []
(0...max_length).each do |col|
  # Check if this column has any non-space character
  has_content = lines.any? { |line| line[col] != ' ' }
  if has_content
    problem_columns << col
  end
end

# Group consecutive columns into problems
# When we find a gap (space-only column), it separates problems
problems = []
current_problem_cols = []

problem_columns.each_with_index do |col, idx|
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
# Don't forget the last problem
problems << current_problem_cols unless current_problem_cols.empty?

# Process each problem
grand_total = 0

problems.each_with_index do |cols, prob_idx|
  # Extract numbers from this problem's columns
  numbers = []

  number_lines.each do |line|
    # Get substring for this problem's columns
    substr = cols.map { |c| line[c] }.join
    # Skip if all spaces
    next if substr.strip.empty?
    # Parse number
    num = substr.strip.to_i
    numbers << num if num != 0 || substr.strip == '0'
  end

  # Get operator for this problem (from any column of this problem)
  operator = cols.map { |c| operator_line[c] }.join.strip[0]

  # Calculate result
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

puts "\nGrand Total: #{grand_total}"
