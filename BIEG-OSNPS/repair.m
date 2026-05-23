% repair
function [Re_P]=repair(P,weight,capacity)
[Ps,item]=size(P);
for i=1:Ps
    Curr_P=P(i,:);
    if sum(weight.*Curr_P)>capacity
        knapscakoverfilled=0;
        if sum(weight.*Curr_P)>capacity
            knapscakoverfilled=1;
        end
        while (knapscakoverfilled>0.5)
            position=1+floor(rand(1)*item);
            Curr_P(1,position)=0;
            if sum(weight.*Curr_P)<=capacity
                knapscakoverfilled=0;
            end
        end
        while (knapscakoverfilled<0.5)
            position=1+floor(rand(1)*item);
            Curr_P(1,position)=1;
            if sum(weight.*Curr_P)>capacity
                knapscakoverfilled=1;
            end               
        end          
        Curr_P(1,position)=0;
    end
    Re_P(i,:)=Curr_P;
end