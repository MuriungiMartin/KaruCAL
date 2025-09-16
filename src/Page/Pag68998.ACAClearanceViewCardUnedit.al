#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68998 "ACA-Clearance View Card Unedit"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            group("Student Clearance Details")
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Balance (LCY)";"Balance (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("ID No";"ID No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Clearance Status";"Clearance Status")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Clearance Initiated by";"Clearance Initiated by")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Clearance Initiated Date";"Clearance Initiated Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Clearance Initiated Time";"Clearance Initiated Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Current Programme";"Current Programme")
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

