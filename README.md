# Personal Projects

**A collection of personal and academic projects, experiments and thesis work.**

This repository brings together projects developed throughout my studies in Computer Science at the University of Milano-Bicocca. Topics include machine learning, computer vision, information retrieval, causal inference and digital design, alongside my bachelor's and master's theses in geometry processing and 3D reconstruction.

Each project is organized in a separate directory containing its available notebooks, source code, reports and supporting results.

## Repository organization

| Directory | Topic | Available material |
| --- | --- | --- |
| [TG3E](TG3E/) | Information retrieval and ranking experiments | Notebook, report and evaluation results |
| [human_age_prediction](human_age_prediction/) | Age estimation from facial images | Python notebook and report |
| [fetal_health_prediction](fetal_health_prediction/) | Fetal-health classification from cardiotocography measurements | Python notebook and report |
| [moving_average_filter](moving_average_filter/) | Digital moving-average filter | VHDL source code, testbenches and report |
| [Causal_effect_of_canopy_management](Causal_effect_of_canopy_management/) | Causal inference on Sangiovese grapevine management | Python notebook and report |
| [bachelor_thesis](bachelor_thesis/) | Increasing the challenge of shape correspondence tasks via a non connectivity-preserving remeshing | Thesis PDF |
| [master_thesis](master_thesis/) | Exploring the Impact of Introducing Geometric Information for Mesh Generation from Single View | Thesis PDF |

## Projects

### TG3E

An information-retrieval project comparing TF-IDF, BM25, PL2 and DLH13, together with additional DLH13 configurations. The repository includes a notebook, a report and a CSV containing ranking metrics.

[Explore the project](TG3E/)

### Human Age Prediction

Age regression from facial images using transfer learning, multi-task learning and self-supervised learning. The project also evaluates an ensemble combining predictions from the three approaches.

[Explore the project](human_age_prediction/)


### Fetal Health Prediction

A comparison of feed-forward neural networks and interpretable decision trees for classifying fetal health from cardiotocography features. Experiments investigate class imbalance, PCA and model complexity.

[Explore the project](fetal_health_prediction/)

### Moving Average Filter

A VHDL implementation of a moving-average filter built from a FIFO, arithmetic logic, an accumulator and a division stage. Component testbenches and a file-driven filter testbench accompany the design.

[Explore the project](moving_average_filter/)

### Causal Effects of Canopy Management

A structural causal model for investigating how canopy-management treatments affect Sangiovese grapes. The notebook implements regression-based g-computation and six queries concerning total, direct and mediated effects.

[Explore the project](Causal_effect_of_canopy_management/)

## Theses

### Bachelor's thesis — Shape correspondence and remeshing

An investigation of shape correspondence when remeshing changes mesh connectivity, with the aim of making correspondence evaluation more challenging.

[Read the thesis](bachelor_thesis/tosca_remesh_thesis.pdf)

### Master's thesis — Single-image human mesh generation

An investigation of geometric information, particularly depth and normal maps, for generating 3D human meshes from a single image.

[Read the thesis](master_thesis/mesh_generation_thesis.pdf)

## Getting started

Start with the README in the project directory, then consult its report for the methodology and experimental discussion.

- **Notebook projects:** open the `.ipynb` file in Jupyter or Google Colab and follow the project-specific setup instructions.
- **VHDL project:** inspect the design sources and testbenches before configuring a simulation.
- **Theses:** open the linked PDFs directly.

Projects are independent and do not share a single installation procedure. Datasets, model weights and simulation inputs may require separate downloads or preparation; consult each project's documentation.

## Author(s)

[Simone Pedico](https://github.com/simonepedico)

Some projects were developed with [Davide Piatti](https://github.com/davidepiatti) and [Valentyn Piskovskyi](https://github.com/piskovskyi). Each project's README lists its authors and collaborators.

## Acknowledgements

Special thanks to Davide Piatti, Valentyn Piskovskyi, Simone Melzi, Filippo Maggioli and Alessandro Riva for their contributions and support across the projects collected here.
