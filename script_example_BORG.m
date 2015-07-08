% This script illustrates the Borg implementation of the 
% WQEISS/WMOSS/FQEISS feature selection techniques described in:
%
%   Karakaya, G., Galelli, S., Ahipasaoglu, S.D., Taormina, R., 2015. 
%   Identifying (Quasi) Equally Informative Subsets in Feature Selection Problems 
%   for Classification: A Max-Relevance Min-Redundancy Approach. 
%   IEEE Trans. Cybern. doi:10.1109/TCYB.2015.2444435
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
 
clc; clear;

%% specify include paths
addpath('..\..\Work\Code\toolboxes\mi');            % Peng's mutual information
addpath('..\toolboxes\borg-matlab\');               % Borg
addpath('..\toolboxes\pareto_front');               % paretofront toolbox



%% Load and prepare dataset

% load dataset
filePath = 'Heart.csv';
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
    getAlgorithmOptions(GOalgorithm,norm_data);

% initialize overall archive and array containing the values of the
% objctive functions (fvals)
global archive fvals ix_solutions
archive = {};               % archive of all solutions explored
fvals   = [];               % values of the obj function explored
                            %   RELEVANCE - REDUNDACY - ACCURACY - #INPUTS  

ix_solutions = [];          % this will track which solutions are found by each algorithm


%% launch WQEISS
fprintf ('Launching WQEISS\n')

% define number of obj functions and the matlab function coding them
options.nobjs = 4;   
options.objectiveFcn = @objFunWQEISS; 
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



%% launch WMOSS
fprintf ('Launching WMOSS\n')

% define number of obj functions and the matlab function coding them
options.nobjs = 2;   
options.objectiveFcn = @objFunWMOSS; 
epsilon = 10^-3;
epsilons = repmat(epsilon, [1,options.nobjs]);

% launch
ix_solutions = zeros(numel(archive),1); % re-initialize ix_solutions. 
                                        % at the start of the algorithm, none
                                        % of solutions in the archive has been
                                        % found yet;
% launch
borg(...
    options.nvars,options.nobjs,options.nconstrs,...
    options.objectiveFcn, options.NFE,...
    options.lowerBounds, options.upperBounds, epsilons);
% get solutions indexes for WMOSS
ixWMOSS  = find(ix_solutions); 

% compute final pareto front
ixesPF    = find(paretofront(fvals(ixWMOSS,3:4)));
PF_WMOSS.archive   = archive(ixWMOSS(ixesPF));
PF_WMOSS.fvals     = fvals(ixWMOSS(ixesPF),[3,4]);
PF_WMOSS.fvals_ext = fvals(ixWMOSS(ixesPF),:);


%% launch FQEISS
fprintf ('Launching FQEISS\n')

% define number of obj functions and the matlab function coding them
options.nobjs = 3;   
options.objectiveFcn = @objFunFQEISS; 
epsilon = 10^-3;
epsilons = repmat(epsilon, [1,options.nobjs]);


% launch
ix_solutions = zeros(numel(archive),1); % re-initialize ix_solutions. 
                                        % at the start of the algorithm, none
                                        % of solutions in the archive has been
                                        % found yet;
% launch
borg(...
    options.nvars,options.nobjs,options.nconstrs,...
    options.objectiveFcn, options.NFE,...
    options.lowerBounds, options.upperBounds, epsilons);      
% get solutions indexes for FQEISS
ixFQEISS  = find(ix_solutions); 

% compute final pareto front
ixesPF    = find(paretofront(fvals(ixFQEISS,[1,2,4])));
PF_FQEISS.archive   = archive(ixFQEISS(ixesPF));
PF_FQEISS.fvals     = fvals(ixFQEISS(ixesPF),[1,2,4]);
PF_FQEISS.fvals_ext = fvals(ixFQEISS(ixesPF),:);

%% delta elimination for WQEISS and WMOSS
delta = 20;
PFdelta_WQEISS = deltaElimination(PF_WQEISS,delta);
PFdelta_FQEISS = deltaElimination(PF_FQEISS,delta);

%% Plot WMOSS vs PFdeltas
figure;
subplot(1,2,1);
plot(PF_WMOSS.fvals_ext(:,4), -PF_WMOSS.fvals_ext(:,3),'ro');
hold on
plot(PFdelta_WQEISS.fvals_ext(:,4), -PFdelta_WQEISS.fvals_ext(:,3),'k.');
legend({'WMOSS','WQEISS'})
title('WMOSS vs WQEISS')
xlabel('Cardinality')
ylabel('Accuracy')
axis square

subplot(1,2,2);
plot(PF_WMOSS.fvals_ext(:,4), -PF_WMOSS.fvals_ext(:,3),'ro');
hold on
plot(PFdelta_FQEISS.fvals_ext(:,4), -PFdelta_FQEISS.fvals_ext(:,3),'k.');
legend({'WMOSS','FQEISS'})
title('WMOSS vs FQEISS')
xlabel('Cardinality')
ylabel('Accuracy')
axis square

%% Plot Frequency matrices
figure('name','FQEISS (left) and WQEISS (right) frequency matrices');
subplot(1,2,1);
plotFrequencyMatrix(PFdelta_FQEISS,options.nvars,varNames)

subplot(1,2,2);
plotFrequencyMatrix(PFdelta_WQEISS,options.nvars,varNames)












