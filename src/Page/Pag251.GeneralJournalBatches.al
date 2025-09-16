#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 251 "General Journal Batches"
{
    Caption = 'General Journal Batches';
    DataCaptionExpression = DataCaption;
    PageType = List;
    SourceTable = "Gen. Journal Batch";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the journal you are creating.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a brief description of the journal batch you are creating.';
                }
                field("Bal. Account Type";"Bal. Account Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the value you have selected in the Bal. Account Type field on the journal template. You may change this value.';
                }
                field("Bal. Account No.";"Bal. Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a copy of the Bal. Account No. field, or the balancing account number for this general journal batch.';
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for the number series that will be used to assign document numbers to journal lines in this journal batch.';
                }
                field("Posting No. Series";"Posting No. Series")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for the number series that will be used to assign document numbers to ledger entries that are posted from this journal batch.';
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the reason code that is linked to the general journal template.';
                }
                field("Copy VAT Setup to Jnl. Lines";"Copy VAT Setup to Jnl. Lines")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether the program to calculate tax for accounts and balancing accounts on the journal line of the selected journal batch.';
                }
                field("Allow VAT Difference";"Allow VAT Difference")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether to allow the manual adjustment of tax amounts in journal templates.';
                }
                field("Allow Payment Export";"Allow Payment Export")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if you can export bank payment files from payment journal lines using this general journal batch.';
                    Visible = IsPaymentTemplate;
                }
                field("Suggest Balancing Amount";"Suggest Balancing Amount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the Amount field on journal lines for the same document number is automatically prefilled with the value that is required to balance the document.';
                }
                field("Bank Statement Import Format";"Bank Statement Import Format")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the format of the bank statement file that can be imported into this general journal batch.';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(EditJournal)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Edit Journal';
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Return';
                ToolTip = 'Edit the general journal.';

                trigger OnAction()
                begin
                    GenJnlManagement.TemplateSelectionFromBatch(Rec);
                end;
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(TestReport)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';

                    trigger OnAction()
                    begin
                        ReportPrint.PrintGenJnlBatch(Rec);
                    end;
                }
                action("P&ost")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Gen. Jnl.-B.Post";
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';
                }
                action("Post and &Print")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Gen. Jnl.-B.Post+Print";
                    ShortCutKey = 'Shift+F9';
                    ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';
                }
                action(MarkedOnOff)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Marked On/Off';
                    Image = Change;
                    ToolTip = 'View all journal batches or only marked journal batches. A journal batch is marked if an attempt to post the general journal fails.';

                    trigger OnAction()
                    begin
                        MarkedOnly(not MarkedOnly);
                        CurrPage.Update(false);
                    end;
                }
            }
            group("Periodic Activities")
            {
                Caption = 'Periodic Activities';
                action("Recurring General Journal")
                {
                    ApplicationArea = Suite;
                    Caption = 'Recurring General Journal';
                    Image = Journal;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Page "Recurring General Journal";
                    ToolTip = 'Define how to post transactions that recur with few or no changes to general ledger, bank, customer, vendor, and fixed assets accounts.';
                }
                action("G/L Register")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'G/L Register';
                    Image = GLRegisters;
                    RunObject = Page "G/L Registers";
                    ToolTip = 'View posted G/L entries.';
                }
            }
        }
        area(reporting)
        {
            action("Detail Trial Balance")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Detail Trial Balance';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedOnly = true;
                RunObject = Report "Detail Trial Balance";
                ToolTip = 'View detail general ledger account balances and activities.';
            }
            action("Trial Balance")
            {
                ApplicationArea = Suite;
                Caption = 'Trial Balance';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedOnly = true;
                RunObject = Report "Trial Balance";
                ToolTip = 'View general ledger account balances and activities.';
            }
            action("Trial Balance by Period")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Trial Balance by Period';
                Image = "Report";
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Trial Balance by Period";
                ToolTip = 'View general ledger account balances and activities within a selected period.';
            }
            action(Action10)
            {
                ApplicationArea = Suite;
                Caption = 'G/L Register';
                Image = GLRegisters;
                RunObject = Report "G/L Register";
                ToolTip = 'View posted G/L entries.';
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetupNewBatch;
    end;

    trigger OnOpenPage()
    begin
        GenJnlManagement.OpenJnlBatch(Rec);
        ShowAllowPaymentExportForPaymentTemplate;
    end;

    var
        ReportPrint: Codeunit "Test Report-Print";
        GenJnlManagement: Codeunit GenJnlManagement;
        IsPaymentTemplate: Boolean;

    local procedure DataCaption(): Text[250]
    var
        GenJnlTemplate: Record "Gen. Journal Template";
    begin
        if not CurrPage.LookupMode then
          if GetFilter("Journal Template Name") <> '' then
            if GetRangeMin("Journal Template Name") = GetRangemax("Journal Template Name") then
              if GenJnlTemplate.Get(GetRangeMin("Journal Template Name")) then
                exit(GenJnlTemplate.Name + ' ' + GenJnlTemplate.Description);
    end;

    local procedure ShowAllowPaymentExportForPaymentTemplate()
    var
        GenJournalTemplate: Record "Gen. Journal Template";
    begin
        if GenJournalTemplate.Get("Journal Template Name") then
          IsPaymentTemplate := GenJournalTemplate.Type = GenJournalTemplate.Type::Payments;
    end;
}

