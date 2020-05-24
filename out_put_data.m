function out_put_data(dpath, filename, x)
%% this function is used to output data into .txt file

if ischar(dpath)
    fid = fopen([dpath, filename,'.txt'], 'w+');
    if isrow(x)
        x = x';
    end %if
    fprintf(fid, "%d;\n", x);
    fclose(fid);
else
    disp("hi")
    dpath = 'C:\Users\geyao\Desktop\';
    fid = fopen([dpath, filename, '.txt'], 'w+');
    if isrow(x)
        x = x';
    end %if
    fprintf(fid, "%d;\n", x);
    fclose(fid);
end %if

disp("output is done ")

end %out_put_data