function Experiment_CogPsy
%% Conditions and Instructions
x=input('Enter Subj Number ');
c=[1 1 1 1 1 1 2 2 2 2 2]; %conditions given to different tasks...1=magnitude 2=parity
c=Shuffle(c);

[win, screenRect] = Screen ('OpenWindow', 0, [127 127 127], [50 50 1800 1000]); %[0 0 0]
DrawFormattedText(win, 'Welcome to our experiment!!! \n\n\n\n Press any key to continue.','center','center', [0 0 0]);
Screen (win, 'Flip')
KbWait;
DrawFormattedText(win, 'INSTRUCTIONS \n\n\n\n During each trial you will be adimistered two different tasks, \n\n each one preceded by a cue (a blue or a red square). \n\n\n The blue square corrsponds to the Magnitude Task, to which you will answer \n\n with your left hand; \n\n the red square corresponds to the Parity Task, and you will have to answer \n\n using your right hand. \n\n\n\n Press any key to continue with instructions.', 'center', 'center', [0 0 0]);
Screen(win, 'Flip')
KbWait;
DrawFormattedText(win, 'MAGNITUDE TASK \n\n\n Press "a" if the number shown is <5 \n\n while press "s" if the number is >5. \n\n\n\n PARITY TASK \n\n\n Press "k" if the number is even, \n\n while press "l" if the number is odd. \n\n\n\n Please try to be more accurate and fast as possible \n\n and remeber to answer to Magnitude Task with your left hand \n\n and to Parity Task with your right hand \n\n\n\n Press any key to start.', 'center', 'center', [0 0 0]);
Screen(win, 'Flip')
KbWait;
pause (.5);

ScreenCntrX = screenRect(RectRight)/2;
ScreenCntrY = screenRect(RectBottom)/2;

%% (Experiment Onset (randomized stimulus presentation)
answer=zeros(40,20);
giuste=zeros(40,20);
s={'1' '2' '3' '4' '6' '7' '8' '9'};
r=randperm(8,8);
keysOfInterest=zeros(1,256);
keysOfInterest(KbName({'a','s','k','l'}))=1;
KbQueueCreate(-1,keysOfInterest);
color=[255 0 0;0 0 255];

for trial=1:length(c)
    %% --------------------------------------TASK1, Magnitude----------------------------------------------
    if c(trial)==1
        rS=s(r);
        for i = 1:8
            r2=randperm(2,1);
            numrSI=str2num(rS{i});
            n=trial*i+(trial-1)*(8-i);
            if r2==2 && numrSI<5
                giuste(n,x)=1;
            elseif r2==2 && numrSI>5
                giuste(n,x)=2;
            end
        end
        dot=Screen('DrawDots', win, [ScreenCntrX ScreenCntrY], 50 , color(r2,:), [],4);
        Screen(win, 'flip');
        pause(0.2)
        dot=Screen('DrawDots', win, [ScreenCntrX ScreenCntrY], 50 , [127 127 127], [],4);
        Screen(win, 'flip');
        pause(0.2)
        DrawFormattedText(win, rS{i},'center','center')
        Screen(win, 'flip');
        myStart1=GetSecs;
        while true
            [keyPressed, keyTime, keyCode] = KbCheck;
            resp = KbName (keyCode);
            KbQueueStart
            KbQueueWait
            if keyPressed resp = 'a'; % metti a posto di modo che uno dia 1 e l'altro 2
                answer(n,x)=1;
                break
            elseif keyPressed resp = 's';
                answer(n,x)=2;
                break
            end
            sec1=[];
            myStop1=GetSecs;
            sec(n,x)=myStop1-myStart1;
        end
    end
        %% -------------------------------------TASK2, Parity---------------------------------------------------------
    elseif c(trial)==2 %Parity Task
        rS=s(r);
        for i = 1:8
            r2=randperm(2,1);
            numrSI=str2num(rS{i});
            n=trial*i+(trial-1)*(8-i);
            if r2==1 && mod(numrSI,2)==0
                giuste(n,x)=1;
            elseif r2==1 && mod(numrSI,2)==1
                giuste(n,x)=2;
            end
            dot=Screen('DrawDots', win, [ScreenCntrX ScreenCntrY], 50 , color(r2,:), [],4);
            Screen(win, 'flip')
            pause(0.2)
            dot=Screen('DrawDots', win, [ScreenCntrX ScreenCntrY], 50 , [127 127 127], [],4);
            Screen(win, 'flip')
            pause(0.2)
            DrawFormattedText(win, rS{i},'center','center')
            Screen(win, 'flip')
            myStart2=GetSecs;
            while true
                [keyPressed, keyTime, keyCode] = KbCheck;
                resp = KbName (keyCode);
                KbQueueStart
                KbQueueWait
                if keyPressed resp = 'k'; % metti a posto di modo che uno dia 1 e l'altro 2
                    answer(n,x)=1;
                    break
                elseif keyPressed resp = 'l';
                    answer(n,x)=2;
                    break
                end
                sec2=[];
                myStop2=GetSecs;
                sec(n,x)=myStop2-myStart2;
            end
        end
    end
    
    
    pause(1);
    DrawFormattedText(win, 'The experiment is over! \n\n\n\n Thank you :) ','center','center', [0 0 0]);
    Screen (win, 'Flip')
    KbWait;
    pause(.5)
    sca
    
    %da qui ----------
    accuracyM=[];
    for n1=1:40
        for n2=1:20
            if answer(n1,n2)==giuste(n1,n2)
                accuracyM(n1,n2)=1;
            else accuracyM(n1,n2)=0;
            end
        end
    end
    % --- a qui
    %si pu� semplificare con accuracyM=zeros(40,20); accuracyM(answer==giuste)=1;
    
    accuracy=sum(accuracyM)/40*100;
    %save subject data
    subNum=num2str(x);
    saveName=['subj' subNum];
    save (saveName, 'accuracy', 'accuracyM', 'answer', 'sec')
    
end
end

