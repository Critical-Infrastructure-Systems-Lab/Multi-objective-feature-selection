function [RED,REL] = computeRelevanceRedundancy(data)
% Computes scaled relevance (REL) and redundancy (RED) arrays for a given dataset
% Last column is the predicted variable.
%
%
% Reference:  Karakaya, G., Galelli, S., Ahipasaoglu, S.D., Taormina, R., 2015. 
%             Identifying (Quasi) Equally Informative Subsets in Feature Selection Problems 
%             for Classification: A Max-Relevance Min-Redundancy Approach. 
%             IEEE Trans. Cybern. doi:10.1109/TCYB.2015.2444435
%
%
%
% Copyright 2015 Riccardo Taormina (riccardo_taormina@sutd.edu.sg), 
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
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with MATLAB_IterativeInputSelection.  
%     If not, see <http://www.gnu.org/licenses/>.

% get predictors and predictand
PHI = data(:,1:end-1);
Y   = data(:,end);

% initialize outputs
nInputs = size(PHI,2);
RED = zeros(nInputs);
REL = zeros(nInputs,1);


hOut = entropy(Y);
for i = 1 : nInputs
    % compute RED
    hX = entropy(PHI(:,i));
    for j = i+1 : nInputs
        hY  = entropy(PHI(:,j));
        hXY = jointentropy(PHI(:,i), PHI(:,j));
        MI = hX+hY-hXY;
        SU = 2*MI/(hX+hY);
        RED(i,j) = SU;
    end
    % compute REL
    hY = hOut;
    hXY = jointentropy(PHI(:,i), Y);
    MI = hX+hY-hXY;
    SU = 2*MI/(hX+hY);
    REL(i) = SU;
end
    
% compute max values and scale everything
maxRED = sum(sum(RED(:)));
maxREL = sum(REL(:));    
RED = RED/maxRED;
REL = REL/maxREL;

