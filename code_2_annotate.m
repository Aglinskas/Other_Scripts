function createfigure(cdata1)
%CREATEFIGURE(CDATA1)
%  CDATA1:  image cdata

%  Auto-generated by MATLAB on 18-Mar-2016 19:58:27

% Create figure
figure1 = figure('Colormap',...
    [0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0476 1;0 0.0952 1;0 0.1429 1;0 0.1905 1;0 0.2381 1;0 0.2857 1;0 0.3333 1;0 0.381 1;0 0.4286 1;0 0.4762 1;0 0.5238 1;0 0.5714 1;0 0.619 1;0 0.6667 1;0 0.7143 1;0 0.7619 1;0 0.8095 1;0 0.8571 1;0 0.9048 1;0 0.9524 1;0 1 1;0.1667 1 0.8333;0.3333 1 0.6667;0.5 1 0.5;0.6667 1 0.3333;0.8333 1 0.1667;1 1 0;1 0.9524 0;1 0.9048 0;1 0.8571 0;1 0.8095 0;1 0.7619 0;1 0.7143 0;1 0.6667 0;1 0.619 0;1 0.5714 0;1 0.5238 0;1 0.4762 0;1 0.4286 0;1 0.381 0;1 0.3333 0;1 0.2857 0;1 0.2381 0;1 0.1905 0;1 0.1429 0;1 0.0952 0;1 0.0476 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0;0.5 0 0],...
    'Color',[1 1 1]);

% Create subplot
subplot1 = subplot(1,2,1,'Parent',figure1);
hold(subplot1,'on');

% Create image
image(cdata1,'Parent',subplot1,'CDataMapping','scaled');

%% Uncomment the following line to preserve the X-limits of the axes
% xlim(subplot1,[0.5 13.5]);
%% Uncomment the following line to preserve the Y-limits of the axes
% ylim(subplot1,[0.5 13.5]);
box(subplot1,'on');
axis(subplot1,'square');
axis(subplot1,'ij');
% Set the remaining axes properties
set(subplot1,'Layer','top','XTick',[],'YTick',[]);
% Create subplot
subplot2 = subplot(1,2,2,'Parent',figure1);
axis off

% Create text
text('Parent',subplot2,'HorizontalAlignment','center','FontSize',0.06,...
    'FontUnits','normalized',...
    'String',{'\bfeach similarity matrix (13^2)','separately rank-transformed','and scaled into [0,1]'},...
    'Position',[6.5 6.5 0],...
    'Visible','on');

%% Uncomment the following line to preserve the X-limits of the axes
% xlim(subplot2,[0.5 13.5]);
%% Uncomment the following line to preserve the Y-limits of the axes
% ylim(subplot2,[0.5 13.5]);
box(subplot2,'on');
axis(subplot2,'square');
axis(subplot2,'ij');
% Set the remaining axes properties
set(subplot2,'Layer','top');
% Create colorbar
colorbar('peer',subplot2);

% Create axes
axes1 = axes('Parent',figure1);
axis off
hold(axes1,'on');

% Create text
text('Parent',axes1,'VerticalAlignment','top','HorizontalAlignment','right',...
    'FontWeight','bold',...
    'FontSize',14,...
    'String','Subject 01',...
    'Position',[1.11 1.08 0],...
    'Visible','on');

% Create title
title('Test');

%% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[0 1]);
%% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[0 1]);
% Create textbox
annotation(figure1,'textbox',...
    [0.131667132708585 0.873244020176819 0.337864117291415 0.0507041998879063],...
    'String','1   2   3   4   5   6   7   8   9  10 11 12 13',...
    'FontSize',24,...
    'FitBoxToText','off');

% Create textbox
annotation(figure1,'textbox',...
    [0.10725 0.82200647249191 0.0161875 0.0323624595469266],'String','1',...
    'HorizontalAlignment','center',...
    'FontSize',16,...
    'FitBoxToText','off');

