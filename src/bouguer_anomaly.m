function bouguer_anom = bouguer_anomaly(grav_obs, latitude, height, density, reference_level)
%BOUGUER_ANOMALY Calculate the Bouguer anomaly from observed gravity
%   BOUGUER_ANOM = BOUGUER_ANOMALY(GRAV_OBS, LATITUDE, HEIGHT, DENSITY, REF_LEVEL)
%   calculates the Bouguer anomaly by applying the necessary corrections
%   to the observed gravity value.
%
%   The Bouguer anomaly is calculated as:
%   Δg_B = g_obs - γ + δg_FA - δg_B - δg_T
%   
%   Where:
%   - g_obs: observed gravity
%   - γ: normal gravity at sea level
%   - δg_FA: free-air correction
%   - δg_B: Bouguer correction  
%   - δg_T: terrain correction
%
%   Input parameters:
%   - grav_obs: Observed gravity value [mGal]
%   - latitude: Latitude in degrees
%   - height: Height above reference level [m]
%   - density: Rock density [kg/m³] (default: 2670 kg/m³)
%   - reference_level: Reference level [m] (default: 0 m, sea level)
%
%   Output:
%   - bouguer_anom: Bouguer anomaly [mGal]
%
%   Example:
%   bouguer_anom = bouguer_anomaly(981000, 45.0, 1000, 2670, 0);
%
%   Reference: Blakely, R.J. (1995). Potential theory in gravity and 
%   magnetic applications. Cambridge University Press.

% Set default values
if nargin < 4
    density = 2670; % kg/m³ - typical crustal rock density
end
if nargin < 5
    reference_level = 0; % sea level
end

% Constants
G = 6.67430e-11; % Gravitational constant [m³/kg/s²]
MGAL_TO_MS2 = 1e-5; % Conversion factor mGal to m/s²

% Convert inputs to consistent units
height_rel = height - reference_level;
lat_rad = latitude * pi / 180;

% Calculate normal gravity at sea level using Somigliana formula (GRS80)
% γ₀ = 9.7803267714 * (1 + 0.0052790414*sin²φ + 0.0000232718*sin⁴φ)
gamma_0 = 9.7803267714 * (1 + 0.0052790414 * sin(lat_rad)^2 + ...
                          0.0000232718 * sin(lat_rad)^4);

% Free-air correction: δg_FA = -0.3086 * h [mGal/m]
free_air_correction = -0.3086 * height_rel;

% Bouguer correction: δg_B = 2πGρh * 10⁵ [mGal]
bouguer_correction = 2 * pi * G * density * height_rel * 1e5;

% For simplicity, terrain correction is set to 0
% In practice, this would require detailed topographic analysis
terrain_correction = 0;

% Convert observed gravity to m/s² if needed
if grav_obs > 100 % Assume input is in mGal if > 100
    grav_obs_ms2 = grav_obs * MGAL_TO_MS2;
    gamma_0_mgal = gamma_0 * 1e5; % Convert to mGal
    
    % Calculate Bouguer anomaly in mGal
    bouguer_anom = grav_obs - gamma_0_mgal + free_air_correction - ...
                   bouguer_correction - terrain_correction;
else
    % Input already in m/s²
    % Calculate Bouguer anomaly in m/s²
    bouguer_anom = grav_obs - gamma_0 + (free_air_correction * MGAL_TO_MS2) - ...
                   (bouguer_correction * MGAL_TO_MS2) - (terrain_correction * MGAL_TO_MS2);
end

end