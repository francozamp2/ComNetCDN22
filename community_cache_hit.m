%NOT USED IN THE PAPER

clear; clc; close all;

beams = 80;

communities_per_beam_max = 6;% 1 = each beam 1 comm. (ideal case); worst case 5-10 comms.

tot_contents=100;
cache_capacity=16;

tot_requests=1e5;


percent_zipf=0.58;%  1 = 100%, 0.01 = 1%

%%%DO NOT CHANGE BELOW%%%

%movie_requested=[];
requests = round (tot_requests / beams);
percent_uniform=1-percent_zipf;

simul_requests_zipf=floor(requests*percent_zipf);
simul_requests_uniform=floor(requests*percent_uniform);

m=tot_contents; % BINs = movies
alpha=1.04;

 CH_TOT=[];%init values of cache hit and miss
 CH_VAR=[];
 
  CH_TOT_shared=[];%init values of cache hit and miss
 CH_VAR_shared=[];
% CH_VAR_MAX=[];

for communities_per_beam=1:communities_per_beam_max
 CH=[];%init values of cache hit and miss
 CM=[];
 CH_shared=[];%init values of cache hit and miss
 CM_shared=[];
 occurrance=zeros(1,m);

for c=1:beams 
    
    request = [zipfrnd(alpha,m,simul_requests_zipf) , uniformrnd(m,simul_requests_uniform)];
 

    cache_hit_shared=0;
    cache_hit=0;
    cache_miss=0;
    cache_miss_shared=0;
 

    

for i=1:length(request) 
    occurrance(request(i)) = occurrance(request(i))+1;
    %disp (['Cache cap: ' , num2str(cache_capacity) , ' Rel size : ' , num2str(cache_capacity / communities_per_beam)]);

    if request(i) <= (cache_capacity )
        cache_hit = cache_hit +1;
    else
        cache_miss = cache_miss +1;
    end
    
    if request(i) <= (cache_capacity / communities_per_beam ) %da rifare con alta correlazione e N cache in un altro loop!!
        cache_hit_shared = cache_hit_shared +1;
    else
        cache_miss_shared = cache_miss_shared +1;
    end
end


%disp (['Beam', num2str(c),' * Cache size : ' , num2str(cache_capacity) , ' Cache-hit : ' , num2str(cache_hit/length(request)*100) , '% Cache-miss : ' , num2str(cache_miss/length(request)*100), '%']);
CH_shared=[CH_shared;cache_hit_shared/length(request)*100];
CM_shared=[CM_shared;cache_miss_shared/length(request)*100];
CH=[CH;cache_hit/length(request)*100];
CM=[CM;cache_miss/length(request)*100];

end

disp (['Averages : Cache-hit : ' , num2str(sum(CH,1)/beams) , '% max : ' , num2str(max(CH)), ' min : ' , num2str(min(CH))]);

CH_TOT=[CH_TOT;sum(CH,1)/beams];
CH_VAR=[CH_VAR;std(CH)];

CH_TOT_shared=[CH_TOT_shared;sum(CH_shared,1)/beams];
CH_VAR_shared=[CH_VAR_shared;std(CH_shared)];

end


figure(1)
size=1:communities_per_beam_max;
errorbar(size,CH_TOT,CH_VAR,CH_VAR,'-o');
hold on;grid on;
errorbar(size,CH_TOT_shared,CH_VAR_shared,CH_VAR_shared,':x' );
legend('Cache-hit')%,'Cache-miss')
xlabel('Communities per beam')
ylabel('%')
title(['Beams: ',num2str(beams) ,' - Cache size per beam: ',num2str(cache_capacity),' - Requests per beam: ',num2str(requests) ])
grid on


