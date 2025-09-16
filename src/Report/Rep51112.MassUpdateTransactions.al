#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51112 "Mass Update Transactions"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61118;UnknownTable61118)
        {
            DataItemTableView = sorting("No.") order(ascending);
            RequestFilterFields = "No.";
            column(ReportForNavId_8631; 8631)
            {
            }

            trigger OnAfterGetRecord()
            begin
                  if not SalaryIncrement then begin
                  if (TransactionCode='') or (PeriodSelected =0D) then
                      Error('The Transaction Code and Period Selected Should be Update');

                  PayrollPeriod.Reset;
                  PayrollPeriod.SetRange(PayrollPeriod."Date Opened",PeriodSelected);
                  if PayrollPeriod.Find('-') then begin
                  if PayrollPeriod.Closed=true then
                     Error('You cannot make changes on a closed period');

                     Month:=Date2dmy(PeriodSelected,2);
                     Year:=Date2dmy(PeriodSelected,3);
                  end;
                    prEmpTrans.Reset;
                    prEmpTrans.SetRange(prEmpTrans."Transaction Code",TransactionCode);
                    prEmpTrans.SetRange(prEmpTrans."Payroll Period",PeriodSelected);
                    prEmpTrans.SetRange(prEmpTrans."Employee Code","HRM-Employee (D)"."No.");
                    if prEmpTrans.Get('-') then
                       Error('A similar transaction exists for the selected period Delete it First');
                    prEmpTrans.Init;
                    prEmpTrans."Employee Code":="HRM-Employee (D)"."No.";
                    prEmpTrans."Transaction Code":=TransactionCode;
                    prEmpTrans.Validate("Transaction Code");
                    prTransCode.Get(TransactionCode);
                    prEmpTrans."Transaction Name":=prTransCode."Transaction Name";
                    prEmpTrans."Period Month":=Month;
                    prEmpTrans."Period Year":=Year;
                    prEmpTrans."Payroll Period":=PeriodSelected;
                    prEmpTrans.Amount:=Amount;
                    prEmpTrans.Balance:=BalanceAmt;
                    prEmpTrans.Insert;
                    end else begin
                       if SalCard.Get("HRM-Employee (D)"."No.") then
                          if "Increment Percentage"=0 then
                             Error('Enter the Percentage of Increment');
                          SalCard."Basic Pay":=SalCard."Basic Pay"+(("Increment Percentage"/100)*SalCard."Basic Pay");
                          SalCard.Modify;
                       CommentLine.Reset;
                       CommentLine.SetRange(CommentLine."Table Name",CommentLine."table name"::Employee);
                       if CommentLine.FindLast then
                       Int:=CommentLine."Line No."
                       else
                            Int:=10000;
                       CommentLine.Init;
                       CommentLine."Table Name":=CommentLine."table name"::Employee;
                       CommentLine."No." :="HRM-Employee (D)"."No.";
                       CommentLine."Line No.":= Int+10000;
                       CommentLine.Date:=Today;
                       CommentLine.Comment:=CommentText;
                       CommentLine.Insert;

                    end;
            end;

            trigger OnPreDataItem()
            begin
                  if not Confirm(Text0003,false) then
                    Error(Text0004);
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
          Message('Process Complete');
    end;

    var
        PayrollPeriod: Record UnknownRecord61081;
        PeriodSelected: Date;
        Month: Integer;
        Year: Integer;
        TransactionCode: Code[20];
        prEmpTrans: Record UnknownRecord61091;
        prTransCode: Record UnknownRecord61082;
        Amount: Decimal;
        BalanceAmt: Decimal;
        SalaryIncrement: Boolean;
        "Increment Percentage": Decimal;
        SalCard: Record UnknownRecord61105;
        Text0003: label 'Are you sure you want to Effect the Changes?';
        Text0004: label 'You have decided to Abort the process';
        CommentLine: Record "Human Resource Comment Line";
        CommentText: Text[100];
        Int: Integer;
}

