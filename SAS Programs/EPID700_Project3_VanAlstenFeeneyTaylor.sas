
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
*%LET libref = ;

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
*added code!
