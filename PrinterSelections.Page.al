#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 64 "Printer Selections"
{
    ApplicationArea = Basic;
    Caption = 'Printer Selections';
    PageType = List;
    SourceTable = "Printer Selection";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the ID of the user for whom you want to define permissions.';
                }
                field("Report ID";"Report ID")
                {
                    ApplicationArea = Basic,Suite;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the report that will be linked to a particular user and/or printer.';
                }
                field("Report Caption";"Report Caption")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the report.';
                }
                field("Printer Name";"Printer Name")
                {
                    ApplicationArea = Basic,Suite;
                    LookupPageID = Printers;
                    ToolTip = 'Specifies the printer that the user will be allowed to use or on which the report will be printed.';
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
    }
}

