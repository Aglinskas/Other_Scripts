clear all
%% Set Input
% Figure out folders, by date of acquisition;
root.dir.fn = '/Volumes/Aidas_HDD/MRI_data2/';
root.dir.dicom.foldername = 'FAISCO003M2Z'
root.dir.dicom.folderpath = fullfile(root.dir.fn,root.dir.dicom.foldername)
root.dir.dicom.contents = dir(root.dir.dicom.folderpath); 
root.dir.foldernames = {root.dir.dicom.contents(3:end).name}';
    
temp.a = cellfun(@(x) strsplit(x,'_'),root.dir.foldernames,'UniformOutput',0);
root.folderDates = cellfun(@(x) x{2},temp.a,'UniformOutput',0);
%
% Date dimesnion is '2';
root.sorttable(:,1) = root.dir.foldernames;
root.sorttable(:,2)= root.folderDates;
root.tableSorted = sortrows(root.sorttable,2); %Sorted by time of acquisition;
%length(root.tableSorted)
% Deal subs
subs = [7:31];
[root.tableSorted(:,3)] = deal(num2cell(subs)); 
%root.tableSorted
% Nice effort, but doesn't work
% [root.sorttable(1:length(root.dir.foldernames)).filename] = deal(root.dir.foldernames{:});
% [root.sorttable.fileDate] = deal(root.folderDates{:});
%% Output
data.outputFolderName = 'Data';
    data.outputFolderPath = fullfile(root.dir.fn,data.outputFolderName);
data.struct_string = 't1_mprage_CNR';
data.epi_string= 'lnif_epi1_3x3x3_TR2500_DiCo';

  if exist(data.outputFolderPath) == 0 
      mkdir(data.outputFolderPath);end
%%
loop = struct;
for mlc = 1:length(root.tableSorted) %master loop counter
    
    loop.subID = root.tableSorted{mlc,3};
    loop.subfolder_name = root.tableSorted{mlc,1};
    loop.subfolder_path = fullfile(root.dir.dicom.folderpath,loop.subfolder_name);
    loop.subfolder_path_contents = dir(loop.subfolder_path);
    loop.subjectdata = dir(fullfile(loop.subfolder_path,loop.subfolder_path_contents(3).name));
    %length(loop.subjectdata)
  {loop.subjectdata.name}'
  
                %cellfun(@(x) strfind(x,data.epi_string),{loop.subjectdata.name}','UniformOutput',0)
  % find EPIs
  loop.temp.e = cellfun(@(x) strfind(x,data.epi_string),{loop.subjectdata.name}','UniformOutput',0)
  loop.EPI_inds = find(cellfun(@isempty,loop.temp.e) == 0);
  loop.EPI_names = {loop.subjectdata(loop.EPI_inds).name}';
  loop.EPI_fns = cellfun(@(x) fullfile(loop.subfolder_path,'LNIF_Fairhall_Scott_EightChannel',x),loop.EPI_names,'UniformOutput',0)
  
  %if length(loop.EPI_fns) ~= 5; error('not 5 runs');end

  % Find struct
  loop.temp.s = cellfun(@(x) strfind(x,data.struct_string),{loop.subjectdata.name}','UniformOutput',0)
  
  loop.struct_ind = find(cellfun(@isempty,loop.temp.s) == 0);
  %if length(loop.struct_ind) ~= 1; error(' more than 1 struct found or zero');end
  loop.structName = {loop.subjectdata(loop.struct_ind).name}';
  loop.structFN = fullfile(loop.subfolder_path,'LNIF_Fairhall_Scott_EightChannel',loop.structName)
  cellfun(@(x) fullfile(loop.subfolder_path,x),loop.structName,'UniformOutput',0)
  
  % Copy Over and Add
 loop.subExpdir = fullfile(data.outputFolderPath,['S' num2str(loop.subID)]);
 mkdir(loop.subExpdir)
 
 cellfun(@(x) copyfile(x,loop.subExpdir),loop.EPI_fns)
 
end
 disp('done')
 
 
 
 
 