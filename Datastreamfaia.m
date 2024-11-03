
DataMain= readmatrix('D:\Thesis\data\EEG_Eye_State_Classification.csv');

%DatawithMain = xlsread('D:\Thesis\data\5%_EEG_Eye_State_Classification.csv');
%DatawithMain = xlsread('D:\Thesis\data\10%_EEG_Eye_State_Classification.csv');
%DatawithMain = xlsread('D:\Thesis\data\15%_EEG_Eye_State_Classification.csv');
%DatawithMain = xlsread('D:\Thesis\data\20%_EEG_Eye_State_Classification.csv');
DataMain=DataMain(1:1500, :);
DatawithMain=DatawithMain(1:1500, :);
DatawithMean=DatawithMain;

[Row,Column]=size(DatawithMain);

 disp(Row);
DataStreamNumber=200;
totalDiv=fix(Row/DataStreamNumber);
Reminder=rem(Row,DataStreamNumber);
InitializationData=DatawithMain(1:DataStreamNumber,:);
 
TrainDataPositive = Proposed2(InitializationData);

Returndata=zeros(200,Column);
    for i=1:200
         Returndata(i,:)= TrainDataPositive((i),:);
    end
Main=DataMain(1:DataStreamNumber,:);
%disp(DataStreamNumber);
[Row,Column]=size(Returndata);
%disp(Row);
AnsRMSE=  RMSE(Returndata,Main); 
Avarage=AnsRMSE;
count=1;
%disp(Avarage);
%disp(count);

for j=2:totalDiv
    
   InitializationData=DatawithMain(DataStreamNumber+1:DataStreamNumber+200,:);
   [DRow, DColumn]=size(TrainDataPositive);
   TrainDataPositive= [TrainDataPositive;InitializationData];
   TrainDataPositive= Proposed2(TrainDataPositive);
   Returndata=zeros(200,Column);
    for i=1:200
         Returndata(i,:)= TrainDataPositive((i+DRow),:);
    end
   Main=DataMain(DataStreamNumber+1:DataStreamNumber+200,:);
    AnsRMSE=  RMSE(Returndata,Main); 
    Avarage=[Avarage;AnsRMSE];
    count=count+1;
    %disp(Avarage);
%disp(count);
    DataStreamNumber=DataStreamNumber+200;
    
end

%Remaining values.............
 InitializationData=DatawithMain(DataStreamNumber+1:DataStreamNumber+Reminder,:);
  [DRow,DColumn]=size(TrainDataPositive);
   TrainDataPositive=[TrainDataPositive;InitializationData];
   TrainDataPositive=Proposed2(TrainDataPositive);
   Returndata=zeros(Reminder,Column);
    for i=1:Reminder
         Returndata(i,:)= TrainDataPositive((i),:);
    end
   Main=DataMain(DataStreamNumber+1:DataStreamNumber+Reminder,:);
   AnsRMSE=  RMSE(Returndata,Main); 
   Avarage=[Avarage;AnsRMSE];
   count=count+1;
   %disp(Avarage);
%disp(count);
Result=sum(Avarage)/count;
disp(Result);
%rmse_table = array2table(rmse_values, 'VariableNames', strcat(string(percentages), '%'));
%writematrix(Result, 'D:\Thesis\Strem\rmsestem_values.csv');