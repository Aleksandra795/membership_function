function cond_corr = correct_cond_prob_lines(x, cond, T)

cond_corr = zeros(size(cond));
number_of_comp = size(cond,2);
for j = 1:number_of_comp
    one_cond = cond(:,j);

    if j==1
        [one_cond_corr, thr] = correct_first_curve(x, one_cond, T);
        

    elseif (j>1) && (j<number_of_comp)
        
        [one_cond_corr, thr] = correct_middle_component(j,x,one_cond, T, thr);

    elseif j==number_of_comp
        one_cond_corr = correct_last_curve(j,x,one_cond, T, thr);
    end

    cond_corr(:,j) = one_cond_corr;

end

