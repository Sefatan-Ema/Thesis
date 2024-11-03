DataMain= readmatrix('D:\Thesis\data\EEG_Eye_State_Classification.csv');

DatawithMain = xlsread('D:\Thesis\data\20%_EEG_Eye_State_Classification.csv');
DatawithMain=DatawithMain(1:2000, :);
DatawithMean=DatawithMain;
[Row,Column]=size(DatawithMain);

DataStreamNumber=500;
Reminder=rem(Row,DataStreamNumber);
totalDiv=fix(Row/DataStreamNumber);
T=[];
Mpre=[];
MinoritySample=[];
   MinorityLable=[];
DataCounting=0;
for j=1:totalDiv
    InitializationData=DatawithMain(DataCounting+1:DataCounting+DataStreamNumber,:);
    xdata=InitializationData(:,1:end-1);
    group = InitializationData(:,end);
    indices = customKfold(group, 2);
    TT=[];
   for i = 1:2
         Test = (indices == i); Train = ~Test;
        TrainingSample=xdata(Train,:);
        TrainingLabel=group(Train,1);
        TestingSample=xdata(Test,:);
        TestingLabel=group(Test,1);
        if ~isempty(Mpre)
            TrainingSample=[TrainingSample;MinoritySample];
            TrainingLabel=[TrainingLabel;MinorityLable];
        end
        
        Training_data=[TrainingSample TrainingLabel]; % training data for resampling
       
       %Training_data=SMOTEstream(Training_data);% Smot Oversampling

       %Training_data=FID_TFS_orginal(Training_data);% FID Oversampling
       Training_data=Proposed2_TFS(Training_data);
        TrainingSample=Training_data(:,1:end-1);
        TrainingLabel=Training_data(:,end);
        
        tree=customFitctree(TrainingSample, TrainingLabel);
     OutLabel=customPredict(tree,TestingSample);
        
        %disp(OutLabel);
        [AUC ACC MCC GM F_measure]= NewOne(OutLabel,TestingLabel);
        results= [AUC ACC MCC GM F_measure]';
        TT=[TT results]
   end
   [MRow Mcol]=size(InitializationData);
   us1=find(InitializationData(:,Mcol)==1);
   Mpre=InitializationData(us1,:);
   MinorityLable=Mpre(:,end);
   MinoritySample=Mpre(:,1:end-1);
   Ava=mean(TT')';
   T=[T,Ava];
   DataCounting=DataCounting+DataStreamNumber;
end
if Reminder>0
InitializationData=DatawithMain(DataStreamNumber+1:DataStreamNumber+Reminder,:);
xdata=InitializationData(:,1:end-1);
    group = InitializationData(:,end);
    indices = customKfold(group, 2);
    TT=[];
   for i = 1:2
         Test = (indices == i); Train = ~Test;
        TrainingSample=xdata(Train,:);
        TrainingLabel=group(Train,1);
        TestingSample=xdata(Test,:);
        TestingLabel=group(Test,1);
        if ~isempty(Mpre)
            TrainingSample=[TrainingSample;MinoritySample];
            TrainingLabel=[TrainingLabel;MinorityLable];
        end
        Training_data=[TrainingSample TrainingLabel]; % training data for resampling
      
       %Training_data=SMOTEstream(Training_data);% FID Oversampling
        %Training_data=FID_TFS_orginal(Training_data); % FID Oversampling
        Training_data=Proposed2_TFS(Training_data);
        TrainingSample=Training_data(:,1:end-1);
        TrainingLabel=Training_data(:,end);
        
       tree=customFitctree(TrainingSample, TrainingLabel);
     OutLabel=customPredict(tree,TestingSample);
        %disp(OutLabel);
        [AUC ACC MCC GM F_measure]= NewOne(OutLabel,TestingLabel);
        results= [AUC ACC MCC GM F_measure]';
        TT=[TT results]
   end
   [MRow Mcol]=size(InitializationData);
   us1=find(InitializationData(:,Column)==1);
   Mpre=InitializationData(us1,:);
   MinorityLable=Mpre(:,end);
   MinoritySample=Mpre(:,1:end-1);
   Ava=mean(TT')';
   T=[T,Ava];
   
end
disp(T);
disp(Ava);