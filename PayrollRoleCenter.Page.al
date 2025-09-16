#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 36601 "Payroll Role Center"
{
    Caption = 'Home';
    PageType = RoleCenter;

    layout
    {
    }

    actions
    {
        area(reporting)
        {
            action("Change Password")
            {
                ApplicationArea = Basic;
                Caption = 'Change Password';
                Image = ChangeStatus;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Change Password";
            }
            action("Employee - Labels")
            {
                ApplicationArea = Basic;
                Caption = 'Employee - Labels';
                RunObject = Report "Employee - Labels";
            }
            action("Employee - List")
            {
                ApplicationArea = Basic;
                Caption = 'Employee - List';
                RunObject = Report "Employee - List";
            }
            action("Employee - Misc. Article Info.")
            {
                ApplicationArea = Basic;
                Caption = 'Employee - Misc. Article Info.';
                RunObject = Report "Employee - Misc. Article Info.";
            }
            action("Employee - Confidential Info.")
            {
                ApplicationArea = Basic;
                Caption = 'Employee - Confidential Info.';
                RunObject = Report "Employee - Confidential Info.";
            }
            action("Employee - Staff Absences")
            {
                ApplicationArea = Basic;
                Caption = 'Employee - Staff Absences';
                RunObject = Report "Employee - Staff Absences";
            }
            action("Employee - Absences by Causes")
            {
                ApplicationArea = Basic;
                Caption = 'Employee - Absences by Causes';
                RunObject = Report "Employee - Absences by Causes";
            }
            action("Employee - Qualifications")
            {
                ApplicationArea = Basic;
                Caption = 'Employee - Qualifications';
                RunObject = Report "Employee - Qualifications";
            }
            action("Employee - Addresses")
            {
                ApplicationArea = Basic;
                Caption = 'Employee - Addresses';
                RunObject = Report "Employee - Addresses";
            }
            action("Employee - Relatives")
            {
                ApplicationArea = Basic;
                Caption = 'Employee - Relatives';
                RunObject = Report "Employee - Relatives";
            }
            action("Employee - Birthdays")
            {
                ApplicationArea = Basic;
                Caption = 'Employee - Birthdays';
                RunObject = Report "Employee - Birthdays";
            }
            action("Employee - Phone Nos.")
            {
                ApplicationArea = Basic;
                Caption = 'Employee - Phone Nos.';
                RunObject = Report "Employee - Phone Nos.";
            }
            action("Employee - Unions")
            {
                ApplicationArea = Basic;
                Caption = 'Employee - Unions';
                RunObject = Report "Employee - Unions";
            }
            action("Employee - Contracts")
            {
                ApplicationArea = Basic;
                Caption = 'Employee - Contracts';
                RunObject = Report "Employee - Contracts";
            }
            action("Employee - Alt. Addresses")
            {
                ApplicationArea = Basic;
                Caption = 'Employee - Alt. Addresses';
                RunObject = Report "Employee - Alt. Addresses";
            }
        }
        area(embedding)
        {
            action(Employees)
            {
                ApplicationArea = Basic;
                Caption = 'Employees';
                RunObject = Page "Employee List";
            }
            action("Absence Registration")
            {
                ApplicationArea = Basic;
                Caption = 'Absence Registration';
                RunObject = Page "Absence Registration";
            }
        }
        area(sections)
        {
            group("Administration HR")
            {
                Caption = 'Administration HR';
                Image = HumanResources;
                action("Human Resources Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Caption = 'Human Resources Unit of Measure';
                    RunObject = Page "Human Res. Units of Measure";
                }
                action("Vend. Causes of Absence")
                {
                    ApplicationArea = Basic;
                    Caption = 'Vend. Causes of Absence';
                    RunObject = Page "Causes of Absence";
                }
                action("Causes of Inactivity")
                {
                    ApplicationArea = Basic;
                    Caption = 'Causes of Inactivity';
                    RunObject = Page "Causes of Inactivity";
                }
                action("Grounds for Termination")
                {
                    ApplicationArea = Basic;
                    Caption = 'Grounds for Termination';
                    RunObject = Page "Grounds for Termination";
                }
                action(Unions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Unions';
                    RunObject = Page Unions;
                }
                action("Employment Contracts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employment Contracts';
                    RunObject = Page "Employment Contracts";
                }
                action(Relatives)
                {
                    ApplicationArea = Basic;
                    Caption = 'Relatives';
                    Image = Relatives;
                    RunObject = Page Relatives;
                }
                action("Misc. Articles")
                {
                    ApplicationArea = Basic;
                    Caption = 'Misc. Articles';
                    RunObject = Page "Misc. Articles";
                }
                action(Confidential)
                {
                    ApplicationArea = Basic;
                    Caption = 'Confidential';
                    RunObject = Page Confidential;
                }
                action(Qualifications)
                {
                    ApplicationArea = Basic;
                    Caption = 'Qualifications';
                    Image = Certificate;
                    RunObject = Page Qualifications;
                }
                action("Employee Statistics Groups")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Statistics Groups';
                    RunObject = Page "Employee Statistics Groups";
                }
                action("IRS 1099 Form-Box")
                {
                    ApplicationArea = Basic;
                    Caption = 'IRS 1099 Form-Box';
                    RunObject = Page "IRS 1099 Form-Box";
                }
            }
        }
    }
}

