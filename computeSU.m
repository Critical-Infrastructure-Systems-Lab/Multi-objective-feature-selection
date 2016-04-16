function SU = computeSU(x,y)
% Computes simmetric uncertainty between two variables
%
%
% Copyright 2016 Riccardo Taormina (riccardo_taormina@sutd.edu.sg), 
%      Gulsah Karakaya (gulsahkilickarakaya@gmail.com;), 
%      Stefano Galelli (stefano_galelli@sutd.edu.sg),
%      and Selin Damla Ahipasaoglu (ahipasaoglu@sutd.edu.sg;. 
%
% Please refer to README.txt for further information.
%
%
% This file is part of Matlab-Multi-objective-Feature-Selection.
% 
%     Matlab-Multi-objective-Feature-Selection is free software: you can redistribute 
%     it and/or modify it under the terms of the GNU General Public License 
%     as published by the Free Software Foundation, either version 3 of the 
%     License, or (at your option) any later version.     
% 
%     This code is distributed in the hope that it will be useful,
%     but WITHOUT ANy WARRANTy; without even the implied warranty of
%     MERCHANTABILITy or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     you should have received a copy of the GNU General Public License
%     along with MATLAB_IterativeInputSelection.  
%     If not, see <http://www.gnu.org/licenses/>.

% discretization options
nBins     = 20;
quantType = 'equalwidth'; 

% quantize variables
x = quantizeVariable(x,nBins,quantType);
y = quantizeVariable(y,nBins,quantType);

% compute entropies
hX  = entropy(x);
hy  = entropy(y);
hXy = jointentropy(x, y);

% compute mutual information
MI = hX+hy-hXy;

% compute symmetric uncertainty
SU = 2*MI/(hX+hy);
    

