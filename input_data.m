function y = input_data(dfile)
dpath = 'C:\Users\geyao\Desktop\';
filename = [dpath, dfile, '.txt'];
y = get_data_sonarfile(filename, 1);



