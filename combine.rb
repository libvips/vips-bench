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

(0 .. max_lines).each do |line_no|
    data.each do |filename|
        if line_no < data[filename].length
            puts "
