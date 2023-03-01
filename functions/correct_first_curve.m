function [corr_probs, thr] =  correct_first_curve(x, one_cond, T)
    R = 20;    

    mu = T(1,1);
    sig = T(1,2);
    w = T(1,3);
    
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
        
        start_idx = idx_peak;
        
        above_stop = 1;
        above_start = 1;
        
        thr_p = y_peak - y_peak*0.2;
        start_idx = start_idx+R;
        stop_idx = idx_peak+round(idx_peak/2);
        while above_start
            if (one_cond(start_idx)>thr_p)
                start_idx = start_idx+1;
            else
                above_start = 0;
            end
        end
        while above_stop
            if (one_cond(stop_idx)>one_cond(stop_idx+1)) && (stop_idx-2<length(x))
                stop_idx = stop_idx+1;
            else
                above_stop = 0;
            end
        end

        idx_vals = start_idx:1:stop_idx;
        vals = x(idx_vals);
        lower_idx = max([round(start_idx - (start_idx)/2), 0]);
        vals = [min(x) x(lower_idx+1) vals max(x)];
        probs_base = one_cond(idx_vals);
        probs = [1 1 probs_base' 0];
        

        % check if unique vals for pchip
%         [~, uniqueIdx] = unique(vals);
%         dupeIdx = ismember( vals, vals( setdiff( 1:numel(vals), uniqueIdx ) ) );
%         dupeLoc = find(dupeIdx);
%         vals(dupeLoc) = [];
%         probs(dupeLoc) = [];

        smoothedY = pchip(vals, probs, x);
        corr_probs = smoothedY;
        corr_probs(corr_probs<0)=0;
        corr_probs(corr_probs>1)=1;

    end
    thr = idx_peak;

end