%% lab 5 calcs
clear, clc, close all

%% inputs
tableIn = readtable("lab5data.xlsx");
% loads
load_psig = tableIn.Pressure_psig;

% modulus of elasticity
E_psi = 29.6e6;
vTheor = 0.303;

% geometry
rCyn_in = 22/(2*pi);
rSph_in = 10.7/2;

% sensor 1, cylindrical
% ---- Strains in microin/in, leaving for matrix division
sen1.Astrain = tableIn.x1A;
sen1.Atheta = deg2rad(270);

sen1.Bstrain = tableIn.x1B;
sen1.Btheta = deg2rad(150);

sen1.Cstrain = tableIn.x1C;
sen1.Ctheta = deg2rad(30);

% sensor 2, spherical
sen2.Astrain = tableIn.x2A;
sen2.Atheta = deg2rad(150);

sen2.Bstrain = tableIn.x2B;
sen2.Btheta = deg2rad(270);

sen2.Cstrain = tableIn.x2C;
sen2.Ctheta = deg2rad(30);

% sensor 3, cylindrical
sen3.Astrain = tableIn.x3A;
sen3.Atheta = deg2rad(270);

sen3.Bstrain = tableIn.x3B;
sen3.Btheta = deg2rad(30);

sen3.Cstrain = tableIn.x3C;
sen3.Ctheta = deg2rad(150);

%% Calcs
% solve for eL and eT (longitudinal strain and hoop strain respectively)

% sensor 1
for k = 1:length(load_psig)
    b = [sen1.Astrain(k); sen1.Bstrain(k); sen1.Cstrain(k)];
    A = [cos(sen1.Atheta)^2, sin(sen1.Atheta)^2, sin(sen1.Atheta)*cos(sen1.Atheta);
          cos(sen1.Btheta)^2, sin(sen1.Btheta)^2, sin(sen1.Btheta)*cos(sen1.Btheta);
          cos(sen1.Ctheta)^2, sin(sen1.Ctheta)^2, sin(sen1.Ctheta)*cos(sen1.Ctheta)];
    
    x = A\b;
    % save values, converting strain from microin/in to dimensionless
    sen1.eT(k) = x(1)*1e-6;
    sen1.eL(k) = x(2)*1e-6;

    clear b A x
end

% sensor 2
for k = 1:length(load_psig)
    b = [sen2.Astrain(k); sen2.Bstrain(k); sen2.Cstrain(k)];
    A = [cos(sen2.Atheta)^2, sin(sen2.Atheta)^2, sin(sen2.Atheta)*cos(sen2.Atheta);
          cos(sen2.Btheta)^2, sin(sen2.Btheta)^2, sin(sen2.Btheta)*cos(sen2.Btheta);
          cos(sen2.Ctheta)^2, sin(sen2.Ctheta)^2, sin(sen2.Ctheta)*cos(sen2.Ctheta)];
    
    x = A\b;
    % save values, converting strain from microin/in to dimensionless
    sen2.eT(k) = x(1)*1e-6;
    sen2.eL(k) = x(2)*1e-6;
    sen2.vExp(k) = x(3);

    clear b A x
end

% sensor 3
for k = 1:length(load_psig)
    b = [sen3.Astrain(k); sen3.Bstrain(k); sen3.Cstrain(k)];
    A = [cos(sen3.Atheta)^2, sin(sen3.Atheta)^2, sin(sen3.Atheta)*cos(sen3.Atheta);
          cos(sen3.Btheta)^2, sin(sen3.Btheta)^2, sin(sen3.Btheta)*cos(sen3.Btheta);
          cos(sen3.Ctheta)^2, sin(sen3.Ctheta)^2, sin(sen3.Ctheta)*cos(sen3.Ctheta)];
    
    x = A\b;
    % save values, converting strain from microin/in to dimensionless
    sen3.eT(k) = x(1)*1e-6;
    sen3.eL(k) = x(2)*1e-6;

    clear b A x
end

% calculate experimental poisson's

% sensor 1
sen1.v = (2*sen1.eL - sen1.eT)./(sen1.eL - 2*sen1.eT);
idx = (~isnan(sen1.v) & (sen1.v > 0.1)); % clean up the nans for the AVG
sen1.vAvg = mean(sen1.v(idx));
sen1.vErr = abs(vTheor - sen1.v)/vTheor * 100;
% sen1.v(1) = 0;

