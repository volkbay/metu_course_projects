% OBJECT BOUNDARY COST FUNCTION (Co)
% V.Okbay, B.Baydar (2016)
% Originated by Ju_StereoSnakes_Contour_Based_ICCV_2015_paper
function CO = Co(pi,disp)
% Global variables needed
global w I_right I_mask prob_map

y = pi(1);
x = pi(2);

sum_Co = 0;
for n = x - floor(w/2) : x + floor(w/2) % In the WxW neighborhood of point pi
    for m = y - floor(w/2) : y + floor(w/2)
        if (0 < n) && (n < size(I_mask,2)) && (0 < m) && (m < size(I_mask,1)) && (0 < n-disp) && (n-disp < size(I_mask,2))
            sum_Co = sum_Co + abs(prob_map(m,n-disp) - I_mask(m,n)); % Object boundary cost equation
        end
    end
end

CO = sum_Co;