function[] = saveplot(Treated_data_struct)

loop_limit = size(Treated_data_struct.data.I_norm) ; 

for i=1:1:loop_limit(2)
   
I_values = cell2mat( Treated_data_struct.data.I_norm(i) ) ; 
day_limit = size(I_values) ;
Days_xvalues = Treated_data_struct.day( 2:(1+day_limit(2)) );
stdev = cell2mat(Treated_data_struct.data.stdev( i ) ); 

X = Days_xvalues ; 
Y = I_values ; 
Y_toperrorbar = I_values + stdev  ;
Y_boterrorbar = I_values - stdev   ; 


control = 0 ; 
while control == 0
  
try
fprintf('\nPlot # = %i; ',i)  
string = input('Please Enter a title for corresponding plot, add.pdf as file extension: ','s') ;    

plot(X,Y,'-o') ;

hold on
plot(X,Y_toperrorbar, '*') ; 
plot(X,Y_boterrorbar, '*') ; 
hold off

title(string);  
xlabel('Day')  
ylabel('Normailized Intensity I/I0')  
ylim([0 1.5])
xlim([0 42])    

%plot error bars 


saveas(gcf,string) ;


control = 1 ; 
catch
    control = 0 ;
    fprintf('\nPlot # = %i; ',i)  
    string = input('Please Enter a title for corresponding plot, add.pdf as file extension: ','s') ;
end
end

end



%Currentfolder = pwd ; 
%mkdir(Currentfolder , 'Intensity_plots')
%newfoldername = ('\Intensity_plots') ; 
%NewFolder = [Currentfolder,newfoldername] ; 
%cd(NewFolder) 



close all


end