#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51436 "Company Information"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Company Information.rdlc';

    dataset
    {
        dataitem(UnknownTable61339;UnknownTable61339)
        {
            column(ReportForNavId_3145; 3145)
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
            column(Company_Info__VAT_Registration_No__;"VAT Registration No.")
            {
            }
            column(Company_Info__Registration_No__;"Registration No.")
            {
            }
            column(Company_Info__Ship_to_Name_;"Ship-to Name")
            {
            }
            column(Company_Info__Ship_to_Name_2_;"Ship-to Name 2")
            {
            }
            column(Company_Info__Ship_to_Address_;"Ship-to Address")
            {
            }
            column(Company_Info__Ship_to_Address_2_;"Ship-to Address 2")
            {
            }
            column(Company_Info__Ship_to_City_;"Ship-to City")
            {
            }
            column(Company_Info__Ship_to_Contact_;"Ship-to Contact")
            {
            }
            column(Company_Info__Post_Code_;"Post Code")
            {
            }
            column(Company_Info_County;County)
            {
            }
            column(Company_Info__E_Mail_;"E-Mail")
            {
            }
            column(Company_Info__Home_Page_;"Home Page")
            {
            }
            column(Company_Info__Company_P_I_N_;"Company P.I.N")
            {
            }
            column(Company_Info__N_S_S_F_No__;"N.S.S.F No.")
            {
            }
            column(Company_Info__Company_code_;"Company code")
            {
            }
            column(Company_Info_Mission;Mission)
            {
            }
            column(Company_Info__Mission_Vision_Link_;"Mission/Vision Link")
            {
            }
            column(Company_Info_Vision;Vision)
            {
            }
            column(Company_InformationCaption;Company_InformationCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Company_Info__VAT_Registration_No__Caption;FieldCaption("VAT Registration No."))
            {
            }
            column(Company_Info__Registration_No__Caption;FieldCaption("Registration No."))
            {
            }
            column(NameCaption;NameCaptionLbl)
            {
            }
            column(Name_2Caption;Name_2CaptionLbl)
            {
            }
            column(AddressCaption;AddressCaptionLbl)
            {
            }
            column(Address_2Caption;Address_2CaptionLbl)
            {
            }
            column(CityCaption;CityCaptionLbl)
            {
            }
            column(ContactCaption;ContactCaptionLbl)
            {
            }
            column(Company_Info__Post_Code_Caption;FieldCaption("Post Code"))
            {
            }
            column(Company_Info_CountyCaption;FieldCaption(County))
            {
            }
            column(Company_Info__E_Mail_Caption;FieldCaption("E-Mail"))
            {
            }
            column(Company_Info__Home_Page_Caption;FieldCaption("Home Page"))
            {
            }
            column(Company_Info__Company_P_I_N_Caption;FieldCaption("Company P.I.N"))
            {
            }
            column(Company_Info__N_S_S_F_No__Caption;FieldCaption("N.S.S.F No."))
            {
            }
            column(Company_Info__Company_code_Caption;FieldCaption("Company code"))
            {
            }
            column(Company_Info_MissionCaption;FieldCaption(Mission))
            {
            }
            column(Company_Info__Mission_Vision_Link_Caption;FieldCaption("Mission/Vision Link"))
            {
            }
            column(Company_Info_VisionCaption;FieldCaption(Vision))
            {
            }
            column(Company_Info_Primary_Key;"Primary Key")
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
        Company_InformationCaptionLbl: label 'Company Information';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        NameCaptionLbl: label 'Name';
        Name_2CaptionLbl: label 'Name 2';
        AddressCaptionLbl: label 'Address';
        Address_2CaptionLbl: label 'Address 2';
        CityCaptionLbl: label 'City';
        ContactCaptionLbl: label 'Contact';
}

