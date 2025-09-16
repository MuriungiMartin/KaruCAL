#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7702 "Fields"
{
    Caption = 'Fields';
    Editable = false;
    PageType = List;
    SourceTable = "Field";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(TableNo;TableNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'TableNo';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'No.';
                }
                field(TableName;TableName)
                {
                    ApplicationArea = Basic;
                    Caption = 'TableName';
                }
                field(FieldName;FieldName)
                {
                    ApplicationArea = Basic;
                    Caption = 'FieldName';
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    Caption = 'Type';
                }
                field(Class;Class)
                {
                    ApplicationArea = Basic;
                    Caption = 'Class';
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

