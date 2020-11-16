
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
%LET libref = C:\Users\Owner\OneDrive\Documents\UNC\CourseWork\FALL2020\EPID700\Projects\project3\sas_project3\Data;

*for Tim's library;
*%LET libref = Z:\OneDrive - University of North Carolina at Chapel Hill\PhD Courses\EPID 700\Project 3\sas_project3\Data;

*for Nandi's library;
*%LET libref = C:\Users\ntayl\OneDrive\Documents\EPID700\Project\Project 3\Data;

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


*�	In the FormC SAS data set, ensure that the DATE9. 
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

		IF spotid NE id_check THEN DO;
			flag_spotid = 1;
			*reset the checker so it isn't off for whole thing;
			id_check = spotid;

		END; 

		ELSE DO;
			flag_spotid = 0;
		END;

RUN;


PROC FREQ DATA = checkSpotIDs;
	TABLES flag_spotid * a_siteid;
RUN;


***************************************************************************
* PART 3
****************************************************************************;
TITLE "Part 3";

* Identifying Discrepancies in Double-entered Data
You determine that the error in the cross-border site Kirongwe
(site ID: 20) will be problematic for future data processing, and
so you request that the Kirongwe team re-key their Form A data. 
They re-enter the values and send them to you in the file �KirongweA.txt.�

*Explore whether there are any discrepancies between the original data from Kirongwe
and this revised data file.;

*1.	First, read the �KirongweA.txt� data file in as a SAS data set. Name your new SAS
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
(Enter only one word.) PROC ;

*compare;

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
OPTIONS MPRINT MLOGIC;

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

*Question 8. Across FormA3, FormB2, and FormC2, how many observations have a missing value for sitespotid?;

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
a.	If you hard-code or overwrite any values, add comments to your code stating the originalvalue(s) and
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

*5.	For each data set where you do not expect repetition of sitespotid values, write and 
execute one PROC
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

/*Now that you�ve created a common variable sitespotid uniquely identifying spots across
the three data sets (FormA3, FormB2, and FormC2), you�re ready to merge all the records together,
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
6 records in the ABC data set � one per Form C interview �
and each of those 6 records should include 01K-033�s spot-level data from FormA3 and FormB2.)*/


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
(Be sure you�ve followed the Step V.1 instructions carefully!) 11567 

Question 13. Would SAS have produced an output data set if you
had excluded the BY statement in the DATA step you wrote in Part V.1? 
A.	
B.	No 

***************************************************************************
* PART 6
****************************************************************************;

/*Part VI. Applying Labels and Formats
Creating labels and user-defined formats for a large data set can be cumbersome.
Fortunately, a colleague has shared two SAS program files for these tasks: �CBIHSApplyLF.sas� 
and �CBIHSFormats.sas.�

1.	Open these two SAS programs just to see what they contain. 
Exit the files once you have an understanding of their contents. 
(Do not run any code while you have these program files open in SAS.)

2.	Return to your SAS program for Project 3. Write and 
execute exactly one statement in your SAS program that will execute all the code in the
�CBIHSFormats.sas� file.
*/

*file pointer -> update the base filepath;
DATA _NULL_;
	CALL SYMPUT('newlibref', TRANWRD("&libref", "\Data", "\SAS Programs"));
RUN;

%INCLUDE "&newlibref.\CBIHSFormats.sas";

/*Question 14. What statement did you use to execute the code in the �CBIHSFormats.sas� file? 
Enter the SAS keyword for the statement 
(enter one word, including any relevant special characters): %INCLUDE */

/*3.	In a new DATA step, use one statement to execute the contents of �CBIHSApplyLF.sas.�
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

/**/
/**/
/**/
/**/
/**/


***************************************************************************
* PART 7
****************************************************************************;

