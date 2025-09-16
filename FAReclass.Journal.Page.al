#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5636 "FA Reclass. Journal"
{
    ApplicationArea = Basic;
    AutoSplitKey = true;
    Caption = 'FA Reclass. Journal';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "FA Reclass. Journal Line";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName;CurrentJnlBatchName)
            {
                ApplicationArea = FixedAssets;
                Caption = 'Batch Name';
                Lookup = true;
                ToolTip = 'Specifies the name of the journal batch of the fixed asset reclassification journal.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    FAReclassJnlManagement.LookupName(CurrentJnlBatchName,Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    FAReclassJnlManagement.CheckName(CurrentJnlBatchName,Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater(Control1)
            {
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the same date as the FA Posting Date field when the line is posted.';
                    Visible = false;
                }
                field("FA Posting Date";"FA Posting Date")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the date that will be used as the posting date on FA ledger entries.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies a value depending on how you have set up the number series that is assigned to the current journal batch.';
                }
                field("FA No.";"FA No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the number of the fixed asset you want to reclassify from.';

                    trigger OnValidate()
                    begin
                        FAReclassJnlManagement.GetFAS(Rec,FADescription,NewFADescription);
                    end;
                }
                field("New FA No.";"New FA No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the number of the fixed asset you want to reclassify to.';

                    trigger OnValidate()
                    begin
                        FAReclassJnlManagement.GetFAS(Rec,FADescription,NewFADescription);
                    end;
                }
                field("Depreciation Book Code";"Depreciation Book Code")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the code for the depreciation book the line will be posted to.';
                }
                field(Description;Description)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the description of the asset entered in the FA No field. field.';
                }
                field("Reclassify Acq. Cost Amount";"Reclassify Acq. Cost Amount")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the acquisition amount you want to reclassify.';
                    Visible = false;
                }
                field("Reclassify Acq. Cost %";"Reclassify Acq. Cost %")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the percentage of the acquisition cost you want to reclassify.';
                }
                field("Reclassify Acquisition Cost";"Reclassify Acquisition Cost")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the reclassification of the acquisition cost for the fixed asset entered in the FA No. field, to the fixed asset entered in the New FA No. field.';
                }
                field("Reclassify Depreciation";"Reclassify Depreciation")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the reclassification of the accumulated depreciation for the fixed asset entered in the FA No. field, to the fixed asset entered in the New FA No. field.';
                }
                field("Reclassify Write-Down";"Reclassify Write-Down")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the reclassification of all write-down entries for the fixed asset entered in the FA No. field to the fixed asset you have entered in the New FA No. field.';
                    Visible = false;
                }
                field("Reclassify Appreciation";"Reclassify Appreciation")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the reclassification of all appreciation entries for the fixed asset entered in the FA No. field to the fixed asset entered in the New FA No. field.';
                    Visible = false;
                }
                field("Reclassify Custom 1";"Reclassify Custom 1")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the reclassification of all custom 1 entries for the fixed asset entered in the FA No. field to the fixed asset entered in the New FA No. field.';
                    Visible = false;
                }
                field("Reclassify Custom 2";"Reclassify Custom 2")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the reclassification of all custom 2 entries for the fixed asset entered in the FA No. field to the fixed asset entered in the New FA No. field.';
                    Visible = false;
                }
                field("Reclassify Salvage Value";"Reclassify Salvage Value")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the salvage value for the fixed asset to be reclassified to the fixed asset entered in the New FA No. field.';
                    Visible = false;
                }
                field("Insert Bal. Account";"Insert Bal. Account")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies whether to create one or more balancing entry lines in the FA general ledger journal or FA Journal.';
                }
                field("Calc. DB1 Depr. Amount";"Calc. DB1 Depr. Amount")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies that the Reclassify function fills in the Temp. Ending Date and Temp. Fixed Depr. Amount fields on the FA depreciation book.';
                    Visible = false;
                }
            }
            group(Control33)
            {
                fixed(Control1902115301)
                {
                    group("FA Description")
                    {
                        Caption = 'FA Description';
                        field(FADescription;FADescription)
                        {
                            ApplicationArea = FixedAssets;
                            Editable = false;
                            ShowCaption = false;
                            ToolTip = 'Specifies a description of the fixed asset.';
                        }
                    }
                    group("New FA Description")
                    {
                        Caption = 'New FA Description';
                        field(NewFADescription;NewFADescription)
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'New FA Description';
                            Editable = false;
                            ToolTip = 'Specifies a description of the fixed asset that is entered in the New FA No. field on the line.';
                        }
                    }
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
            action(Reclassify)
            {
                ApplicationArea = FixedAssets;
                Caption = 'Recl&assify';
                Image = PostOrder;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Reclassify the fixed asset information on the journal lines.';

                trigger OnAction()
                begin
                    Codeunit.Run(Codeunit::"FA Reclass. Jnl.-Transfer",Rec);
                    CurrentJnlBatchName := GetRangemax("Journal Batch Name");
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        FAReclassJnlManagement.GetFAS(Rec,FADescription,NewFADescription);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetUpNewLine(xRec);
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        if IsOpenedFromBatch then begin
          CurrentJnlBatchName := "Journal Batch Name";
          FAReclassJnlManagement.OpenJournal(CurrentJnlBatchName,Rec);
          exit;
        end;
        FAReclassJnlManagement.TemplateSelection(Page::"FA Reclass. Journal",Rec,JnlSelected);
        if not JnlSelected then
          Error('');

        FAReclassJnlManagement.OpenJournal(CurrentJnlBatchName,Rec);
    end;

    var
        FAReclassJnlManagement: Codeunit FAReclassJnlManagement;
        CurrentJnlBatchName: Code[10];
        FADescription: Text[30];
        NewFADescription: Text[30];

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        FAReclassJnlManagement.SetName(CurrentJnlBatchName,Rec);
        CurrPage.Update(false);
    end;
}

