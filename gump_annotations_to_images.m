p.rootfn = '/Users/aidasaglinskas/Downloads/studyforrest-data-annotations-master/emotions/audio-visual/timeseries/';
fls = dir([p.rootfn 'i*'])';
fls = {fls.name}';

for i = 1:length(fls);
f = fullfile(p.root,fls{i})
dt = csvread(f,1,0);
colnames_raw = 'arousal,valence,direction,admiration,angerrage,compassion,contempt,disappointment,fear,fearsconfirmed,gloating,gratification,gratitude,happiness,happyfor,hate,hope,love,pride,relief,remorse,resentment,sadness,satisfaction,shame,audio,context,face,gesture,verbal';
colnames = strsplit(colnames_raw,',')';
im = figure(1);
imagesc(dt);
title(strrep(fls{i},'_','-'));
im.CurrentAxes.TitleFontSizeMultiplier = 1.5;
im.CurrentAxes.XTick = 1:size(dt,2)
im.CurrentAxes.XTickLabel = colnames;
im.CurrentAxes.XTickLabelRotation = 45
im.CurrentAxes.FontSize = 16
im.CurrentAxes.FontWeight = 'bold'
im.CurrentAxes.XAxis
ylabel('Scan Time')
%xlabel('Emotion')
ofn_root = '/Users/aidasaglinskas/Desktop/2nd_Fig/Gump_emotion/';
saveas(im,fullfile(ofn_root,strrep(fls{i},'.csv','.png')),'png')
end

