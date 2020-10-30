
/*****************************************************************************
	Name: Sarah Van Alsten, Tim Feeney, and Nandi Taylor
	Program: EPID700_Project3_VanAlstenFeeneyTaylor.sas
    Date: October 28, 2020
	Description: Project 3. Code Runs Sequentially
*****************************************************************************/
OPTIONS MERGENOBY=warn NODATE NONUMBER FORMCHAR="|----|+|---+=|-/\<>*";
FOOTNOTE "EPID700_Project3_VanAlstenFeeneyTaylor.sas run at %SYSFUNC(DATETIME(), DATETIME.) by Van Alsten, Feeny, and Taylor";
/******************************* begin program ******************************/

*Path(s) to access data. Depending on whose computer we run off, just change/uncomment out the 
macro variable after the %let to make sure the correct library is specified;

*for Sarah's library;
%LET libref = C:\Users\Owner\OneDrive\Documents\UNC\CourseWork\FALL2020\EPID700\Projects\project3\sas_project3\Data;

*for Tim's library;
%LET libref = z:\\OneDrive - University of North Carolina at Chapel Hill\PhD Courses\EPID 700\Project 3\sas_project3\Data;

*for Nandi's library;
*%LET libref = ;

LIBNAME epid "&libref";

**********************************************************************
*PART 1: Reading in External Data Sets
**********************************************************************;
TITLE "PART 1";

*read in the formA data;
PROC IMPORT OUT= formA 
            DATAFILE= "&libref.\FormA.xls" 
            DBMS=EXCEL REPLACE;
     RANGE="DATA$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;

*read in formB data;
PROC IMPORT OUT= formB 
            DATAFILE= "&libref.\FormB.csv" 
            DBMS=DLM REPLACE;
     DELIMITER=','; 
     GETNAMES=YES;
     DATAROW=2; 

RUN;

*read in formC data;
PROC IMPORT OUT= formC 
            DATAFILE= "&libref.\FormC.xlsx" 
            DBMS=EXCEL REPLACE;

     RANGE="FormC$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;

RUN;


*•	In the FormC SAS data set, ensure that the DATE9. 
format is assigned to the variable c2 and that the TIME. format is assigned to variable c3. ;
DATA formC;
SET formC;

	FORMAT c2 DATE9.;
	FORMAT c3 TIME.;

RUN;


*Question 2: In one step run a proc contents-esque procedure to
get a sense of the datasets;
*****************************************************************;
PROC DATASETS;
	CONTENTS DATA = _ALL_ DETAILS;
RUN;
QUIT;





***************************************************************************
* PART 2
****************************************************************************;


	


*read in kirowngeA text file;
*DATA kiro;
*	INFILE "&libref.\KirongweA.txt" MISSOVER FIRSTOBS = 2;
*	INPUT a_siteid 8-9 spotid 15-16 a11 $ 18-25 a17 & a18 & a19 & a20 & a21 a22 a23 a24 a_totalci;
*RUN;

*check import done appropriately;
PROC PRINT DATA = formA (OBS = 10);
RUN;

PROC PRINT DATA = formB (OBS = 10);
RUN;

PROC PRINT DATA = formC (OBS = 10);
RUN;

*PROC PRINT DATA = kiro;
*RUN;


***************************************************************************
* PART 3
****************************************************************************;


* Identifying Discrepancies in Double-entered Data
You determine that the error in the cross-border site Kirongwe
(site ID: 20) will be problematic for future data processing, and
so you request that the Kirongwe team re-key their Form A data. 
They re-enter the values and send them to you in the file “KirongweA.txt.”

*Explore whether there are any discrepancies between the original data from Kirongwe
and this revised data file.;

*1.	First, read the “KirongweA.txt” data file in as a SAS data set. Name your new SAS
data set KirongweA.; 

*2.	To facilitate the comparison of the data files, sort both the KirongweA and FormA
data sets in order of ascending spotid.;


*3.	Using one PROC (not a DATA) step, compare the KirongweA SAS data set to the subset
of records for Kirongwe (only) in the FormA SAS data set. In your PROC step, create an
output data set called kcompare that contains records from both the sorted FormA data 
for Kirongwe and the KirongweA data set. Include all records from both data sets in your
kcompare data set (i.e., write observations to the output data set even when all values
are judged equal). Be sure to examine your log after running the PROC. (As desired, feel
free to explore any other options for the PROC you use to create this data set.);


*Question 5. What procedure did you use to create the kcompare data set?
(Enter only one word.) PROC ;


*4.	Print your kcompare data set. Take a close look at the data, noting which observations 
are from the original FormA data set and which are from the re-keyed KirongweA data. Based on
what you see in kcompare, consider what might have gone wrong during assignment of the Spot
IDs in the Form A data set;

*Question 6. Other than the spotid variable, are there any other variables in the two data
sets that have with inconsistent values between the FormA data vs. KirongweA? Assume that the
KirongweA data set and the FormA data for Kirongwe contain data for the same set of spots 
(i.e., there are no missing or repeated records). Yes/No;


