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

### dgm.mat

`dgm.mat` is a small sample digital terrain model used by the MATLAB examples in
this repository. It was created by the authors for demonstration purposes and is
distributed under the repository's MIT License. You may reuse this file in
accordance with that license.

**Software:**

* MATLAB R2017b or later. The repository has also been tested with GNU Octave 8.4,
  which provides a free, open source alternative.
* Relevant functions (examples):
    * `bouguer_anomaly.m`: Calculates the Bouguer anomaly.
    * `orthometric_height.m`: Computes orthometric heights.
* `vprism.m` (if applicable): Calculates the gravitational potential of a rectangular prism.

### Running the example

1. Start **MATLAB** or **GNU Octave** and change the current directory to the
   root of this repository.
2. Load the sample terrain data
   ```matlab
   dgm = load('dgm.mat');
   ```
   (this step is optional because the script loads the file automatically).
3. Run the main script
   ```matlab
   Gravity_field_topographic
   ```
4. Four figures should appear:
   * *Modeling of topographic masses with a Bouguer plate* (3‑D mesh)
   * *Topography wrt to Bouguer plate* (profile plot)
   * *Topography wrt to Rectangualr Prism*
   * *comparision-Topography wrt to Bouguer plate and Rectangualr Prism*
5. When finished, check the workspace for `gp_top_Bouguer`,
   `gp_top_rectangular_Prism`, `Hp`, and `Hp2`.  Their presence indicates the
   computation ran successfully.

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
