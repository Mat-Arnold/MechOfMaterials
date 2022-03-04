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

% https://www.engineeringtoolbox.com/modulus-rigidity-d_946.html
% alum 6061

alum.stShearMod_psi = 3.5e6;

steel.length_in = 14.0;
steel.dia_in = [0.750 0.754 0.750];
steel.avgDia_in = mean(steel.dia_in);
steel.rad_in    = steel.avgDia_in/2;

steel.twist_deg   = [0.24 0.48 0.72 0.96 1.20];
steel.torque_lbin = [138  200  259  302  354];
steel.twist_rad = deg2rad(steel.twist_deg);

steel.stShearMod_psi = 1.12e7;

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

    % shear modulus for each point, then avg
    material.(name).allShearModulus_psi = material.(name).tau_psi./material.(name).gamma;
    material.(name).shearModulus_psi = mean(material.(name).allShearModulus_psi);

    % shear modulus error
    material.(name).allShearErr = abs(material.(name).stShearMod_psi-material.(name).allShearModulus_psi)./material.(name).stShearMod_psi * 100;
    material.(name).shearErr = abs(material.(name).stShearMod_psi - material.(name).shearModulus_psi)/material.(name).stShearMod_psi * 100;

    % strain error
    material.(name).stGamma = material.(name).tau_psi./material.(name).stShearMod_psi;
    material.(name).gammaErr = abs(material.(name).stGamma-material.(name).gamma)./material.(name).stGamma * 100;


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
    ax = gca;
    ax.FontSize = 20;

end

%% Output

fprintf('Aluminum: \n')
fprintf('Torque [lb-in] \t Twist [deg] \t Twist [rad] \t Tau [psi] \t Gamma \t\t G exp [psi] \t G Err \t\t Theor Gamma \t Gamma Err\n')
fprintf('%10.3f \t %10.3f \t %10.3f \t %10.3f \t %10.6f \t %10.3f \t %10.3f \t %10.6f \t %10.3f\n', [material.Aluminum.torque_lbin; material.Aluminum.twist_deg; material.Aluminum.twist_rad; material.Aluminum.tau_psi; material.Aluminum.gamma; material.Aluminum.allShearModulus_psi; material.Aluminum.allShearErr; material.Aluminum.stGamma; material.Aluminum.gammaErr])
fprintf('\nShear Modulus Exp (psi):\t %0.3f\n', material.Aluminum.shearModulus_psi)
fprintf('Shear Modulus Err (psi):\t %0.3f%%\n\n', material.Aluminum.shearErr)

fprintf('Steel: \n')
fprintf('Torque [lb-in] \t Twist [deg] \t Twist [rad] \t Tau [psi] \t Gamma \t\t G exp [psi] \t G Err \t\t Theor Gamma \t Gamma Err\n')
fprintf('%10.3f \t %10.3f \t %10.3f \t %10.3f \t %10.6f \t %10.3f \t %10.3f \t %10.6f \t %10.3f\n', [material.Steel.torque_lbin; material.Steel.twist_deg; material.Steel.twist_rad; material.Steel.tau_psi; material.Steel.gamma; material.Steel.allShearModulus_psi; material.Steel.allShearErr; material.Steel.stGamma; material.Steel.gammaErr])
fprintf('\nShear Modulus Exp (psi):\t %0.3f\n', material.Steel.shearModulus_psi)
fprintf('Shear Modulus Err (psi):\t %0.3f%%\n\n', material.Steel.shearErr)

%% plot of gammas
figure('Name','Gammas');
scatter(material.Aluminum.gamma, material.Aluminum.tau_psi,80, 'filled');
hold on, grid on
scatter(material.Aluminum.stGamma, material.Aluminum.tau_psi,80,'filled')
scatter(material.Steel.gamma, material.Steel.tau_psi,80, 'filled')
scatter(material.Steel.stGamma, material.Steel.tau_psi,80, 'filled')
title('Experimental Strain vs Standard Strain')
xlabel('Shear Strain')
ylabel('Shear Stress (psi)')
legend({'Aluminum Experimental', 'Aluminum Standard','Steel Experimental','Steel Standard'},'Location','best')
ax = gca;
ax.FontSize = 20;

