#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51851 "Payroll Summary Depts."
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Payroll Summary Depts..rdlc';

    dataset
    {
        dataitem(UnknownTable61092;UnknownTable61092)
        {
            DataItemTableView = sorting("Payroll Period","Group Order","Sub Group Order") order(ascending) where("Group Order"=filter(1|3|4|7|8|9));
            column(ReportForNavId_1000000007; 1000000007)
            {
            }
            column(GO;"PRL-Period Transactions"."Group Order")
            {
            }
            column(SGO;"PRL-Period Transactions"."Sub Group Order")
            {
            }
            column(DeptCodes;"Dimension Value".Code)
            {
            }
            column(DeptName;"Dimension Value".Name)
            {
            }
            column(DeptCodez;HRMEmployeeD."Department Code")
            {
            }
            column(DeptNames;HRMEmployeeD."Department Names")
            {
            }
            column(UserId;CurrUser)
            {
            }
            column(DateToday;Today)
            {
            }
            column(PrintTime;Time)
            {
            }
            column(pic;info.Picture)
            {
            }
            column(PrintBy;'PRINTED BY NAME:........................................................................................ SIGNATURE:................................... DESIGNATION:...................................... DATE:.......................................')
            {
            }
            column(CheckedBy;'CHECKED BY NAME:........................................................................................ SIGNATURE:................................... DESIGNATION:...................................... DATE:.......................................')
            {
            }
            column(VerifiedBy;'VERIFIED BY NAME:........................................................................................ SIGNATURE:................................... DESIGNATION:...................................... DATE:.......................................')
            {
            }
            column(ApprovedBy;'APPROVED BY NAME:........................................................................................ SIGNATURE:................................... DESIGNATION:...................................... DATE:.......................................')
            {
            }
            column(BasicPayLbl;'BASIC PAY')
            {
            }
            column(payelbl;'PAYE.')
            {
            }
            column(nssflbl;'NSSF')
            {
            }
            column(nhiflbl;'NHIF')
            {
            }
            column(Netpaylbl;'Net Pay')
            {
            }
            column(payeamount;payeamount)
            {
            }
            column(nssfam;nssfam)
            {
            }
            column(nhifamt;nhifamt)
            {
            }
            column(NetPay;NetPay)
            {
            }
            column(BasicPay;BasicPay)
            {
            }
            column(GrossPay;GrossPay)
            {
            }
            column(periods;'PAYROLL SUMMARY for '+Format(periods,0,4))
            {
            }
            column(empNo;HRMEmployeeD."No.")
            {
            }
            column(empName;HRMEmployeeD."No."+': '+HRMEmployeeD."First Name"+' '+HRMEmployeeD."Middle Name"+' '+HRMEmployeeD."Last Name")
            {
            }
            column(TransCode;"PRL-Period Transactions"."Transaction Code")
            {
            }
            column(TransName;"PRL-Period Transactions"."Transaction Name")
            {
            }
            column(TransAmount;"PRL-Period Transactions".Amount)
            {
            }
            column(TransBalance;"PRL-Period Transactions".Balance)
            {
            }
            column(OrigAmount;"PRL-Period Transactions"."Original Amount")
            {
            }

            trigger OnAfterGetRecord()
            begin
                 HRMEmployeeD.Reset;
                HRMEmployeeD.SetRange("No.","PRL-Period Transactions"."Employee Code");
                if HRMEmployeeD.Find('-') then begin
                "Dimension Value".Reset;
                "Dimension Value".SetFilter("Dimension Value"."Dimension Code",'%1|%2','DEPARTMENTS','DEPARTMENT');
                "Dimension Value".SetFilter("Dimension Value".Code,HRMEmployeeD."Department Code");
                if "Dimension Value".Find('-') then begin
                  end;
                  end;
                //IF "PRL-Period Transactions"."Transaction Code" IN ['NPAY','PAYE','NSSF','NHIF','BPAY','GPAY'] THEN CurrReport.SKIP;
            end;

            trigger OnPreDataItem()
            begin
                "PRL-Period Transactions".SetFilter("PRL-Period Transactions"."Payroll Period",'=%1',periods);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Period;periods)
                {
                    ApplicationArea = Basic;
                    Caption = 'Period:';
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

    trigger OnInitReport()
    begin
        Users.Reset;
        Users.SetRange(Users."User Name",UserId);
        if Users.Find('-') then begin
          if Users."Full Name"='' then CurrUser:=Users."User Name" else CurrUser:=Users."Full Name";
          end;

           info.Reset;
           if info.Find('-') then info.CalcFields(info.Picture);

        prPayrollPeriods.Reset;
        prPayrollPeriods.SetRange(Closed,false);
        if prPayrollPeriods.Find('-') then begin
          periods:=prPayrollPeriods."Date Opened";
          end;

         if periods=0D then Error('Please Specify the Period first.');
         counts:=0;
         NetPayTotal:=0;
         BasicPayTotal:=0;
         payeamountTotal:=0;
          nssfamTotal:=0;
          nhifamtTotal:=0;
           TransCount:=0;
         showdet:=true;
         NetPay:=0;
         BasicPay:=0;
         Clear(TranscAmount);
          payeamount:=0;
          nssfam:=0;
          nhifamt:=0;
          GrossPay:=0;
    end;

    var
        prPayrollPeriods: Record UnknownRecord61081;
        periods: Date;
        counts: Integer;
        prPeriodTransactions: Record UnknownRecord61092;
        TransName: array [1,200] of Text[200];
        Transcode: array [1,200] of Code[100];
        TransCount: Integer;
        TranscAmount: array [1,200] of Decimal;
        TranscAmountTotal: array [1,200] of Decimal;
        NetPay: Decimal;
        NetPayTotal: Decimal;
        showdet: Boolean;
        payeamount: Decimal;
        payeamountTotal: Decimal;
        nssfam: Decimal;
        nssfamTotal: Decimal;
        nhifamt: Decimal;
        nhifamtTotal: Decimal;
        BasicPay: Decimal;
        BasicPayTotal: Decimal;
        GrossPay: Decimal;
        GrosspayTotal: Decimal;
        prtransCodes: Record UnknownRecord61082;
        info: Record "Company Information";
        Users: Record User;
        CurrUser: Code[100];
        "Dimension Value": Record "Dimension Value";
        HRMEmployeeD: Record UnknownRecord61118;
}

