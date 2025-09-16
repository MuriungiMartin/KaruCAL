#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51024 "Payroll Master Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Payroll Master Summary.rdlc';

    dataset
    {
        dataitem(UnknownTable61092;UnknownTable61092)
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(Transaction_Name;"PRL-Period Transactions"."Transaction Name")
            {
            }
            column(Amount;TotalTrans)
            {
            }
            column(Picture;CompanyInfo.Picture)
            {
            }
            column(Prepared_by;Prepared_by)
            {
            }
            column(Checked_by;Checked_by)
            {
            }
            column(Authorized_by;Authorized_by)
            {
            }
            column(Approved_by;Approved_by)
            {
            }
            column(Date;Date)
            {
            }
            column(Signed;Signed)
            {
            }

            trigger OnAfterGetRecord()
            begin
                  Clear(TotalTrans);
                  //TotalTrans:=0;
                //PrCodes.RESET;
                //PrCodes.SETRANGE(PrCodes."Transaction Code","prPeriod Transactions"."Transaction Code");
                //PrCodes.SETRANGE(PrCodes."Transaction Type",PrCodes."Transaction Type"::Deduction);
                //IF  PrCodes.FIND('-') THEN BEGIN


                 PrPeriods.Reset;
                 PrPeriods.SetRange(PrPeriods."Transaction Code",PrCodes."Transaction Code");
                 PrPeriods.SetRange(PrPeriods."Transaction Code","PRL-Period Transactions"."Transaction Code");
                 //PrPeriods.SETRANGE(PrPeriods."Payroll Period",Periods);
                 PrPeriods.SetRange(PrPeriods."Period Month","PRL-Period Transactions"."Period Month");
                 PrPeriods.SetRange(PrPeriods."Period Year","PRL-Period Transactions"."Period Year");

                 if  PrPeriods.Find('-') then begin
                 repeat
                 TotalTrans:=TotalTrans+PrPeriods.Amount ;
                 until PrPeriods.Next=0;
                 end

                // END;
            end;

            trigger OnPreDataItem()
            begin
                 Clear(TotalTrans);
                if CompanyInfo.Get() then
                CompanyInfo.CalcFields(CompanyInfo.Picture);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Periods;Periods)
                {
                    ApplicationArea = Basic;
                    Caption = 'Pperiod';
                    TableRelation = "PRL-Payroll Periods"."Date Opened";
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        PrPeriods: Record UnknownRecord61092;
        TotalTrans: Decimal;
        PrCodes: Record UnknownRecord61082;
        CompanyInfo: Record "Company Information";
        Prepared_by: Text;
        Checked_by: Text;
        Authorized_by: Text;
        Approved_by: Text;
        Signed: Text;
        Date: Text;
        Periods: Date;
}

