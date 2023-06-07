clear; clc;
combined_data = struct('inp_ampf_tr', [], 'inp_lvdt_tr', [], 'out_lvdt_tr', [], 'time_tr', []);

for i = 1:12
    file_name = sprintf('trimmed_sine_%d.mat', i);
    data = load(file_name);
    
    combined_data(i).inp_ampf_tr = data.inp_ampf_tr;
    combined_data(i).inp_lvdt_tr = data.inp_lvdt_tr;
    combined_data(i).out_lvdt_tr = data.out_lvdt_tr;
    combined_data(i).time_tr = data.time_tr;
end

save('combined_data.mat', 'combined_data');
