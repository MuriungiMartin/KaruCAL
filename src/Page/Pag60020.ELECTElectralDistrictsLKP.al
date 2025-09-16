#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 60020 "ELECT-Electral Districts LKP"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable60004;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Electral District Doce";"Electral District Doce")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("No. of Registered Voters";"No. of Registered Voters")
                {
                    ApplicationArea = Basic;
                }
                field("No. of Votes Cast";"No. of Votes Cast")
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

