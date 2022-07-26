#SCRIPT TO CREATE AN AGGREGATE PDF FROM N PDFs
clear; clc; close all;

m=100; % BINs = movies
cache_size = 6;
max_communities=3;
tot_requests=4e3;
alpha=1.025;
percent_zipf=0.6; 

CH_mc=[];%
CH_bc=[];%

for tot_communities=1:max_communities

occurrance=zeros(1,m);
cache_hit=0;
cache_miss=0;
    
percent_uniform=1-percent_zipf;
simul_requests_zipf=floor(tot_requests*percent_zipf);
simul_requests_uniform=floor(tot_requests*percent_uniform);

for communities=1:tot_communities
   
   
    r = randperm(m);


    request= [zipfrnd(alpha,m,simul_requests_zipf) , uniformrnd(m,simul_requests_uniform)];


    for i=1:length(request) 
        occurrance(request(i)) = occurrance(request(i))+1;
        
    if request(i) <= cache_size
        cache_hit = cache_hit +1;
    else
        cache_miss = cache_miss +1;
    end
    end


    occurrance = occurrance(r);

end

occurrance = sort(occurrance,'descend' );

disp (['cache hit da distr: ' , num2str(m*sum(occurrance(1:cache_size))/(tot_requests*tot_communities))]);
disp (['cache hit iteraz: ' , num2str(m*cache_hit/(tot_requests*tot_communities))]);
CH_bc=[CH_bc,m*sum(occurrance(1:cache_size))/(tot_requests*tot_communities)];
CH_mc=[CH_mc,m*cache_hit/(tot_requests*tot_communities)];

end
figure(1)
occurrance=occurrance/tot_requests;
bar(occurrance'/tot_communities,'EdgeColor','none','BarWidth',0.9)

legend('Discrete PDF')
title([num2str(tot_requests), ' requests (',num2str(tot_communities), ' communities)'   ])
axis([0 m+1 0 max(occurrance/tot_communities)*1.2])
grid on
