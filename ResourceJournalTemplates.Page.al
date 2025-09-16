#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 206 "Resource Journal Templates"
{
    ApplicationArea = Basic;
    Caption = 'Resource Journal Templates';
    PageType = List;
    SourceTable = "Res. Journal Template";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the name of this journal.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a description of the template for easy identification.';
                }
                field(Recurring;Recurring)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies if this journal will contain recurring entries.';
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number series code used to assign document numbers to journal lines in this resource journal template.';
                }
                field("Posting No. Series";"Posting No. Series")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number series code used to assign document numbers to ledger entries that are posted from journals using this template.';
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the source code that is linked to the journal template.';
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a reason code that is inserted on the journal lines.';
                }
                field("Page ID";"Page ID")
                {
                    ApplicationArea = Jobs;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the number of the page that you want to be displayed when the user selects this journal.';
                    Visible = false;
                }
                field("Page Caption";"Page Caption")
                {
                    ApplicationArea = Jobs;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the page you selected in the Page ID field.';
                    Visible = false;
                }
                field("Test Report ID";"Test Report ID")
                {
                    ApplicationArea = Jobs;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the test report that is printed when, on the Actions tab in the Posting group, you choose Test Report.';
                    Visible = false;
                }
                field("Test Report Caption";"Test Report Caption")
                {
                    ApplicationArea = Jobs;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the test report that you selected in the Test Report ID field.';
                    Visible = false;
                }
                field("Posting Report ID";"Posting Report ID")
                {
                    ApplicationArea = Jobs;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the posting report that you want associated with this journal.';
                    Visible = false;
                }
                field("Posting Report Caption";"Posting Report Caption")
                {
                    ApplicationArea = Jobs;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the posting report you selected in the Posting Report ID field.';
                    Visible = false;
                }
                field("Force Posting Report";"Force Posting Report")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies that an updated posting report is printed each time entries in this journal are posted.';
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
                    ApplicationArea = Jobs;
                    Caption = 'Batches';
                    Image = Description;
                    RunObject = Page "Resource Jnl. Batches";
                    RunPageLink = "Journal Template Name"=field(Name);
                    ToolTip = 'Set up multiple resource journals for a specific template. You can use batches when you need multiple journals of a certain type.';
                }
            }
        }
    }
}