% Create textbox
annotation(figure1,'textbox',...
    [0.10646875 0.770226537216829 0.0161875 0.0323624595469266],'String','2',...
    'HorizontalAlignment','center',...
    'FontSize',16,...
    'FitBoxToText','off');

% Create textbox
annotation(figure1,'textbox',...
    [0.10803125 0.710355987055017 0.0161875 0.0323624595469266],'String','3',...
    'HorizontalAlignment','center',...
    'FontSize',16,...
    'FitBoxToText','off');

% Create textbox
annotation(figure1,'textbox',...
    [0.10646875 0.663430420711975 0.0161875 0.0323624595469266],'String','4',...
    'HorizontalAlignment','center',...
    'FontSize',16,...
    'FitBoxToText','off');

% Create textbox
annotation(figure1,'textbox',...
    [0.10725 0.606796116504857 0.0161875 0.0323624595469266],'String','5',...
    'HorizontalAlignment','center',...
    'FontSize',16,...
    'FitBoxToText','off');

% Create textbox
annotation(figure1,'textbox',...
    [0.10725 0.551779935275082 0.0161875 0.0323624595469266],'String','6',...
    'HorizontalAlignment','center',...
    'FontSize',16,...
    'FitBoxToText','off');

% Create textbox
annotation(figure1,'textbox',...
    [0.10803125 0.496763754045309 0.0161875 0.0323624595469266],'String','7',...
    'HorizontalAlignment','center',...
    'FontSize',16,...
    'FitBoxToText','off');

% Create textbox
annotation(figure1,'textbox',...
    [0.1088125 0.443365695792881 0.0161875 0.0323624595469268],'String','8',...
    'HorizontalAlignment','center',...
    'FontSize',16,...
    'FitBoxToText','off');

% Create textbox
annotation(figure1,'textbox',...
    [0.10725 0.3915857605178 0.0161874999999999 0.0323624595469268],...
    'String','9',...
    'HorizontalAlignment','center',...
    'FontSize',16,...
    'FitBoxToText','off');

% Create textbox
annotation(figure1,'textbox',...
    [0.1056875 0.338187702265372 0.0161875 0.0323624595469267],'String','10',...
    'HorizontalAlignment','center',...
    'FontSize',16,...
    'FitBoxToText','off');

% Create textbox
annotation(figure1,'textbox',...
    [0.10803125 0.288025889967638 0.0161875 0.0323624595469266],'String','11',...
    'HorizontalAlignment','center',...
    'FontSize',16,...
    'FitBoxToText','off');

% Create textbox
annotation(figure1,'textbox',...
    [0.10803125 0.228155339805825 0.0161875 0.0323624595469267],'String','12',...
    'HorizontalAlignment','center',...
    'FontSize',16,...
    'FitBoxToText','off');

% Create textbox
annotation(figure1,'textbox',...
    [0.1088125 0.174757281553399 0.0161875 0.0323624595469267],'String','13',...
    'HorizontalAlignment','center',...
    'FontSize',16,...
    'FitBoxToText','off');

% Create textbox
annotation(figure1,'textbox',...
    [0.1150625 0.805825242718447 0.0161875 0.0323624595469266],'String',{'1'},...
    'HorizontalAlignment','center',...
    'FontSize',16,...
    'FitBoxToText','off');

% Create textbox
annotation(figure1,'textbox',...
    [0.56115625 0.0372168284789644 0.18571875 0.322006472491909],...
    'String',{'1. = ''Hair Color''','2. = ''First memory''','3. = ''Attractiveness''','4. = ''Friendliness''','5. = ''Trustworthiness''','6. = ''Positive Emotions''','7. = ''Familiarity''','8. = ''How much write''','9. = ''Common name''','10. = ''How many facts''','11. = ''Occupation''','12. = ''Distinctiveness of face''','13. = ''Integrity'''},...
    'FontSize',13,...
    'FitBoxToText','off');

