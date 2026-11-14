# Fetal Health Prediction

**Comparing neural networks and interpretable decision trees for three-class classification of cardiotocography measurements.**

**Authors:** Simone Pedico, Davide Piatti, Amedeo Desantis.

[Notebook](code.ipynb) · [Full report](report.pdf) · [Dataset](https://www.kaggle.com/datasets/andrewmvd/fetal-health-classification) · [Open in Colab](https://colab.research.google.com/github/simonepedico/Personal_Projects/blob/main/fetal_health_prediction/code.ipynb)

## Overview

This project investigates how class imbalance, dimensionality reduction and model complexity affect fetal-health classification. Starting from numerical features extracted from cardiotocograms (CTGs), it compares three feed-forward neural-network configurations with two pruned decision trees.

The main questions are whether class weighting preserves more useful information than downsampling, whether PCA improves the neural networks, and whether a small, readable decision tree can compete with them. Evaluation includes class-specific precision, recall and F1-score, alongside overall accuracy.

## Project contents

| File | Purpose |
| --- | --- |
| `code.ipynb` | Data download, exploratory analysis, preprocessing, training, evaluation and visualizations. |
| `report.pdf` | Methodology, architecture descriptions, experiment results and discussion. |
| `README.md` | Project overview and execution instructions. |

The dataset is downloaded separately. This project directory does not include exported trained models, a command-line inference application or a pinned dependency file.

## Dataset and target

The [Fetal Health Classification dataset](https://www.kaggle.com/datasets/andrewmvd/fetal-health-classification) contains **2,126 observations**, **21 numerical input features** and one target column, `fetal_health`.

Inputs describe fetal heart-rate baseline, accelerations and decelerations, fetal movement, uterine contractions, short- and long-term variability, and histogram statistics. The notebook converts the target to integers and shifts its labels:

| Class | Original CSV label | Notebook label | Observations |
| --- | ---: | ---: | ---: |
| Normal | 1 | 0 | 1,655 |
| Suspect | 2 | 1 | 295 |
| Pathological | 3 | 2 | 176 |

The strong imbalance motivates comparing downsampling with class-weighted training. A high overall accuracy alone would not establish good performance on the minority classes.

## Method

### Exploration and preprocessing

The notebook analyzes feature distributions, correlations and class frequencies, then standardizes numerical features with `StandardScaler`. The downsampling experiment retains 235 normal observations, all 295 suspect observations and all 176 pathological observations, for a total of 706 samples.

PCA is fitted on the downsampled data. **13 principal components** explain at least 95% of the variance in the recorded experiment. The notebook visualizes explained variance, component loadings and class distributions in PCA space.

### Models

| Model | Training data | Inputs | Imbalance handling |
| --- | --- | ---: | --- |
| `NN_downsampled` | Downsampled dataset | 13 PCA components | Majority-class downsampling |
| `NN_PCA` | Full dataset | 13 PCA components | Class weights |
| `NN_original` | Full dataset | 21 standardized features | Class weights |
| Tree T1 | Full dataset | 21 standardized features | `class_weight="balanced"` |
| Tree T2 | Full dataset | 21 standardized features | `class_weight="balanced"` |

Each neural network contains three dense layers of width equal to the input dimension, followed by a three-unit output layer. The implementation uses sigmoid activations throughout, categorical cross-entropy, Adam and one-hot targets. Main training runs use 200 epochs and batch size 20; cross-validation runs use smaller training budgets.

The decision trees use cost-complexity pruning. The selected `ccp_alpha` values are `0.009017265771584636` for T1 and `0.01082758511624278` for the more heavily pruned T2.

### Evaluation

- Initial train/test splits use 70%/30% and `random_state=42`.
- The downsampled network is evaluated both on its downsampled holdout and on that holdout supplemented with the removed normal observations.
- Outputs include classification reports, confusion matrices, ROC curves for neural networks, feature importance and tree visualizations.
- Repeated K-fold evaluation uses 5 folds × 2 repetitions for the neural networks and 7 folds × 2 repetitions for T1. Confidence intervals summarize variability across runs.

## Reported results

The following values are rounded results from Tables 4, 6, 7 and 9 of the [report](report.pdf), not newly reproduced measurements.

| Model / evaluation set | Samples | Accuracy | Macro F1 | Suspect recall | Pathological recall |
| --- | ---: | ---: | ---: | ---: | ---: |
| NN_downsampled / downsampled holdout | 212 | 0.83 | 0.83 | 0.80 | 0.80 |
| NN_downsampled / holdout + removed data | 1,632 | 0.87 | 0.68 | 0.80 | 0.80 |
| NN_PCA / full-data holdout | 638 | 0.84 | 0.77 | 0.81 | 0.85 |
| NN_original / full-data holdout | 638 | 0.86 | 0.78 | 0.83 | 0.88 |
| Tree T1 / full-data holdout | 638 | 0.85 | 0.80 | 0.91 | 1.00 |
| Tree T2 / full-data holdout | 638 | 0.84 | 0.79 | 0.90 | 0.98 |

The downsampled evaluations have different sample compositions and should not be ranked directly against the full-data holdout. The report selects NN_PCA for the final neural-network/tree comparison based on repeated-validation class-wise F1 results. T1 offers a readable alternative with strong minority-class recall in the reported holdout experiment.

## Running the project

### Google Colab

1. Open the notebook using the **Open in Colab** link above.
2. Add a dependency cell before the imports if packages are missing:

   ```python
   %pip install kagglehub numpy pandas matplotlib seaborn scipy scikit-learn tensorflow keras
   ```

3. Replace the hard-coded CSV path in the dataset-import cell with the actual path returned by KaggleHub:

   ```python
   from pathlib import Path

   path = kagglehub.dataset_download("andrewmvd/fetal-health-classification")
   df_originale = pd.read_csv(Path(path) / "fetal_health.csv")
   ```

4. Run the cells in order. Complete preprocessing before training and evaluation. The final cross-validation sections train many additional models and take longer than a single experiment.

A CPU can run these small models; a GPU is optional. Internet access is needed for the initial dataset download.

### Local Jupyter

```bash
git clone https://github.com/simonepedico/Personal_Projects.git
cd Personal_Projects/fetal_health_prediction
python -m venv .venv
source .venv/bin/activate
python -m pip install jupyterlab kagglehub numpy pandas matplotlib seaborn scipy scikit-learn tensorflow keras
jupyter lab code.ipynb
```

On Windows, activate the environment with `.venv\Scripts\activate`. Apply the CSV-path change above locally as well. These dependencies are derived from notebook imports; the repository does not specify a tested version lock.

## Outputs and reproducibility

Most results remain inside the notebook: fitted models, preprocessing objects, training curves, classification reports, PCA plots and tree diagrams. To reuse a model on new rows, preserve the exact input-column order, fitted scaler, PCA transformation where applicable, and label mapping. A model alone is insufficient to reproduce the preprocessing.

The published experiment has several methodological limitations relevant to interpreting its results:

- Scaling and PCA are fitted before the evaluation splits, so held-out data influence preprocessing. For a stricter evaluation, fit them only on each training partition.
- Pruning parameters are explored using test-set performance. An independent validation set would be needed for model selection before a final untouched test evaluation.
- Repeated K-fold splits are not stratified; neural-network and tree comparisons also use different fold counts.
- The notebook mixes 90% and 95% confidence intervals in different cells. Check the corresponding calculation before comparing intervals.
- Fixed split seeds do not guarantee identical neural-network results across executions or software versions.

These are academic classification experiments on the supplied dataset; they do not establish clinical performance.

## References

- [Project notebook](code.ipynb)
- [Project report](report.pdf), including the feature descriptions and full experimental discussion
- [Kaggle dataset](https://www.kaggle.com/datasets/andrewmvd/fetal-health-classification)
