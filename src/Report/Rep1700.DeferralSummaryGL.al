#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1700 "Deferral Summary - G/L"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Deferral Summary - GL.rdlc';
    Caption = 'G/L Deferral Summary';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Posted Deferral Header";"Posted Deferral Header")
        {
            DataItemTableView = sorting("Deferral Doc. Type","Account No.","Posting Date","Gen. Jnl. Document No.","Document Type","Document No.","Line No.") order(ascending) where("Deferral Doc. Type"=const("G/L"));
            RequestFilterFields = "Account No.";
            column(ReportForNavId_17; 17)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(PageGroupNo;PageGroupNo)
            {
            }
            column(PostedDeferralTableCaption;TableCaption + ': ' + PostedDeferralFilter)
            {
            }
            column(PostedDeferralFilter;PostedDeferralFilter)
            {
            }
            column(EmptyString;'')
            {
            }
            column(No_GLAcc;"Account No.")
            {
            }
            column(DeferralSummaryGLCaption;DeferralSummaryGLCaptionLbl)
            {
            }
            column(PageCaption;PageCaptionLbl)
            {
            }
            column(BalanceCaption;BalanceCaptionLbl)
            {
            }
            column(PeriodCaption;PeriodCaptionLbl)
            {
            }
            column(GLBalCaption;GLBalCaptionLbl)
            {
            }
            column(RemAmtDefCaption;RemAmtDefCaptionLbl)
            {
            }
            column(TotAmtDefCaption;TotAmtDefCaptionLbl)
            {
            }
            column(BalanceAsOfDateCaption;BalanceAsOfDateCaptionLbl + Format(BalanceAsOfDateFilter))
            {
            }
            column(BalanceAsOfDateFilter;BalanceAsOfDateFilter)
            {
            }
            column(AccountNoCaption;AccountNoLbl)
            {
            }
            column(AmtRecognizedCaption;AmtRecognizedLbl)
            {
            }
            column(AccountName;AccountName)
            {
            }
            column(NumOfPeriods;"No. of Periods")
            {
            }
            column(DocumentType;"Document Type")
            {
            }
            column(DeferralStartDate;Format("Start Date"))
            {
            }
            column(AmtRecognized;AmtRecognized)
            {
            }
            column(RemainingAmtDeferred;RemainingAmtDeferred)
            {
            }
            column(TotalAmtDeferred;"Amount to Defer (LCY)")
            {
            }
            column(PostingDate;Format(PostingDate))
            {
            }
            column(DeferralAccount;DeferralAccount)
            {
            }
            column(Amount;"Amount to Defer (LCY)")
            {
            }
            column(GenJnlDocNo;"Gen. Jnl. Document No.")
            {
            }
            column(GLDocType;GLDocType)
            {
            }

            trigger OnAfterGetRecord()
            var
                GLEntry: Record "G/L Entry";
            begin
                PreviousAccount := WorkingAccount;
                if GLAccount.Get("Account No.") then begin
                  AccountName := GLAccount.Name;
                  WorkingAccount := GLAccount."No.";
                end;

                AmtRecognized := 0;
                RemainingAmtDeferred := 0;

                PostedDeferralLine.SetRange("Deferral Doc. Type","Deferral Doc. Type");
                PostedDeferralLine.SetRange("Gen. Jnl. Document No.","Gen. Jnl. Document No.");
                PostedDeferralLine.SetRange("Account No.","Account No.");
                PostedDeferralLine.SetRange("Document Type","Document Type");
                PostedDeferralLine.SetRange("Document No.","Document No.");
                PostedDeferralLine.SetRange("Line No.","Line No.");
                if PostedDeferralLine.Find('-') then
                  repeat
                    DeferralAccount := PostedDeferralLine."Deferral Account";
                    if PostedDeferralLine."Posting Date" <= BalanceAsOfDateFilter then
                      AmtRecognized := AmtRecognized + PostedDeferralLine."Amount (LCY)"
                    else
                      RemainingAmtDeferred := RemainingAmtDeferred + PostedDeferralLine."Amount (LCY)";
                  until (PostedDeferralLine.Next = 0);

                if GLEntry.Get("Entry No.") then begin
                  GLDocType := GLEntry."Document Type";
                  PostingDate := GLEntry."Posting Date";
                end;

                if PrintOnlyOnePerPage and (PreviousAccount <> WorkingAccount) then begin
                  PostedDeferralHeaderPage.Reset;
                  PostedDeferralHeaderPage.SetRange("Account No.","Account No.");
                  if PostedDeferralHeaderPage.FindFirst then
                    PageGroupNo := PageGroupNo + 1;
                end;
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 1;

                CurrReport.NewPagePerRecord := PrintOnlyOnePerPage;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NewPageperGLAcc;PrintOnlyOnePerPage)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Page per G/L Acc.';
                    }
                    field(BalanceAsOfDateFilter;BalanceAsOfDateFilter)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Balance as of:';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if BalanceAsOfDateFilter = 0D then
              BalanceAsOfDateFilter := WorkDate;
        end;
    }

    labels
    {
        PostingDateCaption = 'Posting Date';
        DocNoCaption = 'Document No.';
        DescCaption = 'Description';
        EntryNoCaption = 'Entry No.';
        NoOfPeriodsCaption = 'No. of Periods';
        DeferralAccountCaption = 'Deferral Account';
        DocTypeCaption = 'Document Type';
        DefStartDateCaption = 'Deferral Start Date';
        AcctNameCaption = 'Account Name';
    }

    trigger OnPreReport()
    begin
        PostedDeferralFilter := "Posted Deferral Header".GetFilters;
    end;

    var
        PostedDeferralHeaderPage: Record "Posted Deferral Header";
        GLAccount: Record "G/L Account";
        PostedDeferralLine: Record "Posted Deferral Line";
        GLDocType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        PostedDeferralFilter: Text;
        PrintOnlyOnePerPage: Boolean;
        PageGroupNo: Integer;
        PageCaptionLbl: label 'Page';
        BalanceCaptionLbl: label 'This also includes general ledger accounts that only have a balance.';
        PeriodCaptionLbl: label 'This report also includes closing entries within the period.';
        GLBalCaptionLbl: label 'Balance';
        DeferralSummaryGLCaptionLbl: label 'Deferral Summary - GL';
        RemAmtDefCaptionLbl: label 'Remaining Amt. Deferred';
        TotAmtDefCaptionLbl: label 'Total Amt. Deferred';
        BalanceAsOfDateFilter: Date;
        PostingDate: Date;
        AmtRecognized: Decimal;
        RemainingAmtDeferred: Decimal;
        BalanceAsOfDateCaptionLbl: label 'Balance as of: ';
        AccountNoLbl: label 'Account No.';
        AmtRecognizedLbl: label 'Amt. Recognized';
        AccountName: Text[50];
        WorkingAccount: Code[20];
        PreviousAccount: Code[20];
        DeferralAccount: Code[20];


    procedure InitializeRequest(NewPrintOnlyOnePerPage: Boolean;NewBalanceAsOfDateFilter: Date)
    begin
        PrintOnlyOnePerPage := NewPrintOnlyOnePerPage;
        BalanceAsOfDateFilter := NewBalanceAsOfDateFilter;
    end;
}

