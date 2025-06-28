# Topographic Mass Effect on Gravity Field Quantities
This project investigates the contribution of topography to gravity measurements and how it affects various derived quantities. It explores methods for modeling the topography and computing its gravitational influence.
## Repository: Topographic Mass Effect on Gravity Field Quantities

This repository investigates the contribution of topography to gravity field quantities and its impact on derived measurements. It explores methods for modeling topography and computing its gravitational influence.

**Project Goals:**

* Understand the impact of topography on gravity measurements.
* Develop methods for modeling topography and calculating its gravitational effects.
* Compare approaches for computing orthometric height.

**Methodology:**

* Model topography using a Bouguer plate and rectangular prisms.
* Calculate the topographic contribution to gravity.
* Compare methods for computing orthometric height.

**Data:**

Input data for the examples is provided in the file `dgm.mat` located in the repository root.  If you want to experiment with your own data, create a `data` directory and place your files there.

**Software:**

* Programming language: MATLAB (or a suitable alternative)
* Relevant functions (examples):
    * `bouguer_anomaly.m`: Calculates the Bouguer anomaly.
    * `orthometric_height.m`: Computes orthometric heights.
    * `vprism.m` (if applicable): Calculates the gravitational potential of a rectangular prism.

**Usage**

Run the main script in MATLAB or Octave:

```matlab
Gravity_field_topographic
```

The script loads `dgm.mat`, performs the computations and displays a few plots. Create a `results` directory if you would like to save outputs.

**Results:**

You can create a `results` directory to store any tables, figures or reports produced by the scripts.

**Formulae:**

Key formulae are documented within the code and potentially in the `doc` folder (if it exists). These include:

* Bouguer anomaly formula (Equation 1)
* Plumb line definition (Equation 5)
* Helmert height formula (Equation 6)
* Precise orthometric height formula (Equation 7)
* Gravitational potential of a rectangular prism (Equation 9) (if applicable)

**Contributing**

We welcome contributions to this project. If you'd like to contribute, feel free to fork the repository and submit a pull request.

**License**

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

**Authors:**

Vims

Scripts such as `Gravity_field_topographic.m` and `vprism.m` are stored in the repository root.
