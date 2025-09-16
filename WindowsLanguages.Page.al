#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 535 "Windows Languages"
{
    Caption = 'Available Languages';
    Editable = false;
    PageType = List;
    SourceTable = "Windows Language";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Language ID";"Language ID")
                {
                    ApplicationArea = All;
                    Caption = 'ID';
                    ToolTip = 'Specifies the unique language ID for the Windows language.';
                    Visible = false;
                }
                field(Name;Name)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                    ToolTip = 'Specifies the names of the available Windows languages.';
                }
            }
        }
    }

    actions
    {
    }
}

