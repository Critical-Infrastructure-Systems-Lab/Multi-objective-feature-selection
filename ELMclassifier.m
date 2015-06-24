function [trYhat, valYhat,W1,W2,bias] =...
    ELMclassifier(trX, trY, valX, nUnits)

% This function implements an ELM classifier with tanh activation function.
%
% Inputs:     trX    <- array of training inputs with size  = num. features x num. training patterns 
%             trY    <- array of training targets with size = num. categories x num. training patterns 
%                       (for each i-th column of trY only the entry relative to the correct category is 1)
%             valX   <- array of validation inputs with size  = num. features x num. training patterns  
%             nUnits <- num. hidden units of ELM
%
% Output:
%             trYhat  <- array of training target predictions with size = 1 x num. training patterns 
%                      (each i-th is an integer = predicted category) 
%             valYhat <- array of validaiton target predictions with size = 1 x num. validation patterns 
%                      (each i-th is an integer = predicted category) 
%          W1,W2,bias <- the trained parameters of the ELM
%
% Reference:  Huang, G.-B., Zhu, Q.-Y., Siew, C.-K., 2006. Extreme learning machine: Theory and applications. 
%             Neurocomputing 70, 489–501. doi:10.1016/j.neucom.2005.12.126
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

% get number of features and number of patterns for training and validation
[nFeatures,nPatternsTr]   = size(trX);
nPatternsVal              = size(valX,2);

% generate random input->hidden weights W1 (between -1 and 1) 
W1 = rand(nUnits,nFeatures)*2-1;

% generate random biases (between 0 and 1) 
bias  = rand(nUnits,1);

% compute hidden neuron output matrix H
H = sigActFun(W1*trX + repmat(bias,[1,nPatternsTr]));

% compute hidden->output weights W2
Hinv = pinv(H');
W2  = Hinv * trY';

% get ELM response on training
temp     = (H' * W2)';  
[~,temp] = max(temp,[],1);
trYhat   = temp';

% ...  and validation dataset
Hval     = sigActFun(W1*valX + repmat(bias,[1,nPatternsVal]));
temp     = (Hval' * W2)';
[~,temp] = max(temp,[],1);
valYhat  = temp';