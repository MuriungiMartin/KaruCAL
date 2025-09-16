#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 60016 "ELECT-Positions LKP"
{
    CardPageID = "ELECT-Positions Card";
    DeleteAllowed = false;
    Editable = false;
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
    }
}

