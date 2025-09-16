#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9806 "Fields Lookup"
{
    Caption = 'Fields Lookup';
    Editable = false;
    PageType = List;
    SourceTable = "Field";

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'No.';
                }
                field(FieldName;FieldName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Field Name';
                }
                field("Field Caption";"Field Caption")
                {
                    ApplicationArea = Basic;
                    Caption = 'Field Caption';
                }
            }
        }
    }

    actions
    {
    }
}

