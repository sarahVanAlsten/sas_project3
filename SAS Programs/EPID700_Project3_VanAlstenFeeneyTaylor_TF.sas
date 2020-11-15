
/*****************************************************************************
	Name: Sarah Van Alsten, Tim Feeney, and Nandi Taylor
	Program: EPID700_Project3_VanAlstenFeeneyTaylor.sas
    Date: October 28, 2020
	Description: Project 3. Code Runs Sequentially
*****************************************************************************/
OPTIONS MERGENOBY=warn NODATE NONUMBER FORMCHAR="|----|+|---+=|-/\<>*";
FOOTNOTE "EPID700_Project3_VanAlstenFeeneyTaylor.sas run at %SYSFUNC(DATETIME(), DATETIME.) by Van Alsten, Feeney, and Taylor";
/******************************* begin program ******************************/

*Path(s) to access data. Depending on whose computer we run off, just change/uncomment out the 
macro variable after the %let to make sure the correct library is specified;

*for Sarah's library;
*%LET libref = C:\Users\Owner\OneDrive\Documents\UNC\CourseWork\FALL2020\EPID700\Projects\project3\sas_project3\Data;

*for Tim's library;
%LET libref = W:\p3data;

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

*read in the formA data FOR TIM;
/*PROC IMPORT OUT= formA 
            DATAFILE= "&libref.\FormA.xls" 
            DBMS=XLS REPLACE;
			SHEET="DATA";
			GUESSINGROWS=2147483647;
     RANGE="DATA$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;*/


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


*read in formC data FOR TIM;
/*PROC IMPORT OUT= formC 
            DATAFILE= "&libref.\FormC.xlsx" 
            DBMS=XLSX REPLACE;
     *RANGE="FormC$"; 
     *GETNAMES=YES;
     *MIXED=NO;
     *SCANTEXT=YES;
     *USEDATE=YES;
     *SCANTIME=YES;

RUN;*/


*•	In the FormC SAS data set, ensure that the DATE9. 
format is assigned to the variable c2 and that the TIME. format is assigned to variable c3. ;
DATA formC;
SET formC;

	FORMAT c2 DATE9.;
	FORMAT c3 TIME.;

RUN;

*check import done appropriately;
PROC PRINT DATA = formA (OBS = 10);
RUN;

PROC PRINT DATA = formB (OBS = 10);
RUN;

PROC PRINT DATA = formC (OBS = 10);
RUN;


*Question 2: In one step run a proc contents-esque procedure to
get a sense of the datasets;
*****************************************************************;
PROC DATASETS;
	CONTENTS DATA = _ALL_ DETAILS;
RUN;
QUIT;


/*
Question 1. What procedure did you use to report the contents of all three
data sets with just one PROC step? (Enter only one word.) PROC DATASETS

DATASETS

Question 2. Using the output from the procedure you named in Question 1,
report the number of observations in your FormB data set. 

1160

*/


***************************************************************************
* PART 2
****************************************************************************;
TITLE "Part 2";

PROC SORT DATA = forma OUT = forma_sort;
	BY a_siteid spotid;
RUN;


DATA CheckSpotIDs;
SET forma_sort;
	
	BY a_siteid;

	RETAIN id_check;

		IF first.a_siteid THEN id_check = 1;
			ELSE id_check = id_check + 1;

		IF id_check NE spotid THEN DO;
			flag_spotid = 1;
			*reset the checker so it isn't off for whole thing;
			id_check = spotid;

		END; 

		ELSE DO;
			flag_spotid = 0;
		END;

RUN;

PROC FREQ DATA = checkSpotIDs;
	TABLES a_siteid* flag_spotid;
RUN;

/*Question 3. How many records in your CheckSpotIDs data set have
a flag_spotid value of 1?  ANSWER: 3   */


/*Question 4. How many cross-border sites have any records that have
a flag_spotid value of 1? ANSWER: 2, sites 1 and 20   */

***************************************************************************
* PART 3
****************************************************************************;
TITLE "Part 3";

* Identifying Discrepancies in Double-entered Data
You determine that the error in the cross-border site Kirongwe
(site ID: 20) will be problematic for future data processing, and
so you request that the Kirongwe team re-key their Form A data. 
They re-enter the values and send them to you in the file “KirongweA.txt.”

*Explore whether there are any discrepancies between the original data from Kirongwe
and this revised data file.;

*1.	First, read the “KirongweA.txt” data file in as a SAS data set. Name your new SAS
data set KirongweA.; 


