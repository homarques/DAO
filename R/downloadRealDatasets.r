#Timeout to download each file
#If not complete after 7200s (2h), the download is aborted
options(timeout = 7200)
method = 'wget'
dir.create('datasets/real')
dir.create('datasets/real/raw')

#On the Evaluation of Unsupervised Outlier Detection: Measures, Datasets, and an Empirical Study
#by G. O. Campos, A. Zimek, J. Sander, R. J. G. B. Campello, B. Micenková, E. Schubert, I. Assent and M. E. Houle
download.file('https://www.dbs.ifi.lmu.de/research/outlier-evaluation/input/literature.tar.gz', destfile = 'datasets/real/raw/literature.tar.gz', method = method)
untar("datasets/real/raw/literature.tar.gz", exdir = 'datasets/real/raw/DAMI')
unlink("datasets/real/raw/literature.tar.gz")

download.file('https://www.dbs.ifi.lmu.de/research/outlier-evaluation/input/semantic.tar.gz', destfile = 'datasets/real/raw/semantic.tar.gz', method = method)
untar("datasets/real/raw/semantic.tar.gz", exdir = 'datasets/real/raw/DAMI')
unlink("datasets/real/raw/semantic.tar.gz")



#Internal Evaluation of Unsupervised Outlier Detection
#by H. O. Marques, R. J. G. B. Campello, J. Sander and A. Zimek
dir.create('datasets/real/raw/IREOS')
download.file('https://raw.githubusercontent.com/homarques/ireos-extension/master/data/Isolet', destfile = 'datasets/real/raw/IREOS/Isolet', method = method)
download.file('https://raw.githubusercontent.com/homarques/ireos-extension/master/data/MultipleFeature', destfile = 'datasets/real/raw/IREOS/MultipleFeature', method = method)
download.file('https://raw.githubusercontent.com/homarques/ireos-extension/master/data/OpticalDigits', destfile = 'datasets/real/raw/IREOS/OpticalDigits', method = method)
download.file('https://raw.githubusercontent.com/homarques/ireos-extension/master/data/Vowel', destfile = 'datasets/real/raw/IREOS/Vowel', method = method)



#A Comparative Evaluation of Unsupervised Anomaly Detection Algorithms for Multivariate Data 
#by M. Goldstein and S. Uchida
dir.create('datasets/real/raw/dataverse')
download.file('https://dataverse.harvard.edu/api/access/datafile/:persistentId?persistentId=doi:10.7910/DVN/OPQMVF/7VDJBV', destfile = 'datasets/real/raw/dataverse/aloi-unsupervised-ad.tab', method = method)
download.file('https://dataverse.harvard.edu/api/access/datafile/:persistentId?persistentId=doi:10.7910/DVN/OPQMVF/CJURKL', destfile = 'datasets/real/raw/dataverse/annthyroid-unsupervised-ad.tab', method = method)
download.file('https://dataverse.harvard.edu/api/access/datafile/:persistentId?persistentId=doi:10.7910/DVN/OPQMVF/MTUJ5F', destfile = 'datasets/real/raw/dataverse/breast-cancer-unsupervised-ad.tab', method = method)
download.file('https://dataverse.harvard.edu/api/access/datafile/:persistentId?persistentId=doi:10.7910/DVN/OPQMVF/GIPF3O', destfile = 'datasets/real/raw/dataverse/kdd99-unsupervised-ad.tab', method = method)
download.file('https://dataverse.harvard.edu/api/access/datafile/:persistentId?persistentId=doi:10.7910/DVN/OPQMVF/XF6JAS', destfile = 'datasets/real/raw/dataverse/letter-unsupervised-ad.tab', method = method)
download.file('https://dataverse.harvard.edu/api/access/datafile/:persistentId?persistentId=doi:10.7910/DVN/OPQMVF/KQYDN9', destfile = 'datasets/real/raw/dataverse/pen-global-unsupervised-ad.tab', method = method)
download.file('https://dataverse.harvard.edu/api/access/datafile/:persistentId?persistentId=doi:10.7910/DVN/OPQMVF/CPRXQX', destfile = 'datasets/real/raw/dataverse/pen-local-unsupervised-ad.tab', method = method)
download.file('https://dataverse.harvard.edu/api/access/datafile/:persistentId?persistentId=doi:10.7910/DVN/OPQMVF/UNGQHH', destfile = 'datasets/real/raw/dataverse/satellite-unsupervised-ad.tab', method = method)
download.file('https://dataverse.harvard.edu/api/access/datafile/:persistentId?persistentId=doi:10.7910/DVN/OPQMVF/VW8RDW', destfile = 'datasets/real/raw/dataverse/shuttle-unsupervised-ad.tab', method = method)
download.file('https://dataverse.harvard.edu/api/access/datafile/:persistentId?persistentId=doi:10.7910/DVN/OPQMVF/V62OCZ', destfile = 'datasets/real/raw/dataverse/speech-unsupervised-ad.tab', method = method)



