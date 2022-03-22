%% Lab 4 Calculations
clear,clc, close all

%% pull in inputs
tableIn = readtable('lab4input.xlsx');
loads_lb = tableIn.lb;
bRaw = tableIn.b_microinpin/(1e6);
eRaw = tableIn.e_microinpin/(1e6);
dRaw = tableIn.d_microinpin/(1e6);
h_in = tableIn.h_in(1);
b_in = tableIn.b_in(1);
L_in = tableIn.L_in(1);
xb_in = tableIn.xb_in(1);
xd_in = tableIn.xd_in(1);
xe_in = tableIn.xe_in(1);

stressMax_psi = 3500;
Est_psi = 10e6;
Vst = 0.33;
c_in = h_in/2;
%% Calculations
% corrected strains
bStrain = bRaw - bRaw(1);
eStrain = eRaw - eRaw(1);
dStrain = dRaw - dRaw(1);

% moment of inertia
I_in4 = (b_in * h_in^3)/12;

% safe load
safe_lb = (stressMax_psi*I_in4)/(L_in*c_in);

% calcs at b
bE_exp_psi = (loads_lb*xb_in*c_in)./(bStrain.*I_in4);
bE_error = abs(Est_psi-bE_exp_psi)/Est_psi * 100;
bE_St = (loads_lb*xb_in*c_in)./(Est_psi*I_in4);
bV = abs((dStrain*xb_in)./(bStrain*xd_in));
bV_error = abs(Vst-bV)./Vst * 100;

% calcs at e
eE_exp_psi = (loads_lb*xe_in*c_in)./(eStrain.*I_in4); 
eE_error = abs(Est_psi-eE_exp_psi)/Est_psi * 100;
eE_St = (loads_lb*xe_in*c_in)./(Est_psi*I_in4);
eV = abs((dStrain*xe_in)./(eStrain*xd_in));
eV_error = abs(Vst-eV)./Vst * 100;

% calcs for d
avgV = (bV+eV)/2;
dE_exp_psi = -(avgV.*loads_lb*xd_in*c_in)./(dStrain*I_in4);
dE_error = abs(Est_psi-dE_exp_psi)/Est_psi * 100;
dE_St = -(Vst*loads_lb*xd_in*c_in)/(Est_psi*I_in4);

%% Make Table
output = table;
output.bload_lb = loads_lb;
output.bRaw = bRaw*1e6;
output.bStrain = bStrain;
output.bE_exp_psi = bE_exp_psi;
output.bEst_psi = repmat(Est_psi,[7,1]);
output.bE_error = bE_error;
output.bE_St = bE_St;
output.bVexp = bV;
output.bVst = repmat(Vst,[7,1]);
output.bV_error = bV_error;

output.eload_lb = loads_lb;
output.eRaw = eRaw*1e6;
output.eStrain = eStrain;
output.eE_exp_psi = eE_exp_psi;
output.eEst_psi = repmat(Est_psi,[7,1]);
output.eE_error = eE_error;
output.eE_St = eE_St;
output.eVexp = eV;
output.eVst = repmat(Vst,[7,1]);
output.eV_error = eV_error;

output.dload_lb = loads_lb;
output.dRaw = dRaw*1e6;
output.dStrain = dStrain;
output.dE_exp_psi = dE_exp_psi;
output.dEst_psi = repmat(Est_psi,[7,1]);
output.dE_error = dE_error;
output.dE_St = dE_St;

writetable(output,'lab4output.xlsx')






