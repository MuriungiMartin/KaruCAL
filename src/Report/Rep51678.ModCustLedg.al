#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51678 "Mod Cust Ledg"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Mod Cust Ledg.rdlc';

    dataset
    {
        dataitem("Bank Account Ledger Entry";"Bank Account Ledger Entry")
        {
            DataItemTableView = sorting("Entry No.");
            RequestFilterFields = Open,"Remaining Amount";
            column(ReportForNavId_8503; 8503)
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
            column(no;"Bank Account Ledger Entry"."Statement No.")
            {
            }
            column(status;"Bank Account Ledger Entry"."Statement Status")
            {
            }

            trigger OnAfterGetRecord()
            begin
                "Bank Account Ledger Entry"."Statement No.":='';
                "Bank Account Ledger Entry"."Statement Line No.":=0;
                "Bank Account Ledger Entry"."Statement Status":="Bank Account Ledger Entry"."statement status"::Open;
                "Bank Account Ledger Entry".Modify;
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
        Cust__Ledger_EntryCaptionLbl: label 'Cust. Ledger Entry';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

