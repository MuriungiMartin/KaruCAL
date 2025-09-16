#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68997 "ACA-Clearance View Card"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
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
                }
                field("Clearance Semester";"Clearance Semester")
                {
                    ApplicationArea = Basic;
                }
                field("Clearance Academic Year";"Clearance Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field("Admission Date";"Admission Date")
                {
                    ApplicationArea = Basic;
                }
                field("Current Programme";"Current Programme")
                {
                    ApplicationArea = Basic;
                }
                field("Intake Code";"Intake Code")
                {
                    ApplicationArea = Basic;
                }
                field("Programme End Date";"Programme End Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Date of Completion';
                }
                field("Clearance Reason";"Clearance Reason")
                {
                    ApplicationArea = Basic;
                }
                field("Clearance Status";"Clearance Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;
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
            }
        }
    }

    actions
    {
    }
}

