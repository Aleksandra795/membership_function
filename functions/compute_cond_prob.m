function cond = compute_cond_prob(x, T)
    cond_sum = 0;
    num_comp = size(T, 1);
    
    points = length(x);
    cond = zeros(points, num_comp);

    for j = 1:num_comp
        mu = T(j,1);
        sig = T(j,2);
        w = T(j,3);

        cond_part = w * normpdf(x, mu, sig);
        cond_sum = cond_sum + cond_part; 
        cond(:, j) = cond_part;
    end
    
    for j = 1:num_comp
      
        cond(:, j) = cond(:,j)./cond_sum';
        cond(:, j) = sgolayfilt(cond(:, j),13,17);
        cond(cond(:,j)<0, j)=0;
        cond(cond(:,j)>1, j)=1;

       
    end

    
end