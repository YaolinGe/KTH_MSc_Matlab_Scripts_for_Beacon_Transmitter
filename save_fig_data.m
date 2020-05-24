function save_fig_data(dpath, name, y)
out_put_data(dpath, name, y);
filename = [dpath,'\', name, '.pdf'];
print(gcf, '-dpdf', filename);
disp('save figure is done');
end