function valid_cond = find_inactive_components(x, cond, params)
     [Maxv,Idx] = max(cond,[],2);
     num_comp = size(cond,2);
     valid_cond = [];

     for j = 1:num_comp
       
        mu = params(j,1);
        sig = params(j,2);
        
        x_c = (x>mu-3*sig) & (x<mu+3*sig);
        x_c = x_c';

        counts = Idx(x_c);
        tt = tabulate(counts);
        

        if size(tt,1)<j
            valid_cond(j) = 0;
        elseif tt(j,2) == 0
            valid_cond(j) = 0;
        else
            valid_cond(j) = 1;
        end

     end

end