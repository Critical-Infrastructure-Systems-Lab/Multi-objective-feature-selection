function [] = plotFrequencyMatrix(QEISS,nFeat,featNames)
% Plot the frequency matrix of a set of QEISS
%
% Inputs:     QEISS     <- struct containing QEISS archive and values of the obj. functions
%             nFeat     <- number of features
%             featNames <- cell array of nFeat strings with feature names
%
% Reference:  Karakaya, G., Galelli, S., Ahipasaoglu, S.D., Taormina, R., 2015. 
%             Identifying (Quasi) Equally Informative Subsets in Feature Selection Problems 
%             for Classification: A Max-Relevance Min-Redundancy Approach. 
%             IEEE Trans. Cybern. doi:10.1109/TCYB.2015.2444435%
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


% get archive
archive  = QEISS.archive;
nSubsets = numel(archive);
accuracies  = -QEISS.fvals_ext(:,3);
cardinalities = QEISS.fvals_ext(:,4);

% inizialize frequency matrix
fMat = zeros(nSubsets,nFeat);

% fill frequency matrix
for i = 1 : nSubsets 
    thisSubsetIxes = archive{i};
    fMat(i,thisSubsetIxes) = 1;
end

% add padding for pColor

% plot 
temp = fMat.*repmat(cardinalities*nFeat,1,nFeat); % colour by cardinality
temp2 = [cardinalities,accuracies];
[~,sIxes] = sortrows(temp2,[1,2]); % sort by cardinality, then RMSE
temp = temp(sIxes,:);
imagesc(temp);
myColorMap = flipud(gray(max(unique(temp))+1)); % fliupud so that blanks are white
colormap(myColorMap)

% title and labels
% xlabel('feature id.') % x-axis label
ylabel('subset id.')  % y-axis label
% check if feature names are available. if so, prints them
if (nargin >= 3) && ~isempty(featNames)
    set(gca,'XTick',1:nFeat)
    % rotate labels 
    hx = get(gca,'XLabel');  % Handle to xlabel 
    pos = get(hx,'Position'); 
    y = pos(2); 
    set(gca,'xticklabel',{[]}); % clear labels 
    
    % Place the new labels 
    for i = 1:nFeat
        t(i) = text(i,y,featNames{i}); 
        set(t(i),'Rotation',45,'HorizontalAlignment','right','FontSize',10)
    end    
else
    set(gca,'XTick',1:nFeat,'XTickLabel',1:nFeat);
end

set(gca,'YTick',1:nSubsets)

% add secondary x axis
temp   = sum(fMat)/nSubsets*100;
labels = arrayfun(@(x) sprintf('%3.2f%%',x),temp,...
    'UniformOutput',false);
text(0.875:1:nFeat, zeros(1,nFeat),labels,...
    'HorizontalAlignment','left','Rotation',90);

% add secondary y axis
% check if metricToPrint was given, otherwise go for RMSE
temp = accuracies;

labels = arrayfun(@(x) sprintf('%3.3f',x),temp(sIxes),...
    'UniformOutput',false);
xs = repmat(nFeat+0.625,1,nSubsets+1);
ys = [0,1:nSubsets];
text(xs,ys,cat(1,'accuracy',labels));
[~,ixBest] = max(accuracies(sIxes));
text(xs(ixBest),ys(ixBest+1),labels(ixBest),'Color','red');

axis square

