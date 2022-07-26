function [ X ] = zipfrnd( alpha,n,m)
%ZIPFRND Random array from zipf distribution.
%   X = zipfrnd(alpha) returns an array of random numbers chosen from the
%   zipf distribution with parameter alpha. The mass distribution function is given by 
%   P(X=x_i)= x_i^(-alpha)/sum _{j=1}^m x_j^(-alpha)
%   inputs: alpha: the distribution parameter factor
%           n    : the total number of samples (default value is 100)
%           m    : size of requested vector (default value is 1)
%   Copyright @BassemKhalfi 2017.
if nargin<1
    error(message('stats:zipfrnd:TooFewInputs'));
elseif nargin<2
    m=1;
    n=100;
elseif nargin<3
    m=1;
elseif nargin>3
    print('Error')
end
if alpha<=0
    X=NaN;
else
    Prob=zeros(1,n);
    for idx=1:n
        Prob(idx)=(1/idx)^alpha;
    end
    Prob=Prob/sum(Prob);
    X=zeros(1,m);
    
    for idx2=1:m
        temp=rand;
        for idx=1:n
            if temp<=sum(Prob(1:idx));
                X(idx2)=idx;
                break;
            end
        end
    end
end
end



