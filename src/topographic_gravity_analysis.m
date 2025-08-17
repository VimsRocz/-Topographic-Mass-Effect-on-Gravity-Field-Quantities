function [results, figures] = topographic_gravity_analysis(data_file, varargin)
%TOPOGRAPHIC_GRAVITY_ANALYSIS Comprehensive analysis of topographic mass effects
%   [RESULTS, FIGURES] = TOPOGRAPHIC_GRAVITY_ANALYSIS(DATA_FILE, ...)
%   performs a complete analysis of topographic mass effects on gravity
%   field quantities using both Bouguer plate and rectangular prism models.
%
%   Input parameters:
%   - data_file: Path to .mat file containing topographic data
%   - Name-Value pairs:
%     'density': Rock density in kg/m³ (default: 2670)
%     'profile_length': Profile length in km (default: 4)
%     'point_spacing': Point spacing in m (default: 100)
%     'save_results': Save results to file (default: true)
%     'save_figures': Save figures to file (default: true)
%     'results_dir': Directory for saving results (default: 'results')
%
%   Output:
%   - results: Structure containing all computed values
%   - figures: Array of figure handles
%
%   Example:
%   [res, figs] = topographic_gravity_analysis('dgm.mat', 'density', 2700);

% Parse input arguments
p = inputParser;
addRequired(p, 'data_file', @ischar);
addParameter(p, 'density', 2670, @isnumeric);
addParameter(p, 'profile_length', 4, @isnumeric); % km
addParameter(p, 'point_spacing', 100, @isnumeric); % m
addParameter(p, 'save_results', true, @islogical);
addParameter(p, 'save_figures', true, @islogical);
addParameter(p, 'results_dir', 'results', @ischar);
parse(p, data_file, varargin{:});

% Extract parameters
density = p.Results.density;
profile_length = p.Results.profile_length;
point_spacing = p.Results.point_spacing;
save_results = p.Results.save_results;
save_figures = p.Results.save_figures;
results_dir = p.Results.results_dir;

% Create results directory if it doesn't exist
if save_results || save_figures
    if ~exist(results_dir, 'dir')
        mkdir(results_dir);
    end
end

% Constants
G = 6.67430e-11; % Gravitational constant [m³/kg/s²]
G_legacy = 6.674e-11; % For compatibility with original script

fprintf('=== Topographic Mass Effect Analysis ===\n');
fprintf('Data file: %s\n', data_file);
fprintf('Rock density: %.0f kg/m³\n', density);
fprintf('Profile length: %.1f km\n', profile_length);
fprintf('Point spacing: %.0f m\n', point_spacing);
fprintf('=========================================\n\n');

%% Load and prepare data
fprintf('Loading topographic data...\n');
try
    dgm = load(data_file);
    surface_x = dgm.dgm.x;
    surface_y = dgm.dgm.y;
    surface_z = dgm.dgm.z;
    
    fprintf('  Grid size: %dx%d points\n', size(surface_z));
    fprintf('  X range: %.1f to %.1f m\n', min(surface_x(:)), max(surface_x(:)));
    fprintf('  Y range: %.1f to %.1f m\n', min(surface_y(:)), max(surface_y(:)));
    fprintf('  Z range: %.1f to %.1f m\n', min(surface_z(:)), max(surface_z(:)));
catch ME
    error('Failed to load data file: %s', ME.message);
end

%% Find the center of the surface (highest point - Zugspitze)
[center_surface_z, Index] = max(surface_z(:));
[I_row, I_col] = ind2sub(size(surface_z), Index);

fprintf('Surface center found:\n');
fprintf('  Max elevation: %.1f m\n', center_surface_z);
fprintf('  Grid position: (%d, %d)\n', I_row, I_col);

%% Create profile line
% Calculate indices for the desired profile length
half_points = round((profile_length * 1000) / (2 * point_spacing));

% Extract profile data (north-south orientation)
Line_X = surface_x(max(1, I_col-half_points):2:min(end, I_col+half_points));
Line_Y = surface_y(max(1, I_row-half_points):2:min(end, I_row+half_points));
Line_Z = surface_z(max(1, I_row-half_points):2:min(end, I_row+half_points), ...
                   max(1, I_col-half_points):2:min(end, I_col+half_points));

fprintf('Profile extracted:\n');
fprintf('  Profile points: %d\n', length(Line_Y));
fprintf('  Actual length: %.2f km\n', (max(Line_Y) - min(Line_Y)) / 1000);

%% Task 1 Part 1: Bouguer Plate Model
fprintf('\nCalculating Bouguer plate model...\n');

