#!/usr/bin/ruby

require 'csv'

data = {}

max_lines = 0
ARGV.each do |filename|
    data[filename] = []
    n_lines = 0
    CSV.foreach(filename) do |row| 
        data[filename] << row
        n_lines += 1
    end
    max_lines = [max_lines, n_lines].max
end

data.each do |filename, lines|
    lines[1..-1].sort! {|l1, l2| l1[0] <=> l2[0]}
end

(0 .. max_lines).each do |line_no|
    output_line = []
    data.each do |filename, lines|
        if line_no < lines.length
            output_line << lines[line_no]
        else
            output_line << [[]] * lines[0].length
        end
    end

    puts output_line.join(", ")
end
