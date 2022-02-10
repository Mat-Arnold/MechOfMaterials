%% Lab 1 Main Script
clear, clc, close all

%% Given Data

% Measurements
steel.initDiameter_in = 0.501;
steel.finDiameter_in = 0.404;
steel.initLength_in = 2.00;
steel.finLength_in = 2.284;

alum.initDiameter_in = 0.506;
alum.finDiameter_in = 0.365;
alum.initLength_in = 2.00;
alum.finLength_in = 2.376;

brass.initDiameter_in = 0.506;
brass.finDiameter_in = 0.317;
brass.initLength_in = 2.000;
brass.finLength_in = 2.594;

% Test Results
steel.yieldForce_lbs = 17500;
steel.yieldElongation_percent = 0.85;
steel.ruptureForce_lbs = 13000;
steel.ultimateForce_lbs = 18750;
steel.proportionalLimit_lbs = 15000;
steel.proportionalElongation_percent = 0.25;
% from textbook
steel.expectedYoungs_psi = 29e6;


alum.yieldForce_lbs = 13500;
alum.yieldElongation_percent = 0.5;
alum.ruptureForce_lbs = 14000;
alum.ultimateForce_lbs = 16000;
alum.proportionalLimit_lbs = 12000;
alum.proportionalElongation_percent = 0.6;
% from textbook
alum.expectedYoungs_psi = 10.1e6;


brass.yieldForce_lbs = 9800;
brass.yieldElongation_percent = 0.8;
brass.ruptureForce_lbs = 9000;
brass.ultimateForce_lbs = 11500;
brass.proportionalLimit_lbs = 8000;
brass.proportionalElongation_percent = 0.5;
% from textbook
brass.expectedYoungs_psi = 15e6;

% create parent struct
material.steel = steel;
material.alum = alum;
material.brass = brass;

matList = fieldnames(material);
n = length(matList);

% iterate through materials
for k = 1:n
    name = matList{k};
    material.(name).initArea_in2 = (material.(name).initDiameter_in/2)^2 * pi;
    material.(name).finArea_in2 = (material.(name).finDiameter_in/2)^2 * pi;
    material.(name).areaReduction_percent = (material.(name).initArea_in2 - material.(name).finArea_in2)/material.(name).initArea_in2 * 100;
    material.(name).yieldStress_psi = material.(name).yieldForce_lbs/material.(name).initArea_in2;
    material.(name).proportionalStress_psi = material.(name).proportionalLimit_lbs/material.(name).initArea_in2;
    material.(name).proportionalStrain = material.(name).proportionalElongation_percent/100;
    material.(name).youngsModulus_psi = material.(name).proportionalStress_psi/material.(name).proportionalStrain;
    material.(name).youngsError_percent = (material.(name).expectedYoungs_psi - material.(name).youngsModulus_psi)/material.(name).expectedYoungs_psi * 100;
    material.(name).tensileStress_psi = material.(name).ultimateForce_lbs/material.(name).finArea_in2;
    material.(name).ruptureStress_psi = material.(name).ruptureForce_lbs/material.(name).finArea_in2;
    material.(name).ruptureTensileDiff_percent = (material.(name).tensileStress_psi - material.(name).ruptureStress_psi)/material.(name).tensileStress_psi * 100;
    material.(name).yieldStrain = material.(name).yieldElongation_percent/100;
    material.(name).modResilience = (material.(name).yieldStress_psi * material.(name).yieldStrain)/2;
end

% print results

fprintf('\t\t \t\t Steel \t\t Aluminum \t Brass\n')
fprintf('Initial Area [in^2]: \t\t %0.4f \t %0.4f \t %0.4f\n', material.steel.initArea_in2, material.alum.initArea_in2,material.brass.initArea_in2)
fprintf('Final Area [in^2]: \t\t %0.4f \t %0.4f \t %0.4f\n', material.steel.finArea_in2, material.alum.finArea_in2,material.brass.finArea_in2)
fprintf('Percent Area Reduction: \t %0.4f \t %0.4f \t %0.4f\n', material.steel.areaReduction_percent, material.alum.areaReduction_percent,material.brass.areaReduction_percent)
fprintf('Yield Stress [ksi]: \t\t %0.4f \t %0.4f \t %0.4f\n', material.steel.yieldStress_psi/1e3, material.alum.yieldStress_psi/1e3,material.brass.yieldStress_psi/1e3)
fprintf('PL Stress [ksi]: \t\t %0.4f \t %0.4f \t %0.4f\n', material.steel.proportionalStress_psi/1e3, material.alum.proportionalStress_psi/1e3,material.brass.proportionalStress_psi/1e3)
fprintf('PL Strain: \t\t\t %0.4f \t %0.4f \t %0.4f\n', material.steel.proportionalStrain, material.alum.proportionalStrain,material.brass.proportionalStrain)
fprintf('Youngs Modulus [ksi]: \t\t %0.4f \t %0.4f \t %0.4f\n', material.steel.youngsModulus_psi/1e3, material.alum.youngsModulus_psi/1e3,material.brass.youngsModulus_psi/1e3)
fprintf('Youngs Percent Error: \t\t %0.4f \t %0.4f \t %0.4f\n', material.steel.youngsError_percent, material.alum.youngsError_percent,material.brass.youngsError_percent)
fprintf('Tensile Strength [ksi]: \t %0.4f \t %0.4f \t %0.4f\n', material.steel.tensileStress_psi/1e3, material.alum.tensileStress_psi/1e3,material.brass.tensileStress_psi/1e3)
fprintf('Rupture Strength [ksi]: \t %0.4f \t %0.4f \t %0.4f\n', material.steel.ruptureStress_psi/1e3, material.alum.ruptureStress_psi/1e3,material.brass.ruptureStress_psi/1e3)
fprintf('T/R Percent Difference: \t %0.4f \t %0.4f \t %0.4f\n', material.steel.ruptureTensileDiff_percent, material.alum.ruptureTensileDiff_percent,material.brass.ruptureTensileDiff_percent)
fprintf('Modulus Resilience: \t\t %0.4f \t %0.4f \t %0.4f\n', material.steel.modResilience, material.alum.modResilience,material.brass.modResilience)































