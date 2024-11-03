function FID_data=Proposed2_TFS(original_sample);  % FID
file_data=original_sample;
A=file_data;
[rows cols]=size(A);
us0=find(A(:,cols)==0);
A0=A(us0,:);
[A01 A02]=size(A0);
us1=find(A(:,cols)==1);
A1=A(us1,:);
[m n]=size(A1);


%%% Counting number of new instances need to be creating

 Difference=A01-m;
 percentage=.8;
 balance=A01*(.8);
 Synhetic=balance-m;

R1=Synhetic;
%         for i=1:2
k=R1+m;
k=floor(k);
B2=zeros(rows+k,cols);
B2(1:rows,:)=A;
B2(rows+1:rows+k,:)=NaN;
B2(rows+1:rows+k,cols)=1;
[ins att]=size(B2);
b=randperm(ins);
B2=B2(b,:);
r2=B2(:,end); % find out label
r2=find(r2==1);
C=B2(r2,:);
%G2=Moifiedimplement(C);
G2=ProposedMethod(C);
%disp(G2);
%disp(A);
G2=[A; G2];
G2=ProposedMethod(G2);
%G2=Moifiedimplement(G2);
data=G2;

FID_data=data;