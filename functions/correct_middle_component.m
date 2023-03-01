function [corr_probs, thr_out] = correct_middle_component(j, x, one_cond, T, thr_in)
%j=8;
%one_cond = cond(:,j);
%j

width = 6;

mu = T(j,1);
sig = T(j,2);
w = T(j,3);

L1 = mu-3*sig;
L2 = mu+3*sig;

one_cond(1:thr_in) = 0;
    
x_middle_ids = (x>L1)&(x<L2);
x_middle_vals = x((x>L1)&(x<L2));

all_vals = one_cond(x_middle_ids);
%%% check if decreasing
[~, ix] = min(abs(x_middle_vals-mu));
tempL1x =  mu-1*sig;
tempL2x = mu+1*sig;
[~, ixL1] = min(abs(x_middle_vals-tempL1x));
[~, ixL2] = min(abs(x_middle_vals-tempL2x));

all_vals = all_vals(ixL1:ixL2);
x_middle_vals = x_middle_vals(ixL1:ixL2);

[y_peak, idx_peak_temp] = max(all_vals);
x_peak_temp = x_middle_vals(idx_peak_temp);
idx_peak = find(x==x_peak_temp);

start_idx = idx_peak;
stop_idx = idx_peak;
above_half_stop = 1;
above_half_start = 1;

thr_p = 0.4;
while above_half_start
    if (one_cond(start_idx)>thr_p)
        start_idx = start_idx-1;
    else
        above_half_start = 0;
    end
end
while above_half_stop
    if (one_cond(stop_idx)>thr_p)
        stop_idx = stop_idx+1;
    else
        above_half_stop = 0;
    end
end


idx_vals = start_idx:1:stop_idx;
higher_idx = min([round(stop_idx + (stop_idx)/width), length(x)]);
lower_idx = max([round(start_idx - (start_idx)/width), 0]);
vals = x(idx_vals);
vals = [min(x) x(lower_idx+1) vals x(higher_idx-1) max(x)];
probs_base = one_cond(idx_vals);
probs = [0 0 probs_base' 0 0];


%figure
%plot(vals, probs,'.')
%hold on

smoothedY = pchip(vals, probs, x);
corr_probs = smoothedY;
corr_probs(corr_probs<0)=0;
corr_probs(corr_probs>1)=1;
%corr_probs = sgolayfilt(corr_probs,13,17);
%plot(x, corr_probs, '-.b');

thr_out = idx_peak;






end