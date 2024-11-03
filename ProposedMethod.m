function AfterFID1= ProposedMethod(A)
DatawithMain=A;

%DataMain= readmatrix('D:\Thesis\data\EEG_Eye_State_Classification.csv');
%DatawithMain = xlsread('D:\Thesis\data\5%_EEG_Eye_State_Classification.csv');
%DatawithMain = xlsread('D:\Thesis\data\10%_EEG_Eye_State_Classification.csv');
%DatawithMain = xlsread('D:\Thesis\data\15%_EEG_Eye_State_Classification.csv');
%DatawithMain = xlsread('D:\Thesis\data\20%_EEG_Eye_State_Classification.csv');
%DatawithMain=DatawithMain(1:10000, :);
DatawithMean=DatawithMain;
[numLines,numCols]=size(DatawithMain);

%%% ............. Assing mean values..........
%for colum = 1:numCols
    %col_mean = nanmean(DatawithMean(:,colum)); % Compute the mean, ignoring NaN values
    %DatawithMean(isnan(DatawithMean(:,colum)), colum) = col_mean; % Replace NaNs with the mean
%end

for colum=1:numCols
    
        sum=0;
        count=0;
    for row=1:numLines
        
        if(isnan(DatawithMean(row,colum))~=1)
            sum= sum + DatawithMean(row,colum);
            count=count+1;
        end
        
    end
    avarage=sum/count;
    
    for row= 1:numLines
        if(isnan(DatawithMean(row,colum))==1)
            DatawithMean(row,colum)=avarage;
        end
    end
end

%%%%%%%%.............. Fuzzy decomposion Imputation.....

MissingMatrix= isnan(DatawithMain);

AfterFID1=DatawithMain;

for colum= 1:numCols
     x=zeros(numLines,1);
        for row = 1:numLines
           x(row,1)=DatawithMain(row,colum); 
        end
        %missing value counting 
         sumValue = 0;
         missing = isnan(x);
          for miss=1:numLines
            if(missing(miss)==1)
                sumValue=sumValue+1;
            end
          end
    
            sample=0;
          
            linerow=numLines;
 
            minimum = min(x);
            maximum = max(x);
            TOtalMissingValue=sumValue+sample;
            h=((maximum-minimum))/TOtalMissingValue;
            a=0;
            TOtalMissingValue1=TOtalMissingValue+1;
            U=zeros(1,TOtalMissingValue1);
            %.........Finding Intervals.......
            Is=zeros(TOtalMissingValue1,2);
            for j=1:TOtalMissingValue1
                p=-1;
                for o=1:2
                Is(j,o)=(minimum+(j+p)*(h));
                p=0;
                end
                U(1,j)=(Is(j,1)+Is(j,2))/2;
            end
 %.................. Finding Vlaues in Intervalessss...........
            membershipFuntion=zeros(linerow,TOtalMissingValue1);
            for j=1:linerow
                for g=1:TOtalMissingValue1
                    if(Is(g,1)<= x(j) && Is(g,2)>x(j))
                        %va=exp((-1/2)*((x(j)-U(1,g)).^2/h));
                        va=abs(x(j)-U(1,g));
                    
                        membershipFuntion(j,g)=exp (-(abs(x(j)-U(1,g))/h));
                       %mu(j,g)=exp((-1/2)*((x(j)-U(1,g)).^2/h));
                    else
                        membershipFuntion(j,g)=0;
                    end
                end
            end
 %................  Finding Similarities amnong the member Ship Function.....
 for Rows=1:linerow
     if( isnan(x(Rows)))
        % disp(x(Rows));
    FindingDistence=zeros(linerow,TOtalMissingValue1);
 
                for intervals=1:TOtalMissingValue1
                     
                   for lines=1: linerow
                       Distence=0;
                        if(membershipFuntion(lines,intervals)~=0)
                            
                            for columsValues=1:numCols
                                 if(colum ~= columsValues && Rows~= lines)
                                
                                     Distence=Distence+(DatawithMean(Rows,columsValues)-DatawithMean(lines,columsValues)).^2;
                                 end
                            end
                            FindingDistence(lines,intervals)=sqrt(Distence);
                           
                        end
                   end
                end
           
%................... Finding Minimum intervals......................
  DistenceMinimum=zeros(TOtalMissingValue1,1);
 for NumberMissing= 1:TOtalMissingValue1
     total=0;
     count=0;
        for rows=1:lines
            if(FindingDistence(rows,NumberMissing) ~= 0)
                count=count+1;
                total= total+FindingDistence(rows,NumberMissing);
            end
        end
        DistenceMinimum(NumberMissing)=total/count;
 end
 
 [FindingMinimumValues positions]=min(DistenceMinimum);
 
 %............. Retriving missing values........................
 
 weightedM=zeros(linerow,1);
 totalMembership=0;
 totalMainValues=0;
 for j=1:linerow
    if(membershipFuntion(j,positions) ~=0)           
        weightedM(j)= membershipFuntion(j,positions)*x(j);
        totalMembership= totalMembership +  membershipFuntion(j,positions); 
        
    end    
 end
 Sum=0;
 if( totalMembership ~=0)
    for f=1:linerow
     Sum= Sum+weightedM(f);
    end
    x(Rows)= Sum/ totalMembership;
 else
     x(Rows)=mean(x);
 end
 
          
     end
end          

%................ Updating Values in the datasets.................
        for row = 1:numLines
          AfterFID1(row,colum)= x(row,1); 
        end
    
end
%writematrix(AfterFID1, 'D:\Thesis\data\RESULTp.xlsx');
AfterFID1=AfterFID1;
