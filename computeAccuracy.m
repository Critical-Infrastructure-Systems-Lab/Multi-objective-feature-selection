function accuracy = computeAccuracy(Y,Yhat)
% Computes the accuracy of ELM predictions
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


classes  = unique(Y);
nClasses = numel(unique(Y));
if nClasses == 2
    nClasses = 1; % handle binary classification
end
    

Acc = zeros(1,nClasses);
for j = 1 : nClasses
    if nClasses == 1
        thisClass = 2; % the H1
    else
        thisClass = classes(j);
    end
    % ixes 
    ixes1 = (Y    == thisClass);        
    ixes2 = (Yhat == thisClass); 
    % compute confusion matrix
    tp = sum((ixes1==ixes2)&(ixes1==1));
    tn = sum((ixes1==ixes2)&(ixes1==0));
    fn = sum((ixes1-ixes2)==1);
    fp = sum((ixes1-ixes2)==-1);    
    % compute accuracy
    Acc(j) = (tp+tn)/(tp+fn+fp+tn);
end
% get average accuracy
accuracy = mean(Acc);