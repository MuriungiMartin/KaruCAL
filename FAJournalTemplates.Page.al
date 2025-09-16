#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5630 "FA Journal Templates"
{
    ApplicationArea = Basic;
    Caption = 'FA Journal Templates';
    PageType = List;
    SourceTable = "FA Journal Template";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the name of the journal template you are creating.';
                }
                field(Description;Description)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the journal template you are creating.';
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the code for the number series used to assign document numbers to journal lines in this FA journal template.';
                }
                field("Posting No. Series";"Posting No. Series")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the code for the number series used to assign document numbers to ledger entries posted from journals.';
                }
                field(Recurring;Recurring)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies whether the journal template will be a recurring journal.';
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the source code linked to the journal template.';

                    trigger OnValidate()
                    begin
                        SourceCodeOnAfterValidate;
                    end;
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the reason code linked to the journal template.';
                }
                field("Page ID";"Page ID")
                {
                    ApplicationArea = FixedAssets;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the ID of the window for batches under this journal template.';
                    Visible = false;
                }
                field("Page Caption";"Page Caption")
                {
                    ApplicationArea = FixedAssets;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the window that is specified in the Page ID field.';
                    Visible = false;
                }
                field("Test Report ID";"Test Report ID")
                {
                    ApplicationArea = FixedAssets;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the report that will be printed if you choose to print a test report from a journal batch.';
                    Visible = false;
                }
                field("Test Report Caption";"Test Report Caption")
                {
                    ApplicationArea = FixedAssets;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the report that is specified in the Test Report ID field.';
                    Visible = false;
                }
                field("Posting Report ID";"Posting Report ID")
                {
                    ApplicationArea = FixedAssets;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the report that is printed when you click Post and Print from a journal batch.';
                    Visible = false;
                }
                field("Posting Report Caption";"Posting Report Caption")
                {
                    ApplicationArea = FixedAssets;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the report that is specified in the Posting Report ID field.';
                    Visible = false;
                }
                field("Maint. Posting Report ID";"Maint. Posting Report ID")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the report that is printed when you post a journal line, where the FA Posting Type field = Maintenance, by clicking Post and Print.';
                    Visible = false;
                }
                field("Maint. Posting Report Caption";"Maint. Posting Report Caption")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the name of the report that is specified in the Maint. Posting Report ID field.';
                    Visible = false;
                }
                field("Force Posting Report";"Force Posting Report")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies whether a report is printed automatically when you post.';
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
        area(navigation)
        {
            group("Te&mplate")
            {
                Caption = 'Te&mplate';
                Image = Template;
                action(Batches)
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Batches';
                    Image = Description;
                    RunObject = Page "FA Journal Batches";
                    RunPageLink = "Journal Template Name"=field(Name);
                    ToolTip = 'View the related journal batches.';
                }
            }
        }
    }

    local procedure SourceCodeOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;
}