*At your request, the Kirongwe supervisor verifies all discrepant values against the paper-based
records that had been keyed in. They confirm that the values in the new Kirongwe data set are the
correct ones.

5. Delete the original Kirongwe records from the FormA data set, and replace them with the records
from KirongweA. Name your new and improved FormA data set FormA2.;


*Question 7. How many observations are in your FormA2 data set? ;


***************************************************************************
* PART 4
****************************************************************************;


*1.	First, write three DATA steps (one for each data set FormA2, FormB, and FormC), in which you 
create a new variable sitespotid to serve as your unique spot identifier. 
a.	Assign sitespotid values according to the following structure: 

<2-digit cross-border site ID><first letter of country where spot is located><hyphen><3-digit spotid>;

*b.	Output new Form A, B, and C data sets that contain the sitespotid variable. Name your output data
sets FormA3, FormB2, and FormC2 (based on the input data sets FormA2, FormB, and FormC, respectively).;



*2.	Write one macro called idcheck that can be applied to any data set (FormA3, FormB2, or FormC2) to 
perform the following tasks:
a.	Verify coding of the sitespotid variable by separately comparing the assigned sitespotid values to
the values of each of the variables that went into constructing it (in the data set for which the macro
is called)
b.	Print all records with missing sitespotid values.;

*3.	Call the idcheck macro you wrote to check for missing sitespotid values in each of your new data sets:
FormA3, FormB2, and FormC2.;


*Question 8. Across FormA3, FormB2, and FormC2, how many observations have a missing value for sitespotid?;

*4.	Investigate any missing sitespotid values. Consider the multistage design of this PLACE study and how
you might leverage other data you have for a given spot to determine what any missing sitespotid should be.

a.	Consider the DATA steps you wrote in Step IV.1. Modify the DATA step(s) that created the FormA3, FormB2,
and FormC2 data sets as needed to assign an appropriate (non-missing) sitespotid value to any record where
sitespotid was found to be missing.

a.	If you hard-code or overwrite any values, add comments to your code stating the original value(s) and
providing your rationale for the new value assigned.;

*b.	Call the idcheck macro again for any updated data set(s). Look again at the log and/or output from the
macro to verify that now, no sitespotid values are missing.;



*Question 9. Enter the revised (corrected, updated, non-missing) sitespotid for the spot from the FormC2 data
set that originally had a missing value for sitespotid. (Type carefully!) 


*Question 10. Considering the study design and data structure, in which data set(s) do you expect to see
repetition of sitespotid values? 
A.	FormA3
B.	FormB2
C.	FormC2;

*5.	For each data set where you do not expect repetition of sitespotid values, write and execute one PROC
step that allows you to verify whether there is any duplication of sitespotid values.
Hint: One approach is to use the NODUPKEY option in a PROC that is very familiar to you (albeit for a
different use).;




*Question 11. Consider the data set(s) that you determined should not have any repetition of values in the
sitespotid variable. In those data sets, are there any erroneously repeats of spotsiteid values? 
A.	Yes
B.	No;



***************************************************************************
* PART 5
****************************************************************************;

/**/
/**/
/**/
/**/
/**/
/**/
/**/
/**/
/**/
/**/
/**/


***************************************************************************
* PART 6
****************************************************************************;

/**/
/**/
/**/
/**/
/**/
/**/
/**/
/**/
/**/
/**/
/**/


***************************************************************************
* PART 7
****************************************************************************;

/**/
/**/
/**/
/**/
/**/
/**/
/**/
/**/
/**/
/**/
/**/


***************************************************************************
* PART 8
****************************************************************************;


/**/
/**/
/**/
/**/
/**/
/**/
/**/
/**/
/**/
/**/
/**/

***************************************************************************
* PART 9
****************************************************************************;

/*1.	Among only those who consented to answering the bio-behavioral survey questions
(in Form C), create a new variable, hfcountrycount, which is equal to the number of 
countries in which the respondent reported receiving health services in the preceding
12 months. Follow these instructions:*/

/*Question 19. For many observations did SAS print a note to the log (as per Step
1.d.ii.2)? (You may add another note to your log in which you calculate this value,
if you feel so inclined.) ____*/


/*2.	Moving forward with the report, use any number of SAS procedures and DATA
steps to create and output the following summary table, with no other output, 
for the subset of data collected in Malaba (cross-border site ID = 1):*/


*Question 20. According to your summary table, what was the total number of spots
listed in Busia? N = ___  ;

*Question 21. According to your summary table, how many spots were visited for 
verification in Busia? N = ___   ;

*Question 22. According to your summary table, what percentage of spots visited 
for verification in Busia were found and operational? Report the percentage to
the nearest integer, as shown in your table. (Do not enter the percent sign.) __%;  


*3.	Run the following code to create some additional analysis variables and then
generate a well-formatted table using PROC TABULATE: ;

