# SAS

libname exam "C:\Users\luca\Desktop\EITnice\statcomp";

*ex1;
data ozone;
infile "C:\Users\luca\Desktop\EITnice\statcomp\esame.txt" firstobs =2;
INPUT x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 $ x14 $;


data ozone1;
set ozone(drop = x1 x13 x14);
proc print;
run; 

%let interval = x3-x12;
proc glm data= ozone1;
model x2 = x3-x12;
run;

proc corr data = ozone1 rank
 plots(only)=scatter(nvar=all ellipse=none);
   var &interval;
   with x2;
   
   title "Correlations and Scatter Plots with SalePrice";
run;

proc reg data=ozone1;
    model x2=x3-x12;
    title "Simple Regression with Lot Area as Regressor";
run;



*es 3;

data ozone2;
set ozone( keep = x2 x14);
run;

proc sgplot data = ozone2;
vbox x2 / category=x14
connect = mean ;
run;

proc format;
value   $form  'Pluie'='Yes'
               'Sec'='No'
                ;
run;

proc ttest data = ozone2 plots(shownull)=interval;
class x14;
var x2 ;
format x14 $form.;
run;

proc glm data = ozone2;
class x14;
model x2=x14;
run;


*es4;
options validvarname=any;

DATA esame;
length Author $30;
length title $30;
length year $4;
length 'literary genre'n $30;
INPUT Author $ title $ year 'literary genre'n $;
infile cards DLM = "#";
CARDS;
charles baudelaire#les fleurs du mal#1857#poetry
victor hugo#notre dame des paris#1831#hist novel
gust fla#emma bov#1857#real nivel
guy de maup#le horla#1886#fant novel
;
proc print;
run;