*read in kirowngeA text file;
DATA kirongweA;
	INFILE "&libref.\KirongweA.txt" MISSOVER FIRSTOBS = 2;
	INPUT a_siteid 7-9 spotid 14-16 a11 $ 18-25 a17 & a18 & a19 & a20 & a21 a22 a23 a24 a_totalci;
RUN;

*check import;
PROC PRINT DATA = kirongweA;
RUN;


*2.	To facilitate the comparison of the data files, sort both the KirongweA and FormA
data sets in order of ascending spotid.;

PROC SORT DATA = kirongweA OUT = kirongweA_sort;
	BY spotid;
RUN;

PROC SORT DATA = formA OUT = formA_new_sort;
	BY spotid;
RUN;


*3.	Using one PROC (not a DATA) step, compare the KirongweA SAS data set to the subset
of records for Kirongwe (only) in the FormA SAS data set. In your PROC step, create an
output data set called kcompare that contains records from both the sorted FormA data 
for Kirongwe and the KirongweA data set. Include all records from both data sets in your
kcompare data set (i.e., write observations to the output data set even when all values
are judged equal). Be sure to examine your log after running the PROC. (As desired, feel
free to explore any other options for the PROC you use to create this data set.);


PROC COMPARE  BASE= formA_new_sort COMPARE= kirongweA_sort OUT = kcompare;
   WHERE a_siteid = 20;
RUN;

*Question 5. What procedure did you use to create the kcompare data set?
(Enter only one word.) PROC COMPARE;

*4.	Print your kcompare data set. Take a close look at the data, noting which observations 
are from the original FormA data set and which are from the re-keyed KirongweA data. Based on
what you see in kcompare, consider what might have gone wrong during assignment of the Spot
IDs in the Form A data set;


PROC PRINT DATA = kcompare;
RUN;

*Question 6. Other than the spotid variable, are there any other variables in the two data
sets that have with inconsistent values between the FormA data vs. KirongweA? Assume that the
KirongweA data set and the FormA data for Kirongwe contain data for the same set of spots 
(i.e., there are no missing or repeated records). Yes/No;

*YES;


*At your request, the Kirongwe supervisor verifies all discrepant values against the paper-based
records that had been keyed in. They confirm that the values in the new Kirongwe data set are the
correct ones.

5. Delete the original Kirongwe records from the FormA data set, and replace them with the records
from KirongweA. Name your new and improved FormA data set FormA2.;

DATA FormA2;
SET FormA (WHERE= (a_siteid NE 20)) KirongweA;
RUN;

PROC CONTENTS DATA=formA2;
 RUN;

*Question 7. How many observations are in your FormA2 data set? ;

*1769;

***************************************************************************
* PART 4
****************************************************************************;


*1.	First, write three DATA steps (one for each data set FormA2, FormB, and FormC), in which you 
create a new variable sitespotid to serve as your unique spot identifier. 
a.	Assign sitespotid values according to the following structure: 

<2-digit cross-border site ID><first letter of country where spot is located><hyphen><3-digit spotid>;

*b.	Output new Form A, B, and C data sets that contain the sitespotid variable. Name your output data
sets FormA3, FormB2, and FormC2 (based on the input data sets FormA2, FormB, and FormC, respectively).;


*make a macro to do this since we'll be reusing the code multiple times and don't
want to copy/paste;
%MACRO makeID(site, country, spot);

	*cross border site ids and spotids don't automatically have 2 or 3 digits, respectively;
	*loop over them and if they don't have appropriate numbers of digits, add 0 to start;
	*Note from Sarah-> I did it this way because of past experiences w/ similar things where
	there were many more than 3 digits and it would be annoying to type all possibilities. This
	is more generalizable if we had, say 50 character long variables etc;
	
	*first make them character;
	siteid_new = STRIP(PUT(&site, 3.));
	spotid_new = STRIP(PUT(&spot, 3.));


	DO i = 1 TO 3;
		*applies to both variables;
		IF i NE 3 THEN DO;
			IF lengthn(siteid_new) < i THEN siteid_new = CATS("0", siteid_new);
				ELSE siteid_new = siteid_new;
			IF lengthn(spotid_new) < i THEN spotid_new = CATS("0", spotid_new);
				ELSE spotid_new = spotid_new;
		END;
		*applies only to spotid;
		ELSE DO;
			IF lengthn(spotid_new) < i THEN spotid_new = CAT("0", spotid_new);
				ELSE spotid_new = spotid_new;
		END;

	END;

	*finally, paste strings w/ appropriate digits;
	sitespotid = CATS(siteid_new, SUBSTR(&country, 1, 1), "-", spotid_new);

	*check on missingness;
	IF (&country = "") OR (PUT(&site,3.) = .) OR  (PUT(&spot,3.) = .) THEN sitespotid = " ";
		ELSE sitespotid = sitespotid;

