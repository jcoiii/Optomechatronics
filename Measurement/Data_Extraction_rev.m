clear; clc;
time = cell(1, 12);
inp_lvdt = cell(1, 12);
out_lvdt = cell(1, 12);
inp_ampf = cell(1, 12);

for i = 28:39
    % Generate the file name
    filename = sprintf('exp1_%03d.mat', i);
    data = load(filename);
  
    varname = strrep(filename, '.mat', '');  % remove the '.mat' file ext
    time{i-27} = data.(varname).X.Data;
    inp_lvdt{i-27} = data.(varname).Y(1).Data;
    out_lvdt{i-27} = data.(varname).Y(2).Data;
    inp_ampf{i-27} = data.(varname).Y(3).Data;
    time{i-27} = data.(varname).X.Data;
end

Ts = 0.001;
save("measured_IO.mat","inp_ampf","inp_lvdt","Ts","time","out_lvdt")