function mouse_coords
old_coords = [nan nan];
new_coords = [nan nan];
buttons = [];
while sum(buttons) == 0
old_coords = new_coords;
%[x,y,buttons,focus,valuators,valinfo] = GetMouse(ptb.window);
[x,y,buttons,focus,valuators,valinfo] = GetMouse();
new_coords = [x;y];

if all(old_coords == new_coords) ~= 1
    clc
    disp(num2str(new_coords))
    
end
end

end