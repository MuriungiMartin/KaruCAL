#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77310 "HRM-Clearance View Card"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Card;
    SourceTable = UnknownTable61188;

    layout
    {
        area(content)
        {
            group("Student Clearance Details")
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field(names;Rec."First Name"+' '+Rec."Middle Name"+' '+Rec."Last Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Names';
                }
                field(Phones;"Work Phone Number"+'/'+"Cellular Phone Number")
                {
                    ApplicationArea = Basic;
                    Caption = 'Phones';
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Department Code";"Department Code")
                {
                    ApplicationArea = Basic;
                }
                field("Contract End Date";"Contract End Date")
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
            }
        }
    }

    actions
    {
    }
}

