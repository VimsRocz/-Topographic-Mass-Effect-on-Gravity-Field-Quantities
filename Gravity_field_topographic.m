

clc;
clear all;
format long g;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dgm = load('dgm.mat');
surface_x = dgm.dgm.x;
surface_y = dgm.dgm.y;
surface_z = dgm.dgm.z;

%% Task 1 part 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Topographic contribution to gravity in case of modeling of 
% %     the topographic masses with a Bouguer plate

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Find the center of new surface (Zugspite)
 %why here Index 20183?   not 201*201 
 %here we are saving max value as the center of z and total number for the y is saved as index.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[center_surface_z,Index] = max(surface_z(:)); 
[I_row, I_col] = ind2sub(size(surface_z),Index);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % New Surface with length 4 km, orientation: north-south, and point     %
% %   distance 100 m why we are increasing row by 40? If we want to       %
% increase in the east-west or only east or only north or only south or   %
% onlywest then how we will deal eith the above formual? Incase of only   %
% altitude like in z direction?                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Line_X = surface_x(I_col-40:2:I_col+40);
Line_Y = surface_y(I_row-40:2:I_row+40);
Line_Z = surface_z(I_row-40:2:I_row+40,I_col-40:2:I_col+40);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Modeling of topographic masses with a Bouguer plate %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
G = 6.674*10^(-11);
rho = 2670;
gp_top_Bouguer = 2*pi*G*rho*Line_Z*10^(5);    


% Plots
figure();
mesh(gp_top_Bouguer);
title('Modeling of topographic masses with a Bouguer plate');
xlabel('x surface');
ylabel('y surface');
zlabel('z surface'); 


figure();
plot(Line_Y,gp_top_Bouguer(:,21)); %because 21 column is the center of the all column
xlabel('Distance of the topography');
ylabel('Altitude of the topography');
title('Topography wrt to Bouguer plate');
%%%%%%%%%%%%%%%%%%%%%%%% Task 1 part 2%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Topographic masses with rectangular prisms              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SurfaceX1= repmat(surface_x - 25,numel(surface_y(1,:)),1);
SurfaceX2= repmat(surface_x + 25,numel(surface_y(1,:)),1);
SurfaceY3= repmat(surface_y.' - 25,1,numel(surface_y(1,:)));
SurfaceY4= repmat(surface_y.' + 25,1,numel(surface_y(1,:)));


for k=1:numel(Line_Z(1,:))
    G=SurfaceY3-Line_Y(1,k);
    gp_top_rectangular_Prism(1,k) = sum(sum(v1prism(SurfaceX1-Line_X(1,21),SurfaceX2-Line_X(1,21),SurfaceY3-Line_Y(1,k),SurfaceY4-Line_Y(1,k),-Line_Z(k,21),surface_z-Line_Z(k,21))));
    gp_top_rectangular_Prism(1,k) =gp_top_rectangular_Prism(1,k)*rho*10^(-3);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                            Plots                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 figure();
 plot(gp_top_rectangular_Prism);
 xlabel('Distance of the topography');
ylabel('Altitude of the topography');
title('Topography wrt to Rectangular Prism');

 figure();
 plot(Line_Y,gp_top_rectangular_Prism);
 hold on;
 plot(Line_Y,gp_top_Bouguer(:,21));
 hold off;
xlabel('Distance of the topography');
ylabel('Altitude of the topography');
title('comparison-Topography wrt to Bouguer plate and Rectangular Prism');

 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%                             Task 2                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

field_X =400:150:1300;
field_Y = 400:150:1300;
field_Z1 = repmat(1300,numel(field_Y(1,:)),1); 
a=find(field_Y(:) == 150);
field_Z2(1:7) = repmat(1300,numel(field_Y(1,:)),1); 
 


 %%%%%%%%%%%%%%%%%%%%%%%%% Task 3%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                   Orthometric heights                  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Cp = 29035;
gp = 9.80005688;
free_air_gravity_grad = -0.3086*10^(-5);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Using Helmert heights formula         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
g_bar_1 = gp + 0.0424*10^(-5)*center_surface_z;
Hp = Cp/g_bar_1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Using precise computation of the topographic contribution  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
v_top_rectangular_Prism = sum(sum(vprism(SurfaceX1-Line_X(1,21),SurfaceX2-Line_X(1,21),SurfaceY3-Line_Y(1,21),SurfaceY4-Line_Y(1,21),-Line_Z(21,21),surface_z-Line_Z(21,21))))*rho*10^(-3);
v_top_rectangular_Prism_Zero = sum(sum(vprism(SurfaceX1-Line_X(1,21),SurfaceX2-Line_X(1,21),SurfaceY3-Line_Y(1,21),SurfaceY4-Line_Y(1,21),0,surface_z)))*rho*10^(-3);

gptop =gp_top_rectangular_Prism(1,21);

g_bar_2 = gp - free_air_gravity_grad*center_surface_z/2 - gptop*10^(-5) +(v_top_rectangular_Prism_Zero - v_top_rectangular_Prism)/center_surface_z;
Hp2 = Cp/g_bar_2;

