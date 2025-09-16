#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51444 Applcants
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Applcants.rdlc';

    dataset
    {
        dataitem(UnknownTable61313;UnknownTable61313)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(ReportForNavId_8540; 8540)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Applicants__No__;"No.")
            {
            }
            column(Applicants__First_Name_;"First Name")
            {
            }
            column(Applicants__Middle_Name_;"Middle Name")
            {
            }
            column(Applicants__Last_Name_;"Last Name")
            {
            }
            column(Applicants_Initials;Initials)
            {
            }
            column(Applicants__Search_Name_;"Search Name")
            {
            }
            column(Applicants__Postal_Address_;"Postal Address")
            {
            }
            column(Applicants__Residential_Address_;"Residential Address")
            {
            }
            column(Applicants_City;City)
            {
            }
            column(Applicants__Post_Code_;"Post Code")
            {
            }
            column(Applicants_County;County)
            {
            }
            column(Applicants__Home_Phone_Number_;"Home Phone Number")
            {
            }
            column(Applicants__Cellular_Phone_Number_;"Cellular Phone Number")
            {
            }
            column(Applicants__Work_Phone_Number_;"Work Phone Number")
            {
            }
            column(Applicants__Ext__;"Ext.")
            {
            }
            column(Applicants__E_Mail_;"E-Mail")
            {
            }
            column(Applicants_Picture;Picture)
            {
            }
            column(Applicants__ID_Number_;"ID Number")
            {
            }
            column(Applicants_Gender;Gender)
            {
            }
            column(Applicants__Country_Code_;"Country Code")
            {
            }
            column(Applicants_Status;Status)
            {
            }
            column(Applicants_Comment;Comment)
            {
            }
            column(Applicants__Fax_Number_;"Fax Number")
            {
            }
            column(Applicants__Marital_Status_;"Marital Status")
            {
            }
            column(Applicants__Ethnic_Origin_;"Ethnic Origin")
            {
            }
            column(Applicants__First_Language__R_W_S__;"First Language (R/W/S)")
            {
            }
            column(Applicants__Driving_Licence_;"Driving Licence")
            {
            }
            column(Applicants_Disabled;Disabled)
            {
            }
            column(Applicants__Health_Assesment__;"Health Assesment?")
            {
            }
            column(Applicants__Health_Assesment_Date_;"Health Assesment Date")
            {
            }
            column(Applicants__Date_Of_Birth_;"Date Of Birth")
            {
            }
            column(Applicants_Age;Age)
            {
            }
            column(Applicants__Second_Language__R_W_S__;"Second Language (R/W/S)")
            {
            }
            column(Applicants__Additional_Language_;"Additional Language")
            {
            }
            column(Applicants__Primary_Skills_Category_;"Primary Skills Category")
            {
            }
            column(Applicants_Level;Level)
            {
            }
            column(Applicants__Termination_Category_;"Termination Category")
            {
            }
            column(Applicants__Postal_Address2_;"Postal Address2")
            {
            }
            column(Applicants__Postal_Address3_;"Postal Address3")
            {
            }
            column(Applicants__Residential_Address2_;"Residential Address2")
            {
            }
            column(Applicants__Residential_Address3_;"Residential Address3")
            {
            }
            column(Applicants__Post_Code2_;"Post Code2")
            {
            }
            column(Applicants_Citizenship;Citizenship)
            {
            }
            column(Applicants__Disabling_Details_;"Disabling Details")
            {
            }
            column(Applicants__Disability_Grade_;"Disability Grade")
            {
            }
            column(Applicants__Passport_Number_;"Passport Number")
            {
            }
            column(Applicants__2nd_Skills_Category_;"2nd Skills Category")
            {
            }
            column(Applicants__3rd_Skills_Category_;"3rd Skills Category")
            {
            }
            column(Applicants_Region;Region)
            {
            }
            column(Applicants__First_Language_Read_;"First Language Read")
            {
            }
            column(Applicants__First_Language_Write_;"First Language Write")
            {
            }
            column(Applicants__First_Language_Speak_;"First Language Speak")
            {
            }
            column(Applicants__Second_Language_Read_;"Second Language Read")
            {
            }
            column(Applicants__Second_Language_Write_;"Second Language Write")
            {
            }
            column(Applicants__Second_Language_Speak_;"Second Language Speak")
            {
            }
            column(Applicants__PIN_Number_;"PIN Number")
            {
            }
            column(Applicants__Job_Applied_For_;"Job Applied For")
            {
            }
            column(Applicants__Need_Code_;"Need Code")
            {
            }
            column(Applicants_Stage;Stage)
            {
            }
            column(Applicants__Employee_No_;"Employee No")
            {
            }
            column(Applicants__Applicant_Type_;"Applicant Type")
            {
            }
            column(ApplicantsCaption;ApplicantsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Applicants__No__Caption;FieldCaption("No."))
            {
            }
            column(Applicants__First_Name_Caption;FieldCaption("First Name"))
            {
            }
            column(Applicants__Middle_Name_Caption;FieldCaption("Middle Name"))
            {
            }
            column(Applicants__Last_Name_Caption;FieldCaption("Last Name"))
            {
            }
            column(Applicants_InitialsCaption;FieldCaption(Initials))
            {
            }
            column(Applicants__Search_Name_Caption;FieldCaption("Search Name"))
            {
            }
            column(Applicants__Postal_Address_Caption;FieldCaption("Postal Address"))
            {
            }
            column(Applicants__Residential_Address_Caption;FieldCaption("Residential Address"))
            {
            }
            column(Applicants_CityCaption;FieldCaption(City))
            {
            }
            column(Applicants__Post_Code_Caption;FieldCaption("Post Code"))
            {
            }
            column(Applicants_CountyCaption;FieldCaption(County))
            {
            }
            column(Applicants__Home_Phone_Number_Caption;FieldCaption("Home Phone Number"))
            {
            }
            column(Applicants__Cellular_Phone_Number_Caption;FieldCaption("Cellular Phone Number"))
            {
            }
            column(Applicants__Work_Phone_Number_Caption;FieldCaption("Work Phone Number"))
            {
            }
            column(Applicants__Ext__Caption;FieldCaption("Ext."))
            {
            }
            column(Applicants__E_Mail_Caption;FieldCaption("E-Mail"))
            {
            }
            column(Applicants_PictureCaption;FieldCaption(Picture))
            {
            }
            column(Applicants__ID_Number_Caption;FieldCaption("ID Number"))
            {
            }
            column(Applicants_GenderCaption;FieldCaption(Gender))
            {
            }
            column(Applicants__Country_Code_Caption;FieldCaption("Country Code"))
            {
            }
            column(Applicants_StatusCaption;FieldCaption(Status))
            {
            }
            column(Applicants_CommentCaption;FieldCaption(Comment))
            {
            }
            column(Applicants__Fax_Number_Caption;FieldCaption("Fax Number"))
            {
            }
            column(Applicants__Marital_Status_Caption;FieldCaption("Marital Status"))
            {
            }
            column(Applicants__Ethnic_Origin_Caption;FieldCaption("Ethnic Origin"))
            {
            }
            column(Applicants__First_Language__R_W_S__Caption;FieldCaption("First Language (R/W/S)"))
            {
            }
            column(Applicants__Driving_Licence_Caption;FieldCaption("Driving Licence"))
            {
            }
            column(Applicants_DisabledCaption;FieldCaption(Disabled))
            {
            }
            column(Applicants__Health_Assesment__Caption;FieldCaption("Health Assesment?"))
            {
            }
            column(Applicants__Health_Assesment_Date_Caption;FieldCaption("Health Assesment Date"))
            {
            }
            column(Applicants__Date_Of_Birth_Caption;FieldCaption("Date Of Birth"))
            {
            }
            column(Applicants_AgeCaption;FieldCaption(Age))
            {
            }
            column(Applicants__Second_Language__R_W_S__Caption;FieldCaption("Second Language (R/W/S)"))
            {
            }
            column(Applicants__Additional_Language_Caption;FieldCaption("Additional Language"))
            {
            }
            column(Applicants__Primary_Skills_Category_Caption;FieldCaption("Primary Skills Category"))
            {
            }
            column(Applicants_LevelCaption;FieldCaption(Level))
            {
            }
            column(Applicants__Termination_Category_Caption;FieldCaption("Termination Category"))
            {
            }
            column(Applicants__Postal_Address2_Caption;FieldCaption("Postal Address2"))
            {
            }
            column(Applicants__Postal_Address3_Caption;FieldCaption("Postal Address3"))
            {
            }
            column(Applicants__Residential_Address2_Caption;FieldCaption("Residential Address2"))
            {
            }
            column(Applicants__Residential_Address3_Caption;FieldCaption("Residential Address3"))
            {
            }
            column(Applicants__Post_Code2_Caption;FieldCaption("Post Code2"))
            {
            }
            column(Applicants_CitizenshipCaption;FieldCaption(Citizenship))
            {
            }
            column(Applicants__Disabling_Details_Caption;FieldCaption("Disabling Details"))
            {
            }
            column(Applicants__Disability_Grade_Caption;FieldCaption("Disability Grade"))
            {
            }
            column(Applicants__Passport_Number_Caption;FieldCaption("Passport Number"))
            {
            }
            column(Applicants__2nd_Skills_Category_Caption;FieldCaption("2nd Skills Category"))
            {
            }
            column(Applicants__3rd_Skills_Category_Caption;FieldCaption("3rd Skills Category"))
            {
            }
            column(Applicants_RegionCaption;FieldCaption(Region))
            {
            }
            column(Applicants__First_Language_Read_Caption;FieldCaption("First Language Read"))
            {
            }
            column(Applicants__First_Language_Write_Caption;FieldCaption("First Language Write"))
            {
            }
            column(Applicants__First_Language_Speak_Caption;FieldCaption("First Language Speak"))
            {
            }
            column(Applicants__Second_Language_Read_Caption;FieldCaption("Second Language Read"))
            {
            }
            column(Applicants__Second_Language_Write_Caption;FieldCaption("Second Language Write"))
            {
            }
            column(Applicants__Second_Language_Speak_Caption;FieldCaption("Second Language Speak"))
            {
            }
            column(Applicants__PIN_Number_Caption;FieldCaption("PIN Number"))
            {
            }
            column(Applicants__Job_Applied_For_Caption;FieldCaption("Job Applied For"))
            {
            }
            column(Applicants__Need_Code_Caption;FieldCaption("Need Code"))
            {
            }
            column(Applicants_StageCaption;FieldCaption(Stage))
            {
            }
            column(Applicants__Employee_No_Caption;FieldCaption("Employee No"))
            {
            }
            column(Applicants__Applicant_Type_Caption;FieldCaption("Applicant Type"))
            {
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        ApplicantsCaptionLbl: label 'Applicants';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

