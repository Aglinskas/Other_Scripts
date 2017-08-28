
function add_numbers_to_mat(varargin)

switch nargin
% if nargin == 0
    case 0
    error('gimme at least a matrix to number')
% elseif nargin == 1
    case 1
    matrix = varargin{1};
% elseif nargin == 2
    case 2
    matrix = varargin{1};
    lbls = varargin{2};
    case 3
    matrix = varargin{1};
    %lbls1 = varargin{2};  
    %lbls2 = varargin{3};  
    lblsx = varargin{cellfun(@(x) [isequal(length(x), size(matrix,2)) && isvector(x)],varargin)};
    lblsy = varargin{cellfun(@(x) [isequal(length(x), size(matrix,1)) && isvector(x)],varargin)};
end

%save('/Users/aidasaglinskas/Desktop/args.mat')
imagesc(matrix);
current_mat_fig = gcf;

%if size(matrix,1) ~= size(matrix,2)
    %max(current_mat_fig.CurrentAxes.XTick) ~= max(current_mat_fig.CurrentAxes.YTick)
%error('Not a square matrix')
%end
% if nargin == 2
% if length(lbls) > size(matrix,1)
%     lbls
%     error('Too many labels')
% elseif length(lbls) < size(matrix,1)
%     lbls
%     error('Too few labels')
% end
% end

if nargin == 2
current_mat_fig.CurrentAxes.YTick = 1:size(matrix,1);
current_mat_fig.CurrentAxes.YTickLabel = lbls;%num2str(ord)
current_mat_fig.CurrentAxes.XTick = 1:size(matrix,1);
current_mat_fig.CurrentAxes.XTickLabel = lbls;%num2str(ord)
current_mat_fig.CurrentAxes.YTickLabelRotation = 0;
current_mat_fig.CurrentAxes.XTickLabelRotation = 15;
elseif  nargin == 3
current_mat_fig.CurrentAxes.YTick = 1:size(matrix,1);
current_mat_fig.CurrentAxes.YTickLabel = lblsy;%num2str(ord)
current_mat_fig.CurrentAxes.XTick = 1:size(matrix,2);
current_mat_fig.CurrentAxes.XTickLabel = lblsx;%num2str(ord)
current_mat_fig.CurrentAxes.YTickLabelRotation = 0;
current_mat_fig.CurrentAxes.XTickLabelRotation = 15;  
end

textStrings = num2str(matrix(:),'%0.2f');
textStrings = strtrim(cellstr(textStrings));
if size(matrix,1) == size(matrix,2);
[x,y] = meshgrid(1:length(matrix));
hStrings = text(x(:),y(:),textStrings(:),'HorizontalAlignment','center');
midValue = max(get(gca,'CLim'));%# Get the middle value of the color range
textColors = repmat(matrix(:) > midValue,1,3);  %# Choose white or black for the
set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors
else
    x = meshgrid(1:size(matrix,2));
    y = meshgrid(1:size(matrix,1));
    
hStrings = text;
pos = 1;
for x_ind = 1:length(x)
for y_ind = 1:length(y)
%hStrings = text(x(:),y(:),textStrings(:),'HorizontalAlignment','center');
hStrings(pos) = text(x(x_ind),y(y_ind),textStrings(pos),'HorizontalAlignment','center');
hStrings(pos).Position = [x_ind y_ind 0];
pos = pos+1;
end
end
midValue = max(get(gca,'CLim'));%# Get the middle value of the color range
textColors = repmat(matrix(:) > midValue,1,3);  %# Choose white or black for the
set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors    
% hStrings = text(x(:),y(:),textStrings(:),'HorizontalAlignment','center');
% midValue = max(get(gca,'CLim'));%# Get the middle value of the color range
% textColors = repmat(matrix(:) > midValue,1,3);  %# Choose white or black for the
% set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors
end
end