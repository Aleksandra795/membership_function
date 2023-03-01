function cond_prob_data = get_cond_prob_from_model(x, cond, marker)

    x = round(x,3);
    vals = round(marker,3);
    indx = arrayfun(@(k) find(x==k), vals, 'UniformOutput', false);
    indx = cell2mat(indx);
    cond_prob_data = cond(indx, :);

end