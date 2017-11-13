function myTrials = fix_myTrials(myTrials)

if isfield(myTrials,'response');
    disp('word data');
    myTrials = rmfield(myTrials,'resp');
    temp = {myTrials.response};
    [myTrials.resp] = deal(temp{:});
    myTrials = rmfield(myTrials,'response');
% add nans to missing data
[myTrials(cellfun(@isempty,{myTrials.RT})).RT] = deal(NaN);
[myTrials(cellfun(@isempty,{myTrials.resp})).resp] = deal('Nan');
% fix double press
temp = cellfun(@(x) x(end),{myTrials.resp},'UniformOutput',0);
[myTrials.resp] = deal(temp{:});
% convert strings to numbers
temp = cellfun(@str2num,{myTrials.resp},'UniformOutput',0);
[myTrials.resp] = deal(temp{:});
[myTrials(cellfun(@isempty,{myTrials.resp})).resp] = deal(nan);
else 
    disp('face data');
[myTrials(cellfun(@isempty,{myTrials.RT})).RT] = deal(NaN);
[myTrials(cellfun(@isempty,{myTrials.resp})).resp] = deal(NaN);

    for i = 1:length(myTrials)
        temp = strsplit(myTrials(i).filepath,'/');
        w = {};
    if length(temp)==4
        w = temp{2};
    elseif length(temp)==2
        w = strrep(temp{2},'.jpg','');
    else 
        error('fucked extracting word');
    end
    myTrials(i).word = w;
    end
end

if max([myTrials.resp]) > 4; error('too big');end

