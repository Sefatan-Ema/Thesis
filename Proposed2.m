function FID_data=Proposed2(Data_sample); 
DatawithM=Data_sample;
%DatawithMain=xlsread('F:\Datastreaming Reasearch\Data\data With Details\KC3\10% NaN value05.xlsx','A1:AM458');
%DatawithMain=xlsread('D:\Thesis\Datasets\Page Block (1)\Page Block (1) with 10% NaN value.xlsx');
%DatawithMain = xlsread('D:\Thesis\Datasets\Hyperplane\hyperplaneOrginal with 15% NaN value.xlsx','A1:AM161');
DatawithMean=DatawithM;
[Row,Column]=size(DatawithM);

    AfterFID1=DatawithM;
    %%% ............. Assing mean values..........
    for colum=1:Column
            
            Sum=0;
            count=0;
        for row=1:Row

            if(isnan(DatawithMean(row,colum))~=1)
                Sum= Sum + DatawithMean(row,colum);
                count=count+1;
            end

        end
        avarage=Sum/count;
      
        for row= 1:Row
            if(isnan(DatawithMean(row,colum))==1)
                DatawithMean(row,colum)=avarage;
            end
        end
    end
%disp(avarage);
    % Decomposition.........
  
  for column=1:Column
        %disp(column);
       x=DatawithM(:,column);
       Missing=(isnan(x));

       TotalMissingData=0;
       for j=1:Row
           if(Missing(j)==1)
               TotalMissingData=TotalMissingData+1;
           end
       end
       
       % while TotalMissingData<0
        if TotalMissingData>0
           Maximum=max(x);
           %Minimum= nanmin(x);
           Minimum = min(x(~isnan(x)));

           h=(Maximum-Minimum)/TotalMissingData;
           if h~=0

               %%%%% Finding U values
               Interval=zeros(TotalMissingData,2);
               U=zeros(1,TotalMissingData);
               %Interval(1
               for i=1:TotalMissingData
                   Interval(i,1)=Minimum+((i-1)*h);
                   Interval(i,2)=Minimum+(i*h);
                   U(1,i)=(Interval(i,1)+Interval(i,2))/2;
               end

               %%% Finding memebership function................
               MemberShipFunction=zeros(Row,TotalMissingData);
               numberofMembership=zeros(1,TotalMissingData);
               
               for j=1:Row
                   if Missing(j)==0
                       Dis=zeros(TotalMissingData,2);
                       for i=1:TotalMissingData
                        Dis(i,1)=abs(x(j,1)-U(1,i));
                        Dis(i,2)=i;
                       end
                       [Aftersort positions]=min(Dis(:,1));
                       %m=Aftersort(1,1);

                       num=0;
                       for i=1:TotalMissingData
                           %disp(i);
                           %disp(Dis(i,1));
                           if Dis(i,1)== Aftersort
                               num=num+1;

                           end
                       end


                       %nums=size(num);%%% Counting the number
                      if num==1
                        %disp(h);
                         MemberShipFunction(j,Dis(positions,2))= exp (-(abs(x(j,1)-U(1,Dis(positions,2)))/h));%(1-(abs(x(j,1)-U(1,Dis(positions,2)))/h);
                        %disp( (abs(x(j,1)-U(1,Dis(positions,2)))/h));
                      else
                          position=find(Dis(:,1)== Aftersort);
                         % disp(Dis(position(:),2));
                          for k=1:num

                              MemberShipFunction(j,Dis(position(k),2))=exp (-(abs(x(j,1)-U(1,Dis(positions,2)))/h));

                          end
                      end

                   end
               end

               for y=1:TotalMissingData
                   numberofMembership(1,y)=nnz(MemberShipFunction(:,y)); %%%%non zeros elements..........
                   numberofMembership(2,y)=y;
               end
               newMember=zeros(2,TotalMissingData);

               count=1;
               for y=1:TotalMissingData
                   if  numberofMembership(1,y)~=0
                       %numberofMembership(2,y)=[];
                      newMember(:,count)= numberofMembership(:,y);
                      count=count+1;
                   end
               end
               %newMember=newMember(any(newMember,2),:);
                nonzerosMembership=newMember(:,1:count-1);
               K = min(nonzerosMembership(1,:));
               [sizeRow sizColumn]=size(nonzerosMembership);
               %%%%% Finding missing values......
               for row=1:Row
                   if(Missing(row)==1)
                       values=DatawithMean(row,:);
                       %disp(row);
                       %disp(DatawithMean(row,:));
                       %dis=zeros(nonzerosMembership,2);
                       Avarage=zeros(sizColumn,2);

                       for col=1:sizColumn

                          n= nonzerosMembership(2,col);
                          %disp(n);
                          distance=zeros(Row,1);
                          count=1;
                          for j=1:Row
                              if MemberShipFunction(j,n)~=0
                                  Roenumber=j;
                                  for d=1:Column
                                     if d~= column
                                         distance(count,1)=distance(count,1)+(values(1,d)-DatawithMean(j,d)).^2;
                                     end
                                  end
                                  distance(count,1)=sqrt(distance(count,1));
                                  count=count+1;
                              end
                          end
                          Beforsorting=distance(1:count-1,1);
                          sorting=sortrows(Beforsorting);
                          Sum=0;
                          for k=1:K
                             Sum=Sum+sorting(k); 
                          end

                          Avarage(col,1)=Sum/K;
                          Avarage(col,2)=n;
                          %disp(Avarage(col));
                       end
                       [minumvalue, minimumposition]=min(Avarage(:,1));
                       %disp(minimumposition);
                        weighted=MemberShipFunction(:,Avarage(minimumposition,2));
                        %disp(weighted);
                        Sumation=0;
                        sumatioDivided=0;
                        for kl=1:Row
                           if  weighted(kl,1)~=0
                            Sumation=Sumation+( weighted(kl,1)*x(kl,1));
                            sumatioDivided=sumatioDivided+weighted(kl,1);
                           end
                        end

                        if sumatioDivided~=0
                           x(row,1)=Sumation/sumatioDivided;


                        end
                   end
         end
           else
               for j=1:Row
                   if(Missing(j)==1)
                       x(j,1)=0;
                   end
               end
           end
           % Missing=(isnan(x));
            %TotalMissingData=0;
           %for j=1:Row
              % if(Missing(j)==1)
                  % TotalMissingData=TotalMissingData+1;
               %end
           %end
           %disp(TotalMissingData);

         AfterFID1(:,column)=x(:,1);
    
        end
       
    end
   

FID_data=AfterFID1;
%writematrix(FID_data, 'D:\Thesis\data\RESULTh1.xlsx');