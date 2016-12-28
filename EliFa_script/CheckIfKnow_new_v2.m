function [myTrials]=CheckIfKnow_new_v2(subj)
addpath('/Users/aidasaglinskas/Desktop/EliFa_script/')
% clear
% close all
% sca
% Example call: [myTrials]=CheckIfKnow_v3(999)
% Screen('DrawFormattedText', windowPtr, 'Finished', 'center','center', [0 0 0], backgroundColor)
justGetStimList=0;
%%
load('myTrials_fMRI.mat')
myTrials(find([myTrials.recognised]<0.99))=[];

for i=1:length(myTrials)
    if length(myTrials(i).im)>=5
        [myTrials(i).stim]=1;
    else
        [myTrials(i).stim]=0;
    end
    if myTrials(i).stim==1
        myTrials(i).im(6:end)=[];
    else
    end
end
del=find([myTrials.stim]==0);
myTrials(del)=[];
%%

for ii=1:length(myTrials)
    for jj=1:length(myTrials(ii).fileName)
        myTrials(ii).im{jj}=imread( myTrials(ii).fileName{jj});
    end
    %    myTrials(ii).im(myTrials(ii).doubleCheckRating
end
myTrials=Shuffle(myTrials);

%%
%--------------------------------------------------------------------------
%SCREEN PARAMETERS
%--------------------------------------------------------------------------
allScreens=Screen('Screens');
myScreen=1%max(allScreens); % max = bug
backgroundColor = [127 127 127]; %grigio
[windowPtr] = Screen('Preference','SkipSyncTests', 1);
[width, height]=Screen('WindowSize', myScreen);
% windowSize = [0, 0, width/2, height/2]; % [x partenza, y partenza, x arrivo, y arrivo] %se voglio lo schermo piccolo
windowSize = [0, 0, width, height]; %se voglio lo schermo intero
lunghezzaSchermo = windowSize(3) - windowSize(1); %  il terzo elemento di windowsize - il primo elemento di windowsize
larghezzaSchermo = windowSize(4) - windowSize(2);
centroSchermoX = lunghezzaSchermo/2;
centroSchermoY = larghezzaSchermo/2;
[windowPtr, rect]=Screen('OpenWindow',myScreen, backgroundColor);
% [windowPtr, rect]=Screen('OpenWindow',myScreen, backgroundColor, windowSize);% schermo piccolo
% [windowPtr, rect]=Screen('OpenWindow',0, backgroundColor, windowSize);% schermo intero
%%

%--------------------------------------------------------------------------
%MAKE CONDITION CODE
%--------------------------------------------------------------------------
timeStart=GetSecs;
allTrials=[];
instructionString=('Scrivi la prima lettera del nome e del cognome');
FontUnits=30;
%Instructions
oldTextSize=Screen('TextSize', windowPtr ,FontUnits);
Screen('DrawText', windowPtr, instructionString, lunghezzaSchermo/3.5, larghezzaSchermo/2, [0 0 0], backgroundColor);
Screen('Flip',windowPtr);
pause(2)
%%

for trial=1:length(myTrials)
    img=myTrials(trial).im{1};
    smile=imread('smiley_face.jpg');
    atext = Screen('MakeTexture',windowPtr,smile);
    atexture = Screen('MakeTexture',windowPtr,img);
    Screen('DrawTexture', windowPtr, atexture);
    myTrials(trial).trialStart=Screen('Flip', windowPtr);
    [secs, keyCode, deltaSecs] = KbWait;
    respTemp=KbName(keyCode);
    myTrials(trial).FirstResp=respTemp(1);
    myTrials(trial).FirstTime=secs-myTrials(trial).trialStart;
    Screen('DrawTexture', windowPtr, atexture);
    Screen('DrawText', windowPtr, myTrials(trial).FirstResp, lunghezzaSchermo/2-30, larghezzaSchermo*.75+20, [0 0 0], backgroundColor);
    Screen('Flip', windowPtr);
    KbReleaseWait;
    [secs, keyCode, deltaSecs] = KbWait;
    respTemp=KbName(keyCode);
    myTrials(trial).SecondResp=respTemp(1);
    myTrials(trial).SecondTime=secs-myTrials(trial).trialStart;
    myTrials(trial).trialStart=myTrials(trial).trialStart-timeStart;
    Screen('DrawTexture', windowPtr, atexture);
    Screen('DrawText', windowPtr, myTrials(trial).FirstResp, lunghezzaSchermo/2-30, larghezzaSchermo*.75+20, [0 0 0], backgroundColor);
    Screen('DrawText', windowPtr, myTrials(trial).SecondResp, lunghezzaSchermo/2+30, larghezzaSchermo*.75+20, [0 0 0], backgroundColor);
    % deal with first name only people
    %     try
    if upper(myTrials(trial).first_name(1))==upper(myTrials(trial).FirstResp(1)) && upper(myTrials(trial).surname(1))==upper(myTrials(trial).SecondResp(1))
        myTrials(trial).recognised=1;
        myTrials(trial).mistake=0;
    elseif upper(myTrials(trial).first_name(1))==upper(myTrials(trial).FirstResp(1)) && strcmp(upper(myTrials(trial).SecondResp),'.')
        myTrials(trial).recognised=1;
        myTrials(trial).mistake=0;
        %     elseif upper(myTrials(trial).first_name(1))==upper(myTrials(trial).FirstResp(1)) && ~isnan(myTrials(trial).surname)
        %         myTrials(trial).recognised=1;
    elseif upper(myTrials(trial).surname(1))==upper(myTrials(trial).SecondResp(1)) && strcmp(upper(myTrials(trial).FirstResp),'.')
        myTrials(trial).recognised=1;
        myTrials(trial).mistake=0;
    elseif upper(myTrials(trial).FirstResp(1))==upper(myTrials(trial).surname(1)) || upper(myTrials(trial).SecondResp(1))==upper(myTrials(trial).first_name(1))
        myTrials(trial).recognised=1;
        myTrials(trial).mistake=0;
    else
        myTrials(trial).recognised=0;
        myTrials(trial).mistake=1;
    end
    
    %     catch
    %           myTrials(trial).recognised=0;
    %     end
    KbReleaseWait;
    Screen('Flip', windowPtr);
    if  myTrials(trial).recognised==1
        Screen('DrawTexture', windowPtr, atext);
        Screen('Flip', windowPtr);
    elseif myTrials(trial).recognised==0
        if strcmp(upper(myTrials(trial).FirstResp),'x')
            Screen('Flip', windowPtr);
        elseif strcmp(upper(myTrials(trial).FirstResp),'.')
            myTrials(trial).recognised=1;
            myTrials(trial).mistake=0;
        end
    end
    myTrials(trial).redone=0;
    pause(.3)
    
    toSaveTemp=myTrials;
    toSaveTemp=rmfield(toSaveTemp,'im');
    save (['isKnown_TEMP_s_' num2str(subj)], 'toSaveTemp')
end

% toSaveTemp=myTrials;

%% REDO FOR YY
instructionString2=('Riprova quelle che hai sbagliato');
FontUnits=30;
%Instructions
oldTextSize=Screen('TextSize', windowPtr ,FontUnits);
Screen('DrawText', windowPtr, instructionString2, lunghezzaSchermo/3.5, larghezzaSchermo/2, [0 0 0], backgroundColor);
Screen('Flip',windowPtr);
pause(2)

redoInd=find([myTrials.mistake]==1);
for trial=redoInd
    img=myTrials(trial).im{1};
    atexture = Screen('MakeTexture',windowPtr,img);
    Screen('DrawTexture', windowPtr, atexture);
    myTrials(trial).trialStart=Screen('Flip', windowPtr);
    [secs, keyCode, deltaSecs] = KbWait;
    respTemp=KbName(keyCode);
    myTrials(trial).FirstResp=respTemp(1);
    myTrials(trial).FirstTime=secs-myTrials(trial).trialStart;
    Screen('DrawTexture', windowPtr, atexture);
    Screen('DrawText', windowPtr, myTrials(trial).FirstResp, lunghezzaSchermo/2-30, larghezzaSchermo*.75+20, [0 0 0], backgroundColor)
    Screen('Flip', windowPtr);
    KbReleaseWait;
    [secs, keyCode, deltaSecs] = KbWait;
    respTemp=KbName(keyCode);
    myTrials(trial).SecondResp=respTemp(1);
    myTrials(trial).SecondTime=secs-myTrials(trial).trialStart;
    myTrials(trial).trialStart=myTrials(trial).trialStart-timeStart;
    Screen('DrawTexture', windowPtr, atexture);
    Screen('DrawText', windowPtr, myTrials(trial).FirstResp, lunghezzaSchermo/2-30, larghezzaSchermo*.75+20, [0 0 0], backgroundColor)
    Screen('DrawText', windowPtr, myTrials(trial).SecondResp, lunghezzaSchermo/2+30, larghezzaSchermo*.75+20, [0 0 0], backgroundColor)
    if upper(myTrials(trial).first_name(1))==upper(myTrials(trial).FirstResp(1)) && upper(myTrials(trial).surname(1))==upper(myTrials(trial).SecondResp(1))
        myTrials(trial).recognised=1;
        myTrials(trial).mistake=0;
    elseif upper(myTrials(trial).first_name(1))==upper(myTrials(trial).FirstResp(1)) && strcmp(upper(myTrials(trial).SecondResp),'.')
        myTrials(trial).recognised=1;
        myTrials(trial).mistake=0;
        %     elseif upper(myTrials(trial).first_name(1))==upper(myTrials(trial).FirstResp(1)) && ~isnan(myTrials(trial).surname)
        %         myTrials(trial).recognised=1;
    elseif upper(myTrials(trial).surname(1))==upper(myTrials(trial).SecondResp(1)) && strcmp(upper(myTrials(trial).FirstResp),'.')
        myTrials(trial).recognised=1;
        myTrials(trial).mistake=0;
    elseif upper(myTrials(trial).FirstResp(1))==upper(myTrials(trial).surname(1)) || upper(myTrials(trial).SecondResp(1))==upper(myTrials(trial).first_name(1))
        myTrials(trial).recognised=1;
        myTrials(trial).mistake=0;
    else
        myTrials(trial).recognised=0;
        myTrials(trial).mistake=1;
    end
    KbReleaseWait;
    Screen('Flip', windowPtr);
    if  myTrials(trial).recognised==1
        Screen('DrawTexture', windowPtr, atext);
        Screen('Flip', windowPtr);
    elseif myTrials(trial).recognised==0
        if strcmp(upper(myTrials(trial).FirstResp),'x')
            Screen('Flip', windowPtr);
        end
    else
    end
    myTrials(trial).redone=1;
    pause(.3)
    
    count=0;
    for ii= 1:length(myTrials)
        count=count+1;
        if myTrials(trial).redone==1 && strcmp(upper(myTrials(trial).FirstResp),'.')
            myTrials(trial).recognised=1;
        end
    end
    
end
% if strcmp(upper(myTrials(:).FirstResp),'.')
% toSaveTemp=myTrials;
myTrials=rmfield(myTrials,'im');
save(['isKnown_' num2str(subj)], 'myTrials')
%   Screen('DrawFormattedText', windowPtr, 'Finished', 'center','center', [0 0 0], backgroundColor)

Screen('Flip', windowPtr);
sca