%MEND;


DATA formA3;
SET formA2;

	%makeID(a_siteid, a11, spotid);
	
RUN;

DATA formB2;
SET formB;

		LENGTH country $ 10;
		
		IF b3 = 1 THEN country = "Kenya";
			ELSE IF b3 = 2 THEN country = "Rwanda";
			ELSE IF b3 = 3 THEN country = "Tanzania";
			ELSE IF b3 = 4 THEN country = "Uganda";

		%makeID(b4, country, b5);

RUN;

DATA formC2;
SET formC;

		LENGTH country $ 10;

		IF c4 = 1 THEN country = "Kenya";
			ELSE IF c4 = 2 THEN country = "Rwanda";
			ELSE IF c4 = 3 THEN country = "Tanzania";
			ELSE IF c4 = 4 THEN country = "Uganda";

		%makeID(c5, country, c6);

RUN;

*check code;
PROC PRINT DATA = formA3 (OBS = 10);
	VAR sitespotid a_siteid a11 spotid;
RUN;

PROC PRINT DATA = formB2 (OBS = 10);
	VAR sitespotid b4 b5 country;
RUN;

PROC PRINT DATA = formC2 (OBS = 10);
	VAR sitespotid c5 c6 country;
RUN;


*2.	Write one macro called idcheck that can be applied to any data set (FormA3, FormB2, or FormC2) to 
perform the following tasks:
a.	Verify coding of the sitespotid variable by separately comparing the assigned sitespotid values to
the values of each of the variables that went into constructing it (in the data set for which the macro
is called)
b.	Print all records with missing sitespotid values.;

*3.	Call the idcheck macro you wrote to check for missing sitespotid values in each of your new data sets:
FormA3, FormB2, and FormC2.;
options mprint mlogic;


%MACRO idcheck(data);


	*first, depending on the input dataset define which are
	the variables to compare against;
	%IF &data. = FormA3 %THEN %DO;
		%LET countvar = a11;
		%LET sitevar = a_siteid;
		%LET spotvar = spotid;
	%END;

	%ELSE %IF &data. = FormB2 %THEN %DO;
		%LET countvar = country;
		%LET sitevar = b4;
		%LET spotvar = b5;

	%END;

	%ELSE %IF &data. = FormC3 %THEN %DO;
		%LET countvar = country;
		%LET sitevar = c5;
		%LET spotvar = c6;

	%END;

	%PUT countvar is &countvar;
	%PUT sitevar is &sitevar;
	%PUT spotvar is &spotvar;

	*check the coding;
	DATA &data.idcheck;
	SET &data.;

		*extract the characters for the site;
		site2 = SUBSTR(sitespotid, 1, 2);

		*for the country;
		country1 = SUBSTR(sitespotid, 3, 1);

		*for the hyphen;
		hyph1 = SUBSTR(sitespotid, 4, 1);

		*for the spot;
		spot3 = SUBSTR(sitespotid, 5, 3);

		*if either of these don't match, then flag and stop because we know
		there will be an issue;
		IF (hyph1 NE "-") OR (country1 NE SUBSTR(&countvar,1,1)) THEN flagID = 1;
			ELSE DO; *otherwise keep checking;


		*because of way we coded 0s in front of digits, cant
		directly compare the spot3 and site2 variables to the originals. Need
		to get rid of any leading 0s first. There will be max of 2 0's in front, hence
		do i = 1 to 2. If first char is a 0, make the variable that same string minus the 0 in front;
			DO i = 1 TO 2;
					IF SUBSTR(spot3, 1, 1) = '0' THEN spot3 = SUBSTR(spot3, 2, lengthn(spot3)-1);
						ELSE spot3 = spot3;

					IF SUBSTR(site2, 1, 1) = '0' THEN site2 = SUBSTR(site2, 2, lengthn(site2)-1);
						ELSE site2 = site2;

				END;
			END;

		*now that zeros are removed we can compare;
		IF flagID = 1 OR 
			(STRIP(PUT(&spotvar,3.)) NE spot3) OR
				(STRIP(PUT(&sitevar,3.)) NE site2) THEN flagID = 1;
		RUN;

	*print any problematic ones;
	PROC PRINT DATA = &data.idcheck;
		WHERE flagID = 1;
	RUN;

	*print records where missing sitespotid;
	PROC PRINT DATA = &data. ;
		WHERE sitespotid = "";
	RUN;

