size_of_maze =  [100 100]; %Size of maze 
maze = zeros(size_of_maze); %Generate the maze


wall_l = 10; % Specify wall length (used later)

for i = 1:50 % Run 50 times 
xy_startDrawWall = [randi(size_of_maze(1)) randi(size_of_maze(2))];
%^ Choose random coorinates for where to start to draw a wall
if sum([xy_startDrawWall+ wall_l] < size_of_maze)
   %^ check if the drawn wall wouldn't exceed maze limits 
if randi(2) == 1 % toss a coin for horizontal or vertical line
maze(xy_startDrawWall(1):xy_startDrawWall(1)+wall_l,xy_startDrawWall(2)) = 1;
% Draw the wall vertically
else
maze(xy_startDrawWall(1),xy_startDrawWall(2):xy_startDrawWall(2)+wall_l) = 1;
end
end
end

figure(1)
imagesc(maze)

maze_set = maze;
%%
pac=[0 0 1 0 0;
     0 1 1 1 0;
     1 1 1 1 1;
     0 1 1 1 0;
     0 0 1 0 0];
pac(pac==1) = 2;
pacXY = [3,3]; % Start him off at a corner
mazeframe = maze_set;
mazeframe(pacXY(1)-2:pacXY(1)+2,pacXY(2)-2:pacXY(2)+2) = pac;
imagesc(mazeframe);
commandwindow

for i = 1:100
    [time keycode] = KbWait;
    pressed_key = KbName(keycode);
    
   if strcmp(pressed_key,'DownArrow')
       pacXY_new = pacXY + [0 1];
   elseif strcmp(pressed_key,'UpArrow')
       pacXY_new = pacXY - [0 1];
       elseif strcmp(pressed_key,'RightArrow')
           pacXY_new = pacXY + [1 0 ];
           elseif strcmp(pressed_key,'LeftArrow')
               pacXY_new = pacXY - [1 0 ];
               elseif strcmp(pressed_key,'ESCAPE')
   end%ends if check
    
   
pacXY_go = pacXY_new;
% Check for outside of the maze coords    
where_to_drawPAC = [pacXY_new(1)-2:pacXY_new(1)+2;pacXY_new(2)-2:pacXY_new(2)+2]
if sum(where_to_drawPAC(:) < 1) || sum(where_to_drawPAC(:) > length(maze))
pacXY_go = pacXY;
end
if sum(sum(mazeframe(where_to_drawPAC(1,:),where_to_drawPAC(2,:)) == 1)) > 0
    %^ checks for walls
pacXY_go = pacXY;
end

mazeframe = maze_set;
mazeframe(pacXY_go(1)-2:pacXY_go(1)+2,pacXY_go(2)-2:pacXY_go(2)+2) = pac;
imagesc(mazeframe);
end
