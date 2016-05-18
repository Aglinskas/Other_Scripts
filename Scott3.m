
    %%
%     coord=[];
%     coord{1}=[-39   -64 -17];
% coord{end+1}=[42    -64 -17];
% coord{end+1}=[51    -76 1];
% coord{end+1}=[42    -46 -23];
% coord{end+1}=[51    -43 16];
% coord{end+1}=[-36   -91 19];
% coord{end+1}=[-51   -58 -11];
% coord{end+1}=[-18   -67 49];
% coord{end+1}=[-27   -58 -11];
% coord{end+1}=[30    -49 -11];

coord=[3   53 -19 
  3  -55  29 
 39  -46 -19 
 57   -7 -19 
 42  -58  20 
-21   -7 -13 
-48  -64  29 
-57   -4 -19 
 39   17  23 
 24   -7 -13 
  6   56  17 
 33  -91 -10];

label={'Prec','mPFC','FFA', 'rATL','rSTS','lHipp','lpSTS','lATL','rDLPCF','rHipp','dmPFC','rOFA'};

for i=1:length(coord)
 sph_centre = coord(i,:);
 sph_widths = 6;
 sph_roi = maroi_sphere(struct('centre', sph_centre, ...
                'radius', sph_widths));
if i==1
all_roi = sph_roi;
else
all_roi = sph_roi+all_roi;
end
end

 saveroi(all_roi, (['./Sph_ALL_' '_roi.mat']));