#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68376 "HRM-Confidential Info."
{
    PageType = Document;
    SourceTable = UnknownTable61188;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = false;
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field("First Name";"First Name")
                {
                    ApplicationArea = Basic;
                }
                field("Middle Name";"Middle Name")
                {
                    ApplicationArea = Basic;
                }
                field("Last Name";"Last Name")
                {
                    ApplicationArea = Basic;
                }
                field(Initials;Initials)
                {
                    ApplicationArea = Basic;
                }
                field("ID Number";"ID Number")
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Department Code";"Department Code")
                {
                    ApplicationArea = Basic;
                }
                field(Position;Position)
                {
                    ApplicationArea = Basic;
                }
                field("Contract Type";"Contract Type")
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Join";"Date Of Join")
                {
                    ApplicationArea = Basic;
                }
            }
            part(KPA;"HRM-Emp Confidential Inf.")
            {
                SubPageLink = "Employee No."=field("No.");
            }
            label(Control1000000030)
            {
                ApplicationArea = Basic;
                CaptionClass = Text19056241;
                Style = Standard;
                StyleExpr = true;
            }
        }
    }

    actions
    {
    }

    var
        KPAObjectives: Record UnknownRecord61293;
        KPACode: Code[20];
        Text19056241: label 'Confidential Information';
}

