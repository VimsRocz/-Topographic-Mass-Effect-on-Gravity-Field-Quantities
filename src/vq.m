function q = vq(x, y, z)
%VQ Compute auxiliary function for gravitational potential calculation
%   Q = VQ(X, Y, Z) computes the auxiliary function used in calculating
%   the gravitational potential of a rectangular prism.
%
%   This function implements the formula:
%   q = x*y*log(z + sqrt(x^2 + y^2 + z^2)) + 
%       x*z*atan(y*z/(x*sqrt(x^2 + y^2 + z^2))) +
%       y*z*atan(x*z/(y*sqrt(x^2 + y^2 + z^2)))
%
%   Input parameters:
%   - x, y, z: Coordinates (can be scalars or arrays)
%
%   Output:
%   - q: Auxiliary function value
%
%   Reference: Nagy et al. (2000), The gravitational potential and its 
%   derivatives for the prism, Journal of Geodesy, 74(7-8), 552-560.

% Handle the case when coordinates are zero or near zero
r = sqrt(x.^2 + y.^2 + z.^2);

% Initialize output
q = zeros(size(x));

% Compute each term separately to handle edge cases
% Term 1: x*y*log(z + r)
valid1 = (z + r) > 0;
q(valid1) = q(valid1) + x(valid1) .* y(valid1) .* log(z(valid1) + r(valid1));

% Term 2: x*z*atan(y*z/(x*r))
valid2 = x ~= 0 & r > 0;
q(valid2) = q(valid2) + x(valid2) .* z(valid2) .* atan((y(valid2) .* z(valid2)) ./ (x(valid2) .* r(valid2)));

% Term 3: y*z*atan(x*z/(y*r))
valid3 = y ~= 0 & r > 0;
q(valid3) = q(valid3) + y(valid3) .* z(valid3) .* atan((x(valid3) .* z(valid3)) ./ (y(valid3) .* r(valid3)));

end