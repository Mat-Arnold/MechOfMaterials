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
alum.finLength_in = 2.594;

brass.initDiameter_in = 0.506;
brass.finDiameter_in = 0.317;
brass.initLength_in = 2.000;
brass.finLength_in = 2.594;

% Test Results
steel.yieldForce_lbs = 17500;
steel.yieldElongation_percent = 0.85;
steel.ruptureForce_lbs = 18750;
steel.ultimateForce_lbs = 18750;
steel.proportionalLimit_lbs = 15000;
steel.proportionalElongation_percent = 0.3;
% from textbook
steel.expectedYoungs_psi = 29e6;


alum.yieldForce_lbs = 13500;
alum.yieldElongation_percent = 0.5;
alum.ruptureForce_lbs = 14750;
alum.ultimateForce_lbs = 14750;
alum.proportionalLimit_lbs = 12000;
alum.proportionalElongation_percent = 0.5;
% from textbook
alum.expectedYoungs_psi = 10.1e6;


brass.yieldForce_lbs = 9900;
brass.yieldElongation_percent = 0.8;
brass.ruptureForce_lbs = 11000;
brass.ultimateForce_lbs = 11000;
brass.proportionalLimit_lbs = 7000;
brass.proportionalElongation_percent = 0.4;
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
for k=1:n
    matl = matList{k};
    properties = fieldnames(material.(matl));
    m = length(properties);
    for i = 1:m
        property = properties{i};
        fprintf('The %s of %s is %0.3f \n', property, matl, material.(matl).(property))
    end
    fprintf('\n')
end

