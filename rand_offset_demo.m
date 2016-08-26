for i = 1:100
     st = 40;
    offset = 0
    %theImageLocation = myTrials(randi([1 680])).filepath
   theImageLocation = '/Users/aidas_el_cap/Desktop/im_39.jpg'
    theImage = imread(theImageLocation);
    imageTexture = Screen('MakeTexture', window, theImage);
    
if mod(i,2) == 0
    e1 = e1 - offset;
    e2 = e2 - offset;
     xCenter = xCenter - offset
else
    e1 = e1 + offset;
    e2 = e2 + offset;
    xCenter = xCenter + offset;
end

Screen('DrawLines', window, allCoords,lineWidthPix, white, [xCenter 350]);
Screen('Flip', window);
WaitSecs(3)
Screen('DrawTexture', window, imageTexture, [], [e1 e3 e2 e4],0); 
taskIntruct = myTrials(randi([1 680])).taskIntruct
DrawFormattedText(window, taskIntruct, cCenter, 550, white); 
Screen('Flip', window);
WaitSecs(1)
Screen('Flip', window);


[xCenter, yCenter] = RectCenter(windowRect);  
 e1 = xCenter - s2/2;
 e2 = xCenter + s2/2;
 e3 = yCenter - s1/2 - 150;
 e4 = yCenter + s1/2 - 150;

  e1 = e1 - st;
  e2 = e2 + st;
  e3 = e3 - st;
  e4 = e4 + st;
end
taskIntruct = myTrials(randi([1 680])).taskIntruct