cd '/Users/aidasaglinskas/Downloads/Assignment 2/Assignment 2 Stimuli'


%cd into the 'Assignment 2 Stimuli' folder
% Define the names
stimNames={'ant','axe','banana','bat','belt','brush', 'canary', 'cape', 'cat','cherry','dog', 'dress', 'duck','eagle','fox','goat','goose','hat','jacket','kiwi','koala','ladder','lemon','lion','mole','peach','pencil','penguin','pig','pumpkin','rabbit','sheep','shirt','shoe','skunk','swan','tiger','tomato','zebra'};

for stimCounter = 1:length(stimNames)
stimulus(stimCounter).name = stimNames{stimCounter}
    

% construct the image path
impath = ['./images/' stimNames{stimCounter} '.jpg'];
% Read in the image
img = imread(impath);
% attache the image matrix
stimulus(stimCounter).pic = img;

% sound path 
soudpath = ['./words/' stimNames{stimCounter} '.wav'];
% sound vector
y = audioread(soudpath);
stimulus(stimCounter).sound = y;
end
%%
stimulus = Shuffle(stimulus);

%to play a sound, don't forget the sampling frequence Fs
Fs = 44100;
sound(stimulus(2).sound,Fs);

stimulus = Shuffle(stimulus)