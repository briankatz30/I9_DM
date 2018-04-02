/* CREATE STORED PROCEDURE SCRIPT THAT NEED TO BE CREATED FOR EACH NEW DATABASE *****/
EXECUTE SP_EXECUTESQL N'
CREATE PROC [dbo].[SP_I9_MATCHISNULL]
AS
BEGIN
SELECT * FROM [I9] WHERE ([I9].[MATCH] Is Null) ORDER BY [EMPLOYEE LAST NAME], [EMPLOYEE FIRST NAME]
END '

EXECUTE SP_EXECUTESQL N'
CREATE PROC [dbo].[SP_LOAD_I9]
AS
BEGIN
SELECT *  FROM [I9] ORDER BY [ID] 
END '

EXECUTE SP_EXECUTESQL N'
CREATE PROC [dbo].[SP_LOAD_ROSTER]
AS
BEGIN
SELECT * 
FROM [V_ROSTER] ORDER BY [ID]
END '

EXECUTE SP_EXECUTESQL N'
CREATE PROC [dbo].[SP_ROSTER_MATCH]
AS
BEGIN
SELECT [ROSTER].*, [I9].[MATCH] FROM [ROSTER] LEFT JOIN [I9] ON [ROSTER].[ID] = [I9].[RosterID]  
WHERE ([I9].[MATCH] Is Null) ORDER BY [ROSTER].[EMPLOYEE LAST NAME], [ROSTER].[EMPLOYEE FIRST NAME]
END '

EXECUTE SP_EXECUTESQL N'
SET ANSI_NULLS OFF;
SET QUOTED_IDENTIFIER OFF;
DROP PROCEDURE IF EXISTS [SP_ROSTERVIEW];
CREATE PROC [dbo].[SP_ROSTERVIEW]
@ROSTERCOUNT AS INT OUTPUT,
@I9COUNT AS INT OUTPUT,
@ROSTERDATEERROR AS INT OUTPUT,
@ROSTERSSNERROR AS INT OUTPUT,
@ROSTEROTHERERRORS AS INT OUTPUT,
@ROSTERALLERRORS INT OUTPUT
AS
BEGIN
-- QUERIES TO LOAD THE ROSTER LIST VIEW
--COUNT THE ROWS IN THE ROSTER TABLE
SELECT @ROSTERCOUNT = COUNT(*) FROM [ROSTER] ;
--COUNT THE ROWS IN THE I9 TABLE
SELECT @I9COUNT = COUNT(*) FROM [I9];
--COUNT THE DATE ERRORS
SELECT @ROSTERDATEERROR = COUNT(*) FROM [ROSTER] WHERE [DATE ERROR] = '-1 ';
--COUNT THE SSN ERRORS
SELECT @ROSTERSSNERROR = COUNT(*) FROM[ROSTER] WHERE [SSN ERROR] = '-1 ';
--COUNT THE OTHER ERRORS
SELECT @ROSTEROTHERERRORS = COUNT(*) FROM [ROSTER] WHERE [OTHER ERROR] = + ''-1+'';
--COUNT ALL THE ERRORS
SELECT @ROSTERALLERRORS = COUNT(*) FROM [ROSTER] WHERE (([DATE ERROR] = + ''-1 +'') OR ([SSN ERROR] = +''-1+'') OR ([OTHER ERROR] = +''-1+''))
END '

