%% Lab 3 Calculations
% import from excel

clear, clc, close all

t = readtable("Lab3Input.csv");

sigMax_psi = 14000;
Est_psi = 30e6;

simple.h_in = t.ssh_in(1);
simple.b_in = t.ssb_in(1);
simple.L_in = t.ssL_in(1);
simple.L2_in = t.ssL2_in(1);
simple.L4_in = t.ssL4_in(1);
simple.L2Loads_lb = t.ssL2Loads_lb;
simple.L4Loads_lb = t.ssL4Loads_lb;
simple.d11_in = t.ssd11_in;
simple.d21_in = t.ssd21_in;
simple.d12_in = t.ssd12_in;
simple.d22_in = t.ssd22_in;

cant.h_in = t.canth_in(1);
cant.b_in = t.cantb_in(1);
cant.L_in = t.cantL_in(1);
cant.L2_in = t.cantL2_in(1);
cant.LLoads_lb = t.cantLLoads_lb;
cant.L2Loads_lb = t.cantL2Loads_lb;
cant.d11_in = t.cantd11_in;
cant.d21_in = t.cantd21_in;
cant.d12_in = t.cantd12_in;
cant.d22_in = t.cantd22_in;

%% simply supported beam calcs
% moment of inertia
simple.I_in4 = (simple.b_in*simple.h_in^3)/12;

% distance from neutral plane
simple.c_in = simple.h_in/2;

% safe load at L/2
simple.safeL2_lb = (4*sigMax_psi*simple.I_in4)/(simple.L_in*simple.c_in);

% safe load at L/4
simple.safeL4_lb = (16*sigMax_psi*simple.I_in4)/(3*simple.L_in*simple.c_in);

% E experimental at L/2
simple.EexpL2d11_psi = (simple.L2Loads_lb .* simple.L_in^3)./(48*simple.d11_in*simple.I_in4);
simple.EexpL2d21_psi = (simple.L2Loads_lb .* simple.L_in^3)./(48*simple.d21_in*simple.I_in4);

% E experimental at L/4
simple.EexpL4d12_psi = (3*simple.L4Loads_lb .* simple.L_in^3)./(256*simple.d12_in*simple.I_in4);
simple.EexpL4d22_psi = (3*simple.L4Loads_lb .* simple.L_in^3)./(256*simple.d22_in*simple.I_in4);

% Tabulate Young's Mod Error
simple.Eerrd11 = abs(Est_psi-simple.EexpL2d11_psi)/Est_psi * 100;
simple.Eerrd21 = abs(Est_psi-simple.EexpL2d21_psi)/Est_psi * 100;
simple.Eerrd12 = abs(Est_psi-simple.EexpL4d12_psi)/Est_psi * 100;
simple.Eerrd22 = abs(Est_psi-simple.EexpL4d22_psi)/Est_psi * 100;

% Theoretical Displacement
simple.theord11_in = (simple.L2Loads_lb .* simple.L_in^3)./(48*Est_psi*simple.I_in4);
simple.theord21_in = (simple.L2Loads_lb .* simple.L_in^3)./(48*Est_psi*simple.I_in4);%./1.4;
simple.theord12_in = (3*simple.L4Loads_lb .* simple.L_in^3)./(256*Est_psi*simple.I_in4);%*1.15;
simple.theord22_in = (3*simple.L4Loads_lb .* simple.L_in^3)./(256*Est_psi*simple.I_in4);

% Displacement Error
simple.d11Err = abs(simple.theord11_in - simple.d11_in)./simple.theord11_in * 100;
simple.d21Err = abs(simple.theord21_in - simple.d21_in)./simple.theord21_in * 100;
simple.d12Err = abs(simple.theord12_in - simple.d12_in)./simple.theord12_in * 100;
simple.d22Err = abs(simple.theord22_in - simple.d22_in)./simple.theord22_in * 100;

%% Cantilever Calcs

% moment of inertia
cant.I_in4 = (cant.b_in*cant.h_in^3)/12;

% distance from neutral plane
cant.c_in = cant.h_in/2;

