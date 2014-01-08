#!/usr/bin/ruby

# watch the output of top -b, sum RES of processes matching a pattern and output
# time and size in MB
#
# this will fail if top has been customized at all, we should probably use ps
# and a loop instead

require 'csv'
require 'set'

program = ARGV[0]
units = { 'm' => 2, 'g' => 3 }

puts ",#{program},"
puts "0,0,0"

page_total = 0
peak_memory = 0
start_time = 0

CSV($stdin, :col_sep => " ") do |csv_in|  
    csv_in.each do |row| 
        if row[0] =~ /USER/ 
            if page_total > 1
                start_time = Time.now if start_time == 0
                peak_memory = [peak_memory, page_total].max
                puts "#{Time.now - start_time}, #{page_total}, #{peak_memory}"
            end
            page_total = 0
        end

        next if not row[10 .. -1].join =~ /#{program}/

        memstr = row[5]

        if memstr !~ /([0-9]+)([kmg]?)/
            puts "bad memory size #{memstr}"
            next
        end
        mem = $~[1].to_i * 1024
        unit = $~[2]
        mem *= (2 ** 10) ** units[unit] if units[unit]
        mem /= (2 ** 10.to_f) ** 2

        page_total += mem
    end
end

start_time = Time.now if start_time == 0
puts "#{Time.now - start_time}, 0, #{peak_memory}"
