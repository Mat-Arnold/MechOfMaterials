%% Lab 3 Calculations
% import from excel
t = readtable("Lab3Input.xlsx");

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
simple.theord21_in = (simple.L2Loads_lb .* simple.L_in^3)./(48*Est_psi*simple.I_in4);
simple.theord12_in = (3*simple.L4Loads_lb .* simple.L_in^3)./(256*Est_psi*simple.I_in4);
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
cant.safeL2_lb = (sigMax_psi*cant.I_in4)/(cant.L_in*cant.c_in);

% safe load at L/2
cant.safeL4_lb = (2*sigMax_psi*cant.I_in4)/(cant.L_in*cant.c_in);

% E experimental at L/2
cant.EexpL2d11_psi = (cant.L2Loads_lb .* cant.L_in^3)./(48*cant.d11_in*cant.I_in4);
cant.EexpL2d21_psi = (cant.L2Loads_lb .* cant.L_in^3)./(48*cant.d21_in*cant.I_in4);

% E experimental at L/4
cant.EexpL4d12_psi = (3*cant.L4Loads_lb .* cant.L_in^3)./(256*cant.d12_in*cant.I_in4);
cant.EexpL4d22_psi = (3*cant.L4Loads_lb .* cant.L_in^3)./(256*cant.d22_in*cant.I_in4);

% Tabulate Young's Mod Error
cant.Eerrd11 = abs(Est_psi-cant.EexpL2d11_psi)/Est_psi * 100;
cant.Eerrd21 = abs(Est_psi-cant.EexpL2d21_psi)/Est_psi * 100;
cant.Eerrd12 = abs(Est_psi-cant.EexpL4d12_psi)/Est_psi * 100;
cant.Eerrd22 = abs(Est_psi-cant.EexpL4d22_psi)/Est_psi * 100;

% Theoretical Displacement
cant.theord11_in = (cant.L2Loads_lb .* cant.L_in^3)./(48*Est_psi*cant.I_in4);
cant.theord21_in = (cant.L2Loads_lb .* cant.L_in^3)./(48*Est_psi*cant.I_in4);
cant.theord12_in = (3*cant.L4Loads_lb .* cant.L_in^3)./(256*Est_psi*cant.I_in4);
cant.theord22_in = (3*cant.L4Loads_lb .* cant.L_in^3)./(256*Est_psi*cant.I_in4);

% Displacement Error
cant.d11Err = abs(cant.theord11_in - cant.d11_in)./cant.theord11_in * 100;
cant.d21Err = abs(cant.theord21_in - cant.d21_in)./cant.theord21_in * 100;
cant.d12Err = abs(cant.theord12_in - cant.d12_in)./cant.theord12_in * 100;
cant.d22Err = abs(cant.theord22_in - cant.d22_in)./cant.theord22_in * 100;