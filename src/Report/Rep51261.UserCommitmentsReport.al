#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51261 "User Commitments Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/User Commitments Report.rdlc';

    dataset
    {
        dataitem("G/L Account";"G/L Account")
        {
            RequestFilterFields = "No.","Global Dimension 1 Code";
            column(ReportForNavId_6710; 6710)
            {
            }
            column(USERID;UserId)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Vote_Book_Departmental_ReportCaption;Vote_Book_Departmental_ReportCaptionLbl)
            {
            }
            column(G_L_Account_No_;"No.")
            {
            }
            dataitem(UnknownTable61135;UnknownTable61135)
            {
                DataItemLink = Account=field("No.");
                DataItemTableView = sorting(Department) where("Commitment Type"=const(Committed));
                RequestFilterFields = Date,Department,Account;
                RequestFilterHeading = 'Date Filter';
                column(ReportForNavId_2097; 2097)
                {
                }
                column(Commitment_Entries_Department;Department)
                {
                }
                column(DeptName;DeptName)
                {
                }
                column(Commitment_Entries_Date;Date)
                {
                }
                column(Commitment_Entries__Committed_Amount_;"Committed Amount")
                {
                }
                column(Commitment_Entries_OrderNo;OrderNo)
                {
                }
                column(Commitment_Entries_InvoiceNo;InvoiceNo)
                {
                }
                column(Commitment_Entries_No;No)
                {
                }
                column(Commitment_Entries_Account;Account)
                {
                }
                column(GLName;GLName)
                {
                }
                column(Balance;Balance)
                {
                }
                column(Total_Comm_;"Total Comm")
                {
                }
                column(Total_Allo_;"Total Allo")
                {
                }
                column(DateCaption;DateCaptionLbl)
                {
                }
                column(Commitment_Entries__Committed_Amount_Caption;FieldCaption("Committed Amount"))
                {
                }
                column(Commitment_Entries_OrderNoCaption;FieldCaption(OrderNo))
                {
                }
                column(Commitment_Entries_InvoiceNoCaption;FieldCaption(InvoiceNo))
                {
                }
                column(Commitment_Entries_NoCaption;FieldCaption(No))
                {
                }
                column(Commitment_Entries_AccountCaption;FieldCaption(Account))
                {
                }
                column(Account_NameCaption;Account_NameCaptionLbl)
                {
                }
                column(AllocationsCaption;AllocationsCaptionLbl)
                {
                }
                column(BalanceCaption;BalanceCaptionLbl)
                {
                }
                column(Department_CodeCaption;Department_CodeCaptionLbl)
                {
                }
                column(Department_NameCaption;Department_NameCaptionLbl)
                {
                }
                column(TotalsCaption;TotalsCaptionLbl)
                {
                }
                column(Commitment_Entries_Entry_No;"Entry No")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if "FIN-Commitment Entries".Department='' then begin
                      CurrReport.Skip
                     end;
                    
                    
                      CommitRec.Reset;
                      PurchHeader.Reset;
                       PayRec.Reset;
                       CommitRec.SetRange(CommitRec."Entry No","FIN-Commitment Entries"."Entry No");
                     // payrec.setrange(PayRec.No,"Commitment Entries".No);
                      if PayRec.Get("FIN-Commitment Entries".No) then begin
                        if CommitRec.Find('-') then begin
                         CommitRec.Department:=PayRec.Department;
                         CommitRec."Global Dimension 1":=PayRec."Business Code";
                         CommitRec.Modify;
                        end;
                      end;
                    
                     PurchHeader.SetRange(PurchHeader."No.","FIN-Commitment Entries".No);
                      if PurchHeader.Find('-') then begin
                        CommitRec.Department:=PurchHeader.Department;
                        CommitRec."Global Dimension 1":=PurchHeader."Shortcut Dimension 1 Code";
                        CommitRec.Modify;
                      end;
                    
                          Counter:=0;
                          GLAccount.Reset;
                          GLAccount.Get("FIN-Commitment Entries".Account);
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
                            //Get Budget for the G/L
                          if GenLedSetup.Get then begin
                            GLAccount.SetFilter(GLAccount."Budget Filter",GenLedSetup."Current Budget");
                            GLAccount.SetRange(GLAccount."No.","FIN-Commitment Entries".Account);
                    //GLAccount.SETRANGE(GLAccount."Date Filter",GenLedSetup."Current Budget Start Date",GenLedSetup."Current Budget End Date");
                            GLAccount.CalcFields(GLAccount."Budgeted Amount",GLAccount."Net Change");
                            /*Get the exact Monthly Budget */
                            //IF SingleMonth THEN
                            //GLAccount.SETRANGE(GLAccount."Date Filter",BudgetDate,LastDay);
                           // ELSE
                           /* For a selected period range*/
                           Evaluate(PDate,'010708');
                            GLAccount.SetFilter(GLAccount."Date Filter",'%1..%2',GenLedSetup."Current Budget Start Date","FIN-Commitment Entries".Date);
                            "Total Budget":=0;
                            BudgetEntries.Reset;
                            BudgetEntries.SetRange(BudgetEntries."Budget Name",GenLedSetup."Current Budget");
                            BudgetEntries.SetFilter(BudgetEntries."G/L Account No.","FIN-Commitment Entries".Account);
                            BudgetEntries.SetFilter(BudgetEntries."Budget Dimension 1 Code","FIN-Commitment Entries".Department);
                            if BudgetEntries.Find('-') then begin
                            repeat
                               "Total Budget":="Total Budget"+BudgetEntries.Amount;
                            until BudgetEntries.Next=0;
                            end;
                            Expenses:=0;
                            IssueRec.Reset;
                            IssueRec.SetRange(IssueRec.Department,"FIN-Commitment Entries".Department);
                            IssueRec.SetFilter(IssueRec."Date Issued",'%1..%2',GenLedSetup."Current Budget Start Date",
                            GenLedSetup."Current Budget End Date");
                            if IssueRec.Find('-') then begin
                               repeat
                               "Issue Line".Reset;
                               "Issue Line".SetRange("Issue Line"."No.",IssueRec."No.");
                               if "Issue Line".Find('-') then begin
                                 repeat
                                   Expenses:=Expenses+"Issue Line"."Total Cost";
                                 until "Issue Line".Next=0;
                               end;
                            until IssueRec.Next=0;
                            end;
                            Expenses:=0;
                         end;
                        // Balance:="Total Budget"-(Expenses+"Commitment Entries"."Committed Amount");
                       Balance:=Balance+("Total Budget"-"FIN-Commitment Entries"."Committed Amount");
                    
                      "Total Bal":="Total Bal"+Balance;
                      "Total Exp":=Expenses;
                      "Total Allo":="Total Budget";
                      "Total Comm":="Total Comm"+"FIN-Commitment Entries"."Committed Amount";
                       "Total Bal":=Balance;

                end;

                trigger OnPreDataItem()
                begin
                    LastFieldNo := FieldNo(Department);
                     GenLedSetup.Get();
                     "FIN-Commitment Entries".SetFilter("FIN-Commitment Entries".Date,'%1..%2',GenLedSetup."Current Budget Start Date",
                     GenLedSetup."Current Budget End Date");

                    // Get User Department HOD
                      UserResp.Reset;
                      UserResp.SetRange(UserResp."Login Name",UserId);
                      if UserResp.Find('-') then begin
                        UserDept:=UserResp.Department
                      end;

                      "FIN-Commitment Entries".SetRange("FIN-Commitment Entries".Department,UserDept);
                end;
            }
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
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        TotalFor: label 'Total for ';
        PayRec: Record UnknownRecord61134;
        CommitRec: Record UnknownRecord61135;
        GLACC: Record "G/L Account";
        GLName: Text[100];
        Expenses: Decimal;
        Allocations: Decimal;
        Balance: Decimal;
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
        MonthBudget: Decimal;
        Header: Text[250];
        LastDay: Date;
        GLAccNo: Code[20];
        Counter: Integer;
        DateFrom: Date;
        DateTo: Date;
        DeptName: Text[100];
        Dimm: Record "Dimension Value";
        "Total Bal": Decimal;
        "Total Exp": Decimal;
        "Total Allo": Decimal;
        "Total Comm": Decimal;
        PurchHeader: Record "Purchase Header";
        PDate: Date;
        BudgetEntries: Record "G/L Budget Entry";
        Payment: Record UnknownRecord61134;
        IssueRec: Record UnknownRecord61148;
        "Issue Line": Record UnknownRecord61149;
        UserResp: Record UnknownRecord61278;
        UserDept: Code[20];
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Vote_Book_Departmental_ReportCaptionLbl: label 'Vote Book Departmental Report';
        DateCaptionLbl: label 'Date';
        Account_NameCaptionLbl: label 'Account Name';
        AllocationsCaptionLbl: label 'Allocations';
        BalanceCaptionLbl: label 'Balance';
        Department_CodeCaptionLbl: label 'Department Code';
        Department_NameCaptionLbl: label 'Department Name';
        TotalsCaptionLbl: label 'Totals';
}

