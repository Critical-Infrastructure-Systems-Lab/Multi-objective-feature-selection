function [fval,dummy] = objFunFQEISS(X,varargin)
global archive fvals objFunOptions suREL suRED ix_solutions
% objective function for developing FQEISS filters
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

% initialize fitness values
fval = zeros(1,3);

% unpack data and parameters
Y       = objFunOptions.Y;         % targets
PHI     = objFunOptions.PHI;       % inputs
nFolds  = objFunOptions.nFolds;    % nFolds for k-fold cross validation
nELM    = objFunOptions.nELM;      % number of repeats for computing the accuracy obj function
nUnits  = objFunOptions.nUnits;    % info on dataset
maxCardinality = objFunOptions.maxCardinality;  % maximum cardinality

% retrieve populations size and number of attributes
nAttrs = size(X,2);

% transform decision variables from continuous to discrete
% 0 or 1 assigned depending on ratio of maxCardinality/nAttrs
% (This has no effect if the search algorithm is binary-coded already!) 
varRatio = maxCardinality/nAttrs;
if varRatio > 0.5
    X = X>0.5;
else
    X = X>(1 - varRatio);
end

% get selected features from genotype
featIxes = find(X);

% get cardinality
cardinality = numel(featIxes);


% check if this combination of inputs is already in archive
% if so, assign existing fitness values to this genotype
temp = cellfun(@(x) isequal(x,featIxes),archive,'UniformOutput',false);    
archiveIx = find([temp{:}]);
if ~isempty(archiveIx);
    % get fval from lookup table
    fval = fvals(archiveIx,[1,2,4]);
    ix_solutions(archiveIx) = 1;
else
    if cardinality > maxCardinality
        % if cardinality > maxCardinality do not evaluate and assign very
        % high values of the obj functions
        fval = [Inf,Inf,numel(featIxes)];
    elseif cardinality == 0
        % no inputs selected, irregular solution
        fval = [Inf,Inf,numel(featIxes)];
    else       
        % found new combination, compute values of obj. functions

        % relevance
        REL = sum(suREL(featIxes));               
        
        % redundancy
        if cardinality == 1
            % 1 input selected, no redundancy
            RED = 0;
        else
            temp = nchoosek(featIxes,2); 
            ixes = (temp(:,2)-1)*nAttrs+temp(:,1);        
            RED = sum(suRED(ixes));
        end
        
        % compute ELM classifier accuracy
        ACC = trainAndValidateELM(PHI,Y,featIxes,nFolds,nELM,nUnits);
        
        % fitness values (- for those obj. functions to maximize)                
        fval = [-REL,RED,cardinality];            
        % add solution to archive and fvals
        archive = cat(1,archive,featIxes);
        fvals   = cat(1,fvals,[-REL,RED,-ACC,cardinality]);
        ix_solutions = cat(1,ix_solutions,1);
    end  
end

dummy = [];