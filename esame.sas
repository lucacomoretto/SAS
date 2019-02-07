
libname exam "C:\Users\luca\Desktop\EITnice\statcomp"


data ozone;
infile "C:\Users\luca\Desktop\EITnice\statcomp\esame.txt" firstobs =2;
INPUT x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 $ x14 $;


data ozone1;
set ozone(drop = x1 x13 x14);
proc print;
run; 


proc freq data = ozone1;
tables x2;
run;

proc means data = ozone1;
var x2;
run;

proc univariate data = ozone1;
var x2;
histogram x2 / normal(mu=est sigma=est);
run;

proc univariate data = ozone;
class x14;
histogram x2 / kernel(c = MISE) normal(mu=est sigma=est);
run;

proc freq data = ozone1;
tables x2;
ods graphics;

run;

proc univariate data = ozone1 noprint;
var x2;
histogram x2 / normal kernel;
inset n mean std / position = ne;
title "interval variable distribution analysis";

run;

%let interval = x2-x12;
ods graphics;

proc univariate data=ozone1 noprint;
    var &interval;
    histogram &interval / normal kernel;
    inset n mean std / position=ne;
    title "Interval Variable Distribution Analysis";
run;

title;

ods graphics;

proc ttest data=ozone1
           plots(shownull)=interval
           H0=80;
    var x2;
    title "One-Sample t-test testing whether mean with ozone=80";
run;


title;

ods graphics;


proc sgplot data=ozone;
    vbox x2 / category=x14
                     connect=mean;
    title "Sale Price Differences across Central Air";
run;


title;

%let categorical=x13 x14;

ods graphics;
 proc format;
    value   $form  'Pluie'='Yes'
                     'Sec'='No'
                ;
   run;
proc freq data=ozone;
    tables &categorical / plots=freqplot ;
    format  x14 $x14.
           ;
    title "Categorical Variable Frequency Analysis";
run; 

proc ttest data=ozone ;
   	class x14;
    var x2;
    format x14 $NoYes.;
    title "Two-Sample t-test Comparing Masonry Veneer, No vs. Yes";
run;

proc sgscatter data=ozone1;
    plot x2*x3 / reg;
    title "Associations of Above Grade Living Area with Sale Price";
run;

%let interval=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
         Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom;

options nolabel;
proc sgscatter data=ozone;
    plot x2*(&interval) / reg;
    title "Associations of Interval Variables with Sale Price";
run;

ods graphics;

ods select lsmeans diff diffplot controlplot;
proc glm data=ozone1;
         
    model x2=x3-x12;
run;
quit;

title;

%let interval=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
         Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom;

ods graphics / reset=all imagemap;
proc corr data=ozone1 rank
          plots(only)=scatter(nvar=all ellipse=none);
   var &interval;
   with x2;
   
   title "Correlations and Scatter Plots with SalePrice";
run;

title;

ods graphics off;
proc corr data=ozone1 
          nosimple 
          best=3;
   var &interval;
   title "Correlations and Scatter Plot Matrix of Predictors";
run;

title;

ods graphics;
%let interval2 = x3-x12
proc reg data=ozone1;
    model x2=x3-x12;
    title "Simple Regression with Lot Area as Regressor";
run;
quit;

title;

ods graphics off;
proc means data=ozone1
           mean var std nway;
    class Season_Sold Heating_QC;
    var SalePrice;
    format Season_Sold Season.;
    title 'Selected Descriptive Statistics';
run;

proc sgplot data=STAT1.ameshousing3;
    vline Season_Sold / group=Heating_QC 
                        stat=mean 
                        response=SalePrice 
                        markers;
    format Season_Sold season.;
run; 

ods graphics on;

proc glm data=ozone1 order=internal;
    model x2 = x3-x12;
     title "Model with Heating Quality and Season as Predictors";
run;
quit;

ods graphics on;

proc glm data=STAT1.ameshousing3 
         order=internal 
         plots(only)=intplot;
    class Season_Sold Heating_QC;
    model SalePrice = Heating_QC Season_Sold Heating_QC*Season_Sold;
    lsmeans Heating_QC*Season_Sold / diff slice=Heating_QC;
    format Season_Sold Season.;
    store out=interact;
    title "Model with Heating Quality and Season as Interacting Predictors";
run;
quit;

proc plm restore=interact plots=all;
    slice Heating_QC*Season_Sold / sliceby=Heating_QC adjust=tukey;
    effectplot interaction(sliceby=Heating_QC) / clm;
run; 

title;

ods graphics on;

proc reg data=STAT1.ameshousing3 ;
    model SalePrice=Basement_Area Lot_Area;
    title "Model with Basement Area and Lot Area";
run;
quit;

proc glm data=STAT1.ameshousing3 
         plots(only)=(contourfit);
    model SalePrice=Basement_Area Lot_Area;
    store out=multiple;
    title "Model with Basement Area and Gross Living Area";
run;
quit;

proc plm restore=multiple plots=all;
    effectplot contour (y=Basement_Area x=Lot_Area);
    effectplot slicefit(x=Lot_Area sliceby=Basement_Area=250 to 1000 by 250);
run; 

title;


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

ods graphics on;

ods select lsmeans diff diffplot controlplot;

proc glm data = ozone2;
class x14;
model x2=x14;
run;

ods graphics on;

proc glm data=ozone2 
         order=internal 
         plots(only)=diffplot;
    class x14;
    model x2 = x14;
    
    format x14 $form.;
    store out=interact;
    title "Model with Heating Quality and Season as Interacting Predictors";
run;
proc reg data = ozone2;

model x2=x14;
run;



*es4;
options validvarname=any;
data libri;
length Author $30;
length title $30;
length year $4;
length 'literary genre'n $30;

input Author $ title $ year 'literary genre'n $ ;
infile cards DLM = "#";

Cards;
charls baud#les fle d mal#1389#potert
victor jhgo#csdcnsin dame#4822#hist now
;

proc print;
run;
