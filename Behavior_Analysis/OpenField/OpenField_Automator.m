%Hi user! This is an automated script for open field analsis with the following preselected parameters:
    %threshold=0.8, time = 1 min (1800 frames), # of mice = 1, min pixel =
    %25 (which have been defined in OpenField.m)
%If you wish to use different paramaters let me (Becky) know, otherwise you
%can also set them yourself by using the script: MouseActivity5.m
%However, this can only process one video at a time. 

%N.B.:
    %Please double click to select your arena area once it has been defined.
    %Make sure you have copied the poi folder into your MATLAB source
    %location - you may need admin access for this!
    %This code assumes the arena is a circle with a diameter of 38.5cm.


%Find matching files with .mp4 ending and loop through, if no folder with
%same name exists, use OpenField(), else skip (this covers case of pc crash
%leaving entire process needing to be restarted)

function OpenField_Automator()


clc; % clear the command window
close all; % close all figures
clear; % erase all existing variables

CUSTOMDIRECTORY = matlabroot; %Add working path to this variable and replace matlabroot, this way every folder selection is fast! 
folderpath = uigetdir(CUSTOMDIRECTORY, 'Select folder to analyse:');
path = convertCharsToStrings(folderpath);
files = dir(fullfile(folderpath,'*.mp4'));
unanalysedfiles = [];
if ~isempty(files)
    for i = 1:length(files)
    %disp(files(i));
    %disp(class(folderpath));
    subfolder = convertCharsToStrings(replace(files(i).name, '.mp4',''));
    %disp(subfolder);
    %disp(class(subfolder));
        if ~exist(path+'\'+subfolder,'dir')
            unanalysedfiles = [unanalysedfiles, files(i)];
        end
    end  
    
end
if ~isempty(unanalysedfiles)
    for i = 1:length(unanalysedfiles)   
        OpenField(unanalysedfiles(i).name,folderpath, int2str(i), int2str(length(unanalysedfiles)));
    end
end
logf('OpenField Folder Analysis Complete.');

end

function logf(varargin)
    message = sprintf(varargin{1}, varargin{2:end});
    str = ['[' datestr(now(), 'HH:MM:SS') '] ' message];
    disp(str);
end