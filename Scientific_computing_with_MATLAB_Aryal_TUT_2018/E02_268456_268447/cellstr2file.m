function cellstr2file(strings, filename)
% CELLSTR2FILE writes the strings in a file. 
%
% cellstr2file(strings, filename) writes the strings in the cell
% array strings into the file 'filename', one string per line.

    if nargin < 2
        filename = uiputfile;
    end
    
    assert(iscellstr(strings),'The first argument must be cell array of strings.')
    assert(ischar(filename),'The second argument must be a string.')
    fid = fopen(filename,'w');

    for i=1:1: length(strings)
        fprintf(fid,strings{i});

    end
    fclose(fid);
end