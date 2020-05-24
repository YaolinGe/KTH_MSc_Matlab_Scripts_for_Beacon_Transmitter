function d=get_data_sonarfile(filename,data_cnt)
    counter = 1;
%     data_cnt=1;
    delim = ';';
    file = fopen(filename);
    string = fgetl(file);
    temp={};
    while ischar(string)

        % Count number of ';'
        if(sum(ismember(string,lower(delim))) == data_cnt)

            for( i = 1 : 1 : data_cnt)
                [value,remainder] = strtok(string,';');
                temp{counter,i} = str2double(value);
                string = remainder;
            end
        end
        counter = counter+1;
        string = fgetl(file);
    end
    if(isempty(temp)~=1)
        d = cell2mat(temp);
    else
        d=[];
    end
    fclose(file);
end