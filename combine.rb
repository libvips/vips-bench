#!/usr/bin/env ruby

require 'csv'

data = {}
times = {}

max_lines = 0
ARGV.each do |filename|
    data[filename] = []
    n_lines = 0
    CSV.foreach(filename) do |row| 
        if row[0] =~ /time/
            times[filename] = row[1].to_f 
        else
            data[filename] << row
        end

        n_lines += 1
    end
    max_lines = [max_lines, n_lines].max
end

(0 .. max_lines).each do |line_no|
    output_line = []
    data.each do |filename, lines|
        if line_no == 0
            output_line << lines[line_no][0]
            output_line << lines[line_no][1]
        elsif line_no < lines.length
            line = lines[line_no]
            output_line << times[filename] * line[0].to_f / lines[-1][0].to_f
            output_line << line[1]
        else
            output_line << [[], []]
        end
    end

    puts output_line.join(", ")
end