% safe load at L
cant.safeL_lb = (sigMax_psi*cant.I_in4)/(cant.L_in*cant.c_in);

% safe load at L/2
cant.safeL2_lb = (2*sigMax_psi*cant.I_in4)/(cant.L_in*cant.c_in);

% E experimental at L
cant.EexpLd11_psi = (cant.LLoads_lb .* cant.L_in^3)./(3*cant.d11_in*cant.I_in4);
cant.EexpLd21_psi = (cant.LLoads_lb .* cant.L_in^3)./(3*cant.d21_in*cant.I_in4);

% E experimental at L/2
cant.EexpL2d12_psi = (cant.L2Loads_lb .* cant.L_in^3)./(24*cant.d12_in*cant.I_in4);
cant.EexpL2d22_psi = (cant.L2Loads_lb .* cant.L_in^3)./(24*cant.d22_in*cant.I_in4);

% Tabulate Young's Mod Error
cant.Eerrd11 = abs(Est_psi-cant.EexpLd11_psi)/Est_psi * 100;
cant.Eerrd21 = abs(Est_psi-cant.EexpLd21_psi)/Est_psi * 100;
cant.Eerrd12 = abs(Est_psi-cant.EexpL2d12_psi)/Est_psi * 100;
cant.Eerrd22 = abs(Est_psi-cant.EexpL2d22_psi)/Est_psi * 100;

% Theoretical Displacement
cant.theord11_in = (cant.LLoads_lb .* cant.L_in^3)./(3*Est_psi*cant.I_in4);
cant.theord21_in = (cant.LLoads_lb .* cant.L_in^3)./(3*Est_psi*cant.I_in4);%./3;
cant.theord12_in = (cant.L2Loads_lb .* cant.L_in^3)./(24*Est_psi*cant.I_in4);%.*2.75;
cant.theord22_in = (cant.L2Loads_lb .* cant.L_in^3)./(24*Est_psi*cant.I_in4);

% Displacement Error
cant.d11Err = abs(cant.theord11_in - cant.d11_in)./cant.theord11_in * 100;
cant.d21Err = abs(cant.theord21_in - cant.d21_in)./cant.theord21_in * 100;
cant.d12Err = abs(cant.theord12_in - cant.d12_in)./cant.theord12_in * 100;
cant.d22Err = abs(cant.theord22_in - cant.d22_in)./cant.theord22_in * 100;

%% Create Plots

% Simply Supported Plot
figure('Name','Simply Supported')
plot(simple.d11_in,simple.L2Loads_lb,'b')
hold on, grid on;
plot(simple.theord11_in, simple.L2Loads_lb, 'b--')

plot(simple.d21_in, simple.L2Loads_lb,'g')
plot(simple.theord21_in, simple.L2Loads_lb,'g--')

plot(simple.d12_in, simple.L4Loads_lb, 'r')
plot(simple.theord12_in, simple.L4Loads_lb, 'r--')

plot(simple.d22_in, simple.L4Loads_lb, 'Color','magenta')
plot(simple.theord22_in, simple.L4Loads_lb, '--', 'Color','magenta')

ylim([0 60])
xlabel("Displacement Distance [in]")
ylabel("Loading [lbf]")
title("Displacement vs Loading for a Simply Supported Beam")
legend({'d11_exp', 'd11_theor', 'd21_exp', 'd21_theor', 'd12_exp', 'd12_theor', 'd22_exp', 'd22_theor'},'Location','Best','Interpreter','none')

% Cantilever Plot
figure('Name', 'Cantilever')
plot(cant.d11_in, cant.LLoads_lb, 'b'); hold on, grid on,
plot(cant.theord11_in, cant.LLoads_lb, 'b--')

plot(cant.d21_in, cant.LLoads_lb, 'g')
plot(cant.theord21_in, cant.LLoads_lb, 'g--')

plot(cant.d12_in, cant.L2Loads_lb, 'r')
plot(cant.theord12_in, cant.L2Loads_lb, 'r--')

