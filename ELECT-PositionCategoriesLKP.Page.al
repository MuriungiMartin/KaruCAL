#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 60019 "ELECT-Position Categories LKP"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable60003;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Category Code";"Category Code")
                {
                    ApplicationArea = Basic;
                }
                field("Category Description";"Category Description")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

