#!/usr/bin/env ruby

# from http://tstarling.com/blog/2010/06/measuring-memory-usage-with-strace

# changes:
# - show only max mem, and use \r to animate display
# - better x64 detection ... Tim's version uses 
# 	if ( `uname -m` eq 'x86_64' ) {
#   to spot x64, but this will always fail since the uname output will 
#   include a \n
# - watch sub-processes too
# - redo in ruby

cmd = 'strace -f -e trace=mmap,munmap,brk'

machine = `uname -m`
if machine =~ /x86_64/
	cmd += ',mmap2'
end

ARGV.each do |arg|
	cmd += " '#{arg.gsub /'/, "\\\\'"}'"
end

cmd += " 2>&1"

puts "running #{cmd}"

mapped_memory = {}
current_size = 0
peak_mem = 0
top_of_data = {}
unfinished = {}

IO.popen(cmd) do |f|
    f.each_line do |line|
        puts line

        pid = 0
        if line =~ /^\[pid\s+(\d+)\] /
            pid = $~[1].to_i
        end

        if line =~ /(\w+)\((.*)\s+\<unfinished\s+\.\.\.\>/
            syscall = $~[1]
            args = $~[2].split /, ?/
            unfinished[pid] = {} if not unfinished.has_key?(pid)
            if unfinished[pid].has_key?(syscall)
                puts "nested unfinished #{syscall} on pid #{pid}"
                puts "line = #{line}"
                exit
            end
            unfinished[pid][syscall] = args
            puts "suspended pid = #{pid}, #{syscall}, args = #{args}"
            next
        end

        if line =~ /\<\.\.\.\s+(\w+)\s+resumed\>\s+\)\s+=\s+(.*)/
            syscall = $~[1]
            result = $~[2].hex
            if not unfinished.has_key?(pid)
                puts "no suspended call for resume of #{syscall} #{pid}"
                exit
            end
            if not unfinished[pid].has_key?(syscall)
                puts "no suspended #{syscall} on #{pid}"
                p unfinished
                exit
            end

            args = unfinished[pid][syscall]
            unfinished[pid].delete(syscall)
            line = "(pseudo) #{syscall}(#{args.join(", ")})   = #{result}"

            puts "resumed #{line}"
        end

        if line =~ /mmap2?\((.*)\)\s+=\s+(\w+)/
            key = pid * 2 ** 24 + $~[2].hex
            addr, length, prot, flags, fd, pgoffset = $~[1].split /, ?/
            if addr == "NULL" and fd == "-1" 
                mapped_memory[key] = length.to_i
                current_size += length.to_i
            end
        elsif line =~ /munmap\((.*)\)/ 
            addr, length = $~[1].split /, ?/
            key = pid * 2 ** 24 + addr.hex
            if mapped_memory.has_key?(key)
                if mapped_memory[key] != length.to_i
                    puts "munmap length does not match"
                    puts "mapped length was #{mapped_memory[key]}"
                    puts "munmap length is #{length.to_i}"
                end
                current_size -= mapped_memory[key]
                mapped_memory.delete(key)
            end
        elsif line =~ /brk\((\w+)\)\s+=\s+(\w+)/ 
            new_top = $~[2].hex
            if top_of_data.has_key?(pid) 
                current_size += new_top - top_of_data[pid]
            end
            top_of_data[pid] = new_top
        elsif line !~ /SIGCHLD/ and line !~ /attached/ and line !~ /exited/
            puts "trace: #{line}"
        end

        peak_mem = [peak_mem, current_size].max
    end
end

if not $?
    puts "command failed - #{cmd}"
    exit
end

puts "peak memory = #{peak_mem.to_f / (2 ** 10) ** 2} MB"
