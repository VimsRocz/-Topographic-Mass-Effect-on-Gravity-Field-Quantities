# Installation and Usage Guide

This guide provides step-by-step instructions for installing and using the Topographic Mass Effect Analysis toolkit.

## System Requirements

### Minimum Requirements
- **Operating System:** Windows 10, macOS 10.14, or Linux (Ubuntu 18.04+)
- **Memory:** 4 GB RAM (8 GB recommended for large datasets)
- **Disk Space:** 100 MB for software, additional space for data and results
- **Software:** MATLAB R2017b+ OR GNU Octave 5.0+

### Recommended Configuration
- **CPU:** Intel i5/AMD Ryzen 5 or equivalent (multi-core beneficial)
- **Memory:** 16 GB RAM for optimal performance
- **Storage:** SSD for faster I/O operations
- **Software:** MATLAB R2021a+ with Mapping Toolbox (optional)

## Installation

### Option 1: Git Clone (Recommended)
```bash
# Clone the repository
git clone https://github.com/VimsRocz/Topographic-Mass-Effect-on-Gravity-Field-Quantities.git

# Navigate to the directory
cd Topographic-Mass-Effect-on-Gravity-Field-Quantities

# Verify installation
ls -la
```

### Option 2: Download ZIP
1. Go to the GitHub repository page
2. Click "Code" → "Download ZIP"
3. Extract to your desired location
4. Rename folder if needed

### Option 3: Direct MATLAB Download
```matlab
% In MATLAB command window
websave('topographic_toolkit.zip', 'https://github.com/VimsRocz/Topographic-Mass-Effect-on-Gravity-Field-Quantities/archive/refs/heads/main.zip');
unzip('topographic_toolkit.zip');
cd('Topographic-Mass-Effect-on-Gravity-Field-Quantities-main');
```

## Initial Setup

### 1. Verify Installation
```matlab
% Check that sample data exists
if exist('dgm.mat', 'file')
    disp('✓ Sample data found');
else
    error('✗ Sample data missing - check installation');
end

% Add source directory to path
addpath('src');

% Verify core functions
if exist('vprism', 'file') && exist('topographic_gravity_analysis', 'file')
    disp('✓ Core functions available');
else
    error('✗ Core functions missing - check path');
end
```

### 2. Run Basic Test
```matlab
% Quick functionality test
try
    % Load sample data
    dgm = load('dgm.mat');
    disp('✓ Data loading successful');
    
    % Test core function
    v = vprism(-1, 1, -1, 1, 0, 1);
    if isfinite(v) && v ~= 0
        disp('✓ vprism function working');
    else
        error('✗ vprism function issue');
    end
    
    disp('🎉 Installation successful!');
catch ME
    fprintf('✗ Installation test failed: %s\n', ME.message);
end
```

## Quick Start Examples

### Example 1: Basic Analysis (5 minutes)
```matlab
% Basic analysis with default settings
addpath('src');
[results, figures] = topographic_gravity_analysis('dgm.mat');

% View key results
fprintf('Max elevation: %.1f m\n', results.center_elevation);
fprintf('Helmert height: %.3f m\n', results.helmert_height);
```

### Example 2: Custom Parameters (10 minutes)
```matlab
% Analysis with custom parameters
[results, figures] = topographic_gravity_analysis('dgm.mat', ...
    'density', 2850, ...        % Dense rock
    'profile_length', 6, ...    % Longer profile
    'point_spacing', 50);       % Higher resolution
```

### Example 3: Individual Function Usage
```matlab
% Use individual functions
addpath('src');

% Calculate Bouguer anomaly
anomaly = bouguer_anomaly(981000, 47.5, 2000, 2670);
fprintf('Bouguer anomaly: %.2f mGal\n', anomaly);

% Calculate orthometric height
[H, method] = orthometric_height(2950, 48, 9.8001, 'helmert');
fprintf('%s height: %.3f m\n', method, H);

% Calculate prism potential
V = vprism(-25, 25, -25, 25, 0, 100);
fprintf('Prism potential: %.6f m²/s²\n', V);
```

## Running the Analysis

### Method 1: New Enhanced Function (Recommended)
```matlab
% Navigate to repository root
cd('/path/to/Topographic-Mass-Effect-on-Gravity-Field-Quantities');

% Add source to path
addpath('src');

% Run comprehensive analysis
[results, figures] = topographic_gravity_analysis('dgm.mat');

% Results are automatically saved to results/ directory
% Figures are displayed and saved as PNG files
```

### Method 2: Original Legacy Script
```matlab
% For compatibility with original workflow
Gravity_field_topographic;

% Check workspace for results
whos gp_top_Bouguer gp_top_rectangular_Prism Hp Hp2
```

### Method 3: Step-by-Step Analysis
```matlab
% Manual step-by-step approach for learning
addpath('src');

% 1. Load data
dgm = load('dgm.mat');
fprintf('Loaded DEM: %dx%d points\n', size(dgm.dgm.z));

% 2. Find center point (highest elevation)
[max_elev, idx] = max(dgm.dgm.z(:));
[row, col] = ind2sub(size(dgm.dgm.z), idx);
fprintf('Max elevation: %.1f m at (%d,%d)\n', max_elev, row, col);

% 3. Extract profile
profile_half = 20; % ±2km profile
x_profile = dgm.dgm.x(col-profile_half:2:col+profile_half);
y_profile = dgm.dgm.y(row-profile_half:2:row+profile_half);
z_profile = dgm.dgm.z(row-profile_half:2:row+profile_half, col-profile_half:2:col+profile_half);

% 4. Calculate Bouguer effect
G = 6.674e-11;
rho = 2670;
g_bouguer = 2 * pi * G * rho * z_profile * 1e5; % mGal

% 5. Plot results
figure;
mesh(g_bouguer);
title('Bouguer Plate Gravity Effect');
xlabel('East-West'); ylabel('North-South'); zlabel('Effect [mGal]');
```

## Testing the Installation

### Run Complete Test Suite
```matlab
% Navigate to tests directory
cd('tests');

% Run all tests (takes ~2 minutes)
run_all_tests;

% Expected output: All test suites should complete successfully
```

### Individual Test Components
```matlab
cd('tests');

% Test individual functions
test_vprism;           % Test rectangular prism function
test_bouguer_anomaly;  % Test Bouguer anomaly calculation

% Check results
% All tests should show "PASS" status
```

## Troubleshooting

### Common Issues and Solutions

#### Issue 1: "File not found" errors
```matlab
% Check current directory
pwd

% List files
ls

% Add paths if needed
addpath('src');
addpath('examples');
addpath('tests');
```

#### Issue 2: "Undefined function" errors
```matlab
% Verify function exists
which vprism
which topographic_gravity_analysis

% If empty, check installation
if ~exist('src/vprism.m', 'file')
    error('Installation incomplete - missing source files');
end
```

#### Issue 3: Memory issues with large datasets
```matlab
% Check available memory
memory  % MATLAB only

% Reduce analysis parameters
[results, figs] = topographic_gravity_analysis('dgm.mat', ...
    'profile_length', 2, ...      % Shorter profile
    'point_spacing', 200);        % Coarser spacing
```

#### Issue 4: Slow performance
```matlab
% Use simplified analysis first
[results, figs] = topographic_gravity_analysis('dgm.mat', ...
    'profile_length', 1, ...      % 1 km profile
    'save_figures', false);       % Skip figure saving
```

### GNU Octave Specific Issues

#### Graphics Backend
```octave
% Set graphics backend if plots don't display
graphics_toolkit('qt');        % or 'fltk'
```

#### Function Compatibility
```octave
% Check Octave version
version

% Some functions may have slightly different syntax
% The code includes compatibility measures for most differences
```

## Performance Optimization

### For Large Datasets
1. **Increase Available Memory:**
   ```matlab
   % MATLAB memory optimization
   clear all;
   close all force;
   pack;  % Defragment memory
   ```

2. **Process in Chunks:**
   ```matlab
   % For very large DEMs, process smaller regions
   [results, figs] = topographic_gravity_analysis('large_dem.mat', ...
       'profile_length', 4, ...     % Standard length
       'save_results', true, ...    % Save intermediate results
       'results_dir', 'chunk_1');   % Separate directory
   ```

3. **Use Parallel Processing:**
   ```matlab
   % If Parallel Computing Toolbox available
   parpool;  % Start parallel pool
   % Analysis will automatically use parallel processing where possible
   ```

## Data Preparation

### Preparing Your Own DEM Data
```matlab
% Your data should be organized as:
dgm.dgm.x = x_coordinates;  % 1D or 2D array [m]
dgm.dgm.y = y_coordinates;  % 1D or 2D array [m]
dgm.dgm.z = elevation_data; % 2D array [m]

% Save in MATLAB format
save('my_dem.mat', 'dgm');

% Then analyze
[results, figs] = topographic_gravity_analysis('my_dem.mat');
```

### Data Requirements
- **Coordinate System:** Any metric system (UTM recommended)
- **Units:** Meters for all coordinates and elevations
- **Grid:** Regular spacing preferred (irregular grids supported)
- **Size:** Tested up to 1000×1000 points (~25 GB RAM required)

## Getting Help

### Documentation
- 📖 **API Reference:** `docs/api_reference.md`
- 🧮 **Mathematical Background:** `docs/mathematical_formulations.md`
- 📊 **Expected Results:** `results/expected_outputs.md`

### Examples
- 🎯 **Basic Usage:** `examples/example_basic_analysis.m`
- 🔧 **Advanced Features:** `examples/example_advanced_analysis.m`

### Support
- 🐛 **Issues:** GitHub Issues page
- 💬 **Discussions:** GitHub Discussions
- 📧 **Contact:** Repository maintainer

---

**Next Steps:**
1. Run the basic example to verify installation
2. Explore the advanced example for custom analysis
3. Check the API reference for detailed function documentation
4. Run tests to ensure everything works correctly

Happy analyzing! 🌍📊