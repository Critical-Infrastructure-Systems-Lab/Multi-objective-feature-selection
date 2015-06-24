This toolbox implements the WQEISS/WMOSS/FQEISS feature selection techniques for classification problems presented in Karakaya et al. (2015).
 
Currently only the NSGA-II algorithm (Deb et al., 2002) is supported, but additional scripts  for the Borg version(Hadka and Reed, 2012) will be uploaded shortly. 
 
This toolbox depends on the following contributions which have to be donwloaded and referenced. 
 
1) Song Lin's NGPM toolbox for NSGA-II, 
   http://in.mathworks.com/matlabcentral/fileexchange/31166-ngpm-a-nsga-ii-program-in-matlab-v1-4
 
2) Hanchuan Peng's Mutual Information computation toolbox
  http://www.mathworks.com/matlabcentral/fileexchange/14888-mutual-information-computation

3)Yi Cao's Pareto-front toolbox
  http://www.mathworks.com/matlabcentral/fileexchange/17251-pareto-front

The NSGA-II version of the algorithms is illustrated in "script_example_NSGAII.m" for the "Heart" dataset of the UCI Repository (Lichman, 2013). 

Contrary to the experiments reported in Karakaya et al. (2015), this illustrative implementation features only one run for each algorithm on the chosen dataset. We suggest the user to run each algorithm several times, possibly using different randomizations of the employed dataset at each time, in order to maximize the number of solutions returned by the methods.  



References: 

Deb, K., Pratap, A., Agarwal, S., Meyarivan, T., 2002. 
A Fast and Elitist Multiobjective Genetic Algorithm. 
IEEE Trans. Evol. Comput. 6, 182–197. doi:10.1109/4235.996017

Hadka, D., Reed, P., 2012. 
Borg: An Auto-Adaptive Many-Objective Evolutionary Computing Framework. 
Evol. Comput. 21, 1–30. doi:10.1162/EVCO_a_00075

Lichman, M. (2013). UCI Machine Learning Repository [http://archive.ics.uci.edu/ml]. 
Irvine, CA: University of California, School of Information and Computer Science.

Karakaya, G., Galelli, S., Ahipasaoglu, S.D., Taormina, R., 2015. 
Identifying (Quasi) Equally Informative Subsets in Feature Selection Problems for Classification: 
A Max-Relevance Min-Redundancy Approach. 
IEEE Trans. Cybern. doi:10.1109/TCYB.2015.2444435



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
    along with MATLAB_IterativeInputSelection.  
    If not, see <http://www.gnu.org/licenses/>.

