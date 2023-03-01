%% usage
addpath('functions');

x = ... % vector with original values 
T = ... % table with GMM model with columns in order: mu, sig, cp; 
T = sortrows(T,'mu'); % sort by mean value

step = 0.01;%step 0.01 makes smoother visualizations
num_comp = size(T, 1); %number of components in GMM model
maxp = round(max_value,3)+step;
x = min_value:step:maxp;


cond = compute_cond_prob(x, T); % compute conditional probability
valid_comp = find_inactive_components(x, cond, T); % validate components

% recalculate conditional prob without inactive comp
T = T(logical(valid_comp),:);
cond = compute_cond_prob(x, T);
cond = normalize_prob(cond);

% correct the lines
cond_corr = correct_cond_prob_lines(x, cond, T);
cond_corr = correct_nan_values(x, cond_corr);

result = [transpose(x), cond_corr];

writetable(array2table(result), [path,'/cond_prob_lines.csv']);
