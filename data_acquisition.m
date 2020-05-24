function v = data_acquisition(dfile, name)
% acquire samples from the transducer
dpath = 'C:\Users\geyao\Desktop\';
filename = [dpath, dfile, '.txt'];
file = fopen(filename);
s = fgetl(file);
i = 1;
fsname = ['##START_', name, '##'];
fename = ['##END_', name, '##'];
while (ischar(s)&&~feof(file))
    if (strcmp(s,fsname))
        v(:,i) = get_data_inbetween(file, fename);
        i = i + 1;
    end %if
    s = fgetl(file);
end
% v = v(:);

