clear
close all
xRuns=[];
subCC=0;
for sub=13%[8:11 14:17]
    subCC=subCC+1;
    trialXruns=[];
    for run=1%:4;
        if sub<=3
            load(['OutPut_TimeCourse_Semantic_Retrieval_exp_s' num2str(sub) '_r' num2str(run) '.mat'])
            recoverMe
            allTrials=newAllTrial;
              myISIs=[ 0.1500    0.2129    0.3021    0.4287    0.6083    0.8632];
        elseif sub==[4:7]
        load(['OutPut_TimeCourse_Semantic_Retrieval_exp_s' num2str(sub) '_r' num2str(run) '.mat'])
%                    load(['OutPut_TimeCourse_Semantic_Retrieval_exp_s' num2str(sub) '_r' num2str(run) '.mat'])      
              myISIs= [0.1000    0.1539    0.2368    0.3644    0.5607    0.8628];
              recoverMe;
            allTrials=newAllTrial;
%             load (['OutPut_StimCheck_behavioral_s' num2str(sub)])
%             theUnknown={myTrials([myTrials.resp]==2).name};
        elseif sub>=8
             load(['OutPut_TimeCourse_Semantic_feedback_s' num2str(sub) '_r' num2str(run) '.mat'])
%                    load(['OutPut_TimeCourse_Semantic_Retrieval_exp_s' num2str(sub) '_r' num2str(run) '.mat'])      
              myISIs= [0.1000    0.1539    0.2368    0.3644    0.5607    0.8628];
%               recoverMe;
%             allTrials=newAllTrial;
%             if run==1
             load (['OutPut_StimCheck_behavioral_s' num2str(sub)])
            theUnknown={myTrials([myTrials.resp]==2).name};
%            disp([num2str(length(theUnknown)) '_' num2str(sub)])
%             end
        %%
%         for jj=1:length([allTrials.psCode]==1)
%             if any(strcmp({allTrials(jj).name},theUnknown))
%                 toDelete(jj)=allTrials(jj);
%                 disp('trial rejected')
%                 
%             end
%         end
        end
        for ii=find([allTrials.resp]>0)
            if allTrials(ii).psCode==1
                % %                 if any(strcmp({allTrials(ii).name},theUnkown))%|strcmp(allTrials(2).name,theUnkown))
                % %                     allTrials(ii)=[];
                % %                     ii=ii-1;
                % %                     disp('trial rejected')
                % %                 end
                ind=find(allTrials(ii).trialCode==[allTrials.trialCode]);
                targLoc=find([allTrials(ind).isTarget]);
                try
                    allTrials(ii).targPair={allTrials(ind(targLoc)-1:ind(targLoc)).name};
                catch
                    disp('not working coz old subjects')
                end
            end
        end
        trialTemp=1;
        for ii=2:length(allTrials)
            
            allTrials(ii).trialCode=trialTemp;
            if allTrials(ii).resp~=0
                trialTemp=trialTemp+1;
            end
        end
        
        %%
        allTrials=allTrials(find([allTrials.resp]~=0));
        
        %%
        yesResp=allTrials(find([allTrials.resp]==1));
        noResp=allTrials(find([allTrials.resp]==2));
        totResp=[yesResp noResp];
        for jj=1:length(totResp)
            if totResp(jj).resp==totResp(jj).psCode
                totResp(jj).hit=1;
            else
                totResp(jj).hit=0;
            end
        end
        trialSum=totResp;
        
        for ii=1:length(trialSum)
            trialSum(ii).ISI=trialSum(ii).imDuration;
            trialSum(ii).targTrial=trialSum(ii).psCode;
        end
        
        for myTask=1:4
            for iii=1:length(myISIs)
                ind=find(round([trialSum.ISI]*1000)==round(myISIs(iii)*1000)&[trialSum.task]==myTask);
                myCount(myTask,iii)=length(ind);
                score(myTask,iii)=mean([trialSum(ind).hit]==1); % works to check if pressed for targ and didnt for non targ
            end
        end
        scorexRun(run,:,:)=score;
        myCountxRun(run,:,:)=myCount;
        
    end
    if run>1
    accAll(subCC,:,:)=squeeze(nansum((scorexRun.*myCountxRun))./sum(myCountxRun));
    else
         accAll(subCC,:,:)=squeeze(scorexRun);
    end
    % equivalent to: =squeeze(mean(scorexRun))
end
squeeze(mean(accAll))
%%
figure
subplot(1,1,1)
plot(squeeze(mean(accAll))')
legend({'g','f','p','fa'},'Location','best')
figure(gcf)
%%
figure
for ii=1:4
    subplot(1,4,ii)
plot(squeeze((accAll(:,ii,:)))')
hold on 
plot(squeeze(mean(accAll(:,ii,:)))','--','LineWidth',3)
hold off
end
