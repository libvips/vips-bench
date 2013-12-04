#!/usr/bin/ruby

require 'csv'

program = ARGV[0]
units = { 'k' => 1, 'm' => 2, 'g' => 3 }

puts "#{program},,"

peak = 0

CSV($stdin, :col_sep => " ") do |csv_in|  
    csv_in.each do |row| 
        next if not row[11] =~ /#{program}/
        memstr = row[5]
        timestr = row[10]

        if memstr !~ /([0-9]+)([kmg]?)/
            puts "bad memory size #{memstr}"
            next
        end
        mem = $~[1].to_i
        unit = $~[2]
        mem *= (2 ** 10) ** units[unit] if units[unit]
        peak = mem if mem > peak

        if timestr !~ /([0-9]+):([0-9]+)\.([0-9]+)/
            puts "bad CPU time #{timestr}"
            next
        end
        time = $~[1].to_i * 60 + $~[2].to_i + $~[3].to_f / 100

        puts "#{time}, #{mem}, #{peak}"
    end
end
