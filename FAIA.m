DatawithOri = xlsread('D:\Thesis\data\EEG_Eye_State_Classification.csv');
%DatawithMain = xlsread('D:\Thesis\data\5%_EEG_Eye_State_Classification.csv');
%DatawithMain = xlsread('D:\Thesis\data\10%_EEG_Eye_State_Classification.csv');
DatawithMain = xlsread('D:\Thesis\data\15%_EEG_Eye_State_Classification.csv');
%DatawithMain = xlsread('D:\Thesis\data\20%_EEG_Eye_State_Classification.csv');
origin=DatawithOri(1:2000, :);
DatawithMain=DatawithMain(1:2000, :);

%Only Missing............................................................
%FID_data=ProposedMethod(DatawithMain);
%FID_data=ProposedMethod2(DatawithMain);
%FID_data=coefficient_IDIM_recovery(DatawithMain);
%Only called by datastream2.......
%FID_data=Proposed2(DatawithMain);
%........................................................................
%only for imbalence.....................................................
%FID_data=SMOTE_TFS(DatawithOri);

%..............................................................................

%missing with imbalence.......................................................
FID_data=Proposed2_TFS(DatawithMain);%proposed mathod call kora

%FID_data=FID_TFS_orginal(DatawithMain);
%..............................................................................



FID_data=FID_data(1:2000, :);
rmse_value=RMSE(origin, FID_data);
disp(rmse_value);
