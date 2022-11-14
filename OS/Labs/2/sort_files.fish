function sort_files
    string join ".*/" $argv[2] "[^/]*\." $argv[1] | xargs -I {} echo {}
end

#mkdir -p $argv[1]/bytes $argv[1]/kilobytes $argv[1]/megabytes $argv[1]/gigabytes 1>dev/null