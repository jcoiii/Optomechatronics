clc; clear;
data = load("exp1_032.mat");
time = data.exp1_032.X.Data;
Ts_arr = diff(time);
mean_diff = mean(Ts_arr);
std_diff = std(Ts_arr);
Ts = mean_diff;

inp_lvdt = data.exp1_032.Y(1).Data; % Amplifier out
out_lvdt = data.exp1_032.Y(2).Data; % LVDT Out
inp_ampf = data.exp1_032.Y(3).Data; % Inp to amplifier

zero_crossings = find(diff(sign(out_lvdt)) ~= 0);
start_index = zero_crossings(1);
end_index = zero_crossings(9);


inp_lvdt_trimmed = inp_lvdt(start_index:end_index);
out_lvdt_trimmed = out_lvdt(start_index:end_index);
time_trimmed = time(start_index:end_index);
figure(1)
plot(time_trimmed, out_lvdt_trimmed, time_trimmed, inp_lvdt_trimmed)

meas = iddata(out_lvdt_trimmed', inp_lvdt_trimmed', Ts);

sys = tfest(meas,2,0);
sys
save("est_tf_step.mat","sys")