DATA ABC6;
	SET ABC5;
	IF c10c=1 THEN count=1;
	IF c11a=1 THEN consentHIV=1;
	IF c117b=1 THEN HIVpos=1;
	IF 4<=c15<=6 THEN secormore=1;
	IF 1<=c15<=6 THEN edudata=1;
	IF c18=1 THEN fisher=1;
	IF c18 IN(1,2) THEN fisherdata=1;
RUN;
PROC TABULATE data=ABC6 STYLE=[JUST=CENTER];
	WHERE c10c=1 AND c5=1;
	CLASS c10c c14 c11a;
	VAR count consentHIV HIVpos secormore edudata fisher fisherdata c12 hfcountrycount;
	TABLE (count="Total respondents")*(N='N'*f=8.)
	      (HIVpos="Reactive HIV test")*(N='N'*f=8. PCTN<consentHIV>='%'*f=12.2)
      (secormore="Secondary education or higher")*(N='N'*f=8. PCTN<edudata>='%'*f=12.2)
	      (fisher="Works in fishing industry")*(N='N'*f=8. PCTN<fisherdata>='%'*f=12.2)
	      (c12="Age")*(MEAN='Mean'*f=12.2 STD='SD'*f=12.2)
	      (hfcountrycount="Countries received services in*")*(MEAN='Mean'*f=12.2 STD='SD'*f=12.2)
		,
   		(c14 all) / STYLE=[JUST=center];
	TITLE "East Africa Cross-Border Integrated Health Study (2016-2017)";
	TITLE2 "Unweighted results from Malaba (Site 1)";
	FOOTNOTE "*Number of countries in which health services were received in preceding 12 months";
RUN;


*Question 23. According to the table you just produced, among female respondents
in Malaba, what was the mean number of countries in which health services were 
received in the preceding 12 months? Report the mean to 2 decimal places. Mean = ___  ;



*4.	Convert your code from Step IX.2 and Step IX.3 into a macro called sitereport that
will output both the summary table and PROC TABULATE table for any specified site.
a.	In your macro, make sure to use some TITLE statements that state the site nameand
site ID. 
b.	You can copy/paste your code from Step IX.2 and Step IX.3 or just go back and update
it so that the code from these steps can all be run together as a macro. Be sure to change
all references to site number and site name variables to a macro variable (e.g., you might
change a_siteid=1 to something like a_siteid=&siteid), whose value you can assign when the
macro is called for a certain site.
Hint: The PROC TABULATE code I gave in Part IX.3 has two references to site ID 
(in the CLASS statement and the TITLE2 statement) and one reference to the site name 
(in the TITLE2 statement). You’ll need to replace the value given for c5 (i.e., 1, 
the site ID for Malaba) with a macro variable for the site ID, and you’ll need to 
replace the site name “Malaba” with a macro variable for the site name.;


*5.	Run your sitereport macro code, %MACRO to %MEND, to define the sitereport macro.;

*6.	Call your site-by-site report macro for all 13 sites, exporting the output to a 
single, well-formatted PDF file with the output centered and the results for each site
on a new page. To do this:

a.	Execute the statement: OPTIONS CENTER in open code to center your output.
b.	Write an ODS destination statement to write your output to a PDF. Apply the ODS style
JOURNAL in that ODS statement.
c.	Your goal is to have one page per site, with both tables for a single site appearing
on one page To do this, include the STARTPAGE=NEVER option in the ODS statement. Then, add
the following ODS statement in your sitereport macro (it’ll run in open code, like other
ODS statements) to tell SAS where to begin printing to a new page: ODS STARTPAGE=NOW
d.	After the ODS PDF statement, call your sitereport macro for all 13 sites.
e.	Immediately after the macro calls, close the ODS PDF destination.; 


*Question 24. According to your report, among the spots visited for verification 
in Kirongwe, what percent of visited spots were found and operational? Report the
percentage to the nearest integer. (Do not enter the percent sign.) __% ;

*Question 25. According to your report, which cross-border site had the highest
overall prevalence of HIV among bio-behavioral survey participants? Provide the site
ID number for that cross-border site.  (Interpretation note: I am requesting the 
prevalence only among participants because we have not yet weighted these data to account
for refusals of the HIV test or for differential sampling probabilities across participants.)
Site ID number: ;


*7.	Save the report you just generated as a PDF file named “Project3_Report_GroupName.pdf.”;


***************************************************************************
* PART 10
****************************************************************************;

*Now it’s time to pass the data set on to your collaborators. Your collaborators
use STATA and Excel, so to keep things simple, you’ll export the data to a CSV 
file that can be read into either program.;

*1.	Export your data set as a CSV file with formatted values (using the formats 
already applied – no need to add more). Name the data file “Project3_Data_GroupName.csv.”
Check the output data set to be sure you’ve written the formatted values to the CSV file.;

*2.	Next, encrypt the data file in a zip file for added security and faster upload/download
times. Save your csv file to a zip file named “Project3_Data_GroupName.zip” and encrypt
the file with the password: 2+2...isfive! (be sure to include the “!”). Click here more 
detailed instructions on preparing zip files.;
