addpath('/Users/aidasaglinskas/Desktop/Clutter/QS/')
fn_root = '/Users/aidasaglinskas/Desktop/Clutter/QS/facebook-AAglinskas/fbchat_dump_201711071648/'
ofn_root = '/Users/aidasaglinskas/Desktop/Clutter/QS/facebook-AAglinskas/FBmat/';
temp = dir([fn_root 't*.txt']);
temp([temp.bytes]<1000) = [];
fls = {temp.name}';
for i = 1:length(fls)
disp(sprintf('%d/%d',i,length(fls)))
fn = fullfile(fn_root,fls{i});
[T ttl] = FBmessages_txt_to_T(fn);
disp(ttl)
%disp(size(T,1))
if size(T,1) > 100
save(fullfile(ofn_root,[ttl '.mat']),'T');
end
end