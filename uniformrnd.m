function [ X ] = uniformrnd(n,m)
%           n    : the total number of samples (default value is 100)
%           m    : size of requested vector (default value is 10)

if nargin<1
    m=10;
    n=100;
elseif nargin<2
    m=1;
elseif nargin>2
    print('Error')
end


X = randi([1 n],1,m);


end
