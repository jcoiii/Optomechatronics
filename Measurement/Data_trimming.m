clear; clc;
data = load("measured_IO.mat");
dat_n = 12;
name = "trimmed_sine_12";

inp_1 = data.inp_ampf{dat_n};
inp_2 = data.inp_lvdt{dat_n};
out = data.out_lvdt{dat_n};
time = data.time{dat_n};
zero_crossings = find(diff(sign(out)) ~= 0);
figure(1)
plot(time,out)
s = zero_crossings(1);
e = zero_crossings(36);
figure(2)
plot(time(s:e),out(s:e))
inp_ampf_tr = inp_1(s:e);
inp_lvdt_tr = inp_2(s:e);
out_lvdt_tr = out(s:e);
time_tr = time(s:e);
% save(name,"inp_ampf_tr","inp_lvdt_tr","time_tr","out_lvdt_tr")