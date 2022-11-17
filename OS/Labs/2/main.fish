function sort_files
    # create dirs
    mkdir -p $argv[2]/bytes $argv[2]/kilobytes $argv[2]/megabytes $argv[2]/gigabytes
    # byte sized
    find . -name "$argv[2]*.$argv[1]" -size -1024c -print0  | \
    xargs -0 -I {} cp {} $argv[2]/bytes 1>/dev/null 
    # kilobyte sized
    find . -name "$argv[2]*.$argv[1]" \( -size +1023c -size -1048576c \) -print0| \
    xargs -0 -I {} cp {} $argv[2]/kilobytes 1>/dev/null
    # megabyte sized
    find . -name "$argv[2]*.$argv[1]" \( -size +1048575c -size -1073741824c \)  -print0 | \
    xargs -0 -I {} cp {} $argv[2]/megabytes 1>/dev/null
    # gigabyte sized
    find . -name "$argv[2]*.$argv[1]" \( -size +1073741823c \) -print0 | \
    xargs -0 -I {} cp {} $argv[2]/gigabytes 1>/dev/null
end
