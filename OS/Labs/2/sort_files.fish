function sort_files
    # create dirs
    #mkdir -p $argv[1]/bytes $argv[1]/kilobytes $argv[1]/megabytes $argv[1]/gigabytes 1>dev/null
    string join '' '.*/' $argv[2] '[^/]*\.' $argv[1] | xargs -I {} echo {}
    # byte sized
    string join '' '.*/' $argv[2] '[^/]*\.' $argv[1] | xargs -I {} find . -regex {} -size -1024c -print0  | \
    xargs -0 -I {} cp {} $argv[1]/bytes 1>dev/null 
    # kilobyte sized
    string join '' '.*/' $argv[2] '[^/]*\.' $argv[1] | xargs -I {} find . -regex {} -print0 -size +1023c -size -1048576c | \
    xargs -0 -I {} cp {} $argv[1]/kilobytes 1>dev/null
    # megabyte sized
    string join '' '.*/' $argv[2] '[^/]*\.' $argv[1] | xargs -I {} find . -regex {} -print0 -size +1048575c -size -1073741824c | \
    xargs -0 -I {} cp {} $argv[1]/megabytes 1>dev/null
    # gigabyte sized
    string join '' '.*/' $argv[2] '[^/]*\.' $argv[1] | xargs -I {} find . -regex {} -print0 -size +1073741823c | \
    xargs -0 -I {} cp {} $argv[1]/gigabytes 1>dev/null
end