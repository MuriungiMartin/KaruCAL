#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 60013 "ELECT-Candidates Card"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = UnknownTable60006;

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Candidate No.";"Candidate No.")
                {
                    ApplicationArea = Basic;
                }
                field("Candidate Names";"Candidate Names")
                {
                    ApplicationArea = Basic;
                }
                field("Photo/Potrait";"Photo/Potrait")
                {
                    ApplicationArea = Basic;
                }
                field("Position Code";"Position Code")
                {
                    ApplicationArea = Basic;
                }
                field("Votes Count";"Votes Count")
                {
                    ApplicationArea = Basic;
                }
                field("Electral District Code";"Electral District Code")
                {
                    ApplicationArea = Basic;
                }
                field("Department Code";"Department Code")
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
                field("Campaign Slogan";"Campaign Slogan")
                {
                    ApplicationArea = Basic;
                }
                field("Campaign Statement";"Campaign Statement")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    var
        X: Integer;
}