/*Another important task in managing a data set can data de-identification. 
As you can see by looking at the data collection forms (�FormA.pdf,� �FormB.pdf,� and �FormC.pdf�)
the full CBIHS data sets contain sensitive data. In addition to HIV test results and 
viral load data, the data sets include indications of behaviors that can be stigmatizing and illegal.

When de-identifying data, 
you�ll need to consider which variables will need to be dropped or masked. 
You�ll need to exclude direct identifiers, of course, but you�ll also need take precautions 
to prevent deductive disclosure of participants. The study design and setting should be considered 
when making plans to de-identify data. In a venue-based survey such as this, for example,
the combination of a spot name or location data along with age, sex, and an indicator of 
employment at the spot could be sufficient to identify a respondent. A strategy for 
de-identifying a data set will typically weigh, among other factors, the risks 
of identification, the data safeguards to be used, and data use agreements.

If your data set contains identifiers, 
you could de-identify your data in a variety of ways.
You could exclude the relevant variables or delete sensitive values 
contained in them; you might recode values into coarser categories; 
or you may use offsets to mask the values, preferably in a way that maintains
the statistical properties of the original data. In the data set you received, 
for example, I applied a random offset to the date variable c2.

If the data collection tool for your study contains open-ended fields,
your de-identification process should include manual checks for sensitive
values in these fields. Be sure to check even fields were not intended to 
contain sensitive data. Participants or study staff could have entered more 
information than requested, or they may have recorded sensitive information in an incorrect field.

One way to efficiently check for sensitive values in open-ended questions is 
to generate frequency tables listing all the values of character variables in your data set.
*/

/* Question 17. Fill in the blank with just one term 
(and not a macro variable) that will provide one-way frequency tables for all 
character variables in the ABC3 data set:
*/
PROC FREQ DATA=ABC3;
	TABLES _CHAR_ / LIST MISSPRINT;
RUN;

/*2.	Consult this list of direct identifiers from UNC�s IRB office.
Look through the values from your Step VII.1 output and note whether the data values 
contains any direct identifiers that are included on that list.

� Names- NO
� Geographic subdivisions smaller than a state - SPOTID potentially?
� Zip codes -NO
� All elements of dates except year directly related to an individual, including birth or
death or dates of health care services or health care claims
� Telephone numbers - YES
� Fax numbers
� Electronic mail addresses
� Social security numbers
� Medical record numbers
� Health plan beneficiary identifiers- NO
� Account numbers - NO
� Certificate/license numbers - NO
� Vehicle identifiers and serial numbers, including license plate numbers - NO
� Device identifiers and serial numbers - NO
� Web universal resource locators (URL) -NO
� Internet protocol (IP) address numbers -NO
� Biometric identifiers, including finger and voice prints -NO
� Full face photographic images -NO
� Any other number, characteristic or code that could be used by the researcher to
identify the individual -> Possibly; LANGUAGE where variations of deaf are listed */


/*Question 18. Does ABC3 contain any direct identifiers listed on the UNC IRB document provided? 
A.	YES
*/


/*3.	In a new DATA step, create a new data set named ABC4, based on the following instructions:
a.	If you determined that there were no direct identifiers in the data set, output ABC3 to ABC4 
without any changes.
b.	If you did find identifiers in ABC3, suppress any identifying data values by replacing 
them with a SAS missing value appropriate for the variable type. (Consider referencing a
participant�s values for c13 and/or sitespotid to identify individuals whose sensitive
values are to be overwritten). Be sure to add a comment in your code explaining what you did.


*person who gave cell number
(Note: Any identifiers in the ABC3 data set are simulated for this project; they are not true values.)
*/

