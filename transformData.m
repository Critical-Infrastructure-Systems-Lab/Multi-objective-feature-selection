function transf_data = transformData(data,varTypes)
% This function transforms the data by 
% 1) map the values of categorical attributes between 0 and the number of categories
%
% 2) quantize real valued attributes using nBins numnber of bins
%       modify the value of nBins for sparses/denser discretization
%       quantType = 'equalfreq'  <-- each bin has same num. observations
%       quantType = 'equalwidth' <-- each bin has same width
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
%

% discretization options
nBins     = 20;
quantType = 'equalwidth'; 

% initialize output array
[nObs,nVars] = size(data);
transf_data = zeros(nObs,nVars);


% loop through all variables
for i = 1 : nVars
    % get current attribute
    attr     = data(:,i);
    attrType = varTypes(i);
    % transform accordingly with its varType
    if attrType == 0
        % real-valued, discretize
        transf_data(:,i) = quantizeVariable(attr,nBins,quantType);
    elseif attrType == 1
        % categorical data, sort them between 0 and num. categories
        
        % get categories
        categories = unique(attr);
        for j = 1 : numel(categories)
            ixes = (attr == categories(j));
            attr(ixes) = j-1;
        end
        transf_data(:,i) = attr;
    else
        error('Attribute num#%d, type not recognized!',i);
    end        
end