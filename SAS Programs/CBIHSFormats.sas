***********************************************************************************************
* 	PROGRAM: CBIHSFormats.sas
* 	AUTHOR: Grace Mulholland (gracem@unc.edu)
* 	CREATION DATE: 20 June 2016
* 	LAST MODIFIED: 7 Sept 2017
* 	INSTRUCTIONS: Use an %INC statement to call this PROC FORMAT step in your SAS program;
***********************************************************************************************;

PROC FORMAT;
	VALUE country
	1="Kenya"
	2="Rwanda"
	3="Tanzania"
	4="Uganda"
	.="Missing" 
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE cbsite_revised
	1="Malaba"
	2="Busia"
	3="Katuna/Gatuna"
	4="Holili/Taveta"
	5="Sio Port/Port Victoria/Majanji"
	13="Muhuru Bay"
	7="Isebania/Sirare"
	9="Namanga"
	10="Kagitumba/Mirama Hills" 
	11="Mbita landing site and Rusinga Island"
	12="Kasenyi landing site"
	19="Kisoro"
	20="Kirongwe"
	21="Mutukula"
	25="Muhuru Bay/Kirongwe"
	30="Sio Port/Port Victoria"
	31="Majanji"
	.="Missing" 
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE yndkref
	1="Yes"
	2="No"
	888="Don't Know"
	999="Refused" 	
	.="Missing" 
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE sex
	1="Male"
	2="Female"
	999="Refused" 	
	.="Missing" 
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE lang
	1="English"
	2="Kiswahili"
	3="Luhya"
	4="Dholuo"
	5="Maasai"
	6="Luganda"
	7="Samia"
	8="Rukiga"
	9="Kinyarwanda"
	10="Other" 
	.="Missing" 
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE edulvl
	1="No school or less than primary school completed"
	2="Primary school completed"
	3="Some secondary school completed"
	4="Secondary school completed"
	5="Some post-secondary completed"
	6="Post-secondary completed"
	999="Refused" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE employstatus
	1="No, looking for work"
	2="No, not looking for work"
	3="Informally employed"
	4="Yes, occasional or part-time work"
	5="Yes, full-time work"
	999="Refused" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE jobtype
	1="Farming"
	2="Fishing"
	3="Truck driving"
	4="Construction work"
	5="Other manual labor"
	6="Security"
	7="Military"
	8="Entertainment"
	9="Transportation (not truck driving)"
	10="Office work"
	11="Small business"
	12="NGO/Non-profit/Government work"
	13="Cleaning"
	14="Domestic work"
	15="Bar attending"
	16="Still in school"
	17="Other work"
	100="Construction work or manual labor"
	101="Military or security"
	999="Refused" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE spotvisitfreq
	1="Every day"
	2="4 to 6 times per week"
	3="2 to 3 times per week"
	4="Every week"
	5="2 to 3 times per month"
	6="Every month"
	7="Less than once a month"
	8="This is my first time here."	
	.="Missing"
	999="Refused" 
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE allvisitfreq
	1="I live at such a site."
	2="More than once per day."
	3="Every day"
	4="4 to 6 times per week"
	5="2 to 3 times per week"
	6="Every week"
	7="2 to 3 times per month"
	8="Every month"
	9="Less than once a month"
	999="Refused" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE countryofres
	1="Kenya"
	2="Rwanda"
	3="Tanzania"
	4="Uganda"
	5="Burundi"
	6="Other"
	999="Refused" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE res12m
	1="Less than 12 months"
	2="12 months or more"
	999="Refused"	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)";
	VALUE lengthofres
	1="6 months or less"
	2="More than 6 months, but not more than 12 months"
	3="More than 1 year, but not more than 3 years"
	4="More than 3 years, but not more than 5 years"
	5="More than 5 years, but not for entire life"
	6="Lived there for entire life"
	999="Refused" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE taway
	1="2 weeks or less"
	2="More than 2 weeks, but not more than 1 month"
	3="More than 1 month, but not more than 3 months"
	4="More than 3 months"
	999="Refused" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE twelvemlongerneverpayment
	1="Yes, respondent has given someone money as payment for sex. This has happened within the past 12 months."
	2="Yes, respondent has given someone money as payment for sex. This has not happened in the past 12 months, but happened more than 12 months ago."
	3="Respondent has NEVER given someone money as payment for sex."
	4="Refused" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE twelvemlongerneverggf
	1="Yes, respondent has received gifts, goods, or favors in exchange for sex. This has happened within the past 12 months."
	2="Yes, respondent has received gifts, goods, or favors in exchange for sex. This has not happened in the past 12 months, but it happened more than 12 months ago."
	3="Respondent has NEVER received gifts, goods, or favors in exchange for sex."
	999="Refused" .T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE twelvemlongerneverm
	1="Yes, respondent has received money in exchange for sex. This has happened within the past 12 months."
	2="Yes, respondent has received money in exchange for sex. This has not happened in the past 12 months, but it happened more than 12 months ago."
	3="Respondent has NEVER received money in exchange for sex."
	999="Refused" .T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)" 	
	.="Missing"; 
	VALUE threemlongerneverphys
	1="Yes, respondent has experienced physical violence committed by a partner. This has happened within the past 3 months."
	2="Yes, respondent has experienced physical violence committed by a partner. This has not happened in the past 3 months, but it happened within the past 12 months."
	3="Yes, respondent has experienced physical violence committed by a partner. This has not happened in the past 12 months, but it happened more than 12 months ago."
	4="No, respondent has NEVER experienced physical violence committed by a partner."
	999="Refused" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE threemlongerneverforce
	1="Yes, respondent has been forced by a partner to have sex. This has happened within the past 3 months."
	2="Yes, respondent has been forced by a partner to have sex. This has not happened in the past 3 months, but it happened within the past 12 months."
	3="Yes, respondent has been forced by a partner to have sex. This has not happened in the past 12 months, but it happened more than 12 months ago."
	4="No, respondent has NEVER been forced by a partner to have sex."
	999="Refused" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE threemlongerneversexbcfear
	1="Yes, respondent has had sex with a partner out of fear. This has happened within the past 3 months."
	2="Yes, respondent has had sex with a partner out of fear. This has not happened in the past 3 months, but it happened within the past 12 months."
	3="Yes, respondent has had sex with a partner out of fear. This has not happened in the past 12 months, but it happened more than 12 months ago."
	4="No, respondent has NEVER had sex with a partner out of fear."
	999="Refused" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE twelvemlongerneverdrug
	1="Yes, respondent has injected drugs. This has happened within the past 12 months."
	2="Yes, respondent has injected drugs. This has not happened in the past 12 months, but it happened more than 12 months ago."
	3="Respondent has NEVER injected drugs."
	999="Refused" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE showcondom
	1="Respondent reported having a condom, and condom was shown"
	2="Respondent reported having a condom, but condom was NOT shown"
	3="Respondent reported that he/she did NOT have a condom"
	999="Respondent refused to report whether he/she had a condom" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE hiv_diag_t
	1="Within the past 6 months"
	2="More than 6 months ago, but within the past 12 months"
	3="More than 12 months ago, but within the past 3 years"
	4="More than 3 years ago"
	5="Respondent has NEVER seen a health care worker for HIV care or treatment."
	999="Refused" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE hiv_care_t
	1="Within the past 3 months"
	2="More than 3 months ago, but within the past 6 months"
	3="More than 6 months ago, but within the past 12 months"
	4="More than 12 months ago"
	5="Don't know"
	888="Don't know"
	999="Refused" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE snosdkref
	1="Received services"
	2="Did not receive services"
	888="Don't know"
	999="Refused" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE tb_sympt
	1="Cough lasting longer than 2-3 weeks (only)"
	2="Blood in sputum (only)"
	3="Cough lasting longer than 2-3 weeks AND blood in sputum"
	4="Neither symptom"
	999="Refused" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE barriers
	1="Barrier"
	2="Not a barrier"
	999="Refused" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE stockout
	1="Yes: Needed medication, experienced stock-out"
	2="No: Needed medication, never experienced stock-out"
	3="Not applicable: Did not need medication in past 12 months"
	999="Refused" .T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)" 	
	.="Missing"; 
	VALUE preg_outcome
	1="Live birth"
	2="Still birth"
	3="Miscarriage (at less than 20 weeks pregnant)"
	4="Elective abortion"
	999="Refused" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE fertility_intent
	1="Yes, would like a child/another child"
	2="No, prefers no children/no additional children"
	3="Says she is infertile"
	888="Undecided/doesn't know"
	999="Refused" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE wait_time
	1="Would live to have a child in the next 2 years"
	2="Would like to wait longer than 2 years to have a child"
	888="Undecided/doesn’t know"
	999="Refused" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE cohab
	1="Currently married/living with a partner"
	2="Previously married/lived with a partner, but not now"
	3="NEVER married or lived with a partner"
	999="Refused" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE when_last_sw
	1="Within the last week"
	2="Longer than 1 week ago, but within the last 4 weeks"
	3="Longer than 4 weeks ago, but within the last 3 months"
	4="Longer than 3 months ago, but within the last 12 months"
	5="Longer than 12 months ago"
	999="Refused" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE verif_timelastswf
	1="Within the last week"
	2="Longer than 1 week ago, but within the last 4 weeks"
	3="Longer than 4 weeks ago, but within the last 3 months"
	4="Longer than 3 months ago, but within the last 12 months"
	5="Longer than 12 months ago"
	999="Refused"	
	.="Missing"
	.C="Contradictory responses to c51 and c95"
	.Y="Within the last 12 months, but not further specified"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE verifstartSW3m
	.C="Contradictory responses to firt SW in past 3 months (c92) and [age (c12) - age of first SW (c93)]"
	.O="Did not respond to either first SW in past 3 months (c92) or age of first SW (c93)"
	.B="Missing responses to first SW in past 3 months (c92) and age of first SW (c93)"	
	.="Missing"
	0="First SW longer than 3 months ago"
	1="First SW plausibly within past 3 months";
	VALUE percent_kp
	1="All (100%)"
	2="Almost all (85-99%)"
	3="A little more than half (60-84%)"
	4="Half (40-59%)"
	5="Some (15-39%)"
	6="Few (1-14%)"
	7="None (0%)"
	999="Refused" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE selfcomp_yn
	1="Yes"
	2="No" .T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"	
	.="Missing"; 
	VALUE selfcomp_yn_nomainpart
	1="Yes"
	2="No"
	3="I do not have a main partner." 
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"	
	.="Missing"; 
	VALUE selfcomp_yn_nosex12m
	1="Men only"
	2="Women only"
	3="Men and women"
	4="I have not had sex in the past 12 months." 
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"	
	.="Missing"; 
	VALUE selfcomp_yn_noptvsex
	1="Yes"
	2="No"
	3="I have never had penis to vagina sex." 
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"	
	.="Missing"; 
	VALUE selfcomp_yn_noanalsex
	1="Yes"
	2="No"
	3="I have never had anal sex." 
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"	
	.="Missing"; 
	VALUE selfcomp_hivtest
	1="Infected"
	2="Not infected"
	3="I have never received an HIV test result." 
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"	
	.="Missing"; 
	VALUE hiv_result
	1="Reactive"
	2="Non-reactive"
	3="Other outcome"
	.Q="Missing because respondent did not consent to answer questions"
	.H="Missing because respondent did not consent to HIV test" 
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"	
	.="Missing"; 
	VALUE mrres
	1="Infected with HIV"
	2="Not infected with HIV"
	3="Other result"
	4="Did not collect result"
	888="Don't know"
	999="Refused" 	
	.="Missing"
	.T="Interview terminated early"
	.Z="Assigned as missing during cleaning because question was misinterpreted";
	VALUE res
	1="Infected with HIV"
	2="Not infected with HIV"
	3="Other result"
	4="Have never collected a result"
	888="Don't know"
	999="Refused" 	
	.="Missing"
	.T="Interview terminated early"
	.Z="Assigned as missing during cleaning because question was misinterpreted";
	VALUE confidence
	1="Not confident"
	2="Fairly confident"
	3="Very confident"
	999="Refused to say how confident" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE spot_in_operation
	1="Location not found"
	2="Location found operational"
	3="Location closed temporarily"
	4="Location closed permanently"
	5="Duplicate location, spot informant already interviewed here"
	6="Reassigned"
	7="Other" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE spot_type
	1="Bar/Pub"
	2="Night club/Disco"
	3="Massage parlor"
	4="Brothel"
	5="Truck stop"
	6="Lorry/Railway station"
	7="Hotel/Guest house/Lodge"
	8="Sex worker street"
	9="Cemetery"
	10="Beach"
	11="Gym"
	12="Park"
	13="Construction site"
	14="Recreational/Game centre"
	15="Video/Cinema"
	16="Kiosk/Store/Shop"
	17="Hair Salon"
	18="Market"
	19="Shopping centre/Mall"
	20="Fast food/Restaurant"
	21="Internet café"
	22="Church/Temple/Mosque"
	23="Campus/School"
	24="Tourist attraction"
	25="Private house"
	26="Cultural event"
	27="Party (event)"
	28="Website"
	29="Escort service"
	30="Phone"
	31="Other"
	32="Cannot determine" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE seen_not
	1="Seen"
	2="Not seen" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE visit_freq
	1="I live at this spot."
	2="Daily"
	3="4 to 6 times per week"
	4="2 to 3 times per week"
	5="Once per week"
	6="2 to 3 times per month"
	7="Once per month"
	8="Less than once per month"
	9="This is my first time at this spot."
	999="Refused to answer" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE t_in_operation
	1="Less than 1 year"
	2="1 to 2 years"
	3="More than 2 years"
	9="Not applicable"
	888="Don't know"
	999="Refused to answer" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE six_longer_never_dk
	1="Within the past 6 months"
	2="Longer than 6 months ago"
	3="Never"
	888="Don't know"
	999="Refused" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE day_of_week_one
	1="Monday"
	2="Tuesday"
	3="Wednesday"
	4="Thursday"
	5="Friday"
	6="Saturday"
	7="Sunday"
	100="All days are equally busy"
	888="Don't know"
	999="Refused" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE day_of_week_two
	1="Monday"
	2="Tuesday"
	3="Wednesday"
	4="Thursday"
	5="Friday"
	6="Saturday"
	7="Sunday"
	100="All days are equally busy"
	9="No other busy days"
	888="Don't know"
	999="Refused"
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE time_in_operation
	1="Less than 1 year"
	2="1 to 2 years"
	3="More than 2 years"
	9="Not applicable"
	888="Don't know"
	999="Refused to answer";
	VALUE busy_time_range
	1="11:00 to 14:00"
	2="14:00 to 17:00"
	3="17:00 to 20:00"
	4="20:00 to 23:00"
	5="23:00 to 2:00 the next morning"
	100="All times are equally busy"
	888="Don't know"
	999="Refused to answer" 
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE busy_attendance
	1="Fewer than 15"
	2="15 to 29"
	3="30 to 49"
	4="50 to 74"
	5="75 to 99"
	6="100 to 199"
	7="200 to 299"
	8="300 to 499"
	9="500 to 999"
	10="1000 or more"
	888="Don't know"
	999="Refused to answer" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE asndkr
	1="Always"
	2="Sometimes"
	3="Never"
	888="Don't know"
	999="Refused" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE shown_condom
	1="Condom was shown"
	2="Condom was not shown"
	999="Refused to respond" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE knowledgeable
	1="Not very knowledgeable"
	2="Knowledgeable"
	3="Extremely knowledgeable" 	
	.="Missing"
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE bin
	0="No"
	1="Yes"
	.="Missing" 
	.T="Interview terminated early" .D="Don't know (not presented in response choices)" .S="Skipped (not presented in response choices)" .R="Refused (not presented in response choices)"; 
	VALUE saidinfectedf
	0="Said not infected, Consistent: Said infected during interview and self-completed section"
	1="Said infected, Consistent: Said infected during interview and self-completed section"
	970="Said not infected, Unconfirmed: Said not infected during interview / did not confirm (missing or said never received result) in self-completed section"
	980="Said not infected, Unconfirmed: Said not infected during self-completed section / did not confirm (missing or said never received result) in interview"
	971="Said infected, Unconfirmed: Said infected during interview / did not confirm (missing or said never received result) in self-completed section"
	981="Said infected, Unconfirmed: Said infected during self-completed section / did not confirm (missing or said never received result) in interview"
	997="Contradictory: Said infected during self-completed section / said not infected during interview"
	998="Contradictory: Said infected during interview / said not infected during self-completed section"
	.B="Missing: No response about HIV status provided during interview or self-completed questions"	
	.="Missing";
	VALUE viralloadf
	.N="Not detected"
	.A="Less than 550"
	.B="Less than 2005"	
	.="Missing";
	VALUE virusdetectedf
	1="HIV viral load above level of detection for lab"
	0="HIV viral load below level of detection for lab"
	.="Missing";
	VALUE arm
	1="Intervention"
	2="Comparison"
	.="Missing";
	VALUE mfwpf
	1="Male worker"
	2="Female worker"
	3="Male patron"
	4="Female patron"	
	.="Missing";
	VALUE c101f
	1="She goes to other spots between 8pm and 12am Saturday"
	2="She does not go to other spots between 8pm and 12am Saturday"	
	.="Missing";
	VALUE c109f
	1="He goes to other spots between 8pm and 12am Saturday"
	2="He does not go to other spots between 8pm and 12am Saturday"	
	.="Missing";
RUN;
