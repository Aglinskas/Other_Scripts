old_coords = [];
buttons = [];
while sum(buttons) == 0
old_coords = new_coords;
[x,y,buttons,focus,valuators,valinfo] = GetMouse(ptb.window);

new_coords = [x;y];

if all(old_coords == new_coords) ~= 1
    clc
    disp(new_coords)
    
end
end