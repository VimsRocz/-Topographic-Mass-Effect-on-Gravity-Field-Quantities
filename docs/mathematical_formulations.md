# Mathematical Formulations

This document provides the mathematical foundations for the topographic mass effect calculations implemented in this repository.

## 1. Gravitational Potential of a Rectangular Prism

The gravitational potential V of a rectangular prism with density ρ at point (x₀, y₀, z₀) is calculated using:

```
V(x₀, y₀, z₀) = Gρ ∑∑∑ (-1)^(i+j+k) · vq(x₍ᵢ₎ - x₀, y₍ⱼ₎ - y₀, z₍ₖ₎ - z₀)
```

where the summation is over i,j,k ∈ {1,2} and the auxiliary function vq is defined as:

```
vq(x, y, z) = xy·ln(z + √(x² + y² + z²)) + 
              xz·arctan(yz/(x√(x² + y² + z²))) +
              yz·arctan(xz/(y√(x² + y² + z²)))
```

**Reference**: Nagy, D., Papp, G., & Benedek, J. (2000). The gravitational potential and its derivatives for the prism. Journal of Geodesy, 74(7-8), 552-560.

## 2. Bouguer Plate Approximation

For the simplified case of an infinite horizontal plate (Bouguer plate), the gravitational acceleration at height h above the plate is:

```
g_Bouguer = 2πGρh
```

where:
- G = 6.67430 × 10⁻¹¹ m³/(kg·s²) is the gravitational constant
- ρ is the density of the plate material [kg/m³]
- h is the height above the reference level [m]

## 3. Bouguer Anomaly

The complete Bouguer anomaly is calculated as:

```
Δg_B = g_obs - γ + δg_FA - δg_B - δg_T
```

where:
- g_obs: observed gravity [mGal]
- γ: normal gravity at the reference level [mGal]
- δg_FA: free-air correction [mGal]
- δg_B: Bouguer correction [mGal]
- δg_T: terrain correction [mGal]

### 3.1 Normal Gravity (GRS80 Ellipsoid)

```
γ₀ = 9.7803267714 × (1 + 0.0052790414·sin²φ + 0.0000232718·sin⁴φ) [m/s²]
```

where φ is the latitude in radians.

### 3.2 Free-Air Correction

```
δg_FA = -0.3086 × h [mGal/m]
```

### 3.3 Bouguer Correction

```
δg_B = 2πGρh × 10⁵ [mGal]
```

## 4. Orthometric Heights

### 4.1 Helmert Orthometric Height

The Helmert orthometric height is calculated using the mean normal gravity along the plumb line:

```
H_Helmert = C/γ̄
```

where:
- C is the geopotential number [m²/s²]
- γ̄ is the mean normal gravity along the plumb line [m/s²]

### 4.2 Rigorous Orthometric Height

For more precise calculations, the actual gravity field along the plumb line must be considered:

```
H_rigorous = C/ḡ
```

where ḡ is the mean actual gravity along the plumb line, computed as:

```
ḡ = (1/H) ∫₀ᴴ g(H') dH'
```

## 5. Topographic Correction

The topographic correction accounts for the gravitational effect of irregular terrain and is computed by summing the contributions from all topographic masses:

```
δg_T = Gρ ∑ᵢ ∫∫∫_Vᵢ (z - z₀)/r³ dV
```

where:
- Vᵢ represents individual volume elements (prisms)
- r = √((x-x₀)² + (y-y₀)² + (z-z₀)²) is the distance from the computation point
- z₀ is the elevation of the observation point

## 6. Coordinate Systems and Conventions

### 6.1 Coordinate System
- X-axis: East (positive eastward)
- Y-axis: North (positive northward)  
- Z-axis: Up (positive upward, following right-hand rule)

### 6.2 Units
- Length: meters [m]
- Gravity: milligals [mGal] where 1 mGal = 10⁻⁵ m/s²
- Density: kg/m³
- Angles: degrees or radians as specified

## 7. Numerical Implementation Notes

### 7.1 Prism Integration
The rectangular prism potential calculation uses analytical expressions to avoid numerical integration. The method is stable for observation points outside the prism volume.

### 7.2 Singularity Handling
Special care is taken when computation points coincide with prism vertices or edges. The implementation uses appropriate limit values or small offset techniques.

### 7.3 Precision Considerations
All calculations maintain double precision throughout. For very small prisms or large distances, appropriate scaling factors are applied to maintain numerical accuracy.

## References

1. Nagy, D., Papp, G., & Benedek, J. (2000). The gravitational potential and its derivatives for the prism. Journal of Geodesy, 74(7-8), 552-560.

2. Blakely, R. J. (1995). Potential theory in gravity and magnetic applications. Cambridge University Press.

3. Heiskanen, W. A., & Moritz, H. (1967). Physical geodesy. W.H. Freeman.

4. Torge, W. (2001). Geodesy. Walter de Gruyter.

5. Hofmann-Wellenhof, B., & Moritz, H. (2006). Physical geodesy. Springer.