EXECUTE SP_EXECUTESQL N'
CREATE PROC [dbo].[SP_I9VIEW]
@I9SSNCOUNT AS INT OUTPUT,
@I9DOBCOUNT AS INT OUTPUT,
@I9FIRSTLASTMIDDLECOUNT AS INT OUTPUT,
@I9NAMECOUNT AS INT OUTPUT
AS
DECLARE @YSSN nvarchar(10)
DECLARE @YLFDOB nvarchar(10)
DECLARE @YFMI nvarchar(10)
DECLARE @YFLN nvarchar(10)
DECLARE @SQLString varchar(300)
BEGIN
SET @YSSN = + ''YesSSN''
SET @YLFDOB = + ''YesLFDOB''
SET @YFMI = + ''YesFLMI''
SET @YFLN = + ''YesFLN''
SELECT @I9SSNCOUNT = COUNT(*) FROM [I9] WHERE [Match] = @YSSN ;
SELECT @I9DOBCOUNT = COUNT(*) FROM [I9] WHERE [Match] = @YLFDOB ;
SELECT @I9FIRSTLASTMIDDLECOUNT = COUNT(*) FROM [I9] WHERE [Match] = @YFMI ;
 SELECT @I9NAMECOUNT = COUNT(*) FROM [I9] WHERE [Match] = @YFLN ;
END '

EXECUTE SP_EXECUTESQL N'
CREATE PROCEDURE [dbo].[SP_RUN_MATCH_CHECK]
AS
BEGIN
UPDATE [I9] 
SET [I9].[Match] = Null, [I9].[RosterID] = NULL

