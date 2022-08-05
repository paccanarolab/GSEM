# Machine Learning Prediction of Drug Side effects in Clinical Trials

The code in the Matlab notebook contains an step-to-step example on how to run our algorithm, Geometric Self-Expressive Models (GSEM). Please start by opening the **driver.mlx** file, which is a Matlab notebook.

### Datasets

The datasets used in our study are provided together with the paper in a friendly readable format as tsv files. These are also in the folder *Supplementary Files*.

For easiness, we also provide a .mat file with all the datasets we used in our study in the folder /data/.

* **data_experiments.mat** contains the following Matlab files

  * *ATC*.  contains the associations between drugs and their ATC codes at each of the 4 levels of the ATC hiearchy. The columns are ordered according to ATC_labels.
  * *ATC_labels*. contains the ATC code at each of the 4 different levels of the ATC hiearchy.
  * *DChemMACCS*. contains the MACCS chemical fingerprint of each drug.
  * *DInd*. contains the drug-indication associations..
  * *DTarget*. contains the drug-target associations.
  * *MedDRA*. contains the associations between side effects and MedDRA terms at each of the 3 levels of the MedDRA hiearchy. The columns are ordered according to MedDRA_labels.
  * *MedDRA_labels*. contains the MedDRA terms at each of the levels of the MedDRA hierarchy.  
  * *Xct*. drug side effect matrix association that contains those identified in clinical trials.
  * *Xpost*. postmarketing side effect associations from SIDER 4.1
  * *Xoffs*. postmarketing drug side effect associations from OFFSIDES.
  * *reduced_SE_names*. contains the side effect names.
  * *reduced_drug_names*. contains the drug names.
* **graph_information.mat** contains the graph information for drugs and side effects.
  * *GDrugs*. contains in each element a drug-drug similarity matrix.
    1. Chemical similarity.
    2. Indication similarity.
    3. Target similarity.
    4. ATC taxonomy similarity.
  * *GSE*. contains in each element a side effect-side effect similarity matrix. {1} MedDRA taxonomy similarity. 

## References

If you find these resources useful, please cite our work: 

Galeano, Diego, and Alberto Paccanaro. "The Geometric Sparse Matrix Completion Model for Predicting Drug Side effects." bioRxiv (2019): 652412.
