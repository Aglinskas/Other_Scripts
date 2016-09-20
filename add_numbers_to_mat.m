% add numbers to conf mat
% add_numbers_to_mat(matrix,lbls)
%
function add_numbers_to_mat(matrix,lbls)

imagesc(matrix)
current_mat_fig = gcf

if size(matrix,1) ~= size(matrix,2)
    %max(current_mat_fig.CurrentAxes.XTick) ~= max(current_mat_fig.CurrentAxes.YTick)
error('Not a square matrix')
end

if length(lbls) > size(matrix,1)
    lbls
    error('Too many labels')
elseif length(lbls) < size(matrix,1)
    lbls
    error('Too few labels')
end

current_mat_fig.CurrentAxes.YTick = 1:size(matrix,1);
current_mat_fig.CurrentAxes.YTickLabel = lbls%num2str(ord)
current_mat_fig.CurrentAxes.XTick = 1:size(matrix,1);
current_mat_fig.CurrentAxes.XTickLabel = lbls%num2str(ord)
current_mat_fig.CurrentAxes.YTickLabelRotation = 0
current_mat_fig.CurrentAxes.XTickLabelRotation = 15

textStrings = num2str(matrix(:),'%0.2f');
textStrings = strtrim(cellstr(textStrings));
[x,y] = meshgrid(1:length(matrix));
hStrings = text(x(:),y(:),textStrings(:),'HorizontalAlignment','center');
midValue = max(get(gca,'CLim'));%# Get the middle value of the color range
textColors = repmat(matrix(:) > midValue,1,3);  %# Choose white or black for the
set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors
end