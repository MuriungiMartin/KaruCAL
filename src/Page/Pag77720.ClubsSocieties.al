#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77720 "Clubs & Societies"
{
    PageType = List;
    SourceTable = UnknownTable77715;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Club/Society Code";"Club/Society Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Patron Id";"Patron Id")
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

