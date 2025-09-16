#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9611 "XML Schema Restrictions Part"
{
    Caption = 'XML Schema Restrictions Part';
    Editable = false;
    PageType = ListPart;
    SourceTable = "XML Schema Restriction";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Value;Value)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the value of the imported record.';
                }
            }
        }
    }

    actions
    {
    }
}

