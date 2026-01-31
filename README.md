# tomtec
Matlab code for analysing Tomtec STE data. **NB Work in progress.**
## File contents
### README.md 
- this file
### /data
- data folder containing anonymised Tomtec data files for test purposes.
### Read_tomtec.m
- script to read tomtec files (this replaces Read_AutoStrain.m and Read4D_5.m). **NB this has a setting pointing to a start directory which is specific to my PC and needs to be edited to work on other PCs.**
### ImportInfo.m
- function to read header data - required for Read_tomtec.m
### importCurvesFromTxt.m
- function to read curve data - required for Read_tomtec.m
### seg_corr.m
- script to calcuate segment correlations and display them graphically
### seg_corr_metrics.m
- script to calcuate segment correlation metrics
### seg_coupling_2.m
LV Segment Coupling Analysis (TomTec 18-Segment Model) - plots strain-rate, network, and computes synchrony metric. 
(Collects the 18 TomTec segments, Plots strain-rate waveforms with color + line style, Computes the correlation matrix, Builds a thresholded network graph, Colors nodes by Basal / Mid / Apical, 
Computes quantitative synchrony indices and network statistics, Displays tables for node-level and global metrics)
NB Replaces seg_coupling.m, seg_net_metrics.m and seg_plot.m which are retained for now in case they prove useful or I find a bug in seg_coupling_2.m.
### LV_EnsembleAnalysis.m
A single function for ensemble averaging. Includes: Global average, Anatomical averaging (Basal/Mid/Apical) Network-based weighting, Dimensionality reduction via PCA, Mechanical dispersion, Synchrony indices (MeanCorr, GSI).
**Outputs**
Basal, Mid, Apical -	Regional mean waveforms
Global	- Mean of all 18 segments
NetWeighted	Waveform  - weighted by degree centrality in correlation network
PC1	- First principal component of segment data
MD	- Mechanical dispersion (SD of time-to-peak across segments)
MeanCorr	- Average inter-segment correlation
GSI	- Fraction of edges above threshold
degree	- Node degree per segment
betweenness -	Betweenness centrality per segment
R	- Full correlation matrix
### example_ensemble1.m
- how to use LV_EnsembleAnalysis.m

*last updated by ADH 31/01/2026*



