%% MAE 374 LAB 2 Main Script
clear, clc, close all

%% Raw Data

alum.length_in = 12.1;
alum.dia_in = [0.758 0.748 0.752];
alum.avgDia_in = mean(alum.dia_in);
alum.rad_in = alum.avgDia_in/2;

alum.twist_deg   = [0.24 0.48 0.72 0.96 1.20];
alum.torque_lbin = [55   83   115  147  176];
alum.twist_rad   = deg2rad(alum.twist_deg);

steel.length_in = 14.0;
steel.dia_in = [0.750 0.754 0.750];
steel.avgDia_in = mean(steel.dia_in);
steel.rad_in    = steel.avgDia_in/2;

steel.twist_deg   = [0.24 0.48 0.72 0.96 1.20];
steel.torque_lbin = [138  200  259  302  354];
steel.twist_rad = deg2rad(steel.twist_deg);

%% Calculations

material.Aluminum = alum;
material.Steel = steel;

matList = fieldnames(material);
n = length(matList);

for k = 1:n
    name = matList{k};

    % first calculate polar moment of inertia
    material.(name).J_in4 = (pi * (material.(name).rad_in)^4)/2;

    % calculate shear stress at each point
    material.(name).tau_psi = (material.(name).torque_lbin .* material.(name).rad_in)./material.(name).J_in4;

    % calculate shear strain at each point
    material.(name).gamma = (material.(name).rad_in .* material.(name).twist_rad)./material.(name).length_in;

    % find shear modulus using the line of best fit
    material.(name).bestFit = polyfit(material.(name).gamma, material.(name).tau_psi,1);

    % shear modulus is the first term of the polynomial output
    material.(name).shearModulus_psi = material.(name).bestFit(1);

    % plot the results
    x = linspace(0,material.(name).gamma(end));
    y = polyval(material.(name).bestFit,x);
    figure('Name', name)
    scatter(material.(name).gamma, material.(name).tau_psi,'filled');
    hold on, grid on
    plot(x, y)
    xlabel('Shear Strain')
    ylabel('Shear Stress [psi]')
    title(['Shear Stress vs Shear Strain, Elastic Regime for ', name])

end

%% Output

fprintf('Aluminum: \n')
fprintf('Shear Strain:\t\t')
fprintf('%8.5f ', material.Aluminum.gamma)
fprintf('\nShear Stress (psi):\t')
fprintf('%8.3f ', material.Aluminum.tau_psi)
fprintf('\nShear Modulus (psi):\t %0.3f\n\n', material.Aluminum.shearModulus_psi)

fprintf('Steel: \n')
fprintf('Shear Strain:\t\t')
fprintf('%10.5f ', material.Steel.gamma)
fprintf('\nShear Stress (psi):\t')
fprintf('%10.3f ', material.Steel.tau_psi)
fprintf('\nShear Modulus (psi):\t  %10.3f\n\n', material.Steel.shearModulus_psi)




