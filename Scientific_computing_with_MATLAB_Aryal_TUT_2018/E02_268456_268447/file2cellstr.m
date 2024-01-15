% Mukesh Aryal 268456
% Ujjwal Aryal 268447

function s=file2cellstr(filename)
% FILE2CELLSTR reads the content of a text file.
%
% s=file2cellstr(filname) reads the text file filename and returns
% the nonempty lines in cell array s. 
s={};
if nargin<1 
        [filen, pathn] = uigetfile('*.txt', 'Choose a text file');
        assert(ischar(filen), 'No file selected.');
        filename = fullfile(pathn, filen);
end
file = fopen(filename);
tline = fgetl(file);
while ischar(tline)
    if ~isempty(tline)
        s{end+1}=tline;
    end
    tline = fgetl(file);
end
    

fclose(file);  
end
