#  Dimensionality-Aware Outlier Detection (DAO)

Repository of the paper:
```latex
Dimensionality-Aware Outlier Detection
Submitted to ICDM 2023
```

In this paper, we present a nonparametric method for outlier detection that takes full account of local variations in intrinsic dimensionality within the dataset. Using the theory of Local Intrinsic Dimensionality (LID), our 'dimensionality-aware' outlier detection method, DAO, is derived as an estimator of an asymptotic local expected density ratio involving the query point and a close neighbor drawn at random. The dimensionality-aware behavior of DAO is due to its use of local estimation of LID values in a theoretically-justified way.

Through comprehensive experimentation on more than 800 synthetic and real datasets, we show that DAO significantly outperforms three popular and important benchmark outlier detection methods: Local Outlier Factor (LOF), Simplified LOF, and kNN.


Detailed numbers for all experiments are given in tables in the [Supplementary Material](https://homarques.github.io/DAO/files/DAO_Supplementary.pdf)

## Setup

```sh
git clone https://github.com/homarques/DAO.git
cd DAO
pip install -r requirements.txt
```
#### Downloading real datasets

```sh
Rscript R/downloadRealDatasets.r
Rscript R/preprocessing.r
```

#### Summary of real datasets

```sh
Rscript R/compileResults.r 'summaryRealDatasets'
```
<p align="center"><img width="500" alt="summaryRealDatasets" src="https://github.com/homarques/DAO/assets/1656782/27c32a23-33a5-4d71-ab0b-8187048e511f"></p>

## Experimental Results

### Evaluation of DAO Using Different LID Estimators
```sh
python run_synthetic.py
Rscript R/compileResults.r 'summaryResultsSyntheticDatasets'
```
![synthetic](https://github.com/homarques/DAO/assets/1656782/6556e00e-ce89-4085-9908-35507438763f)
Fig. 1. ROC AUC values for outlier detection performance over 480 synthetic datasets containing 2 clusters. One of the clusters ($c_1$) has intrinsic dimension fixed at 8. The intrinsic dimension of the other cluster ($c_2$) varies across the datasets ($x$-axis). The dashed vertical line indicates the reference set where both clusters lie on manifolds with the same intrinsic dimension (8). The results shown are averages over 30 datasets with the same characteristics. Bars indicate standard deviation.

### Comparative Evaluation on Synthetic Datasets
```sh
Rscript R/compileResults.r 'lrSyntheticDatasets'
```
<p align="center"><img width="500" alt="Screenshot 2023-06-26 at 13 29 20" src="https://github.com/homarques/DAO/assets/1656782/1383c1a7-2955-48b7-9fad-d058fe135c2f"></p>

### Runtime Performance and Computational Complexity
```sh
python runtime.py
Rscript R/compileResults.r 'printRuntime'
```
<p align="center"><img width="275" alt="runtime" src="https://github.com/homarques/DAO/assets/1656782/34b79181-f464-4ff9-827c-089ae7d07614"></p>

### Comparative Evaluation on Real Datasets

```sh
python run_real.py
python stats.py
```

#### Simple linear regression
```sh
Rscript R/compileResults.r 'lrRealDatasets'

#### Simple linear regression
```sh
Rscript R/compileResults.r 'lrRealDatasets'
```
<p align="center"><img width="500" alt="Screenshot 2023-06-26 at 13 53 53" src="https://github.com/homarques/DAO/assets/1656782/0c48065c-7bcb-42a5-8cca-d7d0bf6ac19d"></p>