%MEND;

%idcheck(data=FormA3);
%idcheck(data=FormB2);
%idcheck(data=FormC2);

*Question 8. Across FormA3, FormB2, and FormC2, how many observations have a missing value for sitespotid?
ANSWER:1 ;

*4.	Investigate any missing sitespotid values. Consider the multistage design of this PLACE study and how
you might leverage other data you have for a given spot to determine what any missing sitespotid should be.

a.	Consider the DATA steps you wrote in Step IV.1. Modify the DATA step(s) that created the FormA3, FormB2,
and FormC2 data sets as needed to assign an appropriate (non-missing) sitespotid value to any record where
sitespotid was found to be missing.

*sitespotid missing for obs 5037 in formc2. It's missing data for c4 (country) but we know
that the site is 7 (Isebania/Sirare) and spot is 81. Find out what country that is;

PROC PRINT DATA = formA3;
	WHERE a_siteid = 7 AND spotid=81;
RUN;

PROC PRINT DATA = formB2;
	WHERE b4 = 7 AND b5=81;
RUN;

*Form A and Form B suggest that site 7, spot 81 is in Kenya. Change form C missing
to accomodate this
a.	If you hard-code or overwrite any values, add comments to your code stating the original value(s) and
providing your rationale for the new value assigned.;
DATA formC2;
SET formC;

		LENGTH country $ 10;

		IF c4 = 1 THEN country = "Kenya";
			ELSE IF c4 = 2 THEN country = "Rwanda";
			ELSE IF c4 = 3 THEN country = "Tanzania";
			ELSE IF c4 = 4 THEN country = "Uganda";
			ELSE IF c4 = . AND c5 = 7 AND c6 = 81 THEN country = "Kenya";

		%makeID(c5, country, c6);

RUN;

*b.	Call the idcheck macro again for any updated data set(s). Look again at the log and/or output from the
macro to verify that now, no sitespotid values are missing.;
%idcheck(formC2);


*Question 9. Enter the revised (corrected, updated, non-missing) sitespotid for the spot from the FormC2 data
set that originally had a missing value for sitespotid. (Type carefully!) ;
PROC PRINT DATA = formC2;
	WHERE c6 = 81 AND c5 = 7 AND c4 = .;
RUN;

*07K-081;

*Question 10. Considering the study design and data structure, in which data set(s) do you expect to see
repetition of sitespotid values? 
A.	FormA3 -> NO
B.	FormB2 -> NO
C.	FormC2 -> YES; 

*5.	For each data set where you do not expect repetition of sitespotid values, write and execute one PROC
step that allows you to verify whether there is any duplication of sitespotid values.
Hint: One approach is to use the NODUPKEY option in a PROC that is very familiar to you (albeit for a
different use).;

PROC SORT DATA = formA3 NODUPKEY OUT = formA3_nodup;
	BY sitespotid;
RUN;
PROC SORT DATA = formB2 NODUPKEY OUT = formB2_nodup;
	BY sitespotid;
RUN;

*log shows 0 records duplicated for both of these;


*Question 11. Consider the data set(s) that you determined should not have any repetition of values in the
sitespotid variable. In those data sets, are there any erroneously repeats of spotsiteid values? 

B.	No;



***************************************************************************
* PART 5
****************************************************************************;

/*Now that you’ve created a common variable sitespotid uniquely identifying spots across
the three data sets (FormA3, FormB2, and FormC2), you’re ready to merge all the records together,
spot-by-spot.

1.Merge the FormA3, FormB2, and FormC2 data together by sitespotid to create an output 
data set called ABC according to the following instructions:*/

/* a. Keep all records from the FormC2 data, and link, onto each of the FormC2 records, 
the corresponding spot-level records from the FormA3 and FormB2 data sets. */

/*b.	Exclude, from the ABC data set, any observations that appear in FormA3 or
FormB2 which do not have their sitespotid represented in the FormC2 data set.
(In other words, only include records for the spots where bio-behavioral interviews occurred.
Exclude all spot data for spots where bio-behavioral interviews did not occur.)*/

