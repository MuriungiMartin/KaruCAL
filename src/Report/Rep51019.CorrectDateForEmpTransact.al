#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51019 "Correct Date For Emp. Transact"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Correct Date For Emp. Transact.rdlc';

    dataset
    {
        dataitem(UnknownTable61091;UnknownTable61091)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(Period;"PRL-Employee Transactions"."Payroll Period")
            {
            }
            column(Month;"PRL-Employee Transactions"."Period Month")
            {
            }
            column(Year;"PRL-Employee Transactions"."Period Year")
            {
            }

            trigger OnAfterGetRecord()
            begin
                    Clear(dates);
                    Clear(months);
                    Clear(years);
                    Clear(curdate);
                    Clear(dateString);
                     dates:=Date2dmy("PRL-Employee Transactions"."Payroll Period",1);
                     months:=Date2dmy("PRL-Employee Transactions"."Payroll Period",2);
                     years:=Date2dmy("PRL-Employee Transactions"."Payroll Period",3);
                     if dates>1 then begin
                     curdate:=dates-1;
                     curdate:=curdate*(-1);
                     end;
                     dateString:=Format(curdate)+'D';

                     "PRL-Employee Transactions"."Period Month":=months;
                    "PRL-Employee Transactions"."Period Year":=years;
                    "PRL-Employee Transactions"."Payroll Period":=CalcDate(dateString,"PRL-Employee Transactions"."Payroll Period");
                    Modify;
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
        dates: Integer;
        months: Integer;
        years: Integer;
        curdate: Integer;
        dateString: Text;
}

