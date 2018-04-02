EXECUTE SP_EXECUTESQL N'
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
BEGIN
CREATE DATABASE [DbProjectName] 
END ;'

EXECUTE SP_EXECUTESQL N'
BEGIN
ALTER DATABASE [DbProjectName] SET ANSI_NULL_DEFAULT OFF ;
ALTER DATABASE [DbProjectName] SET ANSI_NULLS OFF ;
ALTER DATABASE [DbProjectName] SET ANSI_PADDING OFF ;
ALTER DATABASE [DbProjectName] SET ANSI_WARNINGS OFF;
ALTER DATABASE [DbProjectName] SET ARITHABORT OFF ;
ALTER DATABASE [DbProjectName] SET AUTO_CLOSE OFF ;
ALTER DATABASE [DbProjectName] SET AUTO_SHRINK OFF ;
ALTER DATABASE [DbProjectName] SET AUTO_UPDATE_STATISTICS ON ;
ALTER DATABASE [DbProjectName] SET CURSOR_CLOSE_ON_COMMIT OFF ;
ALTER DATABASE [DbProjectName] SET CURSOR_DEFAULT  GLOBAL ;
ALTER DATABASE [DbProjectName] SET CONCAT_NULL_YIELDS_NULL OFF ;
ALTER DATABASE [DbProjectName] SET NUMERIC_ROUNDABORT OFF ;
ALTER DATABASE [DbProjectName] SET QUOTED_IDENTIFIER OFF ;
ALTER DATABASE [DbProjectName] SET RECURSIVE_TRIGGERS OFF ;
ALTER DATABASE [DbProjectName] SET  DISABLE_BROKER ;
ALTER DATABASE [DbProjectName] SET AUTO_UPDATE_STATISTICS_ASYNC OFF ;
ALTER DATABASE [DbProjectName] SET DATE_CORRELATION_OPTIMIZATION OFF ;
ALTER DATABASE [DbProjectName] SET TRUSTWORTHY OFF ;
ALTER DATABASE [DbProjectName] SET ALLOW_SNAPSHOT_ISOLATION OFF ;
ALTER DATABASE [DbProjectName] SET PARAMETERIZATION SIMPLE ;
ALTER DATABASE [DbProjectName] SET READ_COMMITTED_SNAPSHOT OFF ;
ALTER DATABASE [DbProjectName] SET HONOR_BROKER_PRIORITY OFF ;
ALTER DATABASE [DbProjectName] SET RECOVERY SIMPLE ;
ALTER DATABASE [DbProjectName] SET  MULTI_USER ;
ALTER DATABASE [DbProjectName] SET PAGE_VERIFY CHECKSUM ;
ALTER DATABASE [DbProjectName] SET DB_CHAINING OFF ;
ALTER DATABASE [DbProjectName] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) ;
ALTER DATABASE [DbProjectName] SET TARGET_RECOVERY_TIME = 60 SECONDS ;
ALTER DATABASE [DbProjectName] SET DELAYED_DURABILITY = DISABLED ;
ALTER DATABASE [DbProjectName] SET QUERY_STORE = OFF ;
END; '

EXECUTE SP_EXECUTESQL N'
BEGIN
USE [DbProjectName]
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF ;
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY ;
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0 ;
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY ;
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON ;
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY ;
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF ;
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY ;
END ';

EXECUTE SP_EXECUTESQL N'
BEGIN
USE [DbProjectName] 
SET ANSI_NULLS ON ;
SET QUOTED_IDENTIFIER ON ;
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
SET ANSI_NULLS ON ;
SET QUOTED_IDENTIFIER ON ;
END ;'

EXECUTE SP_EXECUTESQL N'
BEGIN
USE [DbProjectName] 
SET ANSI_NULLS ON ;
SET QUOTED_IDENTIFIER ON ;
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
END;'
