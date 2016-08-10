This toolbox implements the WQEISS/WMOSS/FQEISS feature selection techniques for classification problems presented in Karakaya et al. (2015).
 
This toolbox depends on the following contributions, which have to be donwloaded and appropriately referenced in the code. 
  
1) Hanchuan Peng's Mutual Information computation toolbox
  http://www.mathworks.com/matlabcentral/fileexchange/14888-mutual-information-computation

2)Yi Cao's Pareto-front toolbox
  http://www.mathworks.com/matlabcentral/fileexchange/17251-pareto-front
  
3) Song Lin's NGPM toolbox for NSGA-II (Deb et al., 2002) 
   http://in.mathworks.com/matlabcentral/fileexchange/31166-ngpm-a-nsga-ii-program-in-matlab-v1-4    

The scripts also support the Borg multi-objective algorithm, which was originally used for the experiments reported in Karakaya et al. (2015). 
Interested users who want to employ Borg instead of NSGA-II are referred to http://borgmoea.org for the MATLAB files required by this package.      

The NSGA-II version of the algorithms is illustrated in "script_example_NSGAII.m" for the "Heart" dataset of the UCI Repository (Lichman, 2013).
Users may refer to "script_example_BORG.m" for the equivalent version in Borg.



NOTE: Contrary to the experiments reported in Karakaya et al. (2015), this illustrative implementation features only one run for each algorithm on the chosen dataset. We suggest the user to run each algorithm several times, possibly using different randomizations of the employed dataset, in order to maximize the number of solutions  returned by the methods and better assess the accuracy of the trained models. An overall Pareto-front should then be constructed from all the solutions returned by  the multiple runs, making sure that the same value of accuracy is assigned to equal solutions (equal subsets) returned on different runs. This could be done by  averaging the accuracies across the runs. For a fair comparison of the results of the three algorithms, it is also important that the same (average) accuracy is assigned for the same solutions returned by the different techniques.


*** UPDATE 08/2016: the W-QEISS algorithm for regression problems is described in 
     
     Taormina, R., Galelli, S., Karakaya, G., Ahipasaoglu, S.D., 2016. An information theoretic approach to select alternate subsets of predictors for data-driven hydrological models. J. Hydro. doi:10.1016/j.jhydrol.2016.07.045. 
     
      See script_example_BORG__REGRESSION and script_example_NSGA__REGRESSION *** 



References:

Karakaya, G., Galelli, S., Ahipasaoglu, S.D., Taormina, R., 2015. 
Identifying (Quasi) Equally Informative Subsets in Feature Selection Problems for Classification: 
A Max-Relevance Min-Redundancy Approach. 
IEEE Trans. Cybern. doi:10.1109/TCYB.2015.2444435 
(available at http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7150365&tag=1)

Deb, K., Pratap, A., Agarwal, S., Meyarivan, T., 2002. 
A Fast and Elitist Multiobjective Genetic Algorithm. 
IEEE Trans. Evol. Comput. 6, 182–197. doi:10.1109/4235.996017

Hadka, D., Reed, P., 2012. 
Borg: An Auto-Adaptive Many-Objective Evolutionary Computing Framework. 
Evol. Comput. 21, 1–30. doi:10.1162/EVCO_a_00075

Lichman, M. (2013). UCI Machine Learning Repository [http://archive.ics.uci.edu/ml]. 
Irvine, CA: University of California, School of Information and Computer Science.



Copyright 2015 Riccardo Taormina (riccardo_taormina@sutd.edu.sg), Gulsah Karakaya (gulsahkilickarakaya@gmail.com;), Stefano Galelli (stefano_galelli@sutd.edu.sg), and Selin Damla Ahipasaoglu (ahipasaoglu@sutd.edu.sg;. 


This file is part of Matlab-Multi-objective-Feature-Selection.

    Matlab-Multi-objective-Feature-Selection is free software: you can redistribute 
    it and/or modify it under the terms of the GNU General Public License 
    as published by the Free Software Foundation, either version 3 of the 
    License, or (at your option) any later version.     

    This code is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with  Matlab-Multi-objective-Feature-Selection.  
    If not, see <http://www.gnu.org/licenses/>.

