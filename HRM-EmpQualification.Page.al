#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68377 "HRM-Emp Qualification"
{
    MultipleNewLines = true;
    PageType = Document;
    SaveValues = true;
    SourceTable = UnknownTable61188;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("First Name";"First Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = true;
                }
                field("Middle Name";"Middle Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Last Name";"Last Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = true;
                }
                field(Initials;Initials)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("ID Number";"ID Number")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Department Code";"Department Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Position;Position)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Contract Type";"Contract Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date Of Join";"Date Of Join")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            part(Qualifications;"HRM-Emp. Qualification")
            {
                SubPageLink = "Employee No."=field("No.");
            }
        }
    }

    actions
    {
    }

    var
        KPAObjectives: Record UnknownRecord61293;
        KPACode: Code[20];
        Text19020326: label 'Qualification';
}

