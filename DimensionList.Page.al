#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 548 "Dimension List"
{
    Caption = 'Dimension List';
    Editable = false;
    PageType = List;
    SourceTable = Dimension;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for the dimension.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the dimension code you enter in the Code field.';
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

    trigger OnAfterGetRecord()
    begin
        Name := GetMLName(GlobalLanguage);
    end;
}

