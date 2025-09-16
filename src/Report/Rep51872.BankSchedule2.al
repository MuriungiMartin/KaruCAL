#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51872 "Bank Schedule 2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Bank Schedule 2.rdlc';

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
            column(EmpCode;prPeriodTransactions."Employee Code")
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
            column(empName;HRMEmployeeD."First Name"+' '+HRMEmployeeD."Middle Name"+' '+HRMEmployeeD."Last Name")
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
            column(Grade;HRMEmployeeD."Grade Level")
            {
            }
            column(Designation;HRMEmployeeD."Job Title")
            {
            }

            trigger OnAfterGetRecord()
            begin
                
                /*//HRMEmployeeD.RESET;
                //HRMEmployeeD.SETRANGE("No.","PRL-Period Transactions"."Employee Code");
                //IF HRMEmployeeD.FIND('-') THEN BEGIN
                
                //"Dimension Value".RESET;
                //"Dimension Value".SETFILTER("Dimension Value"."Dimension Code",'%1|%2','DEPARTMENTS','DEPARTMENT');
                ///"Dimension Value".SETFILTER("Dimension Value".Code,HRMEmployeeD."Department Code");
                //IF "Dimension Value".FIND('-') THEN BEGIN
                  //END;
                  IF prPeriodTransactions."Group Text"='NET PAY' THEN
                    NetPay:="PRL-Period Transactions".Amount;
                
                  //END*/
                
                Clear(NetPay);
                
                
                
                
                PeriodTrans.Reset;
                //PeriodTrans.SETRANGE(PeriodTrans."Employee Code","Employee Code");
                PeriodTrans.SetRange(PeriodTrans."Payroll Period",periods);
                PeriodTrans.SetRange(PeriodTrans."Transaction Code",'NPAY');
                
                NetPay:=0;
                
                
                if PeriodTrans.Find('-') then
                   begin
                   if PeriodTrans.Amount=0 then CurrReport.Skip;
                      NetPay:=PeriodTrans.Amount;
                      NetPayTotal:=NetPayTotal+PeriodTrans.Amount;
                   end;
                
                if NetPay=0 then CurrReport.Skip;

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

         NetPayTotal:=0;

         NetPay:=0;
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
        EmployeeName: Text[200];
        PeriodTrans: Record UnknownRecord61092;
}

