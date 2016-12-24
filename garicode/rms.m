function e = rms(X,Y,dim)
% RMS (root-mean-square error)
%
% "e = rms(X,Y)" returns the square root of the average square difference
% between the corresponding elements in X(:) and Y(:). 
%
% "e = rms(X,Y,dim)" returns the root mean square difference between X and Y
% taken along the dimension "dim". 

if (nargin == 1)
    [a b] = size(X);
    if((a==1) | (b==1))
        error('at least two vectors required')
    end
    fprintf('calculating rms between first two columns of matrix\n')
  Y = X(:,2);
  X = X(:,1);
  dim=1;
end
if nargin < 3
  X = X(:);
  Y = Y(:);
  dim = 1;
end

if isa(X,'uint8')
   X = double(X);
end

if isa(Y,'uint8');
   Y = double(Y);
end

e = sqrt(sum(abs(Y-X).^2,dim)/size(X,dim));
