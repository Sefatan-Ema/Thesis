function Dataset= SMOTE(original_sample)
    data = xlsread('E:\MSc\Thesis\Dataset\KC2\KC2 Main data.xlsx','A1:V37');
    data= original_sample;
    
    [Row Column]=size(data);
    positivesample=find(data(:,end)==1);
    negtivesample=find(data(:,end)==0);
    PT=data(positivesample,:);
    NT=data(negtivesample,:);
    [PT1 PT2]=size(PT);
    [PN1 PN2]=size(NT);

    newdata = data;
    NumberOfSMOTE=500;
   
    NumberOfSMOTE=int64(NumberOfSMOTE/100);
    K=5;

    
    %%%%%% without class labels......
    DataWLable=data;
    DataWLable(:,Column)=[]; 
    positive=PT;
    positive(:,Column)=[];
    
    for i=1:PT1
        Distances= zeros(Row-1,2);
       for row=1:Row
          if row~=positivesample(i)
              Distances(row,1) = sqrt(sum((DataWLable(row,:)-positive(i,:)).^2));
              Distances(row,2) = row;
          end
       end
        AfterSort=sortrows(Distances);
       AfterSort(1,:)=[];
       Array=randi(K,1,NumberOfSMOTE);
        for N=1:NumberOfSMOTE
             synthetic=zeros(1,Column);
           for att=1:Column-1
              diff=data(AfterSort(Array(N),2),att)-PT(i,att);
              gap=rand;
              synthetic(1,att)=PT(i,att)+(gap*diff);
           end
           synthetic(1,Column)=1;
           newdata=[newdata;synthetic];
        end
    end
    Dataset=newdata;
    