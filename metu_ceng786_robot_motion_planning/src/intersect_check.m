function out = intersect_check(pt1,pt2,pt3,pt4)

% Simple linear instersection checking by determinant rule.
%
% Volkan OKBAY, 2018. MATLAB 2016a Student Edition

    x=[pt1(1) pt2(1) pt3(1) pt4(1)];
    y=[pt1(2) pt2(2) pt3(2) pt4(2)];
    dt1=det([1,1,1;x(1),x(2),x(3);y(1),y(2),y(3)])*det([1,1,1;x(1),x(2),x(4);y(1),y(2),y(4)]);
    dt2=det([1,1,1;x(1),x(3),x(4);y(1),y(3),y(4)])*det([1,1,1;x(2),x(3),x(4);y(2),y(3),y(4)]);

    if(dt1<=0 && dt2<=0)
    	out = 1;
    else
        out = 0;
    end
    
    return
end