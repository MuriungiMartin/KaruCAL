#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51079 "Vote Book Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Vote Book Balance.rdlc';

    dataset
    {
        dataitem("G/L Account";"G/L Account")
        {
            DataItemTableView = sorting("No.") order(ascending);
            RequestFilterFields = "No.","Date Filter";
            column(ReportForNavId_6710; 6710)
            {
            }
            column(Header;Header)
            {
            }
            column(G_L_Account__No__;"No.")
            {
            }
            column(G_L_Account_Name;Name)
            {
            }
            column(MonthBudget;MonthBudget)
            {
            }
            column(Expenses;Expenses)
            {
            }
            column(BudgetAvailable_CommittedAmount;BudgetAvailable-CommittedAmount)
            {
            }
            column(CommittedAmount;CommittedAmount)
            {
            }
            column(Item___Sub_ItemCaption;Item___Sub_ItemCaptionLbl)
            {
            }
            column(DescriptionCaption;DescriptionCaptionLbl)
            {
            }
            column(AllocationCaption;AllocationCaptionLbl)
            {
            }
            column(ExpensesCaption;ExpensesCaptionLbl)
            {
            }
            column(BalancesCaption;BalancesCaptionLbl)
            {
            }
            column(Commited_AmountCaption;Commited_AmountCaptionLbl)
            {
            }
            column(KARATINA_UNIVERSITYCaption;KARATINA_UNIVERSITYCaptionLbl)
            {
            }
            column(Datet;DateFrom)
            {
            }
            column(datef;DateTo)
            {
            }

            trigger OnAfterGetRecord()
            begin
                
                      Counter:=0;
                      GLAccount.Reset;
                      GLAccount.Get("G/L Account"."No.");
                      GLAccount.CheckGLAcc;
                      GLAccount.TestField("Direct Posting",true);
                
                        if DateFrom<>0D then begin
                        Evaluate(CurrMonth,Format(Date2dmy(DateFrom,2)));
                        Evaluate(CurrYR,Format(Date2dmy(DateFrom,3)));
                        Evaluate(BudgetDate,Format('01'+'/'+CurrMonth+'/'+CurrYR));
                        BudgetDateTo:=DateTo;
                          //Get the last day of the month
                          /*
                          LastDay:=CALCDATE('1M', BudgetDate);
                          LastDay:=CALCDATE('-1D',LastDay);*/
                        end;
                        /*
                        IF DateTo<>0D THEN BEGIN
                        EVALUATE(CurrMonth,FORMAT(DATE2DMY(DateTo,2)));
                        EVALUATE(CurrYR,FORMAT(DATE2DMY(DateTo,3)));
                        EVALUATE(BudgetDateTo,FORMAT('01'+'/'+CurrMonth+'/'+CurrYR));
                        END;
                        */
                        //Get Budget for the G/L
                      if GenLedSetup.Get then begin
                        GLAccount.SetFilter(GLAccount."Budget Filter",GenLedSetup."Current Budget");
                        GLAccount.SetRange(GLAccount."No.","G/L Account"."No.");
                //GLAccount.SETRANGE(GLAccount."Date Filter",GenLedSetup."Current Budget Start Date",GenLedSetup."Current Budget End Date");
                        GLAccount.CalcFields(GLAccount."Budgeted Amount",GLAccount."Net Change");
                        /*Get the exact Monthly Budget*/
                        if SingleMonth then
                        GLAccount.SetRange(GLAccount."Date Filter",BudgetDate,LastDay)
                        else
                        /*For a selected period range*/
                        GLAccount.SetRange(GLAccount."Date Filter",BudgetDate,BudgetDateTo);
                
                        if GLAccount.Find('-') then begin
                         GLAccount.CalcFields(GLAccount."Budgeted Amount",GLAccount."Net Change");
                         MonthBudget:=GLAccount."Budgeted Amount";
                         Expenses:=GLAccount."Net Change";
                         BudgetAvailable:=GLAccount."Budgeted Amount"-GLAccount."Net Change";
                
                        end;
                        GLAccount.Reset;
                        GLAccount.SetFilter(GLAccount."Budget Filter",GenLedSetup."Current Budget");
                        GLAccount.SetRange(GLAccount."No.","G/L Account"."No.");
                        GLAccount.SetRange(GLAccount."Date Filter",GenLedSetup."Current Budget Start Date",GenLedSetup."Current Budget End Date");
                        GLAccount.CalcFields(GLAccount."Budgeted Amount",GLAccount."Net Change");
                        if GLAccount.Find('-') then begin
                         GLAccount.CalcFields(GLAccount."Budgeted Amount",GLAccount."Net Change");
                          "Total Budget":=GLAccount."Budgeted Amount";
                        end;
                
                     end;
                
                  CommitmentEntries.Reset;
                  CommitmentEntries.SetCurrentkey(CommitmentEntries.Account);
                  CommitmentEntries.SetRange(CommitmentEntries.Account,"G/L Account"."No.");
                  if Departments<>'' then begin
                     CommitmentEntries.SetRange(CommitmentEntries.Department,Departments);
                  end;
                  if SingleMonth then
                     CommitmentEntries.SetRange(CommitmentEntries.Date,DateFrom,LastDay)
                  else
                     CommitmentEntries.SetRange(CommitmentEntries.Date,DateFrom,DateTo);
                
                  CommitmentEntries.CalcSums(CommitmentEntries."Committed Amount");
                  CommittedAmount:=CommitmentEntries."Committed Amount";

            end;

            trigger OnPreDataItem()
            begin
                  "G/L Account".SetRange("G/L Account"."Budget Controlled",true);
                  if GLAcc<>'' then
                  "G/L Account".SetRange("G/L Account"."No.",GLAcc);

                   //IF SingleMonth=FALSE THEN BEGIN
                      if DateFrom=0D then
                        Error('Enter the Start Date');
                      if DateTo=0D then
                        Error('Enter the End Date');
                        Evaluate("Date From",Format(DateFrom));
                        Evaluate("Date To",Format(DateTo));
                        Header:='OVERALL VOTE BOOK BALANCES FOR THE PERIOD BETWEEN '+"Date From"+' AND '+"Date To";
                //   END ELSE BEGIN
                //      IF DateFrom=0D THEN
                //        ERROR('Enter the Start Date');
                //        EVALUATE("Date From",FORMAT(DateFrom));
                //        Header:='OVERALL VOTE BOOK BALANCES AS AT '+"Date From";
                   //END;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Date From";"Date From")
                {
                    ApplicationArea = Basic;
                }
                field("Date To";"Date To")
                {
                    ApplicationArea = Basic;
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
        SingleMonth: Boolean;
        DateFrom: Date;
        DateTo: Date;
        GLAccount: Record "G/L Account";
        Budget: Decimal;
        CurrMonth: Code[10];
        CurrYR: Code[10];
        BudgDate: Text[30];
        BudgetDate: Date;
        YrBudget: Decimal;
        BudgetDateTo: Date;
        BudgetAvailable: Decimal;
        GenLedSetup: Record "General Ledger Setup";
        "Total Budget": Decimal;
        CommitmentEntries: Record UnknownRecord61135;
        CommittedAmount: Decimal;
        MonthBudget: Decimal;
        Expenses: Decimal;
        Header: Text[250];
        "Date From": Text[30];
        "Date To": Text[30];
        LastDay: Date;
        GLAcc: Code[20];
        Counter: Integer;
        Departments: Code[50];
        Item___Sub_ItemCaptionLbl: label 'Item & Sub-Item';
        DescriptionCaptionLbl: label 'Description';
        AllocationCaptionLbl: label 'Allocation';
        ExpensesCaptionLbl: label 'Expenses';
        BalancesCaptionLbl: label 'Balances';
        Commited_AmountCaptionLbl: label 'Commited Amount';
        KARATINA_UNIVERSITYCaptionLbl: label 'KARATINA UNIVERSITY';
}

