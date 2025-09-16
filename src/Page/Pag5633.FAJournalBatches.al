#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5633 "FA Journal Batches"
{
    Caption = 'FA Journal Batches';
    DataCaptionExpression = DataCaption;
    Editable = true;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "FA Journal Batch";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the name of the journal batch you are creating.';
                }
                field(Description;Description)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the journal batch that you are creating.';
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the code for the number series that will assign document numbers to journal lines in this journal batch.';
                }
                field("Posting No. Series";"Posting No. Series")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the code for the number series that will assign document numbers to ledger entries that are posted from this journal batch.';
                    Visible = true;
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the reason code linked to the journal batch.';
                    Visible = true;
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
            action("Edit Journal")
            {
                ApplicationArea = FixedAssets;
                Caption = 'Edit Journal';
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Return';
                ToolTip = 'Open the related journal in edit mode.';

                trigger OnAction()
                begin
                    FAJnlMgt.TemplateSelectionFromBatch(Rec);
                end;
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action("Test Report")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';

                    trigger OnAction()
                    begin
                        ReportPrint.PrintFAJnlBatch(Rec);
                    end;
                }
                action("P&ost")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "FA. Jnl.-B.Post";
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';
                }
                action("Post and &Print")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "FA. Jnl.-B.Post+Print";
                    ShortCutKey = 'Shift+F9';
                    ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';
                }
            }
        }
    }

    trigger OnInit()
    begin
        SetRange("Journal Template Name");
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetupNewBatch;
    end;

    trigger OnOpenPage()
    begin
        FAJnlMgt.OpenJnlBatch(Rec);
    end;

    var
        ReportPrint: Codeunit "Test Report-Print";
        FAJnlMgt: Codeunit FAJnlManagement;

    local procedure DataCaption(): Text[250]
    var
        FAJnlTemplate: Record "FA Journal Template";
    begin
        if not CurrPage.LookupMode then
          if GetFilter("Journal Template Name") <> '' then
            if GetRangeMin("Journal Template Name") = GetRangemax("Journal Template Name") then
              if FAJnlTemplate.Get(GetRangeMin("Journal Template Name")) then
                exit(FAJnlTemplate.Name + ' ' + FAJnlTemplate.Description);
    end;
}

