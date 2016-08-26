
subID = 6
nsess = 5
scans = 359

for sess = 1:nsess
for scan = 1:scans
    fn = sprintf('/Users/aidas_el_cap/Desktop/Scott_MVPA/Data/S%d/Sess%d/adata.nii',subID,sess);
    P{sess}{scan,1} = [fn ',' num2str(scan)];
end
end

%alt 
for sess = 1:nsess
    fn = sprintf('/Users/aidas_el_cap/Desktop/Scott_MVPA/Data/S%d/Sess%d/adata.nii',subID,sess);
    P{sess}= fn
end




