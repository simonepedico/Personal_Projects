# TG3E: Temporally and Geographically Expanded Efficient Entity-Aware Retrieval-Augmented Generation

**Historical IR: a retrieval system for 19th-century newspapers.**

Authors: Simone Pedico, Valentyn Piskovskyi.

[Notebook](TG3E.ipynb) · [Full report](TG3E.pdf) · [Evaluation results](results_all.csv) · [Open in Colab](https://colab.research.google.com/github/simonepedico/Personal_Projects/blob/main/TG3E/TG3E.ipynb)

## Overview

This project compares information-retrieval configurations using precision, recall, mean average precision and normalized discounted cumulative gain.

The exported results cover four ranking models (TF-IDF, BM25, PL2 and DLH13) and four additional DLH13 configurations. The notebook contains the implementation, while the report provides the experimental context.

## Project contents

| File | Purpose |
| --- | --- |
| `TG3E.ipynb` | Implementation and retrieval experiments. |
| `TG3E.pdf` | Project description, methodology and discussion. |
| `results_all.csv` | Exported evaluation metrics for eight configurations. |

## Evaluated configurations

The result file uses the following experiment identifiers:

- `TF_IDF`
- `BM25`
- `PL2`
- `DLH13`
- `DLH13_tc`
- `DLH13_lem`
- `DLH13_te_geo`
- `DLH13_ne`

The suffixes are retained exactly as exported. Refer to the notebook and report for their definitions and preprocessing settings.

## Recorded results

The following values are rounded from `results_all.csv`; they are existing experimental results, not newly reproduced measurements.

| Configuration | MAP ↑ | P@1 ↑ | R@10 ↑ | nDCG@10 ↑ |
| --- | ---: | ---: | ---: | ---: |
| TF_IDF | 0.7084 | 0.6353 | 0.8404 | 0.7368 |
| BM25 | 0.7083 | 0.6344 | 0.8404 | 0.7367 |
| PL2 | 0.6648 | 0.5849 | 0.8100 | 0.6959 |
| DLH13 | 0.7194 | 0.6480 | 0.8492 | 0.7477 |
| DLH13_tc | 0.5925 | 0.5126 | 0.7429 | 0.6241 |
| DLH13_lem | 0.7081 | 0.6357 | 0.8411 | 0.7370 |
| DLH13_te_geo | 0.7157 | 0.6443 | 0.8479 | 0.7445 |
| **DLH13_ne** | **0.7263** | **0.6560** | **0.8514** | **0.7535** |

Among the exported configurations, `DLH13_ne` achieves the highest values for all metrics included in the CSV. Its MAP is approximately 0.96% higher than baseline DLH13.

These comparisons describe the recorded experiment; the CSV alone does not establish statistical significance or generalization to other collections.

## Evaluation metrics

| Metric | Meaning |
| --- | --- |
| MAP | Mean average precision across evaluated queries. |
| P@1, P@5, P@10 | Precision at the specified retrieval cutoff. |
| R@5, R@10 | Recall at the specified retrieval cutoff. |
| nDCG@5, nDCG@10 | Normalized discounted cumulative gain at the specified cutoff. |

Higher values indicate better performance under the corresponding evaluation measure.

## Exploring the project

1. Read the report for the retrieval task and experimental setup.
2. Open the notebook in Jupyter or Google Colab.
3. Check its setup, external-resource and path requirements before executing the experiments.
4. Use `results_all.csv` to inspect the recorded evaluation without rerunning retrieval.

This directory does not contain separate corpus, index or relevance-judgment files. Any external resources required by the notebook must be obtained through its documented setup.

## References

- [Project notebook](TG3E.ipynb)
- [Full report](TG3E.pdf)
- [Complete evaluation table](results_all.csv)
