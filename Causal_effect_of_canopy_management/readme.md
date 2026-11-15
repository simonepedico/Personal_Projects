# Causal Effects of Canopy Management

**Regression-based causal modeling and g-computation for studying canopy-management effects on Sangiovese grapes.**

**Author:** Simone Pedico.

[Notebook](Causal_Effects_of_Canopy_Management.ipynb) · [Full report](Causal_Effects_of_Canopy_Management.pdf) · [Open in Colab](https://colab.research.google.com/github/simonepedico/Personal_Projects/blob/main/Causal_effect_of_canopy_management/Causal_Effects_of_Canopy_Management.ipynb)

## Overview

This project investigates how canopy-management treatments affect grape composition and production-related variables.

The notebook defines a structural causal model through a collection of ordinary least-squares regressions. Each variable is modeled as a function of its direct parents in the assumed causal graph. Intervention scenarios are evaluated by fixing treatment or mediator values and sequentially recomputing downstream predictions.

Six queries examine total effects and effects involving specific mediators.

## Project contents

| File | Purpose |
| --- | --- |
| `Causal_Effects_of_Canopy_Management.ipynb` | Model fitting, g-computation functions and causal queries. |
| `Causal_Effects_of_Canopy_Management.pdf` | Background, query interpretations and methodological discussion. |

The notebook expects an external file named `sangiovese.csv`, which is not included in this directory.

## Method

### Structural equations

The model includes treatment, sprout and bunch counts, vegetation measurements, wood weight and grape-related outcomes.

Local mechanisms are fitted using `statsmodels` formula-based OLS regressions. Treatment is categorical. Predictions are propagated through the model in the order required by its dependencies.

### Intervention queries

The notebook compares treatment levels `T1a` and `T4a`.

| Query | Outcome | Effect investigated |
| --- | --- | --- |
| 1 | `Anthoc` | Total treatment effect |
| 2 | `Brix` | Total treatment effect |
| 3 | `Polyph` | Direct effect with `BunchN` held at its reference-treatment prediction |
| 4 | `Polyph` | Direct effect with `Anthoc` held at its reference-treatment prediction |
| 5 | `pH` | Indirect effect through `BunchN`, with treatment held fixed |
| 6 | `GrapeW` | Indirect effect through `Anthoc`, with treatment held fixed |

The direct-effect queries reuse mediator predictions under the reference treatment. The indirect-effect queries vary mediator predictions between treatment scenarios while holding treatment constant.

Consult the report for the natural-language interpretation of each query and the assumptions supporting its causal interpretation.

## Running the project

### Google Colab

1. Open the notebook using the link above.
2. Make `sangiovese.csv` available in the runtime's working directory.
3. Install missing dependencies before the imports:

   ```python
   %pip install numpy pandas networkx matplotlib statsmodels scikit-learn
   ```

4. Run the setup and data-loading cells.
5. Fit the structural equations before running the g-computation functions and queries.

Keep the original dataset column names and categorical treatment labels: the regression formulas depend on them.

### Local Jupyter

Install Jupyter and the same Python dependencies, then open the notebook:

```bash
python -m pip install jupyterlab numpy pandas networkx matplotlib statsmodels scikit-learn
jupyter lab Causal_Effects_of_Canopy_Management.ipynb
```

The notebook imports `google.colab.files`. For local execution, remove or replace Colab-specific upload code and place the CSV in the working directory.

## Outputs and interpretation

Outputs include fitted regression models, intervention predictions and numerical contrasts for the six queries.

The causal interpretation depends on the assumed graph, the adequacy of the local regression models and the identification assumptions for the chosen effects. The computations propagate fitted predictions; they should not be interpreted as observed outcomes under an actual intervention.

The repository does not include the input CSV or a pinned dependency file. Reproducing the analysis requires the matching dataset and a compatible Python environment.

## References

- [Project notebook](Causal_Effects_of_Canopy_Management.ipynb)
- [Full report](Causal_Effects_of_Canopy_Management.pdf)
