% knapsack problem

clear all
clc
format long;
runs=1;
item=1000;
bestsolution=zeros(1,runs);

time1=cputime;
for i=1:runs
      [result]=programOSNP1000(item);
      bestsolution(1,i)=result(1,1);
      maxGen(1,i)=result(1,2);
end
elapsedtime=(cputime-time1)/runs;

save resultitem1000 bestsolution maxGen elapsedtime;