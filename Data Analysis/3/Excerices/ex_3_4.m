function ex_3_4()
    s = [41 48 50 52 46 50 50 52 47 50 50 53 47 50 50 53 48 50 52 53 50 50 52 53 50 50 53 53 50 50 53 53 50 52 53 54 50 52 53 54 50 53 53 55 50 55 57 68];
    disp("95% interval");
    [H p ci] = vartest(s, 5);
    if(H)
        disp("variance of 5kv is within the interval")
    else
        disp("variance of 5kv is not within the interval")
    end
    
    disp("95% interval of mean");
    [H p ci] = ttest(s, 52);
    if(H)
        disp("mean of 52kv is within the interval")
    else
        disp("mean of 52kv is not within the interval")
    end
    
end