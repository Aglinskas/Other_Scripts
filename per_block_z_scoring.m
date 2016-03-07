raw_all_scans = all_scans;
i = 0;
bl_s = 0;
while i < length(all_scans.sa.chunks) %#468


    bl_s = i + 1;
%bl_s = all_scans.sa.chunks(14);

i = bl_s;


while all_scans.sa.chunks(i + 1) == all_scans.sa.chunks(i);
   
    %c_bl_length = c_bl_length + 1
    i = i + 1;
%     if i == length(all_scans.sa.chunks) - 1;
%     break
% end 
end

if i == length(all_scans.sa.chunks) - 1;
    break
end 

i;
bl_length = i - bl_s;

[bl_s bl_length i];
all_scans.sa.chunks(bl_s,2) = 1;
all_scans.sa.chunks(i,2) = 2;

all_scans.samples(bl_s:i,:) = zscore(all_scans.samples(bl_s:i,:),[],1)
%all_scans.samples(tinx,:) = zscore(all_scans.samples(tinx,:),[],1);
end
debug_zScoring = all_scans.sa.chunks;
all_scans.sa.chunks(:,2) = []

