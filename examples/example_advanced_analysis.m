%% Example 2: Advanced Analysis with Custom Parameters
% This example demonstrates advanced usage with custom parameters and
% additional analysis features.

clc;
clear;
close all;

% Add source directory to path
addpath('src');

fprintf('=== Example 2: Advanced Topographic Analysis ===\n\n');

try
    % Run analysis with custom parameters
    [results, figures] = topographic_gravity_analysis('dgm.mat', ...
        'density', 2700, ...          % Higher density (granite)
        'profile_length', 6, ...      % Longer profile (6 km)
        'point_spacing', 50, ...      % Finer sampling (50 m)
        'save_results', true, ...
        'save_figures', true);
    
    % Additional analysis: Bouguer anomaly calculation
    fprintf('Computing Bouguer anomaly...\n');
    
    % Sample parameters for demonstration
    latitude = 47.5;  % Latitude of the area (Zugspitze region)
    height = results.center_elevation;
    observed_gravity = 9.8001;  % Sample observed gravity [m/s²]
    
    bouguer_anom = bouguer_anomaly(observed_gravity * 1e5, latitude, height, results.input.density);
    
    fprintf('  Observed gravity: %.5f m/s²\n', observed_gravity);
    fprintf('  Bouguer anomaly: %.2f mGal\n', bouguer_anom);
    
    % Orthometric height comparison
    fprintf('\nOrthometric height analysis...\n');
    
    % Sample ellipsoidal height and geoid undulation
    h_ellips = height + 45;  % Sample ellipsoidal height
    N_geoid = 48.5;          % Sample geoid undulation
    
    [H_simple, method1] = orthometric_height(h_ellips, N_geoid, observed_gravity, 'simple');
    [H_helmert, method2] = orthometric_height(h_ellips, N_geoid, observed_gravity, 'helmert');
    [H_rigorous, method3] = orthometric_height(h_ellips, N_geoid, observed_gravity, 'rigorous');
    
    fprintf('  Ellipsoidal height: %.3f m\n', h_ellips);
    fprintf('  Simple method: %.3f m\n', H_simple);
    fprintf('  Helmert method: %.3f m\n', H_helmert);
    fprintf('  Rigorous method: %.3f m\n', H_rigorous);
    
    % Create additional comparison plot
    figure('Name', 'Height Comparison', 'Position', [500, 200, 800, 400]);
    methods = {'Simple', 'Helmert', 'Rigorous', 'Analysis Result'};
    heights = [H_simple, H_helmert, H_rigorous, results.precise_height];
    
    bar(heights);
    set(gca, 'XTickLabel', methods);
    ylabel('Orthometric Height [m]');
    title('Comparison of Orthometric Height Calculation Methods');
    grid on;
    
    % Save this additional plot
    print(gcf, 'results/height_comparison.png', '-dpng', '-r300');
    
    % Summary statistics
    fprintf('\nSummary Statistics:\n');
    fprintf('==================\n');
    fprintf('Profile length: %.1f km\n', (max(results.profile.Line_Y) - min(results.profile.Line_Y))/1000);
    fprintf('Profile points: %d\n', length(results.profile.Line_Y));
    fprintf('Elevation range: %.1f - %.1f m\n', min(results.topography.surface_z(:)), max(results.topography.surface_z(:)));
    
    gravity_diff = results.gravity_prism - results.gravity_bouguer(:,ceil(end/2))';
    fprintf('Mean gravity difference (Prism - Bouguer): %.4f mGal\n', mean(gravity_diff));
    fprintf('RMS gravity difference: %.4f mGal\n', sqrt(mean(gravity_diff.^2)));
    
    fprintf('\nAdvanced analysis completed successfully!\n');
    
catch ME
    fprintf('Error during advanced analysis: %s\n', ME.message);
    fprintf('Stack trace:\n');
    for i = 1:length(ME.stack)
        fprintf('  %s (line %d)\n', ME.stack(i).name, ME.stack(i).line);
    end
end