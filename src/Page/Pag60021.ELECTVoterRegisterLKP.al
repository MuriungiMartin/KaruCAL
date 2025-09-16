#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 60021 "ELECT-Voter Register LKP"
{
    CardPageID = "ELECT-Voter Register Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable60002;

    layout
    {
        area(content)
        {
            repeater(General)
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
                }
                field("Voter Balance";"Voter Balance")
                {
                    ApplicationArea = Basic;
                }
                field("Voter Verified";"Voter Verified")
                {
                    ApplicationArea = Basic;
                }
                field("Department Code";"Department Code")
                {
                    ApplicationArea = Basic;
                }
                field("Campus Code";"Campus Code")
                {
                    ApplicationArea = Basic;
                }
                field("School Code";"School Code")
                {
                    ApplicationArea = Basic;
                }
                field("Electral District";"Electral District")
                {
                    ApplicationArea = Basic;
                }
                field(Eligible;Eligible)
                {
                    ApplicationArea = Basic;
                }
                field("Polling Center Code";"Polling Center Code")
                {
                    ApplicationArea = Basic;
                }
                field(Voted;Voted)
                {
                    ApplicationArea = Basic;
                }
                field("Ballot ID";"Ballot ID")
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

