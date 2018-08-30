fl_dir = '/Users/aidasaglinskas/Downloads/Class Output Data 2/';
cd(fl_dir)
fls_temp = dir(['*.mat']);
fls = {fls_temp.name}';
%%
a = {};
numOfSubjects=length(fls);
clc
pitchVar = 'allPitches';
SNRvar = 'allSNR';
%%
for sub=1:numOfSubjects
    % Fix Naming
    sv_this = 0;
    clearvars -except sub a fls SNRvar pitchVar numOfSubjects
    clear(SNRvar);clear(pitchVar);
    a{sub} = load(fls{sub});
    
    fldnames = fieldnames(a{sub});
    
    match_fldname_pitch = find(~cellfun(@isempty,strfind(fldnames,'itch')));
    expr = [pitchVar ' = ' 'a{sub}.' fldnames{match_fldname_pitch} ';'];
    eval(expr);
    
    match_fldname_SNR = find(~cellfun(@isempty,strfind(fldnames,'SNR')));
    expr = [SNRvar ' = ' 'a{sub}.' fldnames{match_fldname_SNR} ';'];
    eval(expr);
   
    
    
    
    if all(size(allPitches) == [2 20])
    allPitches = [allPitches(1,:) allPitches(2,:)];
    disp(sprintf('sub %d transposed',sub));
    sv_this = 1;
    elseif all(size(allPitches) == [1 40])
        % leave as is
        disp(sprintf('sub %d is fine',sub))
        sv_this = 1;
    else 
        disp(sprintf('sub %d is weird',sub)) 
        sv_this = 0;
    end
  
    if all(size(allSNR) == [2 20])
    allSNR = [allSNR(1,:) allSNR(2,:)];
    disp(sprintf('sub %d transposed',sub))
    sv_this = 1;
    elseif all(size(allSNR) == [1 40])
        % leave as is
        disp(sprintf('sub %d is fine',sub))
        sv_this = 1;
    else 
        disp(sprintf('sub %d is weird',sub)) 
        sv_this = 0;
    end
   disp(unique(allPitches))
    if sv_this
    save(strrep(fls{sub},'.mat','_fixed.mat'),SNRvar,pitchVar);
    end
end

%t1 = arrayfun(@(i) fieldnames(a{i}),1:length(a),'UniformOutput',0);