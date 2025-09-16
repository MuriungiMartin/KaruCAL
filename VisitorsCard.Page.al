#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50051 "Visitors Card"
{
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Card;
    SourceTable = "Automated Notification Setup";

    layout
    {
        area(content)
        {
            group(Group)
            {
                field(Picture;Picture)
                {
                    ApplicationArea = Basic;
                }
                field("ID No.";"ID No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Full Names";"Full Names")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Email;Email)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Company Name";"Company Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(County;County)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Reg. Date";"Reg. Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Reg. Time";"Reg. Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Registered By";"Registered By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("No. of Visits";"No. of Visits")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date Filter";"Date Filter")
                {
                    ApplicationArea = Basic;
                }
                field("Time Filter";"Time Filter")
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

