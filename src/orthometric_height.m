function [H_ortho, method_used] = orthometric_height(H_ellips, N_geoid, grav_surface, method)
%ORTHOMETRIC_HEIGHT Calculate orthometric height from ellipsoidal height
%   [H_ORTHO, METHOD] = ORTHOMETRIC_HEIGHT(H_ELLIPS, N_GEOID, GRAV_SURFACE, METHOD)
%   calculates the orthometric height using different approaches.
%
%   The relationship between heights is: h = H + N
%   Where:
%   - h: ellipsoidal height
%   - H: orthometric height  
%   - N: geoid undulation
%
%   However, precise orthometric heights require considering the actual
%   gravity field along the plumb line.
%
%   Input parameters:
%   - H_ellips: Ellipsoidal height [m]
%   - N_geoid: Geoid undulation [m]
%   - grav_surface: Surface gravity [m/s²] or [mGal]
%   - method: Calculation method ('simple', 'helmert', 'rigorous')
%             Default: 'simple'
%
%   Output:
%   - H_ortho: Orthometric height [m]
%   - method_used: String indicating which method was applied
%
%   Methods:
%   1. 'simple': H = h - N (ignores gravity variations)
%   2. 'helmert': Uses mean gravity along plumb line (Helmert height)
%   3. 'rigorous': Accounts for actual gravity variations (if data available)
%
%   Example:
%   H_ortho = orthometric_height(1250.5, 45.2, 9.8001, 'helmert');
%
%   References:
%   - Heiskanen, W.A. & Moritz, H. (1967). Physical Geodesy. 
%   - Torge, W. (2001). Geodesy, 3rd edition.

% Set default method
if nargin < 4
    method = 'simple';
end

% Constants
gamma_45 = 9.80616; % Normal gravity at 45° latitude [m/s²]
FREE_AIR_GRAD = -0.3086e-5; % Free-air gradient [s⁻²]

% Convert gravity to m/s² if in mGal
if grav_surface > 100
    grav_surface = grav_surface * 1e-5;
end

% Calculate basic orthometric height
H_basic = H_ellips - N_geoid;

switch lower(method)
    case 'simple'
        % Simple relationship: H = h - N
        H_ortho = H_basic;
        method_used = 'Simple (h - N)';
        
    case 'helmert'
        % Helmert orthometric height
        % Uses mean normal gravity along the plumb line
        % γ̄ = γ₀(1 - 2H/a) where a ≈ 6.37×10⁶ m (Earth radius)
        earth_radius = 6.371e6;
        gamma_mean = gamma_45 * (1 - 2 * H_basic / earth_radius);
        
        % Refined height calculation
        % This is a simplified approach; rigorous calculation requires
        % integration along the actual plumb line
        correction_factor = grav_surface / gamma_mean;
        H_ortho = H_basic * correction_factor;
        method_used = 'Helmert (mean gravity)';
        
    case 'rigorous'
        % Rigorous orthometric height
        % In practice, this requires detailed gravity measurements
        % along the plumb line. Here we provide a simplified approach.
        
        % Apply gravity correction based on free-air gradient
        height_correction = FREE_AIR_GRAD * H_basic^2 / (2 * grav_surface);
        H_ortho = H_basic + height_correction;
        method_used = 'Rigorous (gravity corrected)';
        
    otherwise
        error('Unknown method. Use "simple", "helmert", or "rigorous"');
end

% Display information if no output arguments
if nargout == 0
    fprintf('Orthometric Height Calculation\n');
    fprintf('==============================\n');
    fprintf('Method: %s\n', method_used);
    fprintf('Ellipsoidal height: %.3f m\n', H_ellips);
    fprintf('Geoid undulation: %.3f m\n', N_geoid);
    fprintf('Surface gravity: %.5f m/s²\n', grav_surface);
    fprintf('Orthometric height: %.3f m\n', H_ortho);
    fprintf('Height difference: %.3f m\n', H_ortho - H_basic);
end

end