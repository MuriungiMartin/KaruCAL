#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 60005 "ELECT-Cand. Applications Card"
{
    PageType = Card;
    SourceTable = UnknownTable60005;

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Election Code";"Election Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Electraol District Code";"Electraol District Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Position Category";"Position Category")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Position Code";"Position Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Candidate No.";"Candidate No.")
                {
                    ApplicationArea = Basic;
                }
                field("Candidate Names";"Candidate Names")
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
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
            }
        }
    }

    actions
    {
    }
}

