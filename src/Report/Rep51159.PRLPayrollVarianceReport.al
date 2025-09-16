#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51159 "PRL-Payroll Variance Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PRL-Payroll Variance Report.rdlc';
    EnableHyperlinks = true;

    dataset
    {
        dataitem(UnknownTable61840;UnknownTable61840)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(CompName;compInfo.Name)
            {
            }
            column(Address1;compInfo.Address)
            {
            }
            column(Address2;compInfo."Address 2")
            {
            }
            column(Phone1;compInfo."Phone No.")
            {
            }
            column(Phone2;compInfo."Phone No. 2")
            {
            }
            column(pics;compInfo.Picture)
            {
            }
            column(Emails;compInfo."E-Mail")
            {
            }
            column(Homep;compInfo."Home Page")
            {
            }
            column(DateFilter;PeriFilter)
            {
            }
            column(TransCode;"PRL-Variance Trans. Code Buff"."Transaction Code")
            {
            }
            column(EmpCode;"PRL-Variance Trans. Code Buff"."Emp. Code")
            {
            }
            column(TransName;"PRL-Variance Trans. Code Buff"."Transaction Name")
            {
            }
            column(EmpName;"PRL-Variance Trans. Code Buff"."Emp. Name")
            {
            }
            column(CurrAmount;"PRL-Variance Trans. Code Buff"."Current Amount")
            {
            }
            column(PrevAmount;"PRL-Variance Trans. Code Buff"."Previous Amount")
            {
            }
            column(CurrPeriod;PRLPayrollPeriodsCurr."Period Name")
            {
            }
            column(PrevPeriod;PRLPayrollPeriodsPrev."Period Name")
            {
            }
            column(variance;"PRL-Variance Trans. Code Buff"."Current Amount"-"PRL-Variance Trans. Code Buff"."Previous Amount")
            {
            }

            trigger OnAfterGetRecord()
            begin
                if "PRL-Variance Trans. Code Buff"."Current Amount"="PRL-Variance Trans. Code Buff"."Previous Amount" then CurrReport.Skip;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(PeriodFilter;PeriFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Period Filter';
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
        compInfo.Reset;
        if compInfo.Find('-') then begin
        compInfo.CalcFields(Picture);
          end;




        PRLPayrollPeriods.Reset;
        PRLPayrollPeriods.SetRange(Closed,false);
        if PRLPayrollPeriods.Find('-') then begin
          PeriFilter:=PRLPayrollPeriods."Date Opened";
          end else Error('No Open period in the filters');
    end;

    trigger OnPreReport()
    begin
        PRLVarianceTransCodeBuff2.Reset;
        if PRLVarianceTransCodeBuff2.Find('-') then PRLVarianceTransCodeBuff2.DeleteAll;
        if PeriFilter=0D then Error('Invalid date specified');
        PRLPayrollPeriodsCurr.Reset;
        PRLPayrollPeriodsCurr.SetRange("Date Opened",PeriFilter);
        if PRLPayrollPeriodsCurr.Find('-') then begin
        CurrentMonth:=PRLPayrollPeriodsCurr."Period Month";
        CurrentYear:=PRLPayrollPeriodsCurr."Period Year";

        if CurrentMonth=1 then begin
          PrevMonth:=12;
          PrevYear:=CurrentYear-1;
          end else begin
            PrevMonth:=CurrentMonth-1;
            PrevYear:=CurrentYear;
            end;
          end;

        PRLPayrollPeriodsPrev.Reset;
        PRLPayrollPeriodsPrev.SetRange("Period Month",PrevMonth);
        PRLPayrollPeriodsPrev.SetRange("Period Year",PrevYear);
        if PRLPayrollPeriodsPrev.Find('-') then begin
          end;
        // Curent Period data
        PRLPeriodTransactionsCurr.Reset;
        PRLPeriodTransactionsCurr.SetRange("Period Month",CurrentMonth);
        PRLPeriodTransactionsCurr.SetRange("Period Year",CurrentYear);
        PRLPeriodTransactionsCurr.SetFilter("Group Order",'<>%1',6);
        PRLPeriodTransactionsCurr.SetFilter("Transaction Code",'<>%1','TOT-DED');
        if PRLPeriodTransactionsCurr.Find('-') then begin
          repeat
              begin
          HRMEmployeeD.Reset;
          HRMEmployeeD.SetRange("No.",PRLPeriodTransactionsCurr."Employee Code");
          if HRMEmployeeD.Find('-') then begin
            end;

                PRLVarianceTransCodeBuff.Reset;
                PRLVarianceTransCodeBuff.SetRange("Transaction Code",PRLPeriodTransactionsCurr."Transaction Code");
                PRLVarianceTransCodeBuff.SetRange("Emp. Code",PRLPeriodTransactionsCurr."Employee Code");
                if not PRLVarianceTransCodeBuff.Find('-') then begin
                  // Insert Here
                  PRLVarianceTransCodeBuff.Init;
                  PRLVarianceTransCodeBuff."Transaction Code":=PRLPeriodTransactionsCurr."Transaction Code";
                  PRLVarianceTransCodeBuff."Transaction Name":=PRLPeriodTransactionsCurr."Transaction Name";
                  PRLVarianceTransCodeBuff."Emp. Code":=PRLPeriodTransactionsCurr."Employee Code";
                  PRLVarianceTransCodeBuff."Emp. Name":=HRMEmployeeD."First Name"+' '+HRMEmployeeD."Middle Name"+' '+HRMEmployeeD."Last Name";
                  PRLVarianceTransCodeBuff."Current Amount":=PRLPeriodTransactionsCurr.Amount;
                  PRLVarianceTransCodeBuff."Previous Amount":=0;
                  PRLVarianceTransCodeBuff."Current Month":=CurrentMonth;
                  PRLVarianceTransCodeBuff."Previous Month":=PrevMonth;
                  PRLVarianceTransCodeBuff."Current Year":=CurrentYear;
                  PRLVarianceTransCodeBuff."Previous Year":=PrevYear;
                  PRLVarianceTransCodeBuff.Insert;
                  end else begin
                  //PRLVarianceTransCodeBuff."Transaction Code":=PRLPeriodTransactionsCurr."Transaction Code";
                  PRLVarianceTransCodeBuff."Transaction Name":=PRLPeriodTransactionsCurr."Transaction Name";
                  //PRLVarianceTransCodeBuff."Emp. Code":=PRLPeriodTransactionsCurr."Employee Code";
                  PRLVarianceTransCodeBuff."Emp. Name":=HRMEmployeeD."First Name"+' '+HRMEmployeeD."Middle Name"+' '+HRMEmployeeD."Last Name";
                  PRLVarianceTransCodeBuff."Current Amount":=PRLPeriodTransactionsCurr.Amount;
                  //PRLVarianceTransCodeBuff."Previous Amount":=0;
                  PRLVarianceTransCodeBuff.Modify;
                    end;
              end;
            until PRLPeriodTransactionsCurr.Next =0;
          end;

        // Insert fior Previous
        PRLPeriodTransactionsPrev.Reset;
        PRLPeriodTransactionsPrev.SetRange("Period Month",PrevMonth);
        PRLPeriodTransactionsPrev.SetRange("Period Year",PrevYear);
        PRLPeriodTransactionsPrev.SetFilter("Group Order",'<>%1',6);
        PRLPeriodTransactionsPrev.SetFilter("Transaction Code",'<>%1','TOT-DED');
        if PRLPeriodTransactionsPrev.Find('-') then begin
          repeat
              begin
          HRMEmployeeD.Reset;
          HRMEmployeeD.SetRange("No.",PRLPeriodTransactionsPrev."Employee Code");
          if HRMEmployeeD.Find('-') then begin
            end;
                PRLVarianceTransCodeBuff.Reset;
                PRLVarianceTransCodeBuff.SetRange("Transaction Code",PRLPeriodTransactionsPrev."Transaction Code");
                PRLVarianceTransCodeBuff.SetRange("Emp. Code",PRLPeriodTransactionsPrev."Employee Code");
                if not PRLVarianceTransCodeBuff.Find('-') then begin
                  // Insert Here
                  PRLVarianceTransCodeBuff.Init;
                  PRLVarianceTransCodeBuff."Transaction Code":=PRLPeriodTransactionsPrev."Transaction Code";
                  PRLVarianceTransCodeBuff."Transaction Name":=PRLPeriodTransactionsPrev."Transaction Name";
                  PRLVarianceTransCodeBuff."Emp. Code":=PRLPeriodTransactionsPrev."Employee Code";
                  PRLVarianceTransCodeBuff."Emp. Name":=HRMEmployeeD."First Name"+' '+HRMEmployeeD."Middle Name"+' '+HRMEmployeeD."Last Name";
                  PRLVarianceTransCodeBuff."Current Amount":=0;
                  PRLVarianceTransCodeBuff."Previous Amount":=PRLPeriodTransactionsPrev.Amount;
                  PRLVarianceTransCodeBuff."Current Month":=CurrentMonth;
                  PRLVarianceTransCodeBuff."Previous Month":=PrevMonth;
                  PRLVarianceTransCodeBuff."Current Year":=CurrentYear;
                  PRLVarianceTransCodeBuff."Previous Year":=PrevYear;
                  PRLVarianceTransCodeBuff.Insert;
                  end else begin
                  PRLVarianceTransCodeBuff."Transaction Name":=PRLPeriodTransactionsPrev."Transaction Name";
                  PRLVarianceTransCodeBuff."Emp. Name":=HRMEmployeeD."First Name"+' '+HRMEmployeeD."Middle Name"+' '+HRMEmployeeD."Last Name";
                 // PRLVarianceTransCodeBuff."Current Amount":=0;
                  PRLVarianceTransCodeBuff."Previous Amount":=PRLPeriodTransactionsPrev.Amount;
                 // PRLVarianceTransCodeBuff."Current Month":=CurrentMonth;
                 // PRLVarianceTransCodeBuff."Previous Month":=PrevMonth;
                 // PRLVarianceTransCodeBuff."Current Year":=CurrentYear;
                 // PRLVarianceTransCodeBuff."Previous Year":=PrevYear;
                  PRLVarianceTransCodeBuff.Modify;
                  end;
              end;
            until PRLPeriodTransactionsPrev.Next =0;
          end;
        "PRL-Variance Trans. Code Buff".Reset;
        if "PRL-Variance Trans. Code Buff".Find('-') then begin
          end;
    end;

    var
        PRLVarianceTransCodeBuff: Record UnknownRecord61840;
        PRLVarianceTransCodeBuff2: Record UnknownRecord61840;
        PeriFilter: Date;
        PRLPayrollPeriods: Record UnknownRecord61081;
        PRLPayrollPeriodsCurr: Record UnknownRecord61081;
        PRLPayrollPeriodsPrev: Record UnknownRecord61081;
        PRLPeriodTransactions: Record UnknownRecord61092;
        PRLPeriodTransactionsCurr: Record UnknownRecord61092;
        PRLPeriodTransactionsPrev: Record UnknownRecord61092;
        HRMEmployeeD: Record UnknownRecord61118;
        CurrentMonth: Integer;
        CurrentYear: Integer;
        PrevMonth: Integer;
        PrevYear: Integer;
        CurrentAmount: Integer;
        PrevAmounts: Integer;
        "Emp|No": Integer;
        EmpName: Integer;
        compInfo: Record "Company Information";
}

