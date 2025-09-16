#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 70083 "PRL-Cummulative Allowances"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PRL-Cummulative Allowances.rdlc';

    dataset
    {
        dataitem(UnknownTable61092;UnknownTable61092)
        {
            DataItemTableView = where("Group Order"=filter(1|3|4));
            RequestFilterFields = "Transaction Code";
            column(ReportForNavId_1; 1)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(COMPANYNAME_Control1102755015;COMPANYNAME)
            {
            }
            column(COMPANYNAME_Control1102756027;COMPANYNAME)
            {
            }
            column(COMPANYNAME_Control1102756028;COMPANYNAME)
            {
            }
            column(CompanyInfo_Picture;CompanyInfo.Picture)
            {
            }
            column(CompanyInfo_Picture_Control1102756014;CompanyInfo.Picture)
            {
            }
            column(PayrollSummary;'COMPANY PAYROLL SUMMARY')
            {
            }
            column(PeriodNamez;'PERIOD:  '+PeriodName)
            {
            }
            column(TransDesc;'TRANSACTION DESC.')
            {
            }
            column(payments;'PAYMENTS')
            {
            }
            column(deductions;'DEDUCTIONS')
            {
            }
            column(kirinyagatitle;COMPANYNAME)
            {
            }
            column(abreviation;'MUST')
            {
            }
            column(EmpNo;"PRL-Period Transactions"."Employee Code")
            {
            }
            column(empName;empName)
            {
            }
            column(EmpAmount;"PRL-Period Transactions".Amount)
            {
            }
            column("code";"PRL-Period Transactions"."Transaction Code")
            {
            }
            column(name;"PRL-Period Transactions"."Transaction Name")
            {
            }
            column(Transaction;"PRL-Period Transactions"."Transaction Code"+': '+"PRL-Period Transactions"."Transaction Name")
            {
            }
            column(TotLabel;"PRL-Period Transactions"."Transaction Code"+': '+"PRL-Period Transactions"."Transaction Name")
            {
            }
            column(IDNumber;emps."ID Number")
            {
            }
            column(PeriodName2;objPeriod2."Period Name")
            {
            }
            column(PeriodDate2;objPeriod2."Date Opened")
            {
            }
            column(PeriodDate;objPeriod."Date Opened")
            {
            }
            column(PeriodName;objPeriod."Period Name")
            {
            }
            column(PerOpenned;"prPayroll Periods"."Date Opened")
            {
            }
            column(PerName;"prPayroll Periods"."Period Name")
            {
            }
            column(go;"PRL-Period Transactions"."Group Order")
            {
            }

            trigger OnAfterGetRecord()
            begin
                  "prPayroll Periods".Reset;
                  "prPayroll Periods".SetRange("prPayroll Periods"."Date Opened","PRL-Period Transactions"."Payroll Period");
                  if "prPayroll Periods".Find('-') then begin
                  end;

                    Clear(empName);
                    if emps.Get("PRL-Period Transactions"."Employee Code") then
                    empName:=emps."First Name"+' '+emps."Middle Name"+' '+emps."Last Name";
            end;

            trigger OnPreDataItem()
            begin

                "PRL-Period Transactions".SetFilter("PRL-Period Transactions"."Payroll Period",'%1..%2',SelectedPeriod,SelectedPeriod2);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(periodfilter;PeriodFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Start';
                    TableRelation = "PRL-Payroll Periods"."Date Opened";
                }
                field(PeriodFilter2;PeriodFilter2)
                {
                    ApplicationArea = Basic;
                    Caption = 'End';
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
        objPeriod.Reset;
        objPeriod.SetRange(objPeriod.Closed,false);
        if objPeriod.Find('-') then;
        PeriodFilter2:=objPeriod."Date Opened";
    end;

    trigger OnPreReport()
    begin
        if PeriodFilter>PeriodFilter2 then Error('Period Start is greater than period end.');
        if PeriodFilter=0D then Error('Specify a Period!');
        SelectedPeriod:=PeriodFilter;
        objPeriod.Reset;
        objPeriod.SetRange(objPeriod."Date Opened",SelectedPeriod);
        if objPeriod.Find('-') then
        begin
            PeriodName:=objPeriod."Period Name";
        end;

        SelectedPeriod2:=PeriodFilter2;
        objPeriod2.Reset;
        objPeriod2.SetRange(objPeriod2."Date Opened",SelectedPeriod2);
        if objPeriod2.Find('-') then
        begin
            PeriodName2:=objPeriod2."Period Name";
        end;

        if CompanyInfo.Get() then
        Clear(rows);
        Clear(GPY);
        Clear(STAT);
        Clear(DED);
        Clear(NETS);
    end;

    var
        empName: Text[250];
        found: Boolean;
        countz: Integer;
        PeriodFilter: Date;
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        PeriodTrans: Record UnknownRecord61092;
        objPeriod: Record UnknownRecord61081;
        SelectedPeriod: Date;
        PeriodName: Text[30];
        PeriodFilter2: Date;
        objPeriod2: Record UnknownRecord61081;
        SelectedPeriod2: Date;
        PeriodName2: Text[30];
        CompanyInfo: Record "Company Information";
        TotalsAllowances: Decimal;
        Dept: Boolean;
        PaymentDesc: Text[200];
        DeductionDesc: Text[200];
        GroupText1: Text[200];
        GroupText2: Text[200];
        PaymentAmount: Decimal;
        DeductAmount: Decimal;
        PayTrans: array [70] of Text[250];
        PayTransAmt: array [70] of Decimal;
        DedTrans: array [70] of Text[250];
        DedTransAmt: array [70] of Decimal;
        rows: Integer;
        rows2: Integer;
        GPY: Decimal;
        NETS: Decimal;
        STAT: Decimal;
        DED: Decimal;
        TotalFor: label 'Total for ';
        GroupOrder: label '3';
        TransBal: array [2,60] of Text[250];
        Addr: array [2,10] of Text[250];
        RecordNo: Integer;
        NoOfColumns: Integer;
        ColumnNo: Integer;
        emps: Record UnknownRecord61118;
        "prPayroll Periods": Record UnknownRecord61081;
}

