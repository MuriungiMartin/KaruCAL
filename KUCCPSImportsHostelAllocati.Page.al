#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77393 "KUCCPS Imports Hostel Allocati"
{
    PageType = List;
    SourceTable = UnknownTable70082;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Admin;Admin)
                {
                    ApplicationArea = Basic;
                }
                field(Names;Names)
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field(Phone;Phone)
                {
                    ApplicationArea = Basic;
                }
                field(Email;Email)
                {
                    ApplicationArea = Basic;
                }
                field("Assigned Block";"Assigned Block")
                {
                    ApplicationArea = Basic;
                }
                field("Assigned Room";"Assigned Room")
                {
                    ApplicationArea = Basic;
                }
                field("Assigned Space";"Assigned Space")
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

