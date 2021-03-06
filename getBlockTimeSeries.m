 %function [quickER]=getBlockTimeSeries(subFolders, statFold, coord,timeWin,myPath)
% produces block time seriers for SPM data for a single subject or a group
% e.g. [quickER]=getBlockTimeSeries({ 'sub05','sub06','sub07'}, 'anal_m-2', [ 39, -19,  55],20,pwd)
% requires at least one esitmated contrast in the SPM
% clear
%coord=[-36, -19,  53];
%coord=[ 60, -16,  -1];

% coord=[-3,   5,  61]; %SMA
%subVec=[4:11 13:34 36:47 49 50];
%subVec=1:4; 
% P=dir('S*');
% P(~[P.isdir])=[];
% subFolders={P(subVec).name};
wh_tasks = 1:10 % which tasks, 1:10 or 11:12 because of dif sizes can't store in single matrix
%statFold='anal_m-3_seg_mt01s8/';
statFold='Analysis';
timeWin=10; %in TRs
myPath=pwd;
 
% some switches/constant
doZscore=true;
doSPMFilt=true;
useContrast=2;
coord=[36 -49 -19]
 
cc=0;
quickER=[];
subvect = [ 7  8  9 10 11 14 15 17 18 19 20 21 22 24 25 28 29 30 31]
subFolders = subvect;
for sub =1:length(subvect)%
    subID = subvect(sub)
    cc=cc+1;
    
    %load([myPath '/' subFolders{sub} '/' statFold '/SPM.mat']);
    load(sprintf('/Users/aidasaglinskas/Google Drive/Data/S%d/Analysis/SPM.mat',subID))
    %% constants again
    
    nConds=length(SPM.Sess(1).U);
    colsPerSess=nConds+length(SPM.Sess(1).C.name);
    nSess=length(SPM.Sess);
    regVec=[1:nConds];
    %%
    xSPM=SPM;
    xSPM.Ic=useContrast;
    xSPM.Im=0;
    xSPM.Ex=0;
    xSPM.Im=[];
    xSPM.title='prova';
    xSPM.thresDesc='none';
    xSPM.u=.5;
    xSPM.k=15;
    [hReg,xSPM,SPM]=spm_results_ui('Setup',xSPM);
    
    hFxyz = spm_results_ui('FindXYZframe');
    spm_results_ui('setcoords',coord);%[ 39, -19,  55]);%[-18, -91,  -5]);%[ 63, -22,   1]);%[44 -46 -16]);%[ 63, -22,   1]);%[-21,  -7, -14])% [44 -46 -16]);%[57, -13,   1]);%[3 -64 30] );
    hMIPax=spm_mip_ui('FindMIPax');
    XYZmm= spm_mip_ui('Jump',hMIPax,'nrvox');%glmax/nrmax
    beta = spm_mip_ui('extract','beta','voxel');
    
    %% get time series
    if doSPMFilt
        y = spm_mip_ui('extract','kwy','voxel'); % filtered - otherwise use 'y'
    else
        y = spm_mip_ui('extract','y','voxel'); % filtered - otherwise use 'y'
    end
    for sess=1:nSess
    y(SPM.Sess(sess).row)=detrend(y(SPM.Sess(sess).row)); % detrend per run
    end
    
    %% show location
    %myXYZ(modderCount,contrastCount,cc,:)=XYZmm;
    %myBeta(modderCount,contrastCount,cc,:)=beta([1:9 16:24]);
    Fgraph = spm_figure('GetWin','Graphics');
    spm_sections(xSPM,hReg,'/Users/aidasaglinskas/Documents/MATLAB/spm12/canonical/single_subj_T1.nii,1')
    %     [XYZmm,ind] = spm_XYZreg('NearestXYZ',XYZmm,xSPM.XYZmm);
    %     XYZ= xSPM.XYZ(:,ind);
    
    %% select relevent columns (all conditions)
    useCols=[];
    for sessCC=1:nSess
        useCols=  [useCols [regVec]+(sessCC-1)*colsPerSess];
    end
    reg=sum(SPM.xX.X(:,useCols),2);
    
    %% make ER
    ccc=0;
    keep=[];keepFilt=[];keepY=[];
    for sessCC=1:nSess
        X=[SPM.Sess(sessCC).U(regVec(wh_tasks)).ons];
        X=X(:);
        X=round(X/2)+1; % not sure how this +1 influences things but it is consistent !!!!!!!!!!!!!
        % make block design if event related
        blockStart=[1 ;abs(diff(X))>4]; % this '4' should be a constant !!!!!!!!!!!!!
        X=X(find(blockStart))+1;
        for i=1:length(X)
            ccc=ccc+1;
            if doZscore
                keep(ccc,:)=zscore(y(X(i):X(i)+timeWin));
                keepY(ccc,:)=zscore(reg(X(i):X(i)+timeWin));
            else
                keep(ccc,:)=y(X(i):X(i)+timeWin);
                keepY(ccc,:)=reg(X(i):X(i)+timeWin);
            end
        end
    end
    if length(subFolders)>1  % group
        quickER(cc,:,:)=[mean(keep); mean(keepY)];
    else                     % single subject
        quickER(:,1,:)=keep;
        quickER(:,2,:)=keepY;
    end
end
%%
% make a case for single subjects
betaRange=range(squeeze(mean(zscore(quickER(:,1,:),[],3))))
regRange=range(squeeze(mean(zscore(quickER(:,2,:),[],3))))
tempER=quickER;
tempER(:,2,:)=tempER(:,2,:)./(regRange/betaRange); % rescale
 
figure,errorbar(squeeze(mean(zscore(quickER(:,[1],:),[],3)))',squeeze(std(quickER(:,[1],:)))')
hold on
errorbar(squeeze(mean(zscore(quickER(:,2,:),[],3)))'./(regRange/betaRange),squeeze(std(quickER(:,2,:)))','r')

cd (myPath)