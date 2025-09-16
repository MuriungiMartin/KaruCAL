#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51366 "Jab Admission List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Jab Admission List.rdlc';

    dataset
    {
        dataitem(UnknownTable61372;UnknownTable61372)
        {
            DataItemTableView = sorting("Admission No.");
            RequestFilterFields = "Faculty Admitted To","Degree Admitted To";
            column(ReportForNavId_3773; 3773)
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
            column(Admission_Form_Header__Admission_No__;"Admission No.")
            {
            }
            column(Admission_Form_Header__Degree_Admitted_To_;"Degree Admitted To")
            {
            }
            column(Admission_Form_Header_Gender;Gender)
            {
            }
            column(Admission_Form_Header__Index_Number_;"Index Number")
            {
            }
            column(Name;Name)
            {
            }
            column(Admission_Form_HeaderCaption;Admission_Form_HeaderCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Admission_Form_Header__Admission_No__Caption;FieldCaption("Admission No."))
            {
            }
            column(NameCaption;NameCaptionLbl)
            {
            }
            column(Admission_Form_Header__Degree_Admitted_To_Caption;FieldCaption("Degree Admitted To"))
            {
            }
            column(Admission_Form_Header_GenderCaption;FieldCaption(Gender))
            {
            }
            column(Admission_Form_Header__Index_Number_Caption;FieldCaption("Index Number"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                Name:="ACA-Adm. Form Header".Surname+' '+"ACA-Adm. Form Header"."Other Names";
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
        Name: Text[100];
        Admission_Form_HeaderCaptionLbl: label 'Admission Form Header';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        NameCaptionLbl: label 'Name';
}