% sensor 2 (I don't think this is valid but I have nothing else)
sen2.v = sen2.eT./sen2.eL;
sen2.v(1) = 0;
sen2.v(end) = 0;
idx = (~isnan(sen2.v) & (sen2.v > 0.1));
sen2.vAvg = mean(sen2.v(idx));
sen2.vErr = abs(vTheor - sen2.v)/vTheor * 100;

% sensor 3
sen3.v = (2*sen3.eL - sen3.eT)./(sen3.eL - 2*sen3.eT);
idx = (~isnan(sen3.v) & (sen3.v > 0.1));
sen3.vAvg = mean(sen3.v(idx));
sen3.vErr = abs(vTheor - sen3.v)/vTheor * 100;

% calculate experimental thickness
% sensor 1
sen1.t_in = ((load_psig.*rCyn_in)./(2.*sen1.eL'.*E_psi)).*(1-2*sen1.v');
idx = (~isnan(sen1.v) & (sen1.v > 0.1));
sen1.tAvg_in = mean(sen1.t_in(idx));

% sensor 2
sen2.t_in = ((load_psig.*rSph_in)./(2.*sen2.eL'.*E_psi)).*(1-2*sen2.v');
idx = (~isnan(sen2.v) & (sen2.v > 0.1));
sen2.tAvg_in = mean(sen2.t_in(idx));

% sensor 3
sen3.t_in = ((load_psig.*rCyn_in)./(2.*sen3.eL'.*E_psi)).*(1-2*sen3.v');
idx = (~isnan(sen3.v) & (sen3.v > 0.1));
sen3.tAvg_in = mean(sen3.t_in(idx));

% calculate stress
% sensor 1
sen1.hoop_psi = (load_psig.*rCyn_in)./(sen1.t_in);
sen1.long_psi = (load_psig.*rCyn_in)./(2*sen1.t_in);

% sensor 2
sen2.hoop_psi = (load_psig.*rSph_in)./(2*sen2.t_in);

% sensor 3
sen3.hoop_psi = (load_psig.*rCyn_in)./(sen3.t_in);
sen3.long_psi = (load_psig.*rCyn_in)./(2*sen3.t_in);


%% Theoretical Values
sen1.eT_theor = ((load_psig*rCyn_in)./(2*sen1.tAvg_in*E_psi)) * (2 - sen1.vAvg);
sen1.eL_theor = ((load_psig*rCyn_in)./(2*sen1.tAvg_in*E_psi)) * (1 - 2*sen1.vAvg);
sen1.hoopTheor_psi = (load_psig.*rCyn_in)./(sen1.tAvg_in);
sen1.longTheor_psi = (load_psig.*rCyn_in)./(2*sen1.tAvg_in);
sen1.eTerr = abs(sen1.eT_theor - sen1.eT')./sen1.eT_theor * 100;
sen1.eLerr = abs(sen1.eL_theor - sen1.eL')./sen1.eL_theor * 100;
sen1.hoopErr = abs(sen1.hoopTheor_psi - sen1.hoop_psi)./sen1.hoopTheor_psi * 100;
sen1.longErr = abs(sen1.longTheor_psi - sen1.long_psi)./sen1.longTheor_psi * 100;

sen2.eT_theor = ((load_psig*rCyn_in)./(2*sen2.tAvg_in*E_psi)) * (1 - sen2.vAvg);
sen2.hoopTheor_psi = (load_psig.*rSph_in)./(2*sen2.tAvg_in);
sen2.eTerr = abs(sen2.eT_theor - sen2.eT')./sen2.eT_theor * 100;
sen2.hoopErr = abs(sen2.hoopTheor_psi - sen2.hoop_psi)./sen2.hoopTheor_psi * 100;

sen3.eT_theor = ((load_psig*rCyn_in)./(2*sen3.tAvg_in*E_psi)) * (2 - sen3.vAvg);
sen3.eL_theor = ((load_psig*rCyn_in)./(2*sen3.tAvg_in*E_psi)) * (1 - 2*sen3.vAvg);
sen3.hoopTheor_psi = (load_psig.*rCyn_in)./(sen3.tAvg_in);
sen3.longTheor_psi = (load_psig.*rCyn_in)./(2*sen3.tAvg_in);
sen3.eTerr = abs(sen3.eT_theor - sen3.eT')./sen3.eT_theor * 100;
sen3.eLerr = abs(sen3.eL_theor - sen3.eL')./sen3.eL_theor * 100;
sen3.hoopErrr = abs(sen3.hoopTheor_psi - sen3.hoop_psi)./sen3.hoopTheor_psi * 100;
sen3.longErr = abs(sen3.longTheor_psi - sen3.long_psi)./sen3.longTheor_psi * 100;

%% Make Tables

s1Names = fieldnames(sen1);
n1 = length(s1Names);
s1Table = table;
for k = 1:n1
    field = s1Names{k};
    if( length(sen1.(field)) == 5)
        [a, b] = size(sen1.(field));
        if(a == 1)
            s1Table.(field) = sen1.(field)';
        else
            s1Table.(field) = sen1.(field);
        end
    end

end

s2Names = fieldnames(sen2);
n2 = length(s2Names);
s2Table = table;
for k = 1:n2
    field = s2Names{k};
    if( length(sen2.(field)) == 5)
        [a, b] = size(sen2.(field));
        if(a == 1)
            s2Table.(field) = sen2.(field)';
        else
            s2Table.(field) = sen2.(field);
        end
    end

end

s3Names = fieldnames(sen3);
n3 = length(s3Names);
s3Table = table;
for k = 1:n3
    field = s3Names{k};
    if( length(sen3.(field)) == 5)
        [a, b] = size(sen3.(field));
        if(a == 1)
            s3Table.(field) = sen3.(field)';
        else
            s3Table.(field) = sen3.(field);
        end
    end

end


writetable(s1Table,'s1Table.xlsx');
writetable(s2Table,'s2Table.xlsx');
writetable(s3Table,'s3Table.xlsx');
