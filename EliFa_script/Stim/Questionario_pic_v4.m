%% QUESTIONARIO IMMAGINI
%% prepara
clear all;

%% inizializza
commandwindow;

%% set up enviroment
KbName('UnifyKeyNames');

%% set up participants info
run=1;
%subNum=1; % -----------> CAMBIARE NUMERO
modality=1; %1= word; 2=pictures
thisTask=1;

%% get subject initials
options.subjectInitials=inputdlg('Subject initials:');
options.subjectInitials=options.subjectInitials{1};

%% Stimoli parole Tutti
stim2={
    'fragola'
    'banana'
    'datteri'
    'melone'
    'uvetta'
    'anguria'
    'prugna'
    'mirtilli'
    'caramella'
    'granita'
    'meringa'
    'marmellata'
    'sorbetto'
    'budino'
    'baba'''
    'crostoli'
    'macaron'
    'crostata'
    'tiramisu'''
    'cannolo'
    'krapfen'
    'bigne'''
    'torta'
    'pasticcino'
    'peperone'
    'aglio'
    'porro'
    'fagioli'
    'patata'
    'olive'
    'lenticchie'
    'ceci'
    'gorgonzola'
    'cracker'
    'salame'
    'polenta'
    'wurstel'
    'pagnotta'
    'focaccia'
    'farinata'
    'lasagna'
    'carbonara'
    'ravioli'
    'chili'
    'cannelloni'
    'pizza'
    'goulasch'
    'paella'
    };

%% Stimoli provvisori
stim={
    'anguria'
    'baba'''
    'aglio'
    };

%% LOAD stimoli da png
load('loadpic.mat')
eachimage=1 %un'immagine per ogni item
%% Trials
myTrials=[]; %tabella vuota

for i=1:length(stim2)
    myTrials(i).task=thisTask;
    myTrials(i).itemNumber=i;
    myTrials(i).eaten=0;
    myTrials(i).known=0;
    %myTrials(i).RT=0;
    %myTrials(i).imageStart=0;
    %myTrials(i).imageEnd=0;
    %myTrials(i).im= imread([imageList{i} '.jpg']); %mette automaticamente .jpg alla fine di ogni file di imagelist
    %myTrials(i).name=stim{i}; %mostra nome per ogni trial
    myTrials(i).pic= imagefiles(i).name %% - CONTROLLARE SE SALVA
    %myTrials(i).pic= % nome immagine caricata
    %myTrials(i).tex= Screen('MakeTexture',window,blockTrials(i).im);
end
%% specifiche schermo
Screens=Screen('Screens');
whichScreen= max (Screens);
[w, screenRect] = Screen ('openwindow', whichScreen, [0 0 0]); %max screen [215 171 126]

%% leggi immagine PNG
%uniquebgcolor=[0 0 0]; % <- select a color that does not exist in your image!!!

%% font
Screen(w,'textsize', 40); % bigger
Screen(w,'textstyle',1);  % bold

%% istruzioni
[nx, ny, bbox] = DrawFormattedText (w, 'QUESTIONARIO', 'center','center', [255 255 255]); %[102 51 51]
Screen(w,'flip');
KbWait
pause(.5);

%% ciclo per ogni immagine

for j= 1: length(stim2)
%     ima = imread(myTrials(j).pic, 'png','BackgroundColor',uniquebgcolor);
%     mask = bsxfun(@eq,ima,reshape(uniquebgcolor,1,1,3));
%     image(ima,'alphadata',1-double(all(mask,3)));
    ima = imread(myTrials(j).pic, 'png');


    Screen('PutImage', w, ima); % put image on screen
    Screen(w,'TextSize',40);
    DrawFormattedText (w, 'MANGIATO= 1; MAI MANGIATO= 0', ...
        'center',screenRect(4)-850);
    
    keyIsDown=0;
    Screen(w,'flip');
    while ~keyIsDown
        [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
    end
    
    %% GetResponse
    KbReleaseWait
    response=KbName(keyCode);
    disp('hai premuto') %se premi esce questa scritta su MATLAB
    %RT = GetSecs-(experimentStart+blockTrials(trial).imageStart);
    myTrials(j).eaten = str2num(response(1));
    
    if myTrials(j).eaten == 1
        myTrials(j).known = 1;
    end
    
    if myTrials(j).eaten == 0
        Screen('PutImage', w, ima);
        %DrawFormattedText (window, c1{trial},'center', 'center',[102 51 51], 0);
        Screen(w,'TextSize',40);
        DrawFormattedText (w, 'LO CONOSCO= 1; NON LO CONOSCO= 0', ...
            'center', screenRect(4)-850);
        
        keyIsDown=0;
        Screen(w,'flip');
        while ~keyIsDown
            [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
        end
        
        KbReleaseWait
        response2=KbName(keyCode);
        disp('hai premuto') %se premi esce questa scritta su MATLAB
        %RT = GetSecs-(experimentStart+blockTrials(trial).imageStart);
        myTrials(j).known = str2num(response2(1));
    end
    
    DrawFormattedText (w, '+', 'center','center', [255 255 255]);
    Screen(w,'flip');
    %KbWait
    pause(.5);
end

%%  save responses
save(['OutPut_',options.subjectInitials, '_run_'  num2str(run) '_modality_' num2str(modality)])

%% Grazie
[nx, ny, bbox] = DrawFormattedText (w, 'GRAZIE', 'center','center', [102 51 51]);
Screen(w,'flip');
KbWait
pause(.5);

%% Cursor
%ShowCursor

%% Close
sca; % Screen Close All %%% Important! %%