DATA ABC4;
SET ABC3;

	*because some of these languages might be spoken by only small groups 
	of people (I don't know much about how common they are in the source populations)
	language could potentially be an identifying characteristic.
	Probably especially true of deafness which is pretty rare. Suppress those with "";

	IF UPCASE(c10b) IN ('DEAF', 'DEEF', 'DUMP DEAF') THEN c10b = "";
		ELSE c10b = c10b;

	*person who gave cell number;
	IF c10d = "No time now call my mobile number 0718408732" THEN c10d = "";
		ELSE c10d = c10d;

RUN;


/* Check that coding was done correctly*/

PROC FREQ DATA=ABC4;
	TABLES _CHAR_ / LIST MISSPRINT;
RUN;
/**/

/**/
/**/
/**/
/**/


***************************************************************************
* PART 8
****************************************************************************;


/*Part VIII. Creating a Codebook

Knowing that you have not received a codebook for this data set
(you only have questionnaires), you are dreading the task of creating one from scratch. 
Luckily, a colleague has shared a macro that promises to make this task easier.

1.	Open the program �codebook.sas.� There are detailed comments near the top of the
program explaining various parameters you can specify for the macro.
*/


/*
2.	Before you can call the codebook macro, you�ll first need to define this macro 
in your SAS session. Within your Project 3 SAS program,
write one statement that will execute the contents of the �codebook.sas� program.*/

%INCLUDE "&newlibref.\codebook.sas";
RUN;

/*3.	Call the macro, specifying the data set name and increasing the widths of the 
label and format fields to ensure the labels and formats are not truncated in the output 
(consult the �codebook.sas� program for instructions on how to specify these and other parameters
for the macro). You may specify additional parameters for the macro 
to further customize the codebook if you would like, but you are not required to. */
%codebook(data = ABC4,
		  	maxfmts = 0,
			w_format = 100,
		    w_label = 100);


/*4.	Use an ODS destination statement to output the codebook to a PDF file.
			Name your codebook file �Project3_Codebook_GroupName.pdf.�*/
ODS PDF FILE = "Project3_Codebook_VanAlstenFeeneyTaylor.pdf";
%codebook(data = ABC4,
		  	maxfmts = 0,
			w_format = 100,
		    w_label = 100);
ODS PDF CLOSE;


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

*a.	Use a DATA step, and name your output data set ABC5.;
DATA ABC5;
SET ABC4;

*b.	Use an ARRAY and a DO loop (and any other statements you need) in your DATA step.;
	*c.	If any value among c120a, c120b, c120c, c120d, c120e, c120f, or c120g is 999 
	(refused) or missing: hfcountrycount should be assigned a missing value;
	*d.	If no value among c120a, c120b, c120c, c120d, c120e, c120f, or c120g is 999 
	(refused) or missing: hfcountrycount should be set equal to the number of countries 
	in which the participant reported receiving health services.;

	hfcountrycount = 0;

	ARRAY myarray c120a c120b c120d c120e c120f c120g;
	ARRAY myarray2 c120aR c120bR c120dR c120eR c120fR c120gR;

	DO i = 1 TO 6;
		IF myarray[i] IN (999, .) THEN myarray2[i] = .;
			ELSE myarray2[i] = myarray[i];

		IF myarray2[i] = . THEN hfcountrycount = .;
			ELSE IF myarray2[i] = 1 THEN hfcountrycount = hfcountrycount + 1;
			ELSE hfcountrycount = hfcountrycount;

	END;


	*ii.c120g indicates if services were received in a country other than those specifically 
	asked about in c120a through c120f. Respondents who said that they received services in 
	any additional countries were asked to provide the names of those countries in c120h.
	For these respondents, we need to review the values in c120h and manually update hfcountrycount
	according to the number of countries listed. To do this, perform the following steps for any 
	participants where c120g=1: ;
	IF c120h NE "" THEN PUT sitespotid= c13= c120h=;


	*2.	Based on the notes you find in the log, use the sitespotid and c13 values to 
	(conditionally, for the appropriate records) add the number of additional countries named 
	in c120h to the value in hfcountrycount.
	3.	Assume that any numeric responses in c120h indicate the number of additional
	countries in which services were received. If c120h=0 (or �O,� potentially intended as a 0),
	assume that the interviewer had erroneously selected �yes� to c120g, and do add anything to the 
	value in hfcountrycount.
	e.	Given that you manually checked the values in c120 and hard-coded changes 
	to the hfcountrycount variable, add a comment to your code with a prominent
	reminder that values in c120 and hfcountrycount must be re-checked and possibly 
	updated if the source data files change.


	*********************************************************************************
	NOTE TO FUTURE USERS: The following observations had text entry for other countries
	where healthcare was received. I manually added to the country counts the number of
	distinct countries listed for each of the following participants. If survey or
	data change, this coding may also need to change to accomodate updates. I assume
	0 or "o" entries represent no other countries:

	sitespotid=01K-066 c13=32002 c120h=Dubai Quater
	sitespotid=01U-030 c13=21002 c120h=South Sudan
	sitespotid=01U-042 c13=21006 c120h=South Sudan
	sitespotid=01U-063 c13=32008 c120h=Sudan
	sitespotid=02U-087 c13=73007 c120h=South Sudan
	sitespotid=03U-085 c13=101009 c120h=Sudan
	sitespotid=04K-014 c13=164010 c120h=Tunisia
	sitespotid=04K-017 c13=166004 c120h=Mozambique
	sitespotid=04K-022 c13=166006 c120h=India,  Dubai
	sitespotid=04T-059 c13=150002 c120h=Oman
	sitespotid=10U-002 c13=407001 c120h=1
	sitespotid=10U-081 c13=402001 c120h=O
	sitespotid=10U-088 c13=401008 c120h=South Africa
	sitespotid=11K-060 c13=423005 c120h=South Africa
	sitespotid=21U-010 c13=321004 c120h=Sudan
	sitespotid=21U-097 c13=324002 c120h=Zimbabwe
	sitespotid=21U-119 c13=325002 c120h=0
	sitespotid=21U-119 c13=325008 c120h=Turkey
****************************************************************;

IF sitespotid="01K-066" AND c13=32002 THEN hfcountrycount = hfcountrycount + 2;
	ELSE IF sitespotid="01U-030" AND c13=21002 THEN hfcountrycount = hfcountrycount + 1;
	ELSE IF sitespotid="01U-042" AND c13=21006 THEN hfcountrycount = hfcountrycount + 1;
	ELSE IF sitespotid="01U-063" AND c13=32008 THEN hfcountrycount = hfcountrycount + 1;
	ELSE IF sitespotid="02U-087" AND c13=73007 THEN hfcountrycount = hfcountrycount + 1;
	ELSE IF sitespotid="03U-085" AND c13=101009 THEN hfcountrycount = hfcountrycount + 1;
	ELSE IF sitespotid="04K-014" AND c13=164010 THEN hfcountrycount = hfcountrycount + 1;
	ELSE IF sitespotid="04K-017" AND c13=166004 THEN hfcountrycount = hfcountrycount + 1;
	ELSE IF sitespotid="04K-022" AND c13=166006 THEN hfcountrycount = hfcountrycount + 2;
	ELSE IF sitespotid="04T-059" AND c13=150002 THEN hfcountrycount = hfcountrycount + 1;
	ELSE IF sitespotid="10U-002" AND c13=407001 THEN hfcountrycount = hfcountrycount + 1;
	ELSE IF sitespotid="10U-088" AND c13=401008 THEN hfcountrycount = hfcountrycount + 1;
	ELSE IF sitespotid="11K-060" AND c13=423005 THEN hfcountrycount = hfcountrycount + 1;
	ELSE IF sitespotid="21U-010" AND c13=321004 THEN hfcountrycount = hfcountrycount + 1;
	ELSE IF sitespotid="21U-097" AND c13=324002 THEN hfcountrycount = hfcountrycount + 1;
	ELSE IF sitespotid="21U-119" AND c13=325008 THEN hfcountrycount = hfcountrycount + 1;
	ELSE hfcountrycount = hfcountrycount;


RUN;

*Check some of coding to see if done appropriately;
PROC PRINT DATA = abc5 (OBS = 10);
	VAR c120aR c120bR c120dR c120eR c120fR c120gR hfcountrycount;
RUN;

PROC PRINT DATA = abc5;
	WHERE c120h NE "";
	VAR c120aR c120bR c120dR c120eR c120fR c120gR c120h hfcountrycount;
RUN;


/*Question 19. For many observations did SAS print a note to the log (as per Step
1.d.ii.2)? (You may add another note to your log in which you calculate this value,
if you feel so inclined.) 18*/


/*2.	Moving forward with the report, use any number of SAS procedures and DATA
steps to create and output the following summary table, with no other output, 
for the subset of data collected in BUSIA (cross-border site ID = 2):*/

ODS GRAPHICS OFF;            
ODS EXCLUDE ALL; 
/*NOTE: cannot just do noprint because NLEVELS is contained
in a table and the ods selector can't get it if noprint option
specified. Thus, need to exclude all output*/


	/*i.	�Total number of spots listed� = The total number of unique spots in 
	the cross-border site listed by community informants in Step 1 of the PLACE method*/
	PROC FREQ DATA=formA3 NLEVELS;
		WHERE a_siteid = 2;
   		TABLES spotid;
		ODS OUTPUT NLEVELS= totalSpots;
	RUN;

	/* ii.	�Number of spots visited for verification� = The total number of spots visited
	for spot verification in Step 2 of the PLACE method, regardless of the outcome of verification 
	(i.e., regardless of whether the spot was ultimately found, closed, a duplicate spot, etc.)*/
	PROC FREQ DATA = formB2 NLEVELS;
		WHERE b4 = 2;
		TABLES sitespotid;
		ODS OUTPUT NLEVELS = totalVisit;
	RUN;

	/*iii.	�Percent of verified spots found and operational� = Among all spots visited for
	spot verification in Step 2 of the PLACE method, the percent of spots that were classified 
	as �found and operational.� Hint: see b9a. -> look for b9a =2*/
	PROC FREQ DATA = formB2 NLEVELS;
		WHERE b4 = 2 AND b9a = 2;
		TABLES sitespotid;
		ODS OUTPUT NLEVELS = totalOper;
	RUN;

ODS EXCLUDE NONE;  
 





*make a dataset that combines the 3 above datasets;
DATA q19;
	SET totalSpots totalVisit;

	LENGTH Statistic $ 50;

	IF TableVar = "spotid" THEN Statistic = "Total Number of Spots Visited";
		ELSE Statistic = "Number of spots visited for verification";

RUN;

DATA q192;
SET q19 totalOper;
*both the totalvisit and totaloper use sitespotid. This will keep the two
together so I can retain one to push forward as denominator for the percentage;
BY DESCENDING TableVar;

	RETAIN denominator;

	*This brings forward the denominator;
	IF first.TableVar THEN denominator = NLEVELS;

	*only calculate the percentage for the place where 
	we haven't specified string of definition yet;
	IF TableVar = "sitesp" AND NOT first.TableVar THEN DO;
		Statistic = "Percent of visited spots found and operational";
		NLEVELS =ROUND(100*(NLEVELS/denominator));
	END;

	RENAME NLEVELS = Value;

RUN;

PROC PRINT DATA = q192 NOOBS;
	VAR Statistic Value;
	TITLE "Summary Data for Cross-Border Site Busia (Site 2)";
RUN;

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
	WHERE c10c=1 AND c5=2;
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
	TITLE2 "Unweighted results from Busia (Site 2)";
	FOOTNOTE "*Number of countries in which health services were received in preceding 12 months";
RUN;


*Question 23. According to the table you just produced, among female respondents
in Malaba, what was the mean number of countries in which health services were 
received in the preceding 12 months? Report the mean to 2 decimal places. Mean = 1.12  ;



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
(in the TITLE2 statement). You�ll need to replace the value given for c5 (i.e., 1, 
the site ID for Malaba) with a macro variable for the site ID, and you�ll need to 
replace the site name �Malaba� with a macro variable for the site name.;

%MACRO sitereport (bordersite);

	DATA _NULL_;

		IF "&bordersite." = "Malaba" THEN CALL SYMPUT('sitenum', 1);
			ELSE IF "&bordersite." = "Busia" THEN CALL SYMPUT('sitenum', 2);
			ELSE IF "&bordersite." = "Katuna/Gatuna" THEN CALL SYMPUT('sitenum', 3);
			ELSE IF "&bordersite." = "Holili/Taveta" THEN CALL SYMPUT('sitenum', 4);
			ELSE IF "&bordersite." = "Port Victoria/Sio Port/Majanji" THEN CALL SYMPUT('sitenum', 5);
			ELSE IF "&bordersite." = "Isebania/Sirare" THEN CALL SYMPUT('sitenum',7);
			ELSE IF "&bordersite." = "Namanga" THEN CALL SYMPUT('sitenum', 9);
			ELSE IF "&bordersite." = "Kagitumba/Miriama Hills" THEN CALL SYMPUT('sitenum',10);
			ELSE IF "&bordersite." = "Mbita/Rusinga Island" THEN CALL SYMPUT('sitenum',11);
			ELSE IF "&bordersite." = "Kasenyi" THEN CALL SYMPUT('sitenum', 12);
			ELSE IF "&bordersite." = "Muhuru Bay" THEN CALL SYMPUT('sitenum', 13);
			ELSE IF "&bordersite." = "Kirongwe" THEN CALL SYMPUT('sitenum', 20);
			ELSE IF "&bordersite." = "Mutukula" THEN CALL SYMPUT('sitenum',21);
	RUN;

ODS GRAPHICS OFF;            
ODS EXCLUDE ALL; 
/*NOTE: cannot just do noprint because NLEVELS is contained
in a table and the ods selector can't get it if noprint option
specified. Thus, need to exclude all output*/


	/*i.Total number of spots listed = The total number of unique spots in 
	the cross-border site listed by community informants in Step 1 of the PLACE method*/
	PROC FREQ DATA=formA3 NLEVELS;
		WHERE a_siteid = &sitenum.;
   		TABLES spotid;
		ODS OUTPUT NLEVELS= totalSpotsM;
	RUN;

	/* ii.	�Number of spots visited for verification� = The total number of spots visited
	for spot verification in Step 2 of the PLACE method, regardless of the outcome of verification 
	(i.e., regardless of whether the spot was ultimately found, closed, a duplicate spot, etc.)*/
	PROC FREQ DATA = formB2 NLEVELS;
		WHERE b4 = &sitenum.;
		TABLES sitespotid;
		ODS OUTPUT NLEVELS = totalVisitM;
	RUN;

	/*iii.	Percent of verified spots found and operational = Among all spots visited for
	spot verification in Step 2 of the PLACE method, the percent of spots that were classified 
	as �found and operational.� Hint: see b9a. -> look for b9a =2*/
	PROC FREQ DATA = formB2 NLEVELS;
		WHERE b4 = &sitenum. AND b9a = 2;
		TABLES sitespotid;
		ODS OUTPUT NLEVELS = totalOperM;
	RUN;

ODS EXCLUDE NONE;  

*make a dataset that combines the 3 above datasets;
DATA q19M;
	SET totalSpotsM totalVisitM;

	LENGTH Statistic $ 50;

	IF TableVar = "spotid" THEN Statistic = "Total Number of Spots Visited";
		ELSE Statistic = "Number of spots visited for verification";

RUN;

DATA q192M;
SET q19M totalOperM;
*both the totalvisit and totaloper use sitespotid. This will keep the two
together so I can retain one to push forward as denominator for the percentage;
BY DESCENDING TableVar;

	RETAIN denominator;

	*This brings forward the denominator;
	IF first.TableVar THEN denominator = NLEVELS;

	*only calculate the percentage for the place where 
	we havent specified string of definition yet;
	IF TableVar = "sitesp" AND NOT first.TableVar THEN DO;
		Statistic = "Percent of visited spots found and operational";
		NLEVELS =ROUND(100*(NLEVELS/denominator));
	END;

	RENAME NLEVELS = Value;

RUN;

PROC PRINT DATA = q192M NOOBS;
	VAR Statistic Value;
	TITLE "Summary Data for Cross-Border Site &bordersite. (Site &sitenum.)";
RUN;

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
	WHERE c10c=1 AND c5=&sitenum.;
	CLASS c10c c14 c11a;
	VAR count consentHIV HIVpos secormore edudata fisher fisherdata c12 hfcountrycount;
	TABLE (count="Total respondents")*(N='N'*f=8.)
	      (HIVpos="Reactive HIV test")*(N='N'*f=8. PCTN<consentHIV>='%'*f=12.2)
      (secormore= "Secondary education or higher")*(N='N'*f=8. PCTN<edudata>='%'*f=12.2)
	      (fisher= "Works in fishing industry")*(N='N'*f=8. PCTN<fisherdata>='%'*f=12.2)
	      (c12="Age")*(MEAN= 'Mean' *f=12.2 STD= 'SD'*f=12.2)
	      (hfcountrycount= "Countries received services in*")*(MEAN='Mean'*f=12.2 STD='SD'*f=12.2),
   		(c14 all) / STYLE=[JUST=center];
	TITLE "East Africa Cross-Border Integrated Health Study (2016-2017)";
	TITLE2 "Unweighted results from &bordersite.(Site &sitenum.)";
	FOOTNOTE "*Number of countries in which health services were received in preceding 12 months";
RUN;

ODS STARTPAGE=NOW;
%MEND;


*5.	Run your sitereport macro code, %MACRO to %MEND, to define the sitereport macro.;

*6.	Call your site-by-site report macro for all 13 sites, exporting the output to a 
single, well-formatted PDF file with the output centered and the results for each site
on a new page. To do this:

a.	Execute the statement: OPTIONS CENTER in open code to center your output.
b.	Write an ODS destination statement to write your output to a PDF. Apply the ODS style
JOURNAL in that ODS statement.
c.	Your goal is to have one page per site, with both tables for a single site appearing
on one page To do this, include the STARTPAGE=NEVER option in the ODS statement. Then, add
the following ODS statement in your sitereport macro (it�ll run in open code, like other
ODS statements) to tell SAS where to begin printing to a new page: ODS STARTPAGE=NOW
d.	After the ODS PDF statement, call your sitereport macro for all 13 sites.
e.	Immediately after the macro calls, close the ODS PDF destination.; 

OPTIONS CENTER;
ODS PDF FILE = "Project3_Report_VanAlstenFeeneyTaylor.pdf" STARTPAGE=NEVER;

%sitereport(Malaba);
%sitereport(Busia);
%sitereport(Katuna/Gatuna);
%sitereport(Holili/Taveta);
%sitereport(Port Victoria/Sio Port/Majanji);
%sitereport(Isebania/Sirare);
%sitereport(Namanga);
%sitereport(Kagitumba/Miriama Hills);
%sitereport(Mbita/Rusinga Island);
%sitereport(Kasenyi);
%sitereport(Muhuru Bay);
%sitereport(Kirongwe);
%sitereport(Mutukula);

ODS PDF CLOSE;

*Question 24. According to your report, among the spots visited for verification 
in Kirongwe, what percent of visited spots were found and operational? Report the
percentage to the nearest integer. (Do not enter the percent sign.) 73 ;

*Question 25. According to your report, which cross-border site had the highest
overall prevalence of HIV among bio-behavioral survey participants? Provide the site
ID number for that cross-border site.  (Interpretation note: I am requesting the 
prevalence only among participants because we have not yet weighted these data to account
for refusals of the HIV test or for differential sampling probabilities across participants.)
Site ID number: 13;


*7.	Save the report you just generated as a PDF file named �Project3_Report_GroupName.pdf.�;


***************************************************************************
* PART 10
****************************************************************************;

*Now it�s time to pass the data set on to your collaborators. Your collaborators
use STATA and Excel, so to keep things simple, you�ll export the data to a CSV 
file that can be read into either program.;

*1.	Export your data set as a CSV file with formatted values (using the formats 
already applied � no need to add more). Name the data file �Project3_Data_GroupName.csv.�
Check the output data set to be sure you�ve written the formatted values to the CSV file.;
PROC EXPORT DATA = ABC5
  OUTFILE= "&libref.\Project3_Data_VanAlstenFeeneyTaylor.csv"
  DBMS= CSV
  LABEL
  REPLACE;

  PUTNAMES= yes;

RUN;

*2.	Next, encrypt the data file in a zip file for added security and faster upload/download
times. Save your csv file to a zip file named �Project3_Data_GroupName.zip� and encrypt
the file with the password: 2+2...isfive! (be sure to include the �!�). Click here more 
detailed instructions on preparing zip files.;
