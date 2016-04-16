% This script illustrates the Borg implementation of the 
% WQEISS input selection technique described in:
%
%   Taormina, R., Galelli, S., Karakaya, G., Ahipasaoglu, S.D. 
%   An information theoretic approach to select alternate subsets
%   of predictors for data-driven hydrological models.
%   Water Resources Research (in review)
%
%   WQEISS and other techniques for feature selection in classificatio
%   problems are described in:
% 
%   Karakaya, G., Galelli, S., Ahipasaoglu, S.D., Taormina, R., 2015. 
%   Identifying (Quasi) Equally Informative Subsets in Feature Selection Problems 
%   for Classification: A Max-Relevance Min-Redundancy Approach. 
%   IEEE Trans. Cybern. doi:10.1109/TCYB.2015.2444435
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
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with MATLAB_IterativeInputSelection.  
%     If not, see <http://www.gnu.org/licenses/>.
 
clc; clear;

%% specify include paths
addpath('..\..\Work\Code\toolboxes\mi');            % Peng's mutual information
addpath('..\..\Work\Code\toolboxes\borg-matlab\');  % Borg
addpath('..\..\Work\Code\toolboxes\paretofront');   % paretofront toolbox


%% Load and prepare dataset

% load dataset
filePath = 'Concrete_Data.csv';
[orig_data,varNames,varTypes] = readData(filePath);

% transform data
transf_data = transformData(orig_data,varTypes);

% normalize data
norm_data = normalizeData(transf_data);

% compute relevance and redundacy
global suRED suREL
[suRED,suREL] = computeRelevanceRedundancy(norm_data);


%% Prepare for launching the algorithms

% specify GO algorithm to use (BORG or NSGA2)
GOalgorithm = 'BORG';

% get algorithm options
global objFunOptions    

[options,objFunOptions] = ...
    getAlgorithmOptions(GOalgorithm,norm_data,true);

% initialize overall archive and array containing the values of the
% objctive functions (fvals)
global archive fvals ix_solutions
archive = {};               % archive of all solutions explored
fvals   = [];               % values of the obj function explored
                            %   RELEVANCE - REDUNDACY - SU - #INPUTS  

ix_solutions = [];          % this will track which solutions are found by each algorithm


%% launch WQEISS
fprintf ('Launching WQEISS\n')

% define number of obj functions and the matlab function coding them
options.nobjs = 4;   
options.objectiveFcn = @objFunWQEISS_regression; 
epsilon = 10^-3;
epsilons = repmat(epsilon, [1,options.nobjs]);

% launch
borg(...
    options.nvars,options.nobjs,options.nconstrs,...
    options.objectiveFcn, options.NFE,...
    options.lowerBounds, options.upperBounds, epsilons);


% get solutions indexes for WQEISS
ixWQEISS = find(ix_solutions);


% compute final pareto front
ixesPF    = find(paretofront(fvals(ixWQEISS,:)));
PF_WQEISS.archive   = archive(ixWQEISS(ixesPF));
PF_WQEISS.fvals     = fvals(ixWQEISS(ixesPF),:);
PF_WQEISS.fvals_ext = fvals(ixWQEISS(ixesPF),:);




%% delta elimination
delta = 20;
PFdelta_WQEISS = deltaElimination(PF_WQEISS,delta);

%% Plot Frequency matrices
figure('name','W-QEISS frequency matrices');
plotFrequencyMatrix(PFdelta_WQEISS,options.nvars,varNames)











