#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51432 "HMS Process Staff"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HMS Process Staff.rdlc';

    dataset
    {
        dataitem(UnknownTable61188;UnknownTable61188)
        {
            DataItemTableView = order(ascending) where("Contract Type"=filter(PERMANENT));
            RequestFilterFields = "No.";
            column(ReportForNavId_6836; 6836)
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
            column(Customer__No__;"HRM-Employee C"."No.")
            {
            }
            column(CustomerCaption;CustomerCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Customer__No__Caption;FieldCaption("No."))
            {
            }

            trigger OnAfterGetRecord()
            begin
                HMSPatient.CopyEmployeeToHMS;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("No.");
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
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        HMSPatient: Codeunit "HMS Patient";
        CustomerCaptionLbl: label 'Customer';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

