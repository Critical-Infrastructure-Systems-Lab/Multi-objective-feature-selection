function accuracy = trainAndValidateELM(PHI,Y,featIxes,nFolds,nELM,nUnits)
% This function trains and validate an ELM classifier with k-fold
% cross-validation
%
% Inputs:     PHI      <- array of training inputs with size  =  num. patterns x num. features
%             Y        <- array of training targets with size =  num. patterns x num. categories 
%                       (for each i-th column of trY only the entry relative to the correct category is 1)
%             featIxes <- features selected (they are columns of PHI)
%             nFolds   <- num. folds for cross validation
%             nELM     <- num. ELM in the ensemble
%             nUnits   <- num. hidden units of ELM
%
% Output:
%             accuracy <- accuracy of the predictions of the cross-validated ELM ensemble
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


% initialize
Yhat = zeros(size(Y,1),1);
accuracies = zeros(1,nELM) + Inf;
for j = 1 : nELM

    % k-fold cross validation
    lData  = size(Y,1);
    lFold  = floor(lData/nFolds);    

    for i = 1 : nFolds
        % select trainind and validation data
        ix1 = (i-1)*lFold+1;
        if i == nFolds
            ix2 = lData;
        else
            ix2 = i*lFold;
        end
        valIxes  = ix1:ix2; % select the validation chunk
        trIxes = setdiff(1:lData,valIxes); % obtain training indexes by set difference  

        % create datasets
        trX  = PHI(trIxes,featIxes);  trY  = Y(trIxes,:);
        valX = PHI(valIxes,featIxes);
                
        % train and test ELM
        [~,Yhat(valIxes)] =...
            ELMclassifier(trX', trY', valX', nUnits);    
    end
    % compute accuracy after cross-validaiton
    [~,temp] = max(Y');
    Y_    = temp';

    accuracies(j) = computeAccuracy(Y_,Yhat);                              
end
accuracy = mean(accuracies);