#ODDS Library
#by S. Rayana
dir.create('datasets/real/raw/ODDS')
download.file('https://www.dropbox.com/s/ag469ssk0lmctco/lympho.mat?dl=1', destfile = 'datasets/real/raw/ODDS/lympho.mat', method = method)
download.file('https://www.dropbox.com/s/ebz9v9kdnvykzcb/wbc.mat?dl=1', destfile = 'datasets/real/raw/ODDS/wbc.mat', method = method)
download.file('https://www.dropbox.com/s/iq3hjxw77gpbl7u/glass.mat?dl=1', destfile = 'datasets/real/raw/ODDS/glass.mat', method = method)
download.file('https://www.dropbox.com/s/pa26odoq6atq9vx/vowels.mat?dl=1', destfile = 'datasets/real/raw/ODDS/vowels.mat', method = method)
download.file('https://www.dropbox.com/s/galg3ihvxklf0qi/cardio.mat?dl=1', destfile = 'datasets/real/raw/ODDS/cardio.mat', method = method)
download.file('https://www.dropbox.com/s/hckgvu9m6fs441p/satimage-2.mat?dl=1', destfile = 'datasets/real/raw/ODDS/satimage-2.mat', method = method)
download.file('https://www.dropbox.com/s/we6aqhb0m38i60t/musk.mat?dl=1', destfile = 'datasets/real/raw/ODDS/musk.mat', method = method)
download.file('https://www.dropbox.com/s/bih0e15a0fukftb/thyroid.mat?dl=1', destfile = 'datasets/real/raw/ODDS/thyroid.mat', method = method)
download.file('https://www.dropbox.com/s/rt9i95h9jywrtiy/letter.mat?dl=1', destfile = 'datasets/real/raw/ODDS/letter.mat', method = method)
download.file('https://www.dropbox.com/s/mvlwu7p0nyk2a2r/pima.mat?dl=1', destfile = 'datasets/real/raw/ODDS/pima.mat', method = method)
download.file('https://www.dropbox.com/s/dpzxp8jyr9h93k5/satellite.mat?dl=1', destfile = 'datasets/real/raw/ODDS/satellite.mat', method = method)
download.file('https://www.dropbox.com/s/mk8ozgisimfn3dw/shuttle.mat?dl=1', destfile = 'datasets/real/raw/ODDS/shuttle.mat', method = method)
download.file('https://www.dropbox.com/s/g3hlnucj71kfvq4/breastw.mat?dl=1', destfile = 'datasets/real/raw/ODDS/breastw.mat', method = method)
download.file('https://www.dropbox.com/s/lpn4z73fico4uup/ionosphere.mat?dl=1', destfile = 'datasets/real/raw/ODDS/ionosphere.mat', method = method)
download.file('https://www.dropbox.com/s/lmlwuspn1sey48r/arrhythmia.mat?dl=1', destfile = 'datasets/real/raw/ODDS/arrhythmia.mat', method = method)
download.file('https://www.dropbox.com/s/n3wurjt8v9qi6nc/mnist.mat?dl=1', destfile = 'datasets/real/raw/ODDS/mnist.mat', method = method)
download.file('https://www.dropbox.com/s/w52ndgz5k75s514/optdigits.mat?dl=1', destfile = 'datasets/real/raw/ODDS/optdigits.mat', method = method)
download.file('https://www.dropbox.com/s/iy9ucsifal754tp/http.mat?dl=1', destfile = 'datasets/real/raw/ODDS/http.mat', method = 'wget')
download.file('https://www.dropbox.com/s/awx8iuzbu8dkxf1/cover.mat?dl=1', destfile = 'datasets/real/raw/ODDS/cover.mat', method = method)
download.file('https://www.dropbox.com/s/dbv2u4830xri7og/smtp.mat?dl=1', destfile = 'datasets/real/raw/ODDS/smtp.mat', method = method)
download.file('https://www.dropbox.com/s/tq2v4hhwyv17hlk/mammography.mat?dl=1', destfile = 'datasets/real/raw/ODDS/mammography.mat', method = method)
download.file('https://www.dropbox.com/s/aifk51owxbogwav/annthyroid.mat?dl=1', destfile = 'datasets/real/raw/ODDS/annthyroid.mat', method = method)
download.file('https://www.dropbox.com/s/1x8rzb4a0lia6t1/pendigits.mat?dl=1', destfile = 'datasets/real/raw/ODDS/pendigits.mat', method = method)
download.file('https://www.dropbox.com/s/uvjaudt2uto7zal/wine.mat?dl=1', destfile = 'datasets/real/raw/ODDS/wine.mat', method = method)
download.file('https://www.dropbox.com/s/5kuqb387sgvwmrb/vertebral.mat?dl=1', destfile = 'datasets/real/raw/ODDS/vertebral.mat', method = method)



