# Human Age Prediction

**Comparison and ensembling of transfer learning, multi-task learning and self-supervised learning for age regression from facial images.**

**Authors:** Davide Piatti, Simone Pedico, Valentyn Piskovskyi.

[Notebook](code.ipynb) · [Full report](report.pdf) · [Model checkpoints](https://huggingface.co/datasets/siiimo/human_age_prediction_weights) · [Open in Colab](https://colab.research.google.com/github/simonepedico/Personal_Projects/blob/main/human_age_prediction/code.ipynb)

## Overview

This project estimates a person's age from a grayscale facial image. It investigates whether three different representation-learning strategies make sufficiently complementary errors to benefit from an ensemble:

1. **Transfer learning:** ImageNet-pretrained EfficientNetB0 and ResNet152 backbones with age-regression heads.
2. **Multi-task learning (MTL):** a shared convolutional backbone jointly predicting age, the dataset's binary gender label and face-detection score.
3. **Self-supervised learning (SSL):** image-reconstruction pretraining followed by age-regression training on top of a frozen encoder.

The final ensemble averages the age predictions from one transfer model, the SSL model and the MTL model. In the recorded experiment, it improves all reported regression metrics over its individual components.

## Project contents

| Resource | Purpose |
| --- | --- |
| `code.ipynb` | Dataset preparation, augmentation, architectures, training, evaluation, ensemble and submission generation. |
| `report.pdf` | Model motivation, architecture diagrams, results and discussion. |
| [Hugging Face checkpoints](https://huggingface.co/datasets/siiimo/human_age_prediction_weights) | Downloadable model weights and an SSL saved model. |
| `README.md` | Overview, execution instructions and checkpoint-loading guidance. |

Images and checkpoints are external downloads. The repository does not contain a standalone inference script or a pinned dependency file.

## Dataset and preprocessing

Data come from the [Age Prediction — Spring '25 at CU Denver competition](https://www.kaggle.com/competitions/age-prediction-spring-25-at-cu-denver/data). The notebook describes 60,327 labeled images and 1,409 unlabeled judge images, with a resolution of **100 × 100 pixels** and one grayscale channel.

The metadata include `full_path`, `age`, `gender`, `face_score` and `second_face_score`. The age-regression pipeline:

1. Retains rows with a non-missing face score of at least 4.5, no detected second face and age strictly between 0 and 110.
2. Shuffles the filtered rows with `random_state=42` and selects **3,000 images** by default (`number_of_train_images`).
3. Rounds age labels upward with `np.ceil` and creates a 70%/30% train/test split: 2,100 training images and 900 test images before augmentation.
4. Augments the training set to reduce imbalance across observed ages, using crops/resizing, horizontal flips, rotations, brightness and contrast changes.
5. Min-max scales age targets using training-set bounds. MTL also scales the face-score target.

The report's approximately 6,000-image figure refers to the augmented data, not to 6,000 independently selected original images. The exact augmented size depends on the selected age distribution.

### Expected dataset paths

| Resource | Path used in the notebook |
| --- | --- |
| Labeled metadata | `/content/wiki_labels.csv` |
| Training-image root | `wiki_labeled/wiki_labeled/` |
| Judge metadata | `/content/wiki_judge.csv` |
| Judge-image root | `wiki_judge_images/wiki_judge_images/` |

Image filenames are read from `full_path` and appended to the corresponding root. These are the paths in the executable code; some introductory notebook text uses different spellings.

## Models and training

| Approach | Architecture / objective | Main notebook training settings |
| --- | --- | --- |
| EfficientNetB0 transfer | Frozen ImageNet backbone; grayscale-to-RGB conversion and resize to 224 × 224; global pooling, dense layers, dropout and sigmoid age output | Huber loss, Adam `1e-4`, batch 32, up to 25 epochs |
| ResNet152 transfer | Frozen ImageNet backbone with the same head structure and ResNet preprocessing | Huber loss, Adam `1e-4`, batch 32, up to 15 epochs |
| MTL | Shared CNN and separate age, gender-label and face-score heads | MAE / binary cross-entropy / MAE; loss weights `2 / 0.5 / 1.5`; Adam `1e-4`, batch 32, up to 50 epochs after a short calibration run |
| SSL reconstruction | Compact DenseNet-like encoder with two dense blocks and a convolutional upsampling decoder | Reconstruction MSE, Adam `1e-3`, batch 64, up to 25 epochs |
| SSL age regression | Frozen pretrained encoder followed by convolutional and dense regression layers, L1 regularization and dropout | MAE, Adam `1e-3`, up to 40 epochs |

Transfer and supervised regression stages use early-stopping callbacks; some also reduce the learning rate on a plateau. The SSL encoder remains frozen during downstream regression, despite the notebook section being called “fine-tuning.”

These settings describe the current notebook. Some historical settings in the report differ, notably the autoencoder learning rate and epoch count.

### Ensemble

Each model's normalized age output is converted back to years with:

```python
age_years = age_normalized * (age_max - age_min) + age_min
```

The three estimates are then averaged with equal weights:

```python
age_ensemble = (age_transfer + age_ssl + age_mtl) / 3
```

The notebook examines residual correlations and prediction differences to assess complementarity. This is a three-model ensemble; both transfer backbones are explored, but they are not both included as separate ensemble members.

## Reported results

These values appear in the notebook's ensemble-evaluation output and Table 2 of the [report](report.pdf). They describe the project's labeled holdout, **not the Kaggle judge-set score**, and have not been recomputed for this README.

| Model | MAE ↓ (years) | MSE ↓ (years²) | RMSE ↓ (years) | R² ↑ |
| --- | ---: | ---: | ---: | ---: |
| Transfer | 9.622 | 146.485 | 12.103 | 0.234 |
| SSL | 10.038 | 171.657 | 13.102 | 0.102 |
| MTL | 9.887 | 165.664 | 12.871 | 0.133 |
| **Ensemble** | **8.872** | **127.994** | **11.313** | **0.330** |

The ensemble lowers MAE by approximately 7.8% and RMSE by approximately 6.5% relative to the reported transfer component. The results table calls that component “Transfer”; the generic `model_transfer.h5` filename alone does not identify its backbone.

## Running the project

### Google Colab

1. Open the notebook using the link above and select a GPU runtime for practical training times.
2. Install missing dependencies before the import section:

   ```python
   %pip install tensorflow keras numpy pandas matplotlib scipy scikit-learn pillow gdown h5py pydot huggingface_hub
   ```

3. Run the dataset-download cell. It downloads and extracts `dataset.zip` through the Google Drive link embedded in the notebook. If that download is unavailable, obtain the data from the competition page and extract it into the paths listed above.
4. Run preprocessing and augmentation before selecting the desired model-training sections. Set `number_of_train_images` before loading images if changing the experiment size.
5. Run evaluation, then the ensemble and optional submission-generation sections after all required models and normalization parameters are available.

`plot_model` additionally needs the Graphviz system executable. Its visualization cell can be skipped when Graphviz is unavailable. Internet access is required for dataset, checkpoint and ImageNet-weight downloads.

### Local Jupyter

```bash
git clone https://github.com/simonepedico/Personal_Projects.git
cd Personal_Projects/human_age_prediction
python -m venv .venv
source .venv/bin/activate
python -m pip install jupyterlab tensorflow keras numpy pandas matplotlib scipy scikit-learn pillow gdown h5py pydot huggingface_hub
jupyter lab code.ipynb
```

On Windows, activate with `.venv\Scripts\activate`. Replace `/content/...` and `/downloadedModels/` with writable local paths. Ensure archive extraction preserves the expected directory nesting. The notebook uses `root_mean_squared_error`; the installed scikit-learn must expose that function, or the corresponding calculation can use `np.sqrt(mean_squared_error(...))`.

The repository does not provide a tested dependency lock. GPU availability, memory requirements and runtime depend on the model and augmentation size. Several full image arrays and memory-mapped arrays are created during execution.

## Pretrained checkpoints

**Download:** [siiimo/human_age_prediction_weights](https://huggingface.co/datasets/siiimo/human_age_prediction_weights).

The hosted files have different formats and must not all be loaded in the same way:

| Exact path in the checkpoint repository | Intended use |
| --- | --- |
| `Transfer_Learning/efficientnet_new.weights.h5` | Rebuild the EfficientNet-based model from the notebook, then call `load_weights`. |
| `Transfer_Learning/resnet_new2.weights.h5` | Rebuild the ResNet-based model, then call `load_weights`. |
| `Multitasking_Learning/Copia di mtl.weights.h5` | Rebuild `multi_task_model`, then call `load_weights`. |
| `Self-Supervised_Learning/Copia di net_2.h5` | Saved SSL age-regression model; load with Keras `load_model`, subject to serialization compatibility. |

For example, **after defining the matching EfficientNet model** in its notebook section:

```python
from huggingface_hub import hf_hub_download

checkpoint = hf_hub_download(
    repo_id="siiimo/human_age_prediction_weights",
    repo_type="dataset",
    filename="Transfer_Learning/efficientnet_new.weights.h5",
)
net.load_weights(checkpoint)
```

`net` is reused by the ResNet section, so load each weights file immediately after defining its matching architecture. A weights-only file cannot be substituted for a complete model in `load_model`.

The notebook's ensemble section instead downloads full models from its [original Google Drive folder](https://drive.google.com/drive/folders/15182Kbzszn0ccX1W3kycflF2kZdpudlS?usp=drive_link), expecting:

- `/downloadedModels/EnsembleModel/model_transfer.h5`
- `/downloadedModels/EnsembleModel/model_ssl.h5`
- `/downloadedModels/EnsembleModel/model_mtl.h5`

To use the Hugging Face files instead, rebuild/load each appropriate model and assign it to the corresponding `model_transfer`, `model_ssl` and `model_mtl` variables. Skip the Google Drive loading cell. Do not merely rename weights-only files to these full-model filenames.

### Input and output contract

| Component | Input shape | Input values | Age output |
| --- | --- | --- | --- |
| Transfer | `(N, 100, 100, 1)` | Original pixel scale, approximately `[0, 255]`; model includes backbone preprocessing | Normalized scalar |
| SSL | `(N, 100, 100, 1)` | Float pixels in `[0, 1]` | Normalized scalar |
| MTL | `(N, 100, 100, 1)` | Float pixels in `[0, 1]` | First of three outputs; other outputs are gender-label and face-score predictions |

Inference also requires the **training-time `age_min` and `age_max`**. The notebook derives them from `y_train_aug`; they are not supplied as a separate metadata file alongside the listed checkpoints. Reproduce the matching data preparation or retain those exact values from training, rather than estimating them from inference images.

## Outputs and reproducibility notes

Outputs include learning curves, reconstruction examples, age-distribution plots, individual and ensemble regression metrics, residual correlations, and **`submission.csv`** with columns `ID` and `age` for the judge images. Some model-saving cells are commented out; training does not automatically export every checkpoint.

Relevant limitations of the current notebook:

- The judge-set transfer call uses normalized pixels, whereas transfer training and labeled-test evaluation use the original pixel scale. Align this call with the transfer input contract before generating a new submission.
- The SSL reconstruction stage uses the labeled test partition as validation data. A strictly untouched final test set would require a separate validation partition.
- Supervised `validation_split` is applied after augmentation, so related original and augmented images can enter different partitions. Split before augmentation for stricter validation.
- Checkpoint inference is not fully self-contained without the matching architecture, preprocessing and age-scaling bounds. Legacy HDF5 serialization may also depend on the TensorFlow/Keras environment.
- The data are noisy and imbalanced, the original training subset is small, and the report identifies weaker estimates at the younger and older ends of the age distribution.

## References

- [Project notebook](code.ipynb) and [full report](report.pdf), including architecture references
- [Competition and dataset](https://www.kaggle.com/competitions/age-prediction-spring-25-at-cu-denver)
- [Published checkpoints](https://huggingface.co/datasets/siiimo/human_age_prediction_weights)
