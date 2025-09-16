#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9825 "Plans FactBox"
{
    Caption = 'Plans FactBox';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    ShowFilter = false;
    SourceTable = Plan;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the record.';
                }
            }
        }
    }

    actions
    {
    }
}

