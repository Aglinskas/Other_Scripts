cd /Volumes/Aidas_HDD/MRI_data/
subVec= [24:30]
A=dir('S*')
for i = 1:length(A)
    subFold{i}=A(i).name;
end
subFold(find(~[A.isdir]))=[];
myResults=[];
pwd=cd;
subCC=0
assessor=[];
figure
translation=true
for sub=subVec
    
    subCC=subCC+1;
    for j=1:length(dir (['./S' num2str(sub) '/Functional/Sess' '*']));
        fName= dir (['./S' num2str(sub) '/Functional/Sess' num2str(j) '/rp*.txt']) ;
        myMot=load (['./S' num2str(sub) '/Functional/Sess' num2str(j)  '/' fName(1).name]) ;
        %myMot(:,4:6)=myMot(:,4:6)*mean(range(myMot(:,1:3)))/mean(range(myMot(:,4:6)));
        subplot(length(subVec),5,j+(subCC-1)*5)
        if translation
            plot(myMot(:,1:3));
        else
            plot(myMot(:,4:6));
        end
        axis([1,length(myMot),-4, 4])
        assessor(subCC,j)=max(range(myMot));
        title(num2str(sub))
        
    end
    pause(.1)
end