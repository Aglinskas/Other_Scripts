% Open initial window;
[win myRect] = Screen('OpenWindow',0,[127 127 127], [0 0 640 480])
%%
Screen('FillRect',win,[255 0 0],[50 50 100 100]); %Draw a rect
Screen('Flip',win);

rectangleSize=100;
gridSize=5;
% Create rectangles
myCounter=0;
for x=1:rectangleSize:rectangleSize*gridSize
    for y=1:rectangleSize:rectangleSize*gridSize
        myCounter=myCounter+1
        %[x y]
        [x y x+rectangleSize/2 y+rectangleSize/2]
myRects(myCounter,:)=[x y x+rectangleSize/2 y+rectangleSize/2];
    end
end
%% Open new win if needed
 [win screenRect]=Screen('OpenWindow',0,[127 127 127], [0 0 640 480]); 
%% Using myRects
totalNumberRect=myCounter;
for k=1:totalNumberRect
    Screen(win,'FillRect',[1],myRects(k,:));
    %Screen(win,'Flip',[],1)
    %pause(1)
end
Screen('Flip',win) % flip 
%% Using the mouse 

timeToWait = 2; %2s
timeNow = GetSecs;
disp('Started')
while GetSecs < timeNow+timeToWait
    %do nothing
end
disp('Finished')
%% Get Mouse
while true
 	 [mouseX,mouseY,buttons] = GetMouse(win);
   if buttons(1)
 		break
    end
end
disp('done')
%sca

%% Simple mouse click example
noClickYet = true
while noClickYet;
    
    [mouseX, mouseY, buttons] = GetMouse(win);
    if buttons(1);
    for k = 1:totalNumberRect;
        if mouseX>myRects(k,1)&mouseX<myRects(k,3)& mouseY>myRects(k,2)&mouseY<myRects(k,4);
            noClickYet = false
        end
    end
    end
end
    
   

