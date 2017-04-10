% N.B. 1
% during a kbcheck while loop if you press two buttons at once it stores it
% as a cell, if one button is pressed, it's stored as a char. 
% N.B. 2
% Some of you have KbReleaseWait twice in the loop, this makes for very
% laggy code, where typed keys will sometimes be missed

% Necessary constants (can be defined at this or earlier part if the code)
pause(1) % hacky temporal offset
all_Keys = {}; % for debuggin purposes
commandwindow
keyCode = [];
keyName = '';
myString  = [];

% CODE CONTEXT
% Usual PTB code:
% open PTB window,
% This code should be inside trial presentation for-loop, 
% blank screen where the participant will type the response should be open

while ~strcmp(keyName, 'Return') % Until 'Return' key is pressed
                [keyPressed, keyTime, keyCode]=KbCheck; % Check if Key is pressed, only if the key is pressed execute the code below (efficient!)
                     if keyPressed
                    keyName=KbName(keyCode); % get key name
                    all_Keys{end+1} = keyName; % for debugging

% if you press two keys at the same time (or in very rapid succession),
% they're stored as a cell, but the way you concatenate myString will crash
% with cell input
% Let's write code for what to do is keyName is a cell
if iscell(keyName) % if it's a cell 
        keyName = [keyName{:}]; % take all the cell items into an array
        % so if I press 'a' and 'b' gets pressed together 
        % keyname is {'a' 'b'}, and we'll turn it into ['ab'];
end

%before we record the literal value (we don't want to record space key press as 'SPACE')
% let's check for special meaning key presses (Space, delete, escape)
                        if strcmp(keyName, 'space') % if it's a space
                         myString=[myString ' '];
                        elseif strcmp(keyName, 'DELETE') % if it's delete
                            myString=myString(1:end-1);
                        elseif strcmp(keyName, 'ESCAPE') % if it's escape
                            sca; % close the screen 
                            error('Experiment Terminated'); % Write a message and terminate the rest of the code
                        else % if any other key is pressed
                            myString=[myString keyName(1)]; %
                        end
                        
                        % PRESENT THE STRING ON THE SCREEN

                            KbReleaseWait; % Wait for key Release
                     end
end

% INSERT CODE FOR WHAT HAPPENS AFTER THEY PRESS ENTER
% do you add it to myTrials? 
% do you move on to the next trial?