% Calculate topographic contribution using Bouguer plate approximation
gp_top_Bouguer = 2 * pi * G_legacy * density * Line_Z * 1e5; % Convert to mGal

%% Task 1 Part 2: Rectangular Prism Model
fprintf('Calculating rectangular prism model...\n');

% Define prism boundaries (±25m around each grid point)
prism_half_size = 25; % m
SurfaceX1 = repmat(surface_x - prism_half_size, numel(surface_y(1,:)), 1);
SurfaceX2 = repmat(surface_x + prism_half_size, numel(surface_y(1,:)), 1);
SurfaceY3 = repmat(surface_y.' - prism_half_size, 1, numel(surface_y(1,:)));
SurfaceY4 = repmat(surface_y.' + prism_half_size, 1, numel(surface_y(1,:)));

% Calculate gravity effect at each profile point
gp_top_rectangular_Prism = zeros(1, numel(Line_Z(1,:)));

for k = 1:numel(Line_Z(1,:))
    if mod(k, 10) == 0
        fprintf('  Processing point %d/%d\n', k, numel(Line_Z(1,:)));
    end
    
    % Calculate gravitational effect using vprism function
    gp_top_rectangular_Prism(1,k) = sum(sum(vprism(...
        SurfaceX1 - Line_X(1,21), SurfaceX2 - Line_X(1,21), ...
        SurfaceY3 - Line_Y(1,k), SurfaceY4 - Line_Y(1,k), ...
        -Line_Z(k,21), surface_z - Line_Z(k,21))));
    
    gp_top_rectangular_Prism(1,k) = gp_top_rectangular_Prism(1,k) * density * 1e-3;
end

%% Task 2: Field Points Analysis (Placeholder)
fprintf('\nSetting up field points for analysis...\n');
field_X = 400:150:1300;
field_Y = 400:150:1300;
field_Z = repmat(1300, length(field_Y), 1);

%% Task 3: Orthometric Heights
fprintf('Calculating orthometric heights...\n');

% Physical constants for orthometric height calculation
Cp = 29035; % Geopotential number [m²/s²]
gp = 9.80005688; % Reference gravity [m/s²]
free_air_gravity_grad = -0.3086e-5; % Free-air gradient [s⁻²]

% Method 1: Helmert height formula
g_bar_1 = gp + 0.0424e-5 * center_surface_z;
Hp = Cp / g_bar_1;

% Method 2: Precise computation with topographic contribution
center_idx = 21; % Center of the profile
if center_idx <= length(gp_top_rectangular_Prism)
    v_top_rectangular_Prism = sum(sum(vprism(...
        SurfaceX1 - Line_X(1,center_idx), SurfaceX2 - Line_X(1,center_idx), ...
        SurfaceY3 - Line_Y(1,center_idx), SurfaceY4 - Line_Y(1,center_idx), ...
        -Line_Z(center_idx,center_idx), surface_z - Line_Z(center_idx,center_idx)))) * density * 1e-3;
    
    v_top_rectangular_Prism_Zero = sum(sum(vprism(...
        SurfaceX1 - Line_X(1,center_idx), SurfaceX2 - Line_X(1,center_idx), ...
        SurfaceY3 - Line_Y(1,center_idx), SurfaceY4 - Line_Y(1,center_idx), ...
        0, surface_z))) * density * 1e-3;
    
    gptop = gp_top_rectangular_Prism(1,center_idx);
    
    g_bar_2 = gp - free_air_gravity_grad * center_surface_z / 2 - ...
              gptop * 1e-5 + (v_top_rectangular_Prism_Zero - v_top_rectangular_Prism) / center_surface_z;
    
    Hp2 = Cp / g_bar_2;
else
    Hp2 = Hp; % Fallback to Helmert height
    fprintf('  Warning: Using Helmert height as fallback\n');
end

fprintf('  Helmert height: %.4f m\n', Hp);
fprintf('  Precise height: %.4f m\n', Hp2);
fprintf('  Difference: %.4f m\n', abs(Hp2 - Hp));

%% Store results
results = struct();
results.input = struct('data_file', data_file, 'density', density, ...
                      'profile_length', profile_length, 'point_spacing', point_spacing);
results.topography = struct('surface_x', surface_x, 'surface_y', surface_y, 'surface_z', surface_z);
results.profile = struct('Line_X', Line_X, 'Line_Y', Line_Y, 'Line_Z', Line_Z);
results.gravity_bouguer = gp_top_Bouguer;
results.gravity_prism = gp_top_rectangular_Prism;
results.center_elevation = center_surface_z;
results.helmert_height = Hp;
results.precise_height = Hp2;
results.computation_time = now();

%% Create visualizations
fprintf('\nGenerating plots...\n');
figures = [];

% Figure 1: 3D mesh of Bouguer plate model
fig1 = figure('Name', 'Bouguer Plate Model - 3D View', 'Position', [100, 600, 800, 600]);
mesh(gp_top_Bouguer);
title('Modeling of Topographic Masses with a Bouguer Plate', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('East-West Profile Points', 'FontSize', 12);
ylabel('North-South Profile Points', 'FontSize', 12);
zlabel('Gravitational Effect [mGal]', 'FontSize', 12);
colorbar;
grid on;
figures = [figures, fig1];

% Figure 2: Profile view of Bouguer plate
fig2 = figure('Name', 'Bouguer Plate Model - Profile', 'Position', [200, 500, 800, 500]);
center_col = ceil(size(gp_top_Bouguer, 2) / 2);
plot(Line_Y/1000, gp_top_Bouguer(:, center_col), 'b-', 'LineWidth', 2);
xlabel('Distance [km]', 'FontSize', 12);
ylabel('Gravitational Effect [mGal]', 'FontSize', 12);
title('Topographic Effect - Bouguer Plate Model', 'FontSize', 14, 'FontWeight', 'bold');
grid on;
figures = [figures, fig2];

% Figure 3: Profile view of rectangular prism model
fig3 = figure('Name', 'Rectangular Prism Model - Profile', 'Position', [300, 400, 800, 500]);
plot(1:length(gp_top_rectangular_Prism), gp_top_rectangular_Prism, 'r-', 'LineWidth', 2);
xlabel('Profile Point Number', 'FontSize', 12);
ylabel('Gravitational Effect [mGal]', 'FontSize', 12);
title('Topographic Effect - Rectangular Prism Model', 'FontSize', 14, 'FontWeight', 'bold');
grid on;
figures = [figures, fig3];

% Figure 4: Comparison of methods
fig4 = figure('Name', 'Model Comparison', 'Position', [400, 300, 800, 500]);
if length(Line_Y) == length(gp_top_rectangular_Prism)
    plot(Line_Y/1000, gp_top_rectangular_Prism, 'r-', 'LineWidth', 2, 'DisplayName', 'Rectangular Prism');
    hold on;
    plot(Line_Y/1000, gp_top_Bouguer(:, center_col), 'b--', 'LineWidth', 2, 'DisplayName', 'Bouguer Plate');
    xlabel('Distance [km]', 'FontSize', 12);
    ylabel('Gravitational Effect [mGal]', 'FontSize', 12);
    title('Comparison: Bouguer Plate vs Rectangular Prism Models', 'FontSize', 14, 'FontWeight', 'bold');
    legend('Location', 'best', 'FontSize', 11);
    grid on;
    hold off;
else
    % Alternative plot when dimensions don't match
    x_prism = 1:length(gp_top_rectangular_Prism);
    x_bouguer = 1:length(gp_top_Bouguer(:, center_col));
    plot(x_prism, gp_top_rectangular_Prism, 'r-', 'LineWidth', 2, 'DisplayName', 'Rectangular Prism');
    hold on;
    plot(x_bouguer, gp_top_Bouguer(:, center_col), 'b--', 'LineWidth', 2, 'DisplayName', 'Bouguer Plate');
    xlabel('Profile Point', 'FontSize', 12);
    ylabel('Gravitational Effect [mGal]', 'FontSize', 12);
    title('Comparison: Bouguer Plate vs Rectangular Prism Models', 'FontSize', 14, 'FontWeight', 'bold');
    legend('Location', 'best', 'FontSize', 11);
    grid on;
    hold off;
end
figures = [figures, fig4];

%% Save results and figures
if save_results
    results_file = fullfile(results_dir, sprintf('topographic_analysis_%s.mat', ...
                           datestr(now(), 'yyyy-mm-dd_HH-MM-SS')));
    save(results_file, 'results');
    fprintf('Results saved to: %s\n', results_file);
end

if save_figures
    for i = 1:length(figures)
        fig_file = fullfile(results_dir, sprintf('figure_%d_%s.png', i, ...
                           datestr(now(), 'yyyy-mm-dd_HH-MM-SS')));
        print(figures(i), fig_file, '-dpng', '-r300');
    end
    fprintf('Figures saved to: %s\n', results_dir);
end

fprintf('\n=== Analysis Complete ===\n');

end