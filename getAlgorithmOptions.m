function [options,objFunOptions] = getAlgorithmOptions(algorithm,data)
% Options for the algorithms (NSGAII/BORG) and the objective function
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

% extract attributes (PHI) and predictand (Y)
PHI    = data(:,1:end-1);
[nPatterns,nAttrs] = size(PHI);
tempY  = data(:,end);

% restructure predictand (array with same number of columns of number of classes) 
classes  = unique(tempY);
nClasses = numel(classes);
Y = zeros(nPatterns,nClasses);
for i = 1 : nClasses
    thisClass = classes(i);
    ixes = (tempY == thisClass);
    Y(ixes,i) = 1;
end


% Objective Function options
objFunOptions.Y              = Y;               % predictand
objFunOptions.PHI            = PHI;             % attributes
objFunOptions.nFolds         = 10;              % folds for k-fold cross-validation
objFunOptions.nELM           = 5;               % size of ELM ensemble        
objFunOptions.nUnits         = 10;              % number of units in ELM
objFunOptions.maxCardinality = 20;              % maximum cardinality (important for large datasets)

% Algorithm options
if strcmp(algorithm,'NSGA2')
    % NSGA2
    
    options = nsgaopt();                    % get default options 
    options.popsize = 100;                  % populations size
    options.maxGen  = 100;                  % max generation
    options.numVar  = nAttrs;               % number of design variables
    options.numCons = 0;                    % number of contraints
    options.lb      = zeros(1,nAttrs);      % lower bound of design variables (0)
    options.ub      = ones(1,nAttrs);       % upper bound of design variables (1)
    options.vartype  = ones(1,nAttrs);       % specify all binary variables   
    options.outputInterval = 1;             % interval between echo on screen
    options.plotInterval   = 1;             % interval between plot updates
    options.useParallel    = 'no';          % use parallel ('yes'/'no')
    options.poolsize       = 1;             % matlab poolisize (num. parallel threads)
    
elseif strcmp(algorithm,'BORG')
    options.nvars       = nAttrs;              % number of design variables
    options.nconstrs    = 0;                   % number of contraints
    options.NFE         = 5000;                % number of functions evaluations
    options.lowerBounds = zeros(1,nAttrs);     % lower bound of design variables (0)
    options.upperBounds = ones(1,nAttrs);      % upper bound of design variables (1)    
else
    error('Algorithm not supported!')
end

