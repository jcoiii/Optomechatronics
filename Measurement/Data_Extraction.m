clear; clc;
time = cell(1, 12);
inp_lvdt = cell(1, 12);
out_lvdt = cell(1, 12);
inp_ampf = cell(1, 12);
inp_lvdt_trimmed = cell(1, 12);
out_lvdt_trimmed = cell(1, 12);
time_trimmed = cell(1, 12);

for i = 28:39
    % Generate the file name
    filename = sprintf('exp1_%03d.mat', i);
    data = load(filename);
   
    varname = strrep(filename, '.mat', '');  % remove the '.mat' file ext
    time{i-27} = data.(varname).X.Data;
    inp_lvdt{i-27} = data.(varname).Y(1).Data;
    out_lvdt{i-27} = data.(varname).Y(2).Data;
    inp_ampf{i-27} = data.(varname).Y(3).Data;
    [n,p] = size(out_lvdt{i-27});
    if p < 15000
        zero_crossings = find(diff(sign(out_lvdt{i-27})) ~= 0);
        start_index= zero_crossings(1);
        end_index= zero_crossings(5);
    elseif p > 25000
        zero_crossings = find(diff(sign(out_lvdt{i-27})) ~= 0);
        start_index= zero_crossings(3);
        end_index= zero_crossings(end-30);
    elseif (p > 20000) && (p < 21000)
        zero_crossings = find(diff(sign(out_lvdt{i-27})) ~= 0);
        start_index= zero_crossings(1);
        end_index= zero_crossings(end-7);
    elseif (p > 21000) && (p < 23000)
        zero_crossings = find(diff(sign(out_lvdt{i-27})) ~= 0);
        start_index= zero_crossings(1);
        end_index= zero_crossings(end-5);
    end
    inp_lvdt_trimmed{i-27} = inp_lvdt{i-27}(start_index:end_index);
    out_lvdt_trimmed{i-27} = out_lvdt{i-27}(start_index:end_index);
    time_trimmed{i-27} = time{i-27}(start_index:end_index);
end

Ts = 0.001;
allData = [];
for i = 1:numel(time_trimmed)
    data = iddata(out_lvdt_trimmed{i},  inp_lvdt_trimmed{i}, Ts); 
    allData = [allData; data]; 
end

opt = tfestOptions('Ts', Ts);
sys = tfest(allData, 2, 2, opt); 

% start validation here