# Project for Empirical Research Methods Class at CEU.

For my project I am going to replicate the paper "Can Information Reduce Ethnic Discrimination? Evidence from Airbnb." by Laouénan, Morgane, and Roland Rathelot (2022). My git repositary contains the following items.

**base_airbnb_AEJ.zip:** initial data set publised in the additional materials of the paper. Since the size of the dataset provided in the paper is larger than 25 MB, I upload it using Git Bash and Git LFS. The initial data set is available in zip format due to big size. Initial data set isn't a raw dataset, it is a dataset obtained after web scraping Airbnb data and cleaning. The authors don't provide raw data, only initial one. Thus, I only use only initial data set (thus, uploading but not changing anything in web scraping and cleaning codes). 

**Code folder:** code used to obtain final results of the paper separated in the several stages. 

Changes named in the code folder compared to the original source:

1) Code folder separarated in several subfolders for more meaningful organisations
2) Code file names are renamed: abbreviation deleted, names recreated to better depict the meaning of files.
3) Code separated into smaller do files
4) Directories in the code changed to match the one on my laptop, changed "/" in all directories for right formating.
5) Master do file reorganized with changes

**Makefile**: Makefile which integrates together data and 5 most important do files of main analysis. Supplementary code files are part of these 5 main files, so I don't include them in Make separately.

**Important!** Unfortunately, due to high calculations time, I wasn't able to execute most of the codes even after 3 days of running. Apparently, some of the files can take up to 20 days to execute and I only found it later. The same problem relates to Make file. I submit this way with changes made without testing whether it will actually work since I wasn't able to find a solution, at least it will be something. 

**Exhibits** - folder which was supposed to include results, but which is empty since I didn't get any


References:
1) Laouénan, Morgane, and Roland Rathelot. 2022. "Can Information Reduce Ethnic Discrimination? Evidence from Airbnb." American Economic Journal: Applied Economics, 14 (1): 107-32, https://doi.org/10.1257/app.20190188
2) Laouénan, Morgane, and Roland Rathelot. 2022. "Replication data for: Can Information Reduce Ethnic Discrimination? Evidence from Airbnb." American Economic Association [publisher], * Inter-university Consortium for Political and Social Research [distributor]*, https://doi.org/10.3886/E120078V1

