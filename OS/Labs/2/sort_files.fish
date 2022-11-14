function sort_files
    # create dirs
    mkdir -p $argv[2]/bytes $argv[2]/kilobytes $argv[2]/megabytes $argv[2]/gigabytes
    # test command
    string join '' '.*/' $argv[2] '[^/]*\.' $argv[1] | xargs -I {} echo {}
    # byte sized
    string join '' '.*/' $argv[2] '[^/]*\.' $argv[1] | xargs -I {} find . -regex {} -size -1024c -print0  | \
    xargs -0 -I {} cp {} $argv[2]/bytes 1>/dev/null 
    # kilobyte sized
    string join '' '.*/' $argv[2] '[^/]*\.' $argv[1] | xargs -I {} find . -regex {} ( -size +1023c -size -1048576c ) -print0| \
    xargs -0 -I {} cp {} $argv[2]/kilobytes 1>/dev/null
    # megabyte sized
    string join '' '.*/' $argv[2] '[^/]*\.' $argv[1] | xargs -I {} find . -regex {} ( -size +1048575c -size -1073741824c )  -print0 | \
    xargs -0 -I {} cp {} $argv[2]/megabytes 1>/dev/null
    # gigabyte sized
    string join '' '.*/' $argv[2] '[^/]*\.' $argv[1] | xargs -I {} find . -regex {} ( -size +1073741823c ) -print0 | \
    xargs -0 -I {} cp {} $argv[2]/gigabytes 1>/dev/null
end