/*c.	For spots where multiple bio-behavioral interviews were conducted, merge the
FormA3 and FormB2 data sets for that spot onto every bio-behavioral interview record from that spot.
(For example, if 6 people were interviewed at a spot with sitespotid 01K-033, you should have
6 records in the ABC data set – one per Form C interview –
and each of those 6 records should include 01K-033’s spot-level data from FormA3 and FormB2.)*/


/*d.	Output only the following variables to the ABC data set:
a11 a17 a18 a19 a20 a21 a22 a23 a24 a_siteid a_totalci 
b1 b3 b4 b5 b15 b16 b17 b18 b19 b20 b23 b24 b29 b30 b49 b50 b10a b14a
b14b b14c b14d b14e b14f b52a b52b b52c b52d b9a b9b c1 c2 c3 c4 c5 c6 c12
c13 c14 c15 c16 c18 c19 c21 c22 c23 c24 c25 c32 c84 c85 c116 c10a c10b c10c
c10d c117b c117c c11a c120a c120b c120c c120d c120e c120f c120g c120h c17a c20a
c20b c20c c29a c29b c34a c34b_v1 c34b_v2 sitespotid spotid
*/

PROC SORT DATA = formC2 OUT = formC2_sort;
	BY sitespotid;
RUN;

PROC SORT DATA = formB2 OUT = formB2_sort;
	BY sitespotid;
RUN;

PROC SORT DATA = formA3 OUT = formA3_sort;
	BY sitespotid;
RUN;

DATA ABC;
	MERGE FormC2_sort (IN = c) FormA3_sort FormB2_sort;
	BY sitespotid;
	IF c;

	KEEP a11 a17 a18 a19 a20 a21 a22 a23 a24 a_siteid a_totalci 
		  b1 b3 b4 b5 b15 b16 b17 b18 b19 b20 b23 b24 b29 b30 b49 b50 b10a b14a
		  b14b b14c b14d b14e b14f b52a b52b b52c b52d b9a b9b c1 c2 c3 c4 c5 c6 c12
		  c13 c14 c15 c16 c18 c19 c21 c22 c23 c24 c25 c32 c84 c85 c116 c10a c10b c10c
		  c10d c117b c117c c11a c120a c120b c120c c120d c120e c120f c120g c120h c17a c20a
		  c20b c20c c29a c29b c34a c34b_v1 c34b_v2 sitespotid spotid;
RUN;


*2.	Verify that your output data set ABC contains the correct number of variables (it should have 88).;
PROC CONTENTS DATA = ABC;
RUN;

*Question 12. How many observations are in your ABC data set?
(Be sure you’ve followed the Step V.1 instructions carefully!) 11567 

Question 13. Would SAS have produced an output data set if you
had excluded the BY statement in the DATA step you wrote in Part V.1? 
A.	
B.	No 

***************************************************************************
* PART 6
****************************************************************************;

/*Part VI. Applying Labels and Formats
Creating labels and user-defined formats for a large data set can be cumbersome.
Fortunately, a colleague has shared two SAS program files for these tasks: “CBIHSApplyLF.sas” 
and “CBIHSFormats.sas.”

1.	Open these two SAS programs just to see what they contain. 
Exit the files once you have an understanding of their contents. 
(Do not run any code while you have these program files open in SAS.)

2.	Return to your SAS program for Project 3. Write and 
execute exactly one statement in your SAS program that will execute all the code in the
“CBIHSFormats.sas” file.
*/

*file pointer -> update the base filepath;
DATA _NULL_;
	CALL SYMPUT('newlibref', TRANWRD("&libref", "\Data", "\SAS Programs"));
RUN;

%INCLUDE "&newlibref.\CBIHSFormats.sas";

/*Question 14. What statement did you use to execute the code in the “CBIHSFormats.sas” file? 
Enter the SAS keyword for the statement 
(enter one word, including any relevant special characters): %INCLUDE */

/*3.	In a new DATA step, use one statement to execute the contents of “CBIHSApplyLF.sas.”
(Do not copy/paste the formats and labels into your Project 3 code.) 
a.	Name the output data set ABC2.
b.	Do not worry if the log alerts you to variables that are not included in your subset
of the CBIHS data.
*/

DATA ABC2;
SET ABC;

	%INCLUDE "&newlibref.\CBIHSApplyLF.sas";

RUN;


