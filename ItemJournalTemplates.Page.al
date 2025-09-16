#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 102 "Item Journal Templates"
{
    ApplicationArea = Basic;
    Caption = 'Item Journal Templates';
    PageType = List;
    SourceTable = "Item Journal Template";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the item journal you are creating.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a brief description of the item journal template you are creating.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of transaction that will be used with this item journal template.';
                }
                field(Recurring;Recurring)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies whether the item journal template will be a recurring journal.';
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number series code used to assign document numbers to journal lines in this item journal template.';
                }
                field("Posting No. Series";"Posting No. Series")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number series code used to assign document numbers to ledger entries that are posted from journals using this template.';
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the source code that is linked to the item journal template.';
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a reason code that will be inserted on the journal lines.';
                }
                field("Page ID";"Page ID")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the window number for the item journal.';
                    Visible = false;
                }
                field("Page Caption";"Page Caption")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the item journal template''s window.';
                    Visible = false;
                }
                field("Test Report ID";"Test Report ID")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the test report that is printed when you click Actions, point to Posting, and then click Test Report.';
                    Visible = false;
                }
                field("Test Report Caption";"Test Report Caption")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the test report that is printed when you print the item journal.';
                    Visible = false;
                }
                field("Posting Report ID";"Posting Report ID")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the posting report that is printed when you click Post and Print.';
                    Visible = false;
                }
                field("Posting Report Caption";"Posting Report Caption")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the report that is printed when you print the item journal.';
                    Visible = false;
                }
                field("Whse. Register Report ID";"Whse. Register Report ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID assigned to the Whse. Register Report.';
                    Visible = false;
                }
                field("Whse. Register Report Caption";"Whse. Register Report Caption")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the report that is printed when you print the item journal.';
                    Visible = false;
                }
                field("Force Posting Report";"Force Posting Report")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether a report is printed automatically when you post from the journal template.';
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
                    ApplicationArea = Basic,Suite;
                    Caption = 'Batches';
                    Image = Description;
                    RunObject = Page "Item Journal Batches";
                    RunPageLink = "Journal Template Name"=field(Name);
                    ToolTip = 'Set up multiple item journals for a specific template. You can use batches when you need multiple journals of a certain type.';
                }
            }
        }
    }
}

