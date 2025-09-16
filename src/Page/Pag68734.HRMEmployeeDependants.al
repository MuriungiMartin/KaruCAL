#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68734 "HRM-Employee Dependants"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SaveValues = true;
    SourceTable = UnknownTable61188;

    layout
    {
        area(content)
        {
            group("Employee Details")
            {
                Caption = 'Employee Details';
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                    Importance = Promoted;
                    StyleExpr = true;
                }
                field(FullName;FullName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Name';
                    Editable = false;
                    Enabled = false;
                    Importance = Promoted;
                    StyleExpr = true;
                }
                field("Postal Address";"Postal Address")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                    StyleExpr = true;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                    StyleExpr = true;
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                    StyleExpr = true;
                    Visible = false;
                }
                field("Cellular Phone Number";"Cellular Phone Number")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                    StyleExpr = true;
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                    Importance = Promoted;
                    StyleExpr = true;
                }
            }
            part(Control1102755008;"HRM-Employees Dependants")
            {
                SubPageLink = "Employee Code"=field("No."),
                              Type=const(Dependant);
            }
        }
        area(factboxes)
        {
            systempart(Control1102755004;"HRM-Employee Kin SF")
            {
                SubPageLink = "Employee Code"=field("No.");
            }
            systempart(Control1102755002;Outlook)
            {
            }
        }
    }

    actions
    {
    }

    var
        D: Date;
        EmpNames: Text[30];
        HREmp: Record UnknownRecord61067;
        Text19032351: label 'Next Of Kin/Beneficiaries';
}

