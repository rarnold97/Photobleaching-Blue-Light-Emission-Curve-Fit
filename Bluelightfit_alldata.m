control = 0 ; 

while control == 0 
 
try 
 
file = input('\nEnter the File Name: ','s');
%sheet = input('\nEnter Sheet Name: ','s') ;

File = importdata(file) ; 
 
control = 1  ; 
 
catch 
    
    control = 0 ; 
end 

end

control = 0 ; 
while control == 0
    choice = input('\nIf you are testing Pt enter 1.\nIf you are testing Pd enter 2: ');
    if choice == 1 || choice == 2
        control = 1 ; 
    else
        %do nothing 
    end
end
A = struct2cell(File.data) ;

[M,N] = size(A) ; 

Compositions = A(2:M) ;
%Note: if all of your tabs are data then switch the 2 to a 1. In my case I
%have a data analysis tab in my spreadsheet, so this line of code skips
%that tab and only scans the tab with data 

p = 1 ; 

size_comp = M - 1 ; 
subtracted_intensity = zeros(size_comp,7) ; 
Treated_data_struct.day = [0,1,3,7,14,28,41.667] ; 
Treated_data_struct.data.comps = {'0.1wt% 37C' ; '0.1wt% 50C'; '0.5wt% 37C' ; '0.5wt% 50C'; '3wt% 37C' ; '3wt% 50C'; '10wt% 37C' ; '10wt% 50C'} ; 

while p < M
    
    Sheet = Compositions(p) ; 
    
    All_days = Sheet{1} ; 
    
    [R,C] = size(All_days) ; 
    
    i = 1 ;
    
    j = 2 ; 
    
    k = 1 ; 
    
    X = zeros(R,(C/2)) ; 
    
    Y = zeros(R,(C/2)) ; 
    
    while j <= C        
        
        X(:,k) = All_days(:,i) ; 
        
        Y(:,k) = All_days(:,j) ; 
        
        i = i + 2;
        j = j+ 2 ; 
        k = k + 1 ; 
    end
    
    %treat data here
    if choice == 1
        wavelength_index = find(All_days(:,1) == 652.35) ;
    elseif choice == 2
        wavelength_index = find(All_days(:,1) == 673.93) ;
    end
    
    h = 1 ; 
    for z = 1:1:(C/2)
    %subtracted_intensity where p is the sheet number and h is the day     
    subtracted_intensity(p,h) = Extrapolate(X(:,z),Y(:,z),wavelength_index,p) ; 
    h = h + 1 ; 
    end
    %record the sheets to the struct to better record and organize the data
    
    Treated_data_struct.data.intensity_fitted(p) = {subtracted_intensity(p,1:(h-1))} ; 
    
    %loop function until size x and y for each day and make function output
    %desired intensity 
    %output data to excel here for plotting 
     p = p + 1 ; 
end 
k = 1 ; 
for i = 1:3:(size_comp-2)
   
    sample1 = cell2mat ( Treated_data_struct.data.intensity_fitted(i) ); 
    sample2 = cell2mat ( Treated_data_struct.data.intensity_fitted(i +1) ); 
    sample3 = cell2mat ( Treated_data_struct.data.intensity_fitted(i +2) );
    limit = size(sample1) ; 
        for j = 1:1:limit(2)
            Average_I(j) = (sample1(j) + sample2(j) + sample3(j) ) / 3 ;  
            STD(j) = std([sample1(j)  sample2(j)  sample3(j)]) ; 
        end
    Treated_data_struct.data.I_norm(k) = { [Average_I(2:limit(2)) ] / Average_I(1) } ;  
    Treated_data_struct.data.stdev(k) = { STD(2:limit(2)) / Average_I(1) } ; 
    k = k + 1 ; 
end

saveplot(Treated_data_struct)

