#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51649 "Validate Cont"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Validate Cont.rdlc';

    dataset
    {
        dataitem(Contact;Contact)
        {
            DataItemTableView = sorting("No.");
            column(ReportForNavId_6698; 6698)
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
            column(Contact__No__;"No.")
            {
            }
            column(Contact_Name;Name)
            {
            }
            column(Contact__First_Name_;"First Name")
            {
            }
            column(Contact__Middle_Name_;"Middle Name")
            {
            }
            column(Contact__Company_No__;"Company No.")
            {
            }
            column(Contact__Company_Name_;"Company Name")
            {
            }
            column(ContactCaption;ContactCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Contact__No__Caption;FieldCaption("No."))
            {
            }
            column(Contact_NameCaption;FieldCaption(Name))
            {
            }
            column(Contact__First_Name_Caption;FieldCaption("First Name"))
            {
            }
            column(Contact__Middle_Name_Caption;FieldCaption("Middle Name"))
            {
            }
            column(Contact__Company_No__Caption;FieldCaption("Company No."))
            {
            }
            column(Contact__Company_Name_Caption;FieldCaption("Company Name"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                Contact.Validate(Contact."No.");
                Contact.Validate(Contact.Name);
                Contact.Validate(Contact."First Name");
                Contact.Validate(Contact."Middle Name");
                Contact.Validate(Contact."Company No.");
            end;
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
        ContactCaptionLbl: label 'Contact';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

