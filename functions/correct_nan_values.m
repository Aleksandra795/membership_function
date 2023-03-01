function cond = correct_nan_values(x,cond)
    for i = 1:length(x)
       
        invalid_all = all(isnan(cond(i,:)));

        if invalid_all && (i<round(length(x)/2))
            temp_cond = zeros(1,size(cond,2));
            temp_cond(1,1) = 1;
            cond(i,:) = temp_cond;
        elseif invalid_all && (i>round(length(x)/2))
            temp_cond = zeros(1,size(cond,2));
            temp_cond(1,end) = 1;
            cond(i,:) = temp_cond;

        end

        invalid_any = any(isnan(cond(i,:)));
        
        if (invalid_any) && (~invalid_all)
            cond(i, isnan(cond(i,:))) = 0;
        end

    end

end