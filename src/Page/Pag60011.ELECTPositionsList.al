#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 60011 "ELECT-Positions List"
{
    CardPageID = "ELECT-Positions Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = UnknownTable60001;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Position Code";"Position Code")
                {
                    ApplicationArea = Basic;
                }
                field("Position Description";"Position Description")
                {
                    ApplicationArea = Basic;
                }
                field("Position Notes";"Position Notes")
                {
                    ApplicationArea = Basic;
                }
                field("isDelegate?";"isDelegate?")
                {
                    ApplicationArea = Basic;
                }
                field("Electral District";"Electral District")
                {
                    ApplicationArea = Basic;
                }
                field("Department Code";"Department Code")
                {
                    ApplicationArea = Basic;
                }
                field("No. Of Candidates";"No. Of Candidates")
                {
                    ApplicationArea = Basic;
                }
                field("Position Approved";"Position Approved")
                {
                    ApplicationArea = Basic;
                }
                field("School Code";"School Code")
                {
                    ApplicationArea = Basic;
                }
                field("Campus Code";"Campus Code")
                {
                    ApplicationArea = Basic;
                }
                field("Position Category";"Position Category")
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
            action("Candidature Applications")
            {
                ApplicationArea = Basic;
                Caption = 'Candidature Applications';
                Image = ApplyTemplate;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "ELECT-Cand. Applications List";
                RunPageLink = "Election Code"=field("Election Code"),
                              "Position Code"=field("Position Code"),
                              "Position Category"=field("Position Category");
            }
            action(Candidates)
            {
                ApplicationArea = Basic;
                Caption = 'Candidates';
                Image = Hierarchy;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "ELECT-Candidates List";
                RunPageLink = "Election Code"=field("Election Code"),
                              "Position Code"=field("Position Code"),
                              "Position Category"=field("Position Category");
            }
            action(Ballots)
            {
                ApplicationArea = Basic;
                Caption = 'Ballots';
                Image = RegisterPick;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "ELECT-Ballot Register List";
                RunPageLink = "Election Code"=field("Election Code"),
                              "Position Code"=field("Position Code");
            }
        }
    }
}

