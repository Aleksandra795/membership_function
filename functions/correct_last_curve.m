function [corr_probs] =  correct_last_curve(j, x, one_cond, T, thr)
R = 20;   

mu = T(j,1);
    sig = T(j,2);
    w = T(j,3);
    
    L1 = mu-3*sig;
    L2 = mu+3*sig;
  
    x_first_ids = (x>L1)&(x<L2);
    x_first_vals = x((x>L1)&(x<L2));

    all_vals = one_cond(x_first_ids);
    [y_peak, idx_peak_temp] = max(all_vals);
    x_peak_temp = x_first_vals(idx_peak_temp);
    idx_peak = find(x==x_peak_temp);

    if round(y_peak,2) == 1
        y_peak
        corr_probs = one_cond;
    else

        start_idx = idx_peak-round(idx_peak/2);
        stop_idx = idx_peak;
        above_half_stop = 1;
        above_half_start = 1;
        
        thr_p = y_peak - y_peak*0.2;
        while above_half_start
            if (one_cond(start_idx)<one_cond(start_idx+1)) && start_idx-2>0
                start_idx = start_idx-1;
            else
                above_half_start = 0;
            end
        end
        while above_half_stop
            if (one_cond(stop_idx)>thr_p)
                stop_idx = stop_idx-1;
            else
                above_half_stop = 0;
            end
        end

        idx_vals = start_idx:1:stop_idx;
        vals = x(idx_vals);
        higher_idx = min([round(idx_peak + (length(x) - idx_peak)/12), length(x)]);
        vals = [min(x) vals x(higher_idx-1) max(x)];
        probs_base = one_cond(idx_vals);
        probs = [0 probs_base' 1 1];
     
        smoothedY = pchip(vals, probs, x);
        corr_probs = smoothedY;
        corr_probs(corr_probs<0)=0;
        corr_probs(corr_probs>1)=1;
        
       
    end
  

end