function PF = deltaElimination(PF0,delta)
% Performs delta elimination to select QEISS from initial pareto front.  
% The QEISS are those with accuracy at most delta% smaller than the highest one.
%
% Reference:  Karakaya, G., Galelli, S., Ahipasaoglu, S.D., Taormina, R., 2015. 
%             Identifying (Quasi) Equally Informative Subsets in Feature Selection Problems 
%             for Classification: A Max-Relevance Min-Redundancy Approach. 
%             IEEE Trans. Cybern. doi:10.1109/TCYB.2015.2444435
%
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


% initialize output as input (eliminate entries later)
fvals       = PF0.fvals;
fvals_ext   = PF0.fvals_ext;
archive     = PF0.archive;
tempArchive = archive;

% extract accuracies for delta elimination
accuracies = -(fvals_ext(:,3));

% find best value of metric
bestValue = max(accuracies);

delta = (delta/100);


% in this array 1 will identify solution to be eliminated 
ixesToRemove = zeros(size(tempArchive,1),1);

% proceed with delta elimination
for i = 1 : numel(tempArchive)
    if accuracies(i) < (1-delta)*bestValue;
        % remove, it's inferior
        ixesToRemove(i) = 1;
    else
        % eliminate inferior subsets
        Si = tempArchive{i};
        for j = 1 : numel(tempArchive)
            if (j == i) || (ixesToRemove(j) == 1)
                % continue loop if solution already removed of
                % if comparing same solutions
                continue
            end
            Sj = tempArchive{j};
            if isequal(intersect(Si,Sj),Sj) &&...
                    (accuracies(j)>accuracies(i))
                % remove solution if inferior
                ixesToRemove(i) = 1;
            end
        end
    end
end

PF.fvals     = fvals(~ixesToRemove,:);
PF.fvals_ext = fvals_ext(~ixesToRemove,:);
PF.archive   = archive(~ixesToRemove);
