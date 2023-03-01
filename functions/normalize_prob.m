function cond_new = normalize_prob(cond)
    cond_new = [];
    for i = 1:size(cond,1)
        cond_new(i,:) = cond(i,:)./sum(cond(i,:));
    end
end