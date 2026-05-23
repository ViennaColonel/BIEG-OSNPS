function [result]=programOSNP1000(item)
%% program for spiking neural P systems-inspired evolutionary algorithm (SNPEA)
% clear;
% clc;

% problem
load knapsack1000;
% parameter setting
Ps=50; % population size
LengthOfProblem=length(profit);

historialBestSolution=-9999*ones(Ps,1);
historialBestBit=zeros(Ps,LengthOfProblem);
globalmaxfit=-9999;
Dmin = 0.005; 
Dmax = 0.020;
CHAOS_PARAM = 3.58;
historialglobalBestBit = [];
historialglobalBestSolution = [];
% initialization
for i = 1:Ps
    P(i, :) = logistic_chaos(LengthOfProblem,CHAOS_PARAM); 
end
%P=0.5*ones(Ps,LengthOfProblem);
%------------------------------------------------------------------%
flagtermination=-99;
gen=0;
unchangedSolution=globalmaxfit;
unchangedTime=0;

while flagtermination<0
    gen=gen+1;
    [B]=pop_observe(P);
    B=repair(B,weight,capacity);
    fitness=sum((repmat(profit,[size(P,1) 1]).*B),2);
    %------------------------------------------------------%
    [maxfit,maxindex]=max(fitness);
    maxbit=B(maxindex,:);
    [~, sortIndex] = sort(fitness);
    sortedB = B(sortIndex,:);
    globalB = sortedB;

    %------------------------------------------------------%
    % for i=1:Ps
    %     if historialBestSolution(i,1)<fitness(i,1)
    %         historialBestSolution(i,i)=fitness(i,1);
    %         historialBestBit(i,:)=B(i,:);
    %     end
    % end
    historialLogic = historialBestSolution<fitness;
    historialBestSolution(historialLogic == 1) = fitness(historialLogic == 1);
    historialBestBit(historialLogic == 1,:) = B(historialLogic == 1,:);
    %-----------------------------------------------------%
    if (globalmaxfit<maxfit)
        globalmaxfit=maxfit;
        globalmaxbit=maxbit;
    end
    historialglobalBestBit = [historialglobalBestBit; globalmaxbit];
    historialglobalBestSolution = [historialglobalBestSolution; globalmaxfit];
    if size(historialglobalBestBit,1)>Ps
        Index = randi([1, Ps]);
        historialglobalBestBit(Index,:) = [];
        historialglobalBestSolution(Index,:) = [];
    end
    selectMatB = [historialBestBit; historialglobalBestBit];
    selectMatF = [historialBestSolution; historialglobalBestSolution];
    %-----------------------------------------------------%
    Alpha = ones(1,LengthOfProblem); 
    Beta  = ones(1,LengthOfProblem);
    template_pool = [globalmaxbit; historialBestBit]; 
    Alpha = Alpha + sum(template_pool, 1); 
    Beta  = Beta  + size(template_pool,1) - sum(template_pool,1);
    %-----------------------------------------------------%
    den = Alpha + Beta;
    
    p_hat = Alpha ./ den;                                      % 1 ¡Á LengthOfProblem
    var_j = p_hat .* (1 - p_hat) ./ (den + 1);                 % 1 ¡Á LengthOfProblem
    sigma = sqrt(var_j);                                      % 1 ¡Á LengthOfProblem
    eta = 2 * sigma;                                          % 1 ¡Á LengthOfProblem
    
    H = -P .* log2(P + eps) - (1 - P) .* log2(1 - P + eps);    % Ps ¡Á LengthOfProblem
    
    adaptiveMat = H .* eta;                                   % Ps ¡Á LengthOfProblem
    deltaMat = Dmin + (Dmax - Dmin) .* adaptiveMat;            % Ps ¡Á LengthOfProblem
    %----------------------------------------------------%
    updateP=P;
    for i=1:Ps
        if unchangedTime<50
            Plearn=0.05+0.15*rand;
        else
            Plearn=0.2+0.8*rand;
        end
        for j=1:LengthOfProblem

            if rand<Plearn
                k1=ceil(Ps*rand);
                while k1==i
                    k1=ceil(Ps*rand);
                end
                k2=ceil(Ps*rand);
                while (k2==i)|(k2==k1)
                    k2=ceil(Ps*rand);
                end
                if historialBestSolution(k1,1)>historialBestSolution(k2,1)  
                    b=historialBestBit(k1,j);
                else
                    b=historialBestBit(k2,j);
                end
                if B(i,j)~=b
                    delta = deltaMat(i,j);
                    if (b>0.5)
                        updateP(i,j)=P(i,j)+delta;
                    else
                        updateP(i,j)=P(i,j)-delta;
                    end
                end
                clear b;
            else
                X = globalB(randi([1,5]),:);
                if B(i,j)~=X(1,j)
                    delta = deltaMat(i,j);
                    if X(1,j)>0.5
                        updateP(i,j)=P(i,j)+delta;
                    else
                        updateP(i,j)=P(i,j)-delta;
                    end
                end
            end
            if updateP(i,j)>1
                delta=0.005+0.015*rand;
                updateP(i,j)=1-delta;
            end
            if updateP(i,j)<0
                delta=0.005+0.015*rand;
                updateP(i,j)=delta;
            end
        end
    end
    P=updateP;
    
    bestprofit=globalmaxfit;
    if bestprofit>unchangedSolution
        unchangedSolution=bestprofit;
        unchangedTime=0;
    else
        unchangedTime=unchangedTime+1;
    end
    if unchangedTime>500
        flagtermination=99;
    end     

disp(['iteration',num2str(unchangedTime),'bestfitness£º', num2str(bestprofit)])
end
result=[bestprofit gen];

