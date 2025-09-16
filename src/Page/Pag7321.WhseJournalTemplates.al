#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7321 "Whse. Journal Templates"
{
    ApplicationArea = Basic;
    Caption = 'Whse. Journal Templates';
    PageType = List;
    SourceTable = "Warehouse Journal Template";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the warehouse journal template.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the warehouse journal template.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of transaction the warehouse journal template is being used for.';
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series code that the program uses to assign document numbers to the journal lines.';
                }
                field("Registering No. Series";"Registering No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series code used to assign document numbers to the warehouse entries that are registered from this journal.';
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the source code linked to the warehouse journal.';
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the reason code linked to the warehouse journal.';
                }
                field("Page ID";"Page ID")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the number of the window used by the program for this warehouse journal template.';
                    Visible = false;
                }
                field("Page Caption";"Page Caption")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the page identified in the Page ID field.';
                    Visible = false;
                }
                field("Test Report ID";"Test Report ID")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the number of the test report that is printed when you click Registering, Test Report.';
                    Visible = false;
                }
                field("Test Report Caption";"Test Report Caption")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the test report that is printed when you click Registering, Test Report.';
                    Visible = false;
                }
                field("Registering Report ID";"Registering Report ID")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the number of the registering report that is printed when you click Registering, Register and Print.';
                    Visible = false;
                }
                field("Registering Report Caption";"Registering Report Caption")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the report that is printed when you click Registering, Register and Print.';
                    Visible = false;
                }
                field("Force Registering Report";"Force Registering Report")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that a registering report is printed automatically when you register entries from the journal.';
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
                    ApplicationArea = Basic;
                    Caption = 'Batches';
                    Image = Description;
                    RunObject = Page "Whse. Journal Batches";
                    RunPageLink = "Journal Template Name"=field(Name);
                }
            }
        }
    }
}

