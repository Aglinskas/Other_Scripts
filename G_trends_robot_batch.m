list_fn = 'top_names.xlsx';
T = readtable(fn)
items = T.Variables;
items = cellfun(@(x) strrep(x,' ','%20'),items,'UniformOutput',0);
%%
for n = 1:length(items)
disp(sprintf('%d/%d: %s',n,length(items),items{n}))
url_temp = 'https://trends.google.com/trends/explore?q=%s';
url = sprintf(url_temp,items{n});
clipboard('copy',url);
%%
mouse_pos1 = [-665, -973]; % URL BAR position
mouse_pos2 = [210,-365]; % Share button position 
mouse_pos3 = [109,-268]; % DL button position

import java.awt.Robot;
import java.awt.event.*;
Robot = Robot;
Robot.mouseMove(mouse_pos1(1),mouse_pos1(2));
pause(1)
Robot.mousePress(InputEvent.BUTTON1_MASK);    %//left click press
Robot.mouseRelease(InputEvent.BUTTON1_MASK);  % //left click release
pause(.1)

Robot.keyPress(java.awt.event.KeyEvent.VK_META)
Robot.keyPress(java.awt.event.KeyEvent.VK_V)
Robot.keyRelease(java.awt.event.KeyEvent.VK_META)
Robot.keyRelease(java.awt.event.KeyEvent.VK_V)
pause(.1)
Robot.keyPress(java.awt.event.KeyEvent.VK_ENTER)
Robot.keyRelease(java.awt.event.KeyEvent.VK_ENTER)
% URl Opening
pause(5)

Robot.mouseMove(mouse_pos2(1),mouse_pos2(2));
pause(1)
Robot.mousePress(InputEvent.BUTTON1_MASK);    %//left click press
Robot.mouseRelease(InputEvent.BUTTON1_MASK);  % //left click release
pause(.1)

Robot.mouseMove(mouse_pos3(1),mouse_pos3(2));
pause(1)
Robot.mousePress(InputEvent.BUTTON1_MASK);    %//left click press
Robot.mouseRelease(InputEvent.BUTTON1_MASK);  % //left click release
pause(3)
end