%% Example 1: Basic Analysis with Default Parameters
% This example demonstrates the basic usage of the topographic gravity
% analysis tools with the provided sample data.

clc;
clear;
close all;

% Add source directory to path
addpath('src');

fprintf('=== Example 1: Basic Topographic Analysis ===\n\n');

try
    % Run the analysis with default parameters
    [results, figures] = topographic_gravity_analysis('dgm.mat');
    
    % Display key results
    fprintf('Key Results:\n');
    fprintf('  Maximum elevation: %.2f m\n', results.center_elevation);
    fprintf('  Helmert height: %.4f m\n', results.helmert_height);
    fprintf('  Precise height: %.4f m\n', results.precise_height);
    fprintf('  Height difference: %.4f m\n', abs(results.precise_height - results.helmert_height));
    
    % Calculate statistics for comparison
    bouguer_stats = struct();
    bouguer_stats.mean = mean(results.gravity_bouguer(:));
    bouguer_stats.std = std(results.gravity_bouguer(:));
    bouguer_stats.max = max(results.gravity_bouguer(:));
    bouguer_stats.min = min(results.gravity_bouguer(:));
    
    prism_stats = struct();
    prism_stats.mean = mean(results.gravity_prism);
    prism_stats.std = std(results.gravity_prism);
    prism_stats.max = max(results.gravity_prism);
    prism_stats.min = min(results.gravity_prism);
    
    fprintf('\nGravity Effect Statistics:\n');
    fprintf('Bouguer Plate Model:\n');
    fprintf('  Mean: %.4f mGal\n', bouguer_stats.mean);
    fprintf('  Std:  %.4f mGal\n', bouguer_stats.std);
    fprintf('  Range: %.4f to %.4f mGal\n', bouguer_stats.min, bouguer_stats.max);
    
    fprintf('Rectangular Prism Model:\n');
    fprintf('  Mean: %.4f mGal\n', prism_stats.mean);
    fprintf('  Std:  %.4f mGal\n', prism_stats.std);
    fprintf('  Range: %.4f to %.4f mGal\n', prism_stats.min, prism_stats.max);
    
    fprintf('\nAnalysis completed successfully!\n');
    fprintf('Results saved in: results/\n');
    fprintf('Figures displayed and saved as PNG files.\n');
    
catch ME
    fprintf('Error during analysis: %s\n', ME.message);
    fprintf('Stack trace:\n');
    for i = 1:length(ME.stack)
        fprintf('  %s (line %d)\n', ME.stack(i).name, ME.stack(i).line);
    end
end