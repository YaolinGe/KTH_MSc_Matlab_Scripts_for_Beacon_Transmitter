function v = get_data_inbetween(file, str_end)
s = fgetl(file);
counter = 1;
delim = ';';
data_cnt = 1;
flag = 0;
% while(ischar(s)&&counter<2000)
while(ischar(s))
    if (sum(ismember(s,lower(delim)))== data_cnt)
        value = strtok(s, ';');
        v(counter) = str2double(value);
    end %if
    if strcmp(s, str_end)
        flag = 1;
        break;
    end %if
    counter = counter + 1;
    s = fgetl(file);
end %while
if (~flag)
    v = 0;
end

end %funct