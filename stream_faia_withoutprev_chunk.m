
DataMain= readmatrix('D:\Thesis\data\EEG_Eye_State_Classification.csv');

%DatawithMain = xlsread('D:\Thesis\data\5%_EEG_Eye_State_Classification.csv');
%DatawithMain = xlsread('D:\Thesis\data\10%_EEG_Eye_State_Classification.csv');
%DatawithMain = xlsread('D:\Thesis\data\15%_EEG_Eye_State_Classification.csv');
DatawithMain = xlsread('D:\Thesis\data\20%_EEG_Eye_State_Classification.csv');
DataMain=DataMain(1:2000, :);
DatawithMain=DatawithMain(1:2000, :);
DatawithMean=DatawithMain;

[Row,Column]=size(DatawithMain);

 %disp(Row);
DataStreamNumber=500;
totalDiv=fix(Row/DataStreamNumber);
Reminder=rem(Row,DataStreamNumber);
T=[];

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
    
        Training_data=[TrainingSample TrainingLabel]; % training data for resampling
       Training_data=Proposed2_TFS(Training_data);
        TrainingSample=Training_data(:,1:end-1);
        TrainingLabel=Training_data(:,end);
        
        tree=customFitctree(TrainingSample, TrainingLabel);
     OutLabel=customPredict(tree,TestingSample);
        
        %disp(OutLabel);
        [AUC ACC MCC GM F_measure]= NewOne(OutLabel,TestingLabel);
        results= [AUC ACC MCC GM F_measure]';
        TT=[TT results];
        
   end
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
        
        Training_data=[TrainingSample TrainingLabel]; % training data for resampling
      
    
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
   
   Ava=mean(TT')';
   T=[T,Ava];
   
end
disp(T);
disp(Ava);