% Gotta have an xSPM avaialble
%
%
function w = w2v_xSPM(c,xSPM)
v_ind = find(xSPM.XYZmm(1,:) == c(1) & xSPM.XYZmm(2,:) == c(2) & xSPM.XYZmm(3,:) == c(3));
XYZ = xSPM.XYZ(:,v_ind);
w = XYZ;
end