#A Meta-Analysis of the Anomaly Detection Problem 
#by A. Emmott, S. Das, T. Dietterich, A. Fern and W.-K. Wong
download.file('https://ir.library.oregonstate.edu/downloads/1g05fh87w', destfile = 'datasets/real/raw/pageb_benchmarks.zip', method = method)
untar("datasets/real/raw/pageb_benchmarks.zip", exdir = 'datasets/real/raw/META')
unlink("datasets/real/raw/pageb_benchmarks.zip")
file.copy('datasets/real/raw/META/pageb/meta_data/pageb.preproc.csv', 'datasets/real/raw/META')
unlink("datasets/real/raw/META/pageb", recursive = TRUE)

download.file('https://ir.library.oregonstate.edu/downloads/0r967898h', destfile = 'datasets/real/raw/opt.digits_benchmarks.zip', method = method)
untar("datasets/real/raw/opt.digits_benchmarks.zip", exdir = 'datasets/real/raw/META')
unlink("datasets/real/raw/opt.digits_benchmarks.zip")
file.copy('datasets/real/raw/META/opt.digits/meta_data/opt.digits.preproc.csv', 'datasets/real/raw/META')
unlink("datasets/real/raw/META/opt.digits", recursive = TRUE)

download.file('https://ir.library.oregonstate.edu/downloads/1r66j630q', destfile = 'datasets/real/raw/synthetic_benchmarks.zip', method = method)
untar("datasets/real/raw/synthetic_benchmarks.zip", exdir = 'datasets/real/raw/META')
unlink("datasets/real/raw/synthetic_benchmarks.zip")
file.copy('datasets/real/raw/META/synthetic/meta_data/synthetic.preproc.csv', 'datasets/real/raw/META')
unlink("datasets/real/raw/META/synthetic", recursive = TRUE)

download.file('https://ir.library.oregonstate.edu/downloads/zw12zb329', destfile = 'datasets/real/raw/spambase_benchmarks.zip', method = method)
untar("datasets/real/raw/spambase_benchmarks.zip", exdir = 'datasets/real/raw/META')
unlink("datasets/real/raw/spambase_benchmarks.zip")
file.copy('datasets/real/raw/META/spambase/meta_data/spambase.preproc.csv', 'datasets/real/raw/META')
unlink("datasets/real/raw/META/spambase", recursive = TRUE)

download.file('https://ir.library.oregonstate.edu/downloads/sq87c051d', destfile = 'datasets/real/raw/skin_benchmarks.zip', method = method)
untar("datasets/real/raw/skin_benchmarks.zip", exdir = 'datasets/real/raw/META')
unlink("datasets/real/raw/skin_benchmarks.zip")
file.copy('datasets/real/raw/META/skin/meta_data/skin.preproc.csv', 'datasets/real/raw/META')
unlink("datasets/real/raw/META/skin", recursive = TRUE)

