function sort_files
    # create dirs
    #mkdir -p $argv[1]/bytes $argv[1]/kilobytes $argv[1]/megabytes $argv[1]/gigabytes 1>dev/null
    string join '' '.*/' $argv[2] '[^/]*\.' $argv[1] | xargs -I {} echo {}
    # byte sized
    string join '' '.*/' $argv[2] '[^/]*\.' $argv[1] | xargs -I {} find . -regex {} -print0 
    # kilobyte sized
    string join '' '.*/' $argv[2] '[^/]*\.' $argv[1] | xargs -I {} find . -regex {} -print0 
    # megabyte sized
    string join '' '.*/' $argv[2] '[^/]*\.' $argv[1] | xargs -I {} find . -regex {} -print0 
    # gigabyte sized
    string join '' '.*/' $argv[2] '[^/]*\.' $argv[1] | xargs -I {} find . -regex {} -print0 
end