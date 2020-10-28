/***********************************************************************************************
* 	PROGRAM: CBIHSApplyLF.sas
* 	AUTHOR: Grace Mulholland (gracem@unc.edu)
* 	CREATION DATE: 20 June 2016
* 	LAST MODIFIED: 4 Nov 2018
* 	INSTRUCTIONS:
*				1. Call this program in from within a DATA step. This code contains only one 
*					FORMAT and one LABEL statement. Be sure that in your DATA step you include 
* 					a statement specifying your input data set (e.g., a SET statement) and be 
*					sure to RUN the DATA step.
*				2. Depending on the version of the CBIHS data you are using, some labels and 
*					formats may not be applied. SAS may write warnings to your log to inform you
*					that this is happening, but the DATA step should execute without errors.
*				3. If you encounter errors when using formats:
*						a. ensure you have first called the CBIHSFormats.sas file in your code
*						b. run the OPTIONS NOFMTERR statment in open code to instruct SAS to 
*						   continue processing the data without formats.
************************************************************************************************/
	FORMAT
		b3 country.
		b4 cbsite_revised.
		b9a spot_in_operation.
		b10a spot_type. 
		b14a b14b b14c b14d b14e b14f seen_not.
		b15 b18 yndkref.
		b17 sex.
		b19 visit_freq.
		b20 t_in_operation.
		b23 day_of_week_one.
		b24 busy_time_range.
		b29 b30 busy_attendance.
		b50 knowledgeable.
		c4 country. 
		c5 cbsite_revised.
		c10a lang. 
		c10c c11a c18 c19 c20a c20b c20c yndkref.
		c14 sex. 
		c15 edulvl.
		c16 employstatus.
		c17a jobtype.
		c22 spotvisitfreq.
		c23 allvisitfreq.
		c29a countryofres.
		c32 lengthofres.
		c34a res12m.
		c84 threemlongerneverphys.
		c85 threemlongerneverforce.
		c117b hiv_result.
		c120a c120b c120c c120d c120e c120f c120g snosdkref.
		;
		LABEL a_siteid="Cross-border site (Form A)" spotid="Spot ID (3 digits)" 
		a17="Type of spot (Form A)" a18="Busiest day at spot (Form A)" a19="Busiest time at spot (Form A)" a20="Number of people at spot at busiest time (Form A)" 
		a21="Number of CIs reporting FSW go to spot" a22="Number of CIs reporting PWIDs go to spot" a23="Number of CIs reporting MSM go to spot" 
		a24="Number of CIs reporting sex occurs on-site" a_totalci="Total number of community informants who named this spot (Form A)" a11="Country of spot (Form A)"
		b1="Interviewer ID" b3="Country" b4="Cross-border site" b5="Spot ID" b9a="Outcome" b9b="Other Spot ID used for this spot" 
		b10a="Spot type" b14a="HIV/AIDS posters displayed" b14b="Condom promotion posters" b14c="Condoms visible" b14d="Sexual lubricant visible" 
		b14e="Needle exchange visible" b14f="Peer educators present" b52a="Number of male staff" b52b="Number of female staff" b52c="Number of male patrons"
		b52d="Number of female patrons" b15="Respondent consented to answer questions" b49="Distance to nearest place where condoms are available"
		b23="Busiest day" b24="Busiest hours on busiest day" b29="Men at busy time" b30="Women at busy time"
		b16="Age" b17="Sex" b19="Spot visit frequency" b18="Works at spot" b50="How knowledgeable is spot informant"
		c1="Interviewer ID" c4="Country" c5="Cross-border site" c6="Spot ID" c10a="Language" c10b="Specify other language" c10c="Respondent willing to answer questions"
		c10d="Reason for refusing to answer questions" c11a="Respondent willing to get HIV test" c12="Age" c14="Sex" c15="Highest level of education completed" 
		c16="Currently employed" c17a="Type of work" c13="Patron/Worker ID" c18="Work related to the fishing industry" c19="Works at spot" c20a="Came to spot to socialize" 
		c20b="Came to spot to drink alcohol" c20c="Came to spot to look for a sexual partner" c21="Number of days ago when respondent last visited" 
		c22="Frequency with which respondent visits spot" c23="Frequency with which respondent visits ANY spots" 
		c24="Number of places visited today to socialize, drink alcohol, or look for a sexual partner" 
		c25="Number of additional places to visit today to socialize, drink alcohol, or look for a sexual partner"
		c29a="Country of residence" c29b="Specify other country of residence" c32="Length of time residing in smaller administrative area of residence" 
		c34a="Length of time at current residence"
		c84="Ever experienced physical violence by a male intimate partner" c85="Ever forced to have sex with male intimate partner"
		c120a="Received services at a health facility in Burundi" c117a="HIV Tester ID" c117b="HIV test result" c117c="Explain HIV test result" 
		c120b="Received services at a health facility in Rwanda in the past 12 months" c120c="Received services at a health facility in Tanzania in the past 12 months" 
		c120d="Received services at a health facility in Uganda in the past 12 months" c120e="Received services at a health facility in Kenya in the past 12 months" 
		c120f="Received services at a health facility in the DRC in the past 12 months" c120g="Received services at a health facility in another country in the past 12 months"
		c120h="Specify other countries in which services at a health facility were received in the past 12 months"
		;
