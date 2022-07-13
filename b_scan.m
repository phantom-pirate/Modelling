%% © Created by: Sakthi Aadharsh Azhagar Gobinath Kavitha (sakthiaa@buffalo.edu)
clear all
h = warndlg(sprintf("The file for the matlab must be an excel file that contains the data from the Circular Dichroism. \nPlease do not use the original data set from the Circular Dichroism experiment (the .csv file). \nDo not add any other data to the file."), 'Alert');
waitfor(h);
prompt = ["Enter the name of the file (.xlsx only): ","Enter the starting enthalphy for the protien, (cal/mol): "];
dlgtitle = 'Input';
dims = [1 35];
definput = {'L1B0216','32735'};
answer = inputdlg(prompt,dlgtitle,dims,definput);
%%
file_name=string(answer(1));
T=readtable(file_name);
dH=double(string(answer(2)));
min_temp=table2array(T(1,end));
max_temp=table2array(T(1,2));
min_wave=T.Var1(end);
max_wave=T.Var1(1);

min_ind=find(T.Var1==max_wave);
max_ind=find(T.Var1==min_wave);
x=flipud(T.Var1(min_ind:max_ind));
y1=flipud(T.Var2(min_ind:max_ind));
y2=flipud(T.Var37(min_ind:max_ind));
figure(1)
plot(x,y1,x,y2);
title("Change in Protien Interaction")
legend(sprintf("T=%d˚C",(min_temp)),sprintf("T=%d˚C",(max_temp)))
xlabel("Wavelength")
ylabel("Absorbance")
lower_ind=find(T.Var1==250);
upper_ind=find(T.Var1==215);
x=flipud(T.Var1(lower_ind:upper_ind));
y1=flipud(T.Var2(lower_ind:upper_ind));
y2=flipud(T.Var37(lower_ind:upper_ind));
d=abs(y1-y2);
b=find(d==max(d));
%% 
w=x(b);
maxtemp_ind=find(table2array(T(1,:))==46);
mintemp_ind=find(table2array(T(1,:))==80);
l_exp=fliplr(table2array(T((upper_ind+1)-b,mintemp_ind:maxtemp_ind)))';
ini=l_exp(1);
fin=l_exp(end);
l_exp=(l_exp-fin)/(ini-fin);
t=flipud(table2array(T(1,mintemp_ind:maxtemp_ind))'+273.15);
f=fittype('1/(1+exp(a/1.987*(1/b-1/x)))');
fo=fitoptions(f);
fo.Startpoint=[dH,300];
c=fit(t,l_exp,f,fo); 
figure(2)
plot(t,l_exp);
hold on
%%
Tm=c.b;%arbitary value
dH=c.a;
for i=1:length(t)
    l_the(i)=1/(1+exp(dH*(1/Tm-1/t(i))));
end
%%
plot(t,l_the);
legend("Experimental","Theoretical")
title("Peak Temperature Plot-Experimental vs Theoretical")
xlabel("Temperature")
ylabel("Absorbance")
hold off
%%
out=warndlg(sprintf("The peak wavelength is %d nm. \nThe denaturing temperature is %g ˚C.\nThe Enthalpy of formation is %g cal/mol.",w,Tm-273.15,dH));