plot(cant.d22_in, cant.L2Loads_lb, 'Color','magenta')
plot(cant.theord22_in, cant.L2Loads_lb, '--', 'Color', 'magenta')

ylim([0 25])

xlabel("Displacement Distance [in]")
ylabel("Loading [lbf]")
title("Displacement vs Loading for a Cantilevered Beam")
legend({'d11_exp', 'd11_theor', 'd21_exp', 'd21_theor', 'd12_exp', 'd12_theor', 'd22_exp', 'd22_theor'},'Location','Best','Interpreter','none')



%% Output Tables

simpleL2Output = table;
simpleL2Output.L2_Loads_lb = simple.L2Loads_lb;
simpleL2Output.d11_in = simple.d11_in;
simpleL2Output.d21_in = simple.d21_in;
simpleL2Output.Eexp_d11_psi = simple.EexpL2d11_psi;
simpleL2Output.Eexp_d21_psi = simple.EexpL2d21_psi;
simpleL2Output.Est_psi = repmat(Est_psi,[5 1]);
simpleL2Output.Eerr_d11 = simple.Eerrd11;
simpleL2Output.Eerr_d21 = simple.Eerrd21;
simpleL2Output.theor_d11_in = simple.theord11_in;
simpleL2Output.theor_d21_in = simple.theord21_in;
simpleL2Output.d11_err = simple.d11Err;
simpleL2Output.d21_err = simple.d21Err;
writetable(simpleL2Output,'simpleL2Output.csv');

simpleL4Output = table;
simpleL4Output.L4_Loads_lb = simple.L4Loads_lb;
simpleL4Output.d12_in = simple.d12_in;
simpleL4Output.d22_in = simple.d22_in;
simpleL4Output.Eexp_d12_psi = simple.EexpL4d12_psi;
simpleL4Output.Eexp_d22_psi = simple.EexpL4d22_psi;
simpleL4Output.Est_psi = repmat(Est_psi,[5 1]);
simpleL4Output.Eerr_d12 = simple.Eerrd12;
simpleL4Output.Eerr_d22 = simple.Eerrd22;
simpleL4Output.theor_d12_in = simple.theord12_in;
simpleL4Output.theor_d22_in = simple.theord22_in;
simpleL4Output.d12_err = simple.d12Err;
simpleL4Output.d22_err = simple.d22Err;
writetable(simpleL4Output,'simpleL4Output.csv');

cantLOutput = table;
cantLOutput.L_Loads_lb = cant.LLoads_lb;
cantLOutput.d11_in = cant.d11_in;
cantLOutput.d21_in = cant.d21_in;
cantLOutput.Eexp_d11_psi = cant.EexpLd11_psi;
cantLOutput.Eexp_d21_psi = cant.EexpLd21_psi;
cantLOutput.Est_psi = repmat(Est_psi,[5 1]);
cantLOutput.Eerr_d11 = cant.Eerrd11;
cantLOutput.Eerr_d21 = cant.Eerrd21;
cantLOutput.theor_d11_in = cant.theord11_in;
cantLOutput.theor_d21_in = cant.theord21_in;
cantLOutput.d11_err = cant.d11Err;
cantLOutput.d21_err = cant.d21Err;
writetable(cantLOutput,'cantLOutput.csv');

cantL2Output = table;
cantL2Output.L2_Loads_lb = cant.L2Loads_lb;
cantL2Output.d12_in = cant.d12_in;
cantL2Output.d22_in = cant.d22_in;
cantL2Output.Eexp_d12_psi = cant.EexpL2d12_psi;
cantL2Output.Eexp_d22_psi = cant.EexpL2d22_psi;
cantL2Output.Est_psi = repmat(Est_psi,[5 1]);
cantL2Output.Eerr_d12 = cant.Eerrd12;
cantL2Output.Eerr_d22 = cant.Eerrd22;
cantL2Output.theor_d12_in = cant.theord12_in;
cantL2Output.theor_d22_in = cant.theord22_in;
cantL2Output.d12_err = cant.d12Err;
cantL2Output.d22_err = cant.d22Err;
writetable(cantL2Output,'cantL2Output.csv');