UPDATE [I9]  
SET [I9].[Match] =  +''YesSSN'' ,
[I9].[RosterID] = [ROSTER].[ID]
FROM ROSTER
INNER JOIN  [I9]
ON [ROSTER].[Employee SS#] = [I9].[Employee SS#]  
WHERE [I9].Match IS NULL 

UPDATE [I9]
SET   [I9].[Match] =  + ''YesLFDOB'', 
[I9].[RosterID] = [ROSTER].[ID] 
FROM ROSTER
INNER JOIN [I9] ON
([ROSTER].[Employee Last Name] = [I9].[Employee Last Name]) And 
([ROSTER].[Employee First Name] = [I9].[Employee First Name]) And 
([I9].[Employee Date of Birth] = [I9].[Employee Date of Birth])
WHERE [I9].Match IS NULL 

UPDATE [I9]
SET   [I9].[Match] = + ''YesFLMI'', 
[I9].[RosterID] = [ROSTER].[ID] 
FROM ROSTER
INNER JOIN [I9] ON
([ROSTER].[Employee Last Name] = [I9].[Employee Last Name]) And 
([ROSTER].[Employee First Name] = [I9].[Employee First Name]) And 
([ROSTER].[Employee Middle Name] = [I9].[Employee Middle Initial])
WHERE [I9].Match IS NULL 

UPDATE [I9]
SET   [I9].[Match] = + ''YesFLN'', 
[I9].[RosterID] = [ROSTER].[ID] 
FROM ROSTER
INNER JOIN [I9] ON
([ROSTER].[Employee Last Name] = [I9].[Employee Last Name]) And 
([ROSTER].[Employee First Name] = [I9].[Employee First Name])
WHERE [I9].Match IS NULL ;
END ;'

EXECUTE SP_EXECUTESQL N'
CREATE PROC FINDSECTION3S
AS
--GETS ALL THE POSSIBLE ROWS TO CHECK FOR STANDALONE SECTION 3S

BEGIN
SELECT * INTO #TEMPTABLE FROM I9 
WHERE
(
([SECTION 3 FLAG] IS NULL OR [SECTION 3 FLAG] = +'''') AND
[EMPLOYEE SIGNATURE] = + ''N'' AND
[TRANSLATOR SIGNATURE]= + ''N'' AND
[SUPERVISOR SIGNATURE]= + ''N''
)

--CHECK FOR VALUES IN SOME FIELDS AND NULL IN OTHERS

SELECT * INTO #NULLTEMPTABLE FROM #TEMPTABLE
WHERE
(
([EMPLOYEE STATUS] IS NULL OR [EMPLOYEE STATUS] = + '''' ) AND
([EMPLOYEE LPR ALIEN #] IS NULL OR  [EMPLOYEE LPR ALIEN #] = + '''') AND
([EMPLOYEE ALIEN REGISTRATION/USCIS #] IS NULL OR [EMPLOYEE ALIEN REGISTRATION/USCIS #] = + '''') AND
([EMPLOYEE ALIEN AUTHORIZED TO WORK UNTIL] IS NULL OR [EMPLOYEE ALIEN AUTHORIZED TO WORK UNTIL] = +'''') AND
([EMPLOYEE ALIEN OR ADMISSION #] IS NULL OR [EMPLOYEE ALIEN OR ADMISSION #]=  + '''') AND
([EMPLOYEE FOREIGN PASSPORT #] IS NULL OR [EMPLOYEE FOREIGN PASSPORT #]  = + '''') AND
([EMPLOYEE FOREIGN PASSPORT COUNTRY] IS NULL OR [EMPLOYEE FOREIGN PASSPORT COUNTRY]= + '''')
)

DROP TABLE #TEMPTABLE

--NEED TO CHECK FOR NON NULL VALUES TO GET TO THE LAST NUMBER OF SECTION 3S 

SELECT * FROM #NULLTEMPTABLE
WHERE
(
([EMPLOYEE NEW LAST NAME (SECTION 3)] IS NOT NULL) OR
([EMPLOYEE FIRST NAME (SECTION 3)] IS NOT NULL) OR	
([EMPLOYEE MIDDLE INITIAL (SECTION 3)] IS NOT NULL) OR	
([DATE OF REHIRE (SECTION 3)] IS NOT NULL) OR	
([DOCUMENT TITLE (SECTION 3)]	IS NOT NULL) OR
([DOCUMENT NUMBER (SECTION 3)] IS NOT NULL) OR	
([DOCUMENT EXPIRATION DATE (SECTION 3)] IS NOT NULL) OR
([SUPERVISOR SIGNED DATE (SECTION 3)] IS NOT NULL) OR
([SUPERVISOR PRINT NAME (SECTION 3)] IS NOT NULL) 
)

--UPDATE THE I9 TABLE WITH THE SECTION 3 FLAG BASED ON THE QUERY
UPDATE
   I9
SET
    I9.[SECTION 3 FLAG] = 1
FROM
    #NULLTEMPTABLE
INNER JOIN
    I9
ON 
    I9.ID = #NULLTEMPTABLE.ID

DROP TABLE #NULLTEMPTABLE
END ;'

EXECUTE SP_EXECUTESQL N'
CREATE PROC ORPHANDOCS
AS
BEGIN
UPDATE I9
SET [ORPHANDOC] = + ''Y''
FROM I9
WHERE 
(
[2 PAGE FLAG] = +''Y'' AND (
([I-9 DOCUMENT NAME] IS NULL) 
OR [I-9 Document Name] = +'''' 
OR ([I-9 Document Name 2] IS NULL) 
OR [I-9 DOCUMENT NAME 2] = +'''')
)
END ;'

EXECUTE SP_EXECUTESQL N'
CREATE PROC UPDATEIMAGELOCATIONS
AS
BEGIN
--UPDATE THE RECORDS FROM [I-9 DOCUMENT NAME 2] FIELD TO THE [I-9 DOUCMENT NAME] IF IT IS NULL
SELECT [ID], [I-9 DOCUMENT NAME], [I-9 DOCUMENT NAME 2] INTO #TEMPTABLE
FROM I9
WHERE
(
([I-9 DOCUMENT NAME] IS NULL OR [I-9 DOCUMENT NAME] = +'''') AND
([I-9 DOCUMENT NAME] IS NOT NULL)
)

UPDATE #TEMPTABLE
SET 
[I-9 DOCUMENT NAME] = [I-9 DOCUMENT NAME 2],
[I-9 DOCUMENT NAME 2] = NULL
FROM #TEMPTABLE

UPDATE I9
SET 
I9.[I-9 DOCUMENT NAME] = #TEMPTABLE.[I-9 DOCUMENT NAME],
I9.[I-9 DOCUMENT NAME 2] = #TEMPTABLE.[I-9 DOCUMENT NAME 2]
FROM I9
INNER JOIN
     #TEMPTABLE
ON 
    I9.ID = #TEMPTABLE.ID

DROP TABLE #TEMPTABLE
END;'

EXECUTE SP_EXECUTESQL N'
CREATE PROC TRANSLATOR_QC
AS
BEGIN
--NEED TO CLEAN UP THE FIELD FIRST BEFORE WE QUERY IT
UPDATE I9
SET [TRANSLATOR PRINT NAME/LAST NAME] = NULL
WHERE  [TRANSLATOR PRINT NAME/LAST NAME] = +''''

SELECT[TRANSLATOR SIGNATURE], [TRANSLATOR PRINT NAME/LAST NAME] FROM I9
WHERE [TRANSLATOR SIGNATURE] = +''N'' AND ([TRANSLATOR PRINT NAME/LAST NAME] <> +'''' OR [TRANSLATOR PRINT NAME/LAST NAME] IS NOT NULL)
END ;'

EXECUTE SP_EXECUTESQL N'
CREATE PROC DROP_G2_ROSTER
AS
BEGIN
DROP VIEW  IF EXISTS [V_ROSTER] ;

/****** DROP ROSTER ******/
DROP TABLE [dbo].[ROSTER] ;

/****** RECREATE THE G2 ROSTER TABLE ******/
CREATE TABLE [dbo].[ROSTER](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Employee ID] [nvarchar](255) NULL,
	[Employee Last Name] [nvarchar](255) NULL,
	[Employee First Name] [nvarchar](255) NULL,
	[Employee Middle Name] [nvarchar](255) NULL,
	[Employee Maiden Name] [nvarchar](255) NULL,
	[Employee Title] [nvarchar](255) NULL,
	[Employee Date of Birth] [nvarchar](255) NULL,
	[Employee SS#] [nvarchar](255) NULL,
	[Employee Address] [nvarchar](255) NULL,
	[Employee Address 2] [nvarchar](255) NULL,
	[Employee Apt #] [nvarchar](255) NULL,
	[Employee City] [nvarchar](255) NULL,
	[Employee State] [nvarchar](255) NULL,
	[Employee Zip] [nvarchar](255) NULL,
	[Employee Country] [nvarchar](255) NULL,
	[Work Phone] [nvarchar](255) NULL,
	[Work Extension] [nvarchar](255) NULL,
	[Home Phone] [nvarchar](255) NULL,
	[Home Extension] [nvarchar](255) NULL,
	[Cell Phone] [nvarchar](255) NULL,
	[Cell Extension] [nvarchar](255) NULL,
	[Email Address] [nvarchar](255) NULL,
	[Location Name] [nvarchar](255) NULL,
	[Location Number] [nvarchar](255) NULL,
	[Business Unit] [nvarchar](255) NULL,
	[Hire Date] [nvarchar](255) NULL,
	[Terminated Date] [nvarchar](255) NULL,
	[Custom Field 1] [nvarchar](255) NULL,
	[Custom Field 2] [nvarchar](255) NULL,
	[Custom Field 3] [nvarchar](255) NULL,
	[Custom Field 4] [nvarchar](255) NULL,
	[Custom Field 5] [nvarchar](255) NULL,
	[Custom Field 6] [nvarchar](255) NULL,
	[Custom Field 7] [nvarchar](255) NULL,
	[Custom Field 8] [nvarchar](255) NULL,
	[Date Error] [nvarchar](15) NULL,
	[Date Description] [nvarchar](max) NULL,
	[SSN Error] [nvarchar](15) NULL,
	[SSN Description] [nvarchar](max) NULL,
	[Other Error] [nvarchar](15) NULL,
	[Other Description] [nvarchar](max) NULL,
 CONSTRAINT [PK__ROSTER_ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY] ;

END ;'

EXECUTE SP_EXECUTESQL N'
CREATE PROC DROP_I9
AS
BEGIN
/****** DROP I9 TABLE  ******/
DROP TABLE [dbo].[I9];

/****** CREATE I9 TABLE ******/
CREATE TABLE [dbo].[I9](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[2 page Flag] [nvarchar](255) NULL,
	[Section 3 Flag] [nvarchar](255) NULL,
	[Employee Last Name] [nvarchar](255) NULL,
	[Employee First Name] [nvarchar](255) NULL,
	[Employee Middle Initial] [nvarchar](255) NULL,
	[Employee Maiden Name] [nvarchar](255) NULL,
	[Employee Address] [nvarchar](255) NULL,
	[Employee Apt #] [nvarchar](255) NULL,
	[Employee Date of Birth] [nvarchar](255) NULL,
	[Employee City] [nvarchar](255) NULL,
	[Employee State] [nvarchar](255) NULL,
	[Employee Zip] [nvarchar](255) NULL,
	[Employee SS#] [nvarchar](255) NULL,
	[Employee E-mail] [nvarchar](255) NULL,
	[Employee Phone Number] [nvarchar](255) NULL,
	[Employee Status] [nvarchar](255) NULL,
	[Employee LPR Alien #] [nvarchar](255) NULL,
	[Employee Alien Authorized to Work Until] [nvarchar](255) NULL,
	[Employee Alien Registration/USCIS #] [nvarchar](255) NULL,
	[Employee Alien or Admission #] [nvarchar](255) NULL,
	[Employee Foreign Passport #] [nvarchar](255) NULL,
	[Employee Foreign Passport Country] [nvarchar](255) NULL,
	[Employee Signature] [nvarchar](255) NULL,
	[Employee Signed Date] [nvarchar](255) NULL,
	[Translator Employee Setting] [nvarchar](255) NULL,
	[Translator Signature] [nvarchar](255) NULL,
	[Translator Print Name/Last Name] [nvarchar](255) NULL,
	[Translator First Name] [nvarchar](255) NULL,
	[Translator Address] [nvarchar](255) NULL,
	[Translator City] [nvarchar](255) NULL,
	[Translator State] [nvarchar](255) NULL,
	[Translator Zip] [nvarchar](255) NULL,
	[Translator Signed Date] [nvarchar](255) NULL,
	[Section 2 Header Last Name] [nvarchar](255) NULL,
	[Section 2 Header First Name] [nvarchar](255) NULL,
	[Section 2 Header Middle Initial] [nvarchar](255) NULL,
	[Section 2 Header Immigration Status] [nvarchar](255) NULL,
	[Document Title List A] [nvarchar](255) NULL,
	[Issuing Authority (A)] [nvarchar](255) NULL,
	[Document Number (A1)] [nvarchar](255) NULL,
	[Expiration Date (A1)] [nvarchar](255) NULL,
	[Document Title List (A2)] [nvarchar](255) NULL,
	[Issuing Authority (A2)] [nvarchar](255) NULL,
	[Document Number (A2)] [nvarchar](255) NULL,
	[Expiration Date (A2)] [nvarchar](255) NULL,
	[Document List (A3)] [nvarchar](255) NULL,
	[Issuing Authority (A3)] [nvarchar](255) NULL,
	[Document Number (A3)] [nvarchar](255) NULL,
	[Expiration Date (A3)] [nvarchar](255) NULL,
	[Document Title List (B)] [nvarchar](255) NULL,
	[Issuing Authority (B)] [nvarchar](255) NULL,
	[Document Number (B)] [nvarchar](255) NULL,
	[Expiration Date (B)] [nvarchar](255) NULL,
	[Document Title List (C)] [nvarchar](255) NULL,
	[Issuing Authority (C)] [nvarchar](255) NULL,
	[Document Number (C)] [nvarchar](255) NULL,
	[Expiration Date (C)] [nvarchar](255) NULL,
	[Section 2 Addition Info] [nvarchar](255) NULL,
	[Employee Start Date] [nvarchar](255) NULL,
	[Supervisor Signature] [nvarchar](255) NULL,
	[Supervisor Print/Last Name] [nvarchar](255) NULL,
	[Supervisor First Name] [nvarchar](255) NULL,
	[Supervisor Title] [nvarchar](255) NULL,
	[Business Name] [nvarchar](255) NULL,
	[Business Address] [nvarchar](255) NULL,
	[Business City] [nvarchar](255) NULL,
	[Business State] [nvarchar](255) NULL,
	[Business Zip] [nvarchar](255) NULL,
	[Supervisor Signed Date] [nvarchar](255) NULL,
	[Employee New Last Name (Section 3)] [nvarchar](255) NULL,
	[Employee First Name (Section 3)] [nvarchar](255) NULL,
	[Employee Middle Initial (Section 3)] [nvarchar](255) NULL,
	[Date of Rehire (Section 3)] [nvarchar](255) NULL,
	[Document Title (Section 3)] [nvarchar](255) NULL,
	[Document Number (Section 3)] [nvarchar](255) NULL,
	[Document Expiration Date (Section 3)] [nvarchar](255) NULL,
	[Supervisor Signature (Section 3)] [nvarchar](255) NULL,
	[Supervisor Signed Date (Section 3)] [nvarchar](255) NULL,
	[Supervisor Print Name (Section 3)] [nvarchar](255) NULL,
	[Handwritten data in margins] [nvarchar](max) NULL,
	[Form Version] [nvarchar](255) NULL,
	[I-9 Folder] [nvarchar](255) NULL,
	[I-9 Document Name] [nvarchar](max) NULL,
	[I-9 Document Name 2] [nvarchar](max) NULL,
	[Supporting Doc 1 Name] [nvarchar](max) NULL,
	[Supporting Doc 2 Name] [nvarchar](max) NULL,
	[Supporting Doc 3 Name] [nvarchar](max) NULL,
	[Supporting Doc 4 Name] [nvarchar](max) NULL,
	[Supporting Doc 5 Name] [nvarchar](max) NULL,
	[Supporting Doc 6 Name] [nvarchar](max) NULL,
	[Supporting Doc 7 Name] [nvarchar](max) NULL,
	[Supporting Doc 8 Name] [nvarchar](max) NULL,
	[Supporting Doc 9 Name] [nvarchar](max) NULL,
	[Supporting Doc 10 Name] [nvarchar](max) NULL,
	[Supporting Doc 11 Name] [nvarchar](max) NULL,
	[Supporting Doc 12 Name] [nvarchar](max) NULL,
	[Supporting Doc 13 Name] [nvarchar](max) NULL,
	[Supporting Doc 14 Name] [nvarchar](max) NULL,
	[Supporting Doc 15 Name] [nvarchar](max) NULL,
	[Supporting Doc 16 Name] [nvarchar](max) NULL,
	[Supporting Doc 17 Name] [nvarchar](max) NULL,
	[Supporting Doc 18 Name] [nvarchar](max) NULL,
	[Supporting Doc 19 Name] [nvarchar](max) NULL,
	[Supporting Doc 20 Name] [nvarchar](max) NULL,
	[Supporting Doc 21 Name] [nvarchar](max) NULL,
	[Supporting Doc 22 Name] [nvarchar](max) NULL,
	[Match] [nvarchar](20) NULL,
	[RosterID] [smallint] NULL,
	[OrphanDoc] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY] ;
END ;'

EXECUTE SP_EXECUTESQL N'
CREATE PROC DROP_G1_ROSTER
AS
BEGIN
/****** DROP ROSTER ******/
DROP TABLE [dbo].[ROSTER];

/****** RECREATE THE G1 ROSTER TABLE ******/
CREATE TABLE [dbo].[ROSTER](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Employee ID] [nvarchar](255) NULL,
	[Employee Last Name] [nvarchar](255) NULL,
	[Employee First Name] [nvarchar](255) NULL,
	[Employee Middle Name] [nvarchar](255) NULL,
	[Employee Maiden Name] [nvarchar](255) NULL,
	[Employee Title] [nvarchar](255) NULL,
	[Employee Date of Birth] [nvarchar](255) NULL,
	[Employee SS#] [nvarchar](255) NULL,
	[Employee Address] [nvarchar](255) NULL,
	[Employee Address 2] [nvarchar](255) NULL,
	[Employee Apt #] [nvarchar](255) NULL,
	[Employee City] [nvarchar](255) NULL,
	[Employee State] [nvarchar](255) NULL,
	[Employee Zip] [nvarchar](255) NULL,
	[Employee Country] [nvarchar](255) NULL,
	[Work Phone] [nvarchar](255) NULL,
	[Work Extension] [nvarchar](255) NULL,
	[Home Phone] [nvarchar](255) NULL,
	[Home Extension] [nvarchar](255) NULL,
	[Cell Phone] [nvarchar](255) NULL,
	[Cell Extension] [nvarchar](255) NULL,
	[Email Address] [nvarchar](255) NULL,
	[Location Name] [nvarchar](255) NULL,
	[Location Number] [nvarchar](255) NULL,
	[Occupation Class] [nvarchar](255) NULL,
	[Business Unit] [nvarchar](255) NULL,
	[Hire Date] [nvarchar](255) NULL,
	[Terminated Date] [nvarchar](255) NULL,
	[Date Error] [nvarchar](15) NULL,
	[Date Description] [nvarchar](max) NULL,
	[SSN Error] [nvarchar](15) NULL,
	[SSN Description] [nvarchar](max) NULL,
	[Other Error] [nvarchar](15) NULL,
	[Other Description] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END; '

EXECUTE SP_EXECUTESQL N'
CREATE VIEW [dbo].[V_ROSTER]
WITH SCHEMABINDING 
AS
SELECT [ID],
        [EMPLOYEE ID], [EMPLOYEE LAST NAME], [EMPLOYEE FIRST NAME], [EMPLOYEE MIDDLE NAME], [EMPLOYEE MAIDEN NAME], [EMPLOYEE TITLE],
        [EMPLOYEE Date Of BIRTH],[EMPLOYEE SS#],[EMPLOYEE ADDRESS], [EMPLOYEE ADDRESS 2],[EMPLOYEE APT #],
        [EMPLOYEE CITY], [EMPLOYEE STATE], [EMPLOYEE ZIP], [EMPLOYEE COUNTRY], [WORK PHONE], [WORK EXTENSION], [HOME PHONE], [HOME EXTENSION] , [CELL PHONE], [CELL EXTENSION] ,
        [EMAIL ADDRESS],[HIRE DATE], [TERMINATED DATE],  [LOCATION NAME] , [LOCATION NUMBER], [BUSINESS UNIT] , [DATE ERROR], [DATE DESCRIPTION],
        [SSN ERROR], [SSN DESCRIPTION], [OTHER ERROR], [OTHER DESCRIPTION]
        FROM [ROSTER] ;  '
	
	EXECUTE SP_EXECUTESQL N' 
	CREATE STERED INDEX IDX_V1 ON dbo.V_ROSTER ([ID]); ' 
	
	EXECUTE SP_EXECUTESQL N' 
	CREATE INDEX IDX_V2  ON dbo.V_ROSTER ([SSN ERROR], [ID]);'  
	
	EXECUTE SP_EXECUTESQL N' 
	CREATE INDEX IDX_V3  ON dbo.V_ROSTER ([OTHER ERROR], [ID]); ' 

	EXECUTE SP_EXECUTESQL N' 
	CREATE INDEX IDX_V4  ON dbo.V_ROSTER ([DATE ERROR], [ID]); '
	