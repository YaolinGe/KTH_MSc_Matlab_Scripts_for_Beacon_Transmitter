function [result, Nvalid] = LPfiltering(input, LP_impls, Ninput, NLP)
%% conduct the low pass filtering operation
result = zeros(1, Ninput);
intersum = zeros(1: NLP);
Nvalid = Ninput;
i_res = 1;
for i = 1:Ninput
    intersum(:) = input(i:i+NLP-1).*LP_impls;
    result(i_res) = sum(intersum);
    i_res = i_res + 1;
end %for

end %LPfiltering