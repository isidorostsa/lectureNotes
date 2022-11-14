function sort_files
    #mkdir -p $argv[1]/bytes $argv[1]/kilobytes $argv[1]/megabytes $argv[1]/gigabytes 1>dev/null
    string join '.*/' $argv[2] '[^/]*\.' $argv[1] | xargs -I {} echo {}
end