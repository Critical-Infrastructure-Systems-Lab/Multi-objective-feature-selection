function [data,varNames,varTypes] = readFile(filePath)
% This function reads experiment data from .csv file with n columns
%
% The .csv file has to be structured as follows
%   Column 1 to n-1 = attributes
%   Last column     = variable to be predicted
%   
%   1st row = name of attributes and variable to be predicted
%   2nd row = attribute and variable types (0 = Real, 1 = Categorical)
%   remaining rows = the data samples
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

% load file using xlsread
[temp_a,temp_b] = xlsread(filePath);

% extract attribute and variable types
varTypes = temp_a(1,:);

% extract data samples
data  = temp_a(2:end,:);

% get names
varNames = temp_b(1,:);
