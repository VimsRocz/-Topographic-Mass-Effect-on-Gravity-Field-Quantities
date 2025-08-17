# API Reference

This document provides detailed information about all functions and their usage in the Topographic Mass Effect analysis toolkit.

## Core Analysis Functions

### topographic_gravity_analysis

**Purpose**: Main function for comprehensive analysis of topographic mass effects on gravity field quantities.

**Syntax**:
```matlab
[results, figures] = topographic_gravity_analysis(data_file)
[results, figures] = topographic_gravity_analysis(data_file, Name, Value)
```

**Parameters**:
- `data_file` (string): Path to .mat file containing topographic data with structure `dgm.dgm.{x,y,z}`
- `'density'` (numeric): Rock density in kg/m³ (default: 2670)
- `'profile_length'` (numeric): Profile length in km (default: 4)
- `'point_spacing'` (numeric): Point spacing in m (default: 100)
- `'save_results'` (logical): Save results to file (default: true)
- `'save_figures'` (logical): Save figures to file (default: true)
- `'results_dir'` (string): Directory for saving results (default: 'results')

**Returns**:
- `results` (struct): Complete analysis results containing all computed values
- `figures` (array): Handle array for generated figures

**Example**:
```matlab
[res, figs] = topographic_gravity_analysis('dgm.mat', 'density', 2700, 'profile_length', 6);
```

---

### vprism

**Purpose**: Calculate gravitational potential of a rectangular prism.

**Syntax**:
```matlab
v = vprism(x1, x2, y1, y2, z1, z2)
```

**Parameters**:
- `x1, x2`: X-coordinate boundaries of the prism [m]
- `y1, y2`: Y-coordinate boundaries of the prism [m]  
- `z1, z2`: Z-coordinate boundaries of the prism [m]

**Returns**:
- `v`: Gravitational potential in m²/s² for ρ=1 g/cm³

**Note**: For positive results, ensure |coordinate₁| < |coordinate₂| for each dimension.

**Example**:
```matlab
potential = vprism(-25, 25, -25, 25, 0, 100);
```

---

### vq

**Purpose**: Auxiliary function for gravitational potential calculation.

**Syntax**:
```matlab
q = vq(x, y, z)
```

**Parameters**:
- `x, y, z`: Coordinates (scalars or arrays)

**Returns**:
- `q`: Auxiliary function value used in potential calculations

**Note**: This function handles edge cases where coordinates are zero or near zero.

---

### bouguer_anomaly

**Purpose**: Calculate Bouguer anomaly from observed gravity measurements.

**Syntax**:
```matlab
bouguer_anom = bouguer_anomaly(grav_obs, latitude, height, density, reference_level)
```

**Parameters**:
- `grav_obs`: Observed gravity value [mGal or m/s²]
- `latitude`: Latitude in degrees
- `height`: Height above reference level [m]
- `density`: Rock density [kg/m³] (default: 2670)
- `reference_level`: Reference level [m] (default: 0)

**Returns**:
- `bouguer_anom`: Bouguer anomaly [mGal or m/s²]

**Example**:
```matlab
anomaly = bouguer_anomaly(981000, 45.0, 1000, 2670, 0);
```

---

### orthometric_height

**Purpose**: Calculate orthometric height from ellipsoidal height using different methods.

**Syntax**:
```matlab
[H_ortho, method_used] = orthometric_height(H_ellips, N_geoid, grav_surface, method)
```

**Parameters**:
- `H_ellips`: Ellipsoidal height [m]
- `N_geoid`: Geoid undulation [m]
- `grav_surface`: Surface gravity [m/s² or mGal]
- `method`: Calculation method ('simple', 'helmert', 'rigorous') (default: 'simple')

**Returns**:
- `H_ortho`: Orthometric height [m]
- `method_used`: Description of method applied

**Example**:
```matlab
[height, method] = orthometric_height(1250.5, 45.2, 9.8001, 'helmert');
```

## Data Structures

### Results Structure

The `results` structure returned by `topographic_gravity_analysis` contains:

```matlab
results = struct(
    'input', struct(          % Input parameters
        'data_file',          % Original data file path
        'density',            % Used density value
        'profile_length',     % Profile length
        'point_spacing'       % Point spacing
    ),
    'topography', struct(     % Topographic data
        'surface_x',          % X-coordinates array
        'surface_y',          % Y-coordinates array  
        'surface_z'           % Z-coordinates (elevation) array
    ),
    'profile', struct(        % Extracted profile data
        'Line_X',             % Profile X-coordinates
        'Line_Y',             % Profile Y-coordinates
        'Line_Z'              % Profile elevations
    ),
    'gravity_bouguer',        % Bouguer plate gravity effects [mGal]
    'gravity_prism',          % Rectangular prism gravity effects [mGal]
    'center_elevation',       % Maximum elevation [m]
    'helmert_height',         % Helmert orthometric height [m]
    'precise_height',         % Precise orthometric height [m]
    'computation_time'        % Timestamp of computation
);
```

### Input Data Format

Input `.mat` files should contain a structure with the following format:

```matlab
dgm.dgm.x    % X-coordinates [m] (1D array or 2D grid)
dgm.dgm.y    % Y-coordinates [m] (1D array or 2D grid)  
dgm.dgm.z    % Elevation values [m] (2D array)
```

## Error Handling

### Common Error Messages

1. **"Failed to load data file"**: Check that the specified .mat file exists and contains the required `dgm.dgm.{x,y,z}` structure.

2. **"Unknown method"**: For `orthometric_height`, use only 'simple', 'helmert', or 'rigorous'.

3. **"Array dimension mismatch"**: Ensure coordinate arrays and elevation matrix have compatible dimensions.

### Debugging Tips

1. Use `exist('filename.mat', 'file')` to verify data file existence
2. Load data manually first: `dgm = load('filename.mat'); whos dgm`  
3. Check array sizes: `size(dgm.dgm.x)`, `size(dgm.dgm.z)`
4. Verify coordinate system orientation and units

## Performance Notes

### Computation Complexity
- Bouguer plate calculation: O(n²) where n is profile length
- Rectangular prism calculation: O(n³) where n depends on grid resolution
- Memory usage scales with topographic grid size

### Optimization Tips
1. Reduce `profile_length` for faster computation
2. Increase `point_spacing` to reduce number of calculation points  
3. Consider subsampling large topographic grids for initial analysis
4. Use `'save_results', false` and `'save_figures', false` to skip I/O operations

### Hardware Requirements
- Minimum: 4 GB RAM for typical datasets
- Recommended: 8 GB RAM for large topographic grids
- Processing time: 1-10 minutes depending on grid size and profile parameters

## Version Compatibility

### MATLAB Compatibility
- Minimum version: MATLAB R2017b
- Tested versions: R2017b, R2019a, R2021a, R2023a
- Required toolboxes: None (uses base MATLAB functions only)

### GNU Octave Compatibility  
- Minimum version: Octave 5.0
- Tested version: Octave 8.4
- Notes: Full compatibility with minor syntax differences handled internally

## File I/O

### Supported Data Formats
- Input: MATLAB .mat files with `dgm` structure
- Output: MATLAB .mat files for results, PNG files for figures

### Results Directory Structure
```
results/
├── topographic_analysis_YYYY-MM-DD_HH-MM-SS.mat
├── figure_1_YYYY-MM-DD_HH-MM-SS.png
├── figure_2_YYYY-MM-DD_HH-MM-SS.png
├── figure_3_YYYY-MM-DD_HH-MM-SS.png
└── figure_4_YYYY-MM-DD_HH-MM-SS.png
```