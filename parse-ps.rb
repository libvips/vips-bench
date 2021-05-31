#!/usr/bin/ruby

# watch the output of ps, sum RSS of processes matching a pattern and output
# time and size in MB

require 'set'

program = ARGV[0]
units = { 'm': 2, 'g': 3 }

start_time = Time.now
page_memory = 0
peak_memory = 0
trace = []

$stdin.each do |line|
    row = line.split
    prg = row[10 .. -1].join
    memstr = row[5]

    if row[0] =~ /USER/ 
        peak_memory = [peak_memory, page_memory].max
        trace << [Time.now - start_time, page_memory, peak_memory]
        page_memory = 0
        next
    end

    next if not prg =~ /#{program}/

    # we need to not count ourselves
    next if prg =~ /parse-ps/

    if memstr !~ /([0-9]+)([kmg]?)/
        puts "bad memory size #{memstr}"
        next
    end
    mem = $~[1].to_i * 1024
    unit = $~[2]
    mem *= (2 ** 10) ** units[unit] if units[unit]
    mem /= (2 ** 10.to_f) ** 2

    page_memory += mem
end

peak_memory = [peak_memory, page_memory].max
trace << [Time.now - start_time, page_memory, peak_memory]
trace << [Time.now - start_time, 0, peak_memory]

puts ",#{program},"
trace.each do |time, mem, peak|
  puts "#{time.round(2)}, #{mem}, #{peak}"
end
