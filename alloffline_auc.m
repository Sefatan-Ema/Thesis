function [T TT]=FID_im();
%T is a 11 times 100 matrix, TT is the average values of each iterative
%time, that is it is a 11 time 10 matrix
DataMain= readmatrix('D:\Thesis\data\EEG_Eye_State_Classification.csv');

DatawithMain = xlsread('D:\Thesis\data\10%_EEG_Eye_State_Classification.csv');
DatawithMain=DatawithMain(1:2000, :);
DataMain= DataMain(1:2000, :);

A=DatawithMain;
%A=DataMain;
xdata=A(:,1:end-1);
group = A(:,end);
T=[];
TT=[];
for j=1:10
    indices = customKfold(group, 5);
    for i = 1:5
        Test = (indices == i); Train = ~Test;
        TrainingSample=xdata(Train,:);
        TrainingLabel=group(Train,1);
        TestingSample=xdata(Test,:);
        TestingLabel=group(Test,1);
        
        Training_data=[TrainingSample TrainingLabel]; % training data for resampling
        Training_data=FID_TFS_orginal(Training_data); % FID Oversampling
        %Training_data=proposed2_TFS(Training_data); % FAIA Oversampling
        %Training_data=SMOTE(Training_data); % SOMOTE Oversampling
        TrainingSample=Training_data(:,1:end-1);
        TrainingLabel=Training_data(:,end);
        
        
        tree=customFitctree(TrainingSample, TrainingLabel);
        OutLabel=customPredict(tree,TestingSample);
        %disp(OutLabel);
       [AUC ACC MCC GM F_measure]= NewOne(OutLabel,TestingLabel);
        results= [AUC ACC MCC GM F_measure]';
        T=[T results];
    end
    NANA=isnan(T);
    T(NANA)=0;
    STDD=mean(T')';
    TT=[TT STDD];
end

disp(STDD);