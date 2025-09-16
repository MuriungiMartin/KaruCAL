#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9839 "Printer Selections FactBox"
{
    Caption = 'Printer Selections FactBox';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Printer Selection";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user for whom you want to define permissions.';
                    Visible = false;
                }
                field("Report ID";"Report ID")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the report that will be linked to a particular user and/or printer.';
                }
                field("Report Caption";"Report Caption")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the report.';
                }
                field("Printer Name";"Printer Name")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Printers;
                    ToolTip = 'Specifies the printer that the user will be allowed to use or on which the report will be printed.';
                }
            }
        }
    }

    actions
    {
    }
}

