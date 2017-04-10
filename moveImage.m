%Open the screen 
[wPtr,rect]=Screen('OpenWindow',0,[0 0 0],[0 0 640 480]); %
xCenter=rect(3)/2; 
yCenter=rect(4)/2; 
%Create texture
myImage = imread('cat2.jpeg'); 
faceTexture = Screen('MakeTexture', wPtr, myImage);
%Get size of image 
[imageHeight, imageWidth] = size(myImage); 
%Define image rect
%imageRect = [0 0 imageWidth imageHeight]; 
%Left right

middle = [rect(3)/ 2 rect(4)/ 2];
top_corner_Y_Left = 50;
sq_size = 100; 
leftRect = [middle(1)-sq_size middle(2)-sq_size/2 middle(1) middle(2)+sq_size/2]
rightRect = [middle(1) middle(2)-sq_size/2 middle(1)+sq_size middle(2)+sq_size/2]
      %gap=10;
      %leftRect=[xCenter-gap-imageWidth,yCenter-imageHeight/2,xCenter-gap,yCenter+imageHeight/2];
      % leftRect = [0 0 100 100]
      %rightRect=[xCenter+gap,yCenter-imageHeight/2,xCenter+gap+imageWidth,...
      %   yCenter+imageHeight/2];
    
%Draw it 
    Screen('DrawTexture', wPtr, faceTexture,[],leftRect); 
%    Screen('DrawTexture', windowPointer, texturePointer [,sourceRect] [,destinationRect] [,rotationAngle] [, filterMode] [, globalAlpha] [, modulateColor] [, textureShader] [, specialFlags] [, auxParameters]);

    Screen(wPtr,'flip'); 
%Wait for keypress and clear 
%WaitSecs(2); 
%KbWait(); 
%clear Screen; 
