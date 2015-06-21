function quantY = quantizeVariable(Y,nBins,type)
% Unsupervised quantization of continuous variable
%
% Inputs:     Y     <- the variable to discretize
%             nBins <- number of bins employed for quantization
%             type  <- "equalfreq"  --> each bin has same same num. of observations
%                   <- "equalwidth" --> each bin has same width
%           
%
% Output:
%            quantY <- the quantized variable (mean values of all observations in the bin)
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


if strcmp(type,'equalfreq')
    % bins with same height
    temp1 = sort(Y);
    temp2 = ceil(linspace(1,numel(Y),nBins+1));  
    steps = temp1(temp2);    
    quantY = Y;
    for i = 1 : nBins
        if i == 1
            ixes = (Y>=steps(1)) .* (Y<=steps(2));
        else
            ixes = (Y>steps(i)) .* (Y<=steps(i+1));
        end
        quantY(logical(ixes)) = mean(Y(logical(ixes)));
    end    
elseif strcmp(type,'equalwidth')
    % bins with same width
    maxY = max(Y); minY = min(Y);    
    steps = linspace(minY,maxY,nBins+1);
    quantY = Y;
    for i = 1 : nBins
        if i == 1
            ixes = (Y>=steps(1)) .* (Y<=steps(2));
        else
            ixes = (Y>steps(i)) .* (Y<=steps(i+1));
        end
        quantY(logical(ixes)) = mean(Y(logical(ixes)));
    end
else
    error('Type not recognized!!')
end

