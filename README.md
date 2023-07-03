#  Dimensionality-Aware Outlier Detection (DAO)

Repository of the paper:
```latex
Dimensionality-Aware Outlier Detection
Submitted to ICDM 2023
```

In this paper, we present a nonparametric method for outlier detection that takes full account of local variations in intrinsic dimensionality within the dataset. Using the theory of Local Intrinsic Dimensionality (LID), our 'dimensionality-aware' outlier detection method, DAO, is derived as an estimator of an asymptotic local expected density ratio involving the query point and a close neighbor drawn at random. The dimensionality-aware behavior of DAO is due to its use of local estimation of LID values in a theoretically-justified way.

Through comprehensive experimentation on more than 800 synthetic and real datasets, we show that DAO significantly outperforms three popular and important benchmark outlier detection methods: Local Outlier Factor (LOF), Simplified LOF, and kNN.


Detailed numbers for all experiments are given in tables in the [Supplementary Material](https://anonymous.4open.science/r/DAO-984F/files/DAO_Supplementary.pdf)

------

## Repository setup
<!--- git clone https://github.com/homarques/DAO.git
cd DAO --->

```sh
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
<p align="center"><img src="https://anonymous.4open.science/r/DAO-984F/files/tab1.png" width="50%" height="50%"></p>


## Experimental Results

### Evaluation of LID Estimation on DAO Performance
```sh
python run_synthetic.py
Rscript R/compileResults.r 'summaryResultsSyntheticDatasets'
```
<p align="center"><img src="https://anonymous.4open.science/r/DAO-984F/files/synthetic.png" width="90%" height="90%"></p>
Fig. 1. ROC AUC values for outlier detection performance over 480 synthetic datasets containing 2 clusters. One of the clusters (c<sub>1</sub>) has intrinsic dimension fixed at 8. The intrinsic dimension of the other cluster (c<sub>2</sub>) varies across the datasets (x-axis). The dashed vertical line indicates the reference set where both clusters lie on manifolds with the same intrinsic dimension (8). The results shown are averages over 30 datasets with the same characteristics. Bars indicate standard deviation.

### Comparative Evaluation on Synthetic Datasets
```sh
Rscript R/compileResults.r 'lrSyntheticDatasets'
```
<p align="center"><img src="https://anonymous.4open.science/r/DAO-984F/files/tab2.png" width="50%" height="50%"></p>


### Comparative Evaluation on Real Datasets

```sh
python run_real.py
python stats.py
```

#### Simple linear regression

```sh
Rscript R/compileResults.r 'lrRealDatasets'
```
<p align="center"><img src="https://anonymous.4open.science/r/DAO-984F/files/tab3.png" width="50%" height="50%"></p>

#### Visualizing Outlier Detection Performance
```sh
Rscript R/compileResults.r 'plot_R_MoransI'
```
<p align="center">
  <img src="https://anonymous.4open.science/r/DAO-984F/files/slof.png" width="45%" height="45%">
  <img src="https://anonymous.4open.science/r/DAO-984F/files/lof.png" width="45%" height="45%">
</p>
<p align="center"><img src="https://anonymous.4open.science/r/DAO-984F/files/knn.png" width="45%" height="45%">
  <img src="https://anonymous.4open.science/r/DAO-984F/files/oracle.png" width="45%" height="45%">
</p>
Fig. 2. Differences in ROC AUC performance between DAO<sub>MLE</sub> and the dimensionality-unaware methods over 393 real datasets. Blue dots indicate datasets where DAO outperforms its competitor, whereas red dots indicate the opposite. The 'Oracle' method indicates the best-performing competitor for each individual dataset. Color intensity is proportional to the ROC AUC difference. On the x- and y-axis we show the Moran's I autocorrelation and dispersion R of log-LID estimates, respectively.

#### Critical Distance Diagram

```sh
Rscript R/compileResults.r 'plotCDRealDatasets'
```
<p align="center"><img src="https://anonymous.4open.science/r/DAO-984F/files/plotCD.png" width="50%" height="50%"></p>
Fig. 3. Critical difference diagram (significance level α = 1e-16) of average ranks of the methods on 393 real datasets: DAO<sub>MLE</sub> vs. baseline competitors.

### Runtime Performance and Computational Complexity
```sh
python runtime.py
Rscript R/compileResults.r 'printRuntime'
```
<p align="center"><img src="https://anonymous.4open.science/r/DAO-984F/files/runtime.png" width="27%" height="27%"></p>

