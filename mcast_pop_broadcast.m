%SCRIPT#1 broadcast reference.

clear; clc; close all;

tot_contents=100;
cache_capacity_step=1;
num_caches=32;
requests_per_cache=125;

tot_requests=requests_per_cache*num_caches;

%High corr: percent_zipf=0.6; alpha 1.08
%Medium corr: percent_zipf=0.3; alpha 1.08
%Low corr: percent_zipf=0.02; alpha 1.08

percent_zipf=0.35; %0.01 = 1%
alpha=1.03;


terr_cost=1;
sat_cost=5;
arch_cost=0.5;
arch_cost_exp=1.2;


GB_per_content=2;


%%%DO NOT CHANGE BELOW%%%%
percent_uniform=1-percent_zipf;

if percent_zipf > 0.5
    PLOT_TITLE='High-correlation community';
elseif percent_zipf < 0.3
    PLOT_TITLE='Low-correlation community';  
else
    PLOT_TITLE='Medium-correlation community';
end


simul_requests_zipf=floor(tot_requests*percent_zipf);
simul_requests_uniform=floor(tot_requests*percent_uniform);

CH=[0];%init values of cache hit and miss with no caching
CM=[100];

m=tot_contents; % BINs = movies
alpha=1.08;

request= [zipfrnd(alpha,m,simul_requests_zipf) , uniformrnd(m,simul_requests_uniform)];


for cache_capacity=cache_capacity_step:cache_capacity_step:tot_contents
    occurrance=zeros(1,m);
    cache_hit=0;
    cache_miss=0;
    
for i=1:length(request) 
    occurrance(request(i)) = occurrance(request(i))+1;
    if request(i) <= cache_capacity 
        cache_hit = cache_hit +1;
    else
        cache_miss = cache_miss +1;
    end
end



occurrance = sort(occurrance,'descend' );

disp (['Cache size : ' , num2str(cache_capacity) , ' Cache-hit : ' , num2str(cache_hit/length(request)*100) , '% Cache-miss : ' , num2str(cache_miss/length(request)*100), '%']);
CH=[CH,cache_hit/length(request)*100];
CM=[CM,cache_miss/length(request)*100];

end

figure(1)
occurrance=occurrance/length(request);
bar([occurrance'],'EdgeColor','none','BarWidth',.9)
legend('Discrete PDF')
title([PLOT_TITLE,' (',num2str(tot_requests), ' requests)'   ])
axis([0 tot_contents+1 0 max(occurrance)])
grid on


size=0:cache_capacity_step:tot_contents;

figure(2)
plot(size,CH,'-X',size,CM,':');
legend('Cache-hit','Cache-miss')
xlabel('Cache Size')
ylabel('%')
title([PLOT_TITLE,' (',num2str(tot_requests), ' requests)'   ])
grid on

figure(3)
plot(size,((CM*tot_requests/100 * terr_cost) + size*sat_cost + size.^arch_cost_exp * arch_cost * num_caches)/tot_requests);
title(['Normalized simple cost model (',num2str(tot_requests), ' requests)'   ])
xlabel('Contents cached')

grid on


figure (4)


subplot(2,1,1)
plot(size,CM*tot_requests*GB_per_content);
grid on
ylabel('GBytes')
legend('Terrestrial')
subplot(2,1,2)
plot(size,size*GB_per_content);
legend('Satellite')
ylabel('GBytes')
xlabel('Contents cached')
grid on

