#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5829 "Inventory Period Entries"
{
    Caption = 'Inventory Period Entries';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Inventory Period Entry";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Entry Type";"Entry Type")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the type for an inventory period entry, such as closed or re-opened.';
                }
                field("Ending Date";"Ending Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the ending date that uniquely identifies an inventory period.';
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the identification code of the user who closed or re-opened the inventory period.';
                }
                field("Creation Date";"Creation Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the date when the inventory period entry was created.';
                }
                field("Creation Time";"Creation Time")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the time when the inventory period entry was created.';
                }
                field("Closing Item Register No.";"Closing Item Register No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of the last item register in a closed inventory period.';
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies a unique entry number for each entry of an inventory period.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies any useful information about the inventory period entry.';
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