/*Question 15. How many statements did you write in your Project 3 SAS program to accomplish 
Step VI.3? (Be sure to include the DATA and RUN statements in your count.) 4*/


/*
4.	Inspect the variables attributes in your new data set, ABC2.
*/
PROC CONTENTS DATA = ABC2;
RUN;

/*Question 16. How many of the 88 variables in ABC2 do not have a label? (In your count, 
include only variables for which the label attribute is completely empty/blank.) 2 */


/*5.	In a new DATA step, create an output data set named ABC3 in which you:
a.	Assign informative variable labels to any yet-unlabeled variables (as identified
in Question 16). Remember: you have been given the questionnaires that show the questions
associated with each variable.
b.	Assign the format CBSITE_REVISED. (you loaded this format into the WORK library in 
Step VI.2) to the variable a_siteid.
*/

DATA ABC3;
SET ABC2;


	LABEL sitespotid = "Two Digit Cross-border site ID, First Letter Country, 3 Digit Spot ID";
	LABEL b20 = "Years Spot in Operation";


	FORMAT a_siteid CBSITE_REVISED.;

RUN;


***************************************************************************
* PART 7 De-identifying Data
****************************************************************************;

/*In a venue-based survey such as this, for example, the combination of a spot name or location
data along with age, sex, and an indicator of employment at the spot could be sufficient to identify
a respondent. A strategy for de-identifying a data set will typically weigh, among other factors,
the risks of identification, the data safeguards to be used, and data use agreements.*/

/**/
PROC FREQ DATA=ABC3;
	TABLES _CHARACTER_ / LIST MISSPRINT;
RUN;

/*Question 17. Fill in the blank with just one term (and not a macro variable) that will provide one-way
frequency tables for all character variables in the ABC3 data set:
PROC FREQ DATA=ABC3;
	TABLES _____ / LIST MISSPRINT;
RUN;


ANSWER _character_*/


/*Question 18. Does ABC3 contain any direct identifiers listed on the UNC IRB document provided? 
A.	Yes
B.	No


ANSWER: yes
c10b: languages and hearing function (ie deaf individuals)

c10d:
No time now call my mobile number 0718408732

*/

/*3.	In a new DATA step, create a new data set named ABC4, based on the following instructions:
a.	If you determined that there were no direct identifiers in the data set, output ABC3 to ABC4 
without any changes.

b.	If you did find identifiers in ABC3, suppress any identifying data values by replacing them with
a SAS missing value appropriate for the variable type. (Consider referencing a participant’s values 
for c13 and/or sitespotid to identify individuals whose sensitive values are to be overwritten). Be 
sure to add a comment in your code explaining what you did.*/

DATA ABC4;
	SET ABC3;
	*removing identifiable values;
	IF c10b="Deaf" OR c10b="Deef" OR c10b="Dump deaf" THEN c10b=" ";
	IF c10d="No time now call my mobile number 0718408732" THEN c10d=" ";
	RUN;

PROC FREQ DATA=ABC4; *rechecking to make sure the variable are deidentified;
	TABLES _CHARACTER_ / LIST MISSPRINT;
RUN;



***************************************************************************
* PART 8 Creating a Codebook
****************************************************************************;


/*1.	Open the program “codebook.sas.” There are detailed comments near the top of 
the program explaining various parameters you can specify for the macro.

2.	Before you can call the codebook macro, you’ll first need to define this macro in 
your SAS session. Within your Project 3 SAS program, write one statement that will execute
the contents of the “codebook.sas” program.*/

	%INCLUDE "&libref.\codebook.sas";
	RUN;

/*%macro codebook(
	data=, 
	library=work, 
	maxfmts=0, 
	def_othr=yes,
    w_label=20, 
	w_format=20, 
	w_raw=9, 
	addvalue=yes,
	sortby=name,      /* sorby: name or varnum 
	out=codebook ) ;*/


/*3.	Call the macro, specifying the data set name and increasing the widths of the
	label and format fields to ensure the labels and formats are not truncated in the output
	(consult the “codebook.sas” program for instructions on how to specify these and other
	parameters for the macro). You may specify additional parameters for the macro to further
	customize the codebook if you would like, but you are not required to. */
OPTIONS MPRINT;
	


	ODS PDF FILE="&libref.\Project3_Codebook_VanAlstenFeeneyTaylor.PDF";
%codebook(
	data=ABC4,  
	maxfmts=0,
    w_label=100, 
	w_format=100) ;
	ODS PDF CLOSE;

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
