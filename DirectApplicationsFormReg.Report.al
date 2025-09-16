#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51379 "Direct Applications Form Reg"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Direct Applications Form Reg.rdlc';

    dataset
    {
        dataitem(UnknownTable61358;UnknownTable61358)
        {
            DataItemTableView = sorting("Application No.");
            RequestFilterFields = Status;
            column(ReportForNavId_2953; 2953)
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
            column(Application_Form_Header__Application_No__;"Application No.")
            {
            }
            column(Application_Form_Header__Issued_Date_;"Issued Date")
            {
            }
            column(Application_Form_Header__Surname__________Other_Names_;"ACA-Applic. Form Header".Surname + ' ' + "Other Names")
            {
            }
            column(Application_Form_Header__Receipt_Slip_No__;"Receipt Slip No.")
            {
            }
            column(Application_Form_Header__Application_Date_;"Application Date")
            {
            }
            column(RecNo;RecNo)
            {
            }
            column(Direct_Application_Form_RegisterCaption;Direct_Application_Form_RegisterCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Application_Form_Header__Application_No__Caption;FieldCaption("Application No."))
            {
            }
            column(Application_Form_Header__Issued_Date_Caption;FieldCaption("Issued Date"))
            {
            }
            column(Name_of_ApplicantCaption;Name_of_ApplicantCaptionLbl)
            {
            }
            column(Application_Form_Header__Receipt_Slip_No__Caption;FieldCaption("Receipt Slip No."))
            {
            }
            column(Return_DateCaption;Return_DateCaptionLbl)
            {
            }
            column(No_Caption;No_CaptionLbl)
            {
            }
            column(KshsCaption;KshsCaptionLbl)
            {
            }
            column(GRDCaption;GRDCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                RecNo:=RecNo+1;
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
        RecNo: Integer;
        Direct_Application_Form_RegisterCaptionLbl: label 'Direct Application Form Register';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Name_of_ApplicantCaptionLbl: label 'Name of Applicant';
        Return_DateCaptionLbl: label 'Return Date';
        No_CaptionLbl: label 'No.';
        KshsCaptionLbl: label 'Kshs';
        GRDCaptionLbl: label 'GRD';
}

