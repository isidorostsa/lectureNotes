function sort_files
    # byte sized
    if find . -name "$argv[2]*.$argv[1]" -size -1024c -print0 | tee bytes.my_special_file | grep . > /dev/null
        mkdir -p $argv[2]/bytes
        cat bytes.my_special_file | xargs -0 -I {} cp {} $argv[2]/bytes 1>/dev/null
    end
    rm bytes.my_special_file

    # kilobyte sized
    if find . -name "$argv[2]*.$argv[1]" -size +1023c -size -1048576c -print0 | tee kilobytes.my_special_file | grep . > /dev/null
        mkdir -p $argv[2]/kilobytes
        cat kilobytes.my_special_file | xargs -0 -I {} cp {} $argv[2]/kilobytes 1>/dev/null
    end
    rm kilobytes.my_special_file

    # megabyte sized
    if find . -name "$argv[2]*.$argv[1]" -size +1048575c -size -1073741824c -print0 | tee megabytes.my_special_file | grep . > /dev/null
        mkdir -p $argv[2]/megabytes
        cat megabytes.my_special_file | xargs -0 -I {} cp {} $argv[2]/megabytes 1>/dev/null
    end
    rm megabytes.my_special_file

    # gigabyte and bigger sized
    if find . -name "$argv[2]*.$argv[1]" -size +1073741823c -print0 | tee gigabytes.my_special_file | grep . > /dev/null
        mkdir -p $argv[2]/gigabytes
        cat gigabytes.my_special_file | xargs -0 -I {} cp {} $argv[2]/gigabytes 1>/dev/null
    end
    rm gigabytes.my_special_file
end