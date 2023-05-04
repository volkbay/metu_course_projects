% STEREO CORRESPONDENCE COST (Cs)
% V.Okbay, B.Baydar (2016)
% Originated by Ju_StereoSnakes_Contour_Based_ICCV_2015_paper
function CS = Cs(pi,disp)
% Global variables needed
global w I_left I_right I_mask

y = pi(1);
x = pi(2);
sum_Cad = 0;
for n = x - floor(w/2) : x + floor(w/2) % In the WxW neighborhood of point pi
    for m = y - floor(w/2) : y + floor(w/2)
        if (0 < n) && (n < size(I_mask,2)) && (0 < m) && (m < size(I_mask,1)) && (0 < n-disp) && (n-disp < size(I_mask,2))
            if I_mask(m,n) == 1 
                Cad = abs(I_left(m,n,1) - I_right(m,n-disp,1)) + abs(I_left(m,n,2) - I_right(m,n-disp,2)) + abs(I_left(m,n,3) - I_right(m,n-disp,3));
                sum_Cad = double(Cad) + sum_Cad; % Stereo correspondence cost equation
            end
        end
    end
end

CS = sum_Cad;