download.file('https://ir.library.oregonstate.edu/downloads/8p58pk46v', destfile = 'datasets/real/raw/abalone_benchmarks.zip', method = method)
untar("datasets/real/raw/abalone_benchmarks.zip", exdir = 'datasets/real/raw/META')
unlink("datasets/real/raw/abalone_benchmarks.zip")
file.copy('datasets/real/raw/META/abalone/meta_data/abalone.preproc.csv', 'datasets/real/raw/META')
unlink("datasets/real/raw/META/abalone", recursive = TRUE)

download.file('https://ir.library.oregonstate.edu/downloads/jh343z59f', destfile = 'datasets/real/raw/wave_benchmarks.zip', method = method)
untar("datasets/real/raw/wave_benchmarks.zip", exdir = 'datasets/real/raw/META')
unlink("datasets/real/raw/wave_benchmarks.zip")
file.copy('datasets/real/raw/META/wave/meta_data/wave.preproc.csv', 'datasets/real/raw/META')
unlink("datasets/real/raw/META/wave", recursive = TRUE)

download.file('https://ir.library.oregonstate.edu/downloads/9p290g47x', destfile = 'datasets/real/raw/wine_benchmarks.zip', method = method)
untar("datasets/real/raw/wine_benchmarks.zip", exdir = 'datasets/real/raw/META')
unlink("datasets/real/raw/wine_benchmarks.zip")
file.copy('datasets/real/raw/META/wine/meta_data/wine.preproc.csv', 'datasets/real/raw/META')
unlink("datasets/real/raw/META/wine", recursive = TRUE)

download.file('https://ir.library.oregonstate.edu/downloads/gm80j165b', destfile = 'datasets/real/raw/shuttle_benchmarks.zip', method = method)
untar("datasets/real/raw/shuttle_benchmarks.zip", exdir = 'datasets/real/raw/META')
unlink("datasets/real/raw/shuttle_benchmarks.zip")
file.copy('datasets/real/raw/META/shuttle/meta_data/shuttle.preproc.csv', 'datasets/real/raw/META')
unlink("datasets/real/raw/META/shuttle", recursive = TRUE)

download.file('https://ir.library.oregonstate.edu/downloads/n009w715f', destfile = 'datasets/real/raw/imgseg_benchmarks.zip', method = method)
untar("datasets/real/raw/imgseg_benchmarks.zip", exdir = 'datasets/real/raw/META')
unlink("datasets/real/raw/imgseg_benchmarks.zip")
file.copy('datasets/real/raw/META/imgseg/meta_data/imgseg.preproc.csv', 'datasets/real/raw/META')
unlink("datasets/real/raw/META/imgseg", recursive = TRUE)

download.file('https://ir.library.oregonstate.edu/downloads/7h149v981', destfile = 'datasets/real/raw/letter.rec_benchmarks.zip', method = method)
untar("datasets/real/raw/letter.rec_benchmarks.zip", exdir = 'datasets/real/raw/META')
unlink("datasets/real/raw/letter.rec_benchmarks.zip")
file.copy('datasets/real/raw/META/letter.rec/meta_data/letter.rec.preproc.csv', 'datasets/real/raw/META')
unlink("datasets/real/raw/META/letter.rec", recursive = TRUE)

download.file('https://ir.library.oregonstate.edu/downloads/z890s0657', destfile = 'datasets/real/raw/yeast_benchmarks.zip', method = method)
untar("datasets/real/raw/yeast_benchmarks.zip", exdir = 'datasets/real/raw/META')
unlink("datasets/real/raw/yeast_benchmarks.zip")
file.copy('datasets/real/raw/META/yeast/meta_data/yeast.preproc.csv', 'datasets/real/raw/META')
unlink("datasets/real/raw/META/yeast", recursive = TRUE)

download.file('https://ir.library.oregonstate.edu/downloads/rr1723408', destfile = 'datasets/real/raw/concrete_benchmarks.zip', method = method)
untar("datasets/real/raw/concrete_benchmarks.zip", exdir = 'datasets/real/raw/META')
unlink("datasets/real/raw/concrete_benchmarks.zip")
file.copy('datasets/real/raw/META/concrete/meta_data/concrete.preproc.csv', 'datasets/real/raw/META')
unlink("datasets/real/raw/META/concrete", recursive = TRUE)

download.file('https://ir.library.oregonstate.edu/downloads/p26771366', destfile = 'datasets/real/raw/fault_benchmarks.zip', method = method)
untar("datasets/real/raw/fault_benchmarks.zip", exdir = 'datasets/real/raw/META')
unlink("datasets/real/raw/fault_benchmarks.zip")
file.copy('datasets/real/raw/META/fault/meta_data/fault.preproc.csv', 'datasets/real/raw/META')
unlink("datasets/real/raw/META/fault", recursive = TRUE)

download.file('https://ir.library.oregonstate.edu/downloads/d504rr59b', destfile = 'datasets/real/raw/comm.and.crime_benchmarks.zip', method = method)
untar("datasets/real/raw/comm.and.crime_benchmarks.zip", exdir = 'datasets/real/raw/META')
unlink("datasets/real/raw/comm.and.crime_benchmarks.zip")
file.copy('datasets/real/raw/META/comm.and.crime/meta_data/comm.and.crime.preproc.csv', 'datasets/real/raw/META')
unlink("datasets/real/raw/META/comm.and.crime", recursive = TRUE)

download.file('https://ir.library.oregonstate.edu/downloads/3b591f67s', destfile = 'datasets/real/raw/magic.gamma_benchmarks.zip', method = method)
untar("datasets/real/raw/magic.gamma_benchmarks.zip", exdir = 'datasets/real/raw/META')
unlink("datasets/real/raw/magic.gamma_benchmarks.zip")
file.copy('datasets/real/raw/META/magic.gamma/meta_data/magic.gamma.preproc.csv', 'datasets/real/raw/META')
unlink("datasets/real/raw/META/magic.gamma", recursive = TRUE)

download.file('https://ir.library.oregonstate.edu/downloads/2n49t708t', destfile = 'datasets/real/raw/gas_meta_and_benchmarks_1_to_400.zip', method = method)
untar("datasets/real/raw/gas_meta_and_benchmarks_1_to_400.zip", exdir = 'datasets/real/raw/META')
unlink("datasets/real/raw/gas_meta_and_benchmarks_1_to_400.zip")
file.copy('datasets/real/raw/META/gas/meta_data/gas.preproc.csv', 'datasets/real/raw/META')
unlink("datasets/real/raw/META/gas", recursive = TRUE)

download.file('https://ir.library.oregonstate.edu/downloads/qz20sz599', destfile = 'datasets/real/raw/landsat_benchmarks.zip', method = method)
untar("datasets/real/raw/landsat_benchmarks.zip", exdir = 'datasets/real/raw/META')
unlink("datasets/real/raw/landsat_benchmarks.zip")
file.copy('datasets/real/raw/META/landsat/meta_data/landsat.preproc.csv', 'datasets/real/raw/META')
unlink("datasets/real/raw/META/landsat", recursive = TRUE)

download.file('https://ir.library.oregonstate.edu/downloads/pr76f856h', destfile = 'datasets/real/raw/yearp_meta_and_benchmarks_1_to_400.zip', method = method)
untar("datasets/real/raw/yearp_meta_and_benchmarks_1_to_400.zip", exdir = 'datasets/real/raw/META')
unlink("datasets/real/raw/yearp_meta_and_benchmarks_1_to_400.zip")
file.copy('datasets/real/raw/META/yearp/meta_data/yearp.preproc.csv', 'datasets/real/raw/META')
unlink("datasets/real/raw/META/yearp", recursive = TRUE)

download.file('https://ir.library.oregonstate.edu/downloads/m326m700d', destfile = 'datasets/real/raw/particle_benchmarks.zip', method = method)
untar("datasets/real/raw/particle_benchmarks.zip", exdir = 'datasets/real/raw/META')
unlink("datasets/real/raw/particle_benchmarks.zip")
file.copy('datasets/real/raw/META/particle/meta_data/particle.preproc.csv', 'datasets/real/raw/META')
unlink("datasets/real/raw/META/particle", recursive = TRUE)



#On Normalization and Algorithm Selection for Unsupervised Outlier Detection
#by S. Kandanaarachchi, M. A. Muñoz, R. J. Hyndman and K. Smith-Miles
download.file('https://figshare.com/ndownloader/files/14338235', destfile = 'datasets/real/raw/Datasets_12338.zip', method = method)
untar("datasets/real/raw/Datasets_12338.zip", exdir = 'datasets/real/raw/')
unlink("datasets/real/raw/Datasets_12338.zip")
file.rename('datasets/real/raw/Datasets_12338/', 'datasets/real/raw/Monash')
