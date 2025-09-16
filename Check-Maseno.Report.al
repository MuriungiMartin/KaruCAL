#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51193 "Check-Maseno"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Check-Maseno.rdlc';

    dataset
    {
        dataitem(UnknownTable61134;UnknownTable61134)
        {
            DataItemTableView = sorting(No);
            RequestFilterFields = No;
            column(ReportForNavId_3752; 3752)
            {
            }
            column(FORMAT__Payment_Date__0_4_;Format("Payment Date",0,4))
            {
            }
            column(Account_Name__________;'****' + "Account Name" + '****')
            {
            }
            column(FORMAT_ROUND__Net_Amount__2___________;'****' + Format(ROUND("Net Amount",2)) + '****')
            {
            }
            column(NumberText_1________NumberText_2_;NumberText[1] +' '+ NumberText[2])
            {
            }
            column(Payments_No;No)
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo(No);
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

    trigger OnPostReport()
    begin
        if CurrReport.Preview=false then
          begin
            "FIN-Payments"."Cheque Raised":=true;
            "FIN-Payments"."Cheque Raised Date":=Today;
            "FIN-Payments"."Cheque Raised Time":=Time;
            "FIN-Payments"."Cheque Raised By":=UserId;
            "FIN-Payments"."No. Printed":="FIN-Payments"."No. Printed" + 1;
            "FIN-Payments".Modify;
          end;
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        Check: Report "House Levy Report";
        NumberText: array [2] of Text[80];
}

