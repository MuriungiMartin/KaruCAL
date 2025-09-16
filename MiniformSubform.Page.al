#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7701 "Miniform Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Miniform Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Area";Area)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a specification of the area on the handheld display in which to show the data on this line.';
                }
                field("Field Type";"Field Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of data that is defined in the miniform line.';
                }
                field("Table No.";"Table No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the table in the program from which the data comes or in which it is entered.';
                }
                field("Field No.";"Field No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the field from which the data comes or in which the data is entered.';
                }
                field("Field Length";"Field Length")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'This field is used internally.';
                }
                field(Text;Text)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies text if the field type is Text.';
                }
                field("Call Miniform";"Call Miniform")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which miniform will be called when the user on the handheld selects the choice on the line.';
                }
            }
        }
    }

    actions
    {
    }
}

