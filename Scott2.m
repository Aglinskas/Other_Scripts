P=dir('all*roi.mat')
for ii=1:length(P)
if ii==1
trim_stim = maroi('load', [ './' P(ii).name]);
else
    temp = maroi('load', ['./' P(ii).name]);
    trim_stim=temp+trim_stim
end
end
 saveroi(trim_stim, (['.' '/Prova' '_roi.mat']));
    %%
for i=1:length(coord)
 
 sph_centre = coord{i};
 sph_widths = 3;
 sph_roi = maroi_box(struct('centre', sph_centre, ...
                'widths', sph_widths));
 
path='/Users/scott/Data/RSexpItem/Group_anal_NIndex';
trim_stim = maroi('load', [path '/Trim_roi.mat']);
trim_stim = sph_roi & trim_stim;
trim_stim = label(trim_stim, voiName{i});
 saveroi(trim_stim, ([path '/Sph_' voiName{i} '_roi.mat']));
end