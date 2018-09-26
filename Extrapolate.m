function[adjusted_int] = Extrapolate(X,Y,wave_index,k)

i =  1 ; 
control = 1 ; 
%measure the size of the array to determine a stopping point in the scan 
size = length(Y)  ;
while (control > 0) && (i +100 < size) 
    %measure the difference in intenisty values that are reasonably spread
    %apart
    D = Y(i+100) - Y(i) ; 
     if (D < 0) && (abs(D) > 0.1 *(Y(i)))
     control = 0 ; 
     %break the loop if the difference is negative and a significant amount
     %less than the last point.  this ensures we get only the desired
     %portion of the curve
     else
         
         i = i+1 ; 
     
     end 
    
end
%measure where to start the new curve 
point1 = i + 100 ;

control = 1 ; 
%this next loop does essentially the same thing but instead measures when
%the curve transitions to the overlap region attributed to the scaffold
%intensity 
while (control > 0) && (i +10 < size) 
    D = Y(i+10) - Y(i) ; 
     if (D > 0) && (abs(D) > 0.01 *(Y(i)))
     control = 0 ; 
     
     else
         
         i = i+1 ; 
     
     end 
    
end
%measure the endpoint of the curve 
point2 = i + 10  ; 

%scan in the data from the specified interval
curve1y = Y(point1:point2) ; 
curve1x = X(point1:point2) ; 

curve2y = Y(1310:size) ; 
curve2x =  X(1310:size) ; 
extrapolaterange_y = vertcat(curve1y ,curve2y  )  ;
extrapolaterange_x = vertcat(curve1x , curve2x )  ; 

%curve1y(point2 + 1) = Y(1250) ; 
%curve1x(point2 + 1) = X(1250)  ;

%plot the raw data for comparison
%**********
plot(X(point1:size), Y(point1:size),'-k')
plot_name = sprintf('Spreadsheet tab %i',k) ;
title(plot_name)
xlabel('Wavelength nm')
ylabel('Intensity in Photon Counts') 
%***********

%full_fitrangex = X(point1:size) ; 
%full_fitrangey = Y(point1:size) ; 

%fit with an exponential curve

%Fn = fit(curve1x,curve1y,'exp2') ;

%change exp2 to a better fit type if necessary
%Fourier Series

Fn = fit(extrapolaterange_x,extrapolaterange_y ,'exp2') ;
%Fn = fit(X,Y,'exp2', 'Start',full_fitrangex,'Exclude', (X>620)) ; %X(770:1250) ) ; 
%retrieve coefficents from the struct

%*******Exponential********
a = Fn.a ;
b = Fn.b ; 
c = Fn.c ; 
d = Fn.d ; 
%**********

%*******Rational************
%p1 = Fn.p1 ; 
%q1 = Fn.q1 ; 
%q2 = Fn.q2 ; 


%*************

%generate a set of ponts that are extrapolated to the end of the original
%array
fitrangex = X(point1:size) ; 

%EXPONENTIAL
Eqn = a*exp(b.*fitrangex) + c*exp(d.*fitrangex) ; 
blue_int = a*exp(b*X(wave_index)) + c*exp(d*X(wave_index)) ; 
adjusted_int = Y(wave_index) - blue_int ; 

%RATIONAL
%Eqn = p1 / (fitrangex.^2 + q1.*fitrangex + q2) ;
%blue_int = p1 / (X(wave_index).^2 + q1.*X(wave_index) + q2); 
%adjusted_int = Y(wave_index) - blue_int ; 

%plot the extrapolated points 



%*******
hold on 
plot(fitrangex,Eqn , '-r') 
hold off 
%********
file_name = sprintf('Spreadsheet_tab_number %i.png',k) ; 
saveas(gcf,file_name) ; 

close all



end