clear;close all;clc;
baseVal = 2:30;
powerVal = 2:15;
shift = 1;
whichSeq = 1;
for i = 2
    for j = 2:15
        generate_mseq(i, j, shift, whichSeq);
    end %for
end %for

for i = 3
    for j = 2:7
        generate_mseq(i, j, shift, whichSeq);
    end %for
end %for

for i = 5
    for j = 2:4
        generate_mseq(i, j, shift, whichSeq);
    end %for
end %for

function generate_mseq(baseVal, powerVal, shift, whichSeq)
%% Usage: generate m sequence in a text file to be imported later

y = mseq(baseVal, powerVal, shift, whichSeq);
filename = ['m_seq_', num2str(baseVal), '_', num2str(powerVal),'.txt'];
fid = fopen(filename, 'w+');
fprintf(fid, '%d\n', y);
fclose(fid);

end
