clc; clear;
data = load("exp1_033.mat");
int_g = load("est_tf.mat");
int_sys= int_g.sys;
time = data.exp1_033.X.Data;
Ts_arr = diff(time);
mean_diff = mean(Ts_arr);
std_diff = std(Ts_arr);
Ts = mean_diff;

inp_lvdt = data.exp1_033.Y(1).Data; % Amplifier out
out_lvdt = data.exp1_033.Y(2).Data; % LVDT Out
inp_ampf = data.exp1_033.Y(3).Data; % Inp to amplifier

zero_crossings = find(diff(sign(out_lvdt)) ~= 0);
start_index = zero_crossings(2);
end_index = zero_crossings(5);


inp_lvdt_trimmed = inp_lvdt(start_index:end_index);
out_lvdt_trimmed = out_lvdt(start_index:end_index);
time_trimmed = time(start_index:end_index);
% figure(1)
% plot(time_trimmed, out_lvdt_trimmed, time_trimmed, inp_lvdt_trimmed)

meas = iddata(out_lvdt_trimmed', inp_lvdt_trimmed', Ts);
figure(2)
compare(meas,int_sys)