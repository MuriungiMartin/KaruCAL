#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 60002 "ELECT-Voter Register Card"
{
    PageType = Card;
    SourceTable = UnknownTable60002;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Voter Type";"Voter Type")
                {
                    ApplicationArea = Basic;
                }
                field("Voter No.";"Voter No.")
                {
                    ApplicationArea = Basic;
                }
                field("Voter Names";"Voter Names")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Voter Balance";"Voter Balance")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Electral District";"Electral District")
                {
                    ApplicationArea = Basic;
                }
                field("Polling Center Code";"Polling Center Code")
                {
                    ApplicationArea = Basic;
                }
                field("Voter Verified";"Voter Verified")
                {
                    ApplicationArea = Basic;
                }
                field("Manual Eligibility to Contest";"Manual Eligibility to Contest")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cleared to Vie';
                }
                field("Department Code";"Department Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Campus Code";"Campus Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("School Code";"School Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(Eligible;Eligible)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Ballot ID";"Ballot ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(Voted;Voted)
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

