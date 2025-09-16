#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 60008 "ELECT-Polling Centers List"
{
    PageType = List;
    SourceTable = UnknownTable60008;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Polling Center Code";"Polling Center Code")
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
                field("Returning Officer ID";"Returning Officer ID")
                {
                    ApplicationArea = Basic;
                }
                field("Returning Officer Name";"Returning Officer Name")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Booths)
            {
                ApplicationArea = Basic;
                Caption = 'Booths';
                Image = ExecuteBatch;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "ELECT-Polling Booths List";
                RunPageLink = "Election Code"=field("Election Code"),
                              "Polling Center Code"=field("Polling Center Code"),
                              "Electral District"=field("Electral District");
            }
            action(Agents)
            {
                ApplicationArea = Basic;
                Caption = 'Poll Agents';
                Image = AddWatch;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "ELECTPoll Agents List";
                RunPageLink = "Election Code"=field("Election Code"),
                              "Electral District"=field("Electral District"),
                              "Polling Center"=field("Polling Center Code");
            }
        }
    }
}

