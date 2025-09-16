#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68152 "HRM-Employee Cue"
{
    PageType = CardPart;
    SourceTable = UnknownTable61682;

    layout
    {
        area(content)
        {
            cuegroup("HR Employees")
            {
                Caption = 'HR Employees';
                field("Employee-Active";"Employee-Active")
                {
                    ApplicationArea = Basic;
                    Caption = 'Active Employees';
                    DrillDownPageID = "HRM-Employee List";
                }
                field("Employee-Male";"Employee-Male")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employees - Male';
                    DrillDownPageID = "HRM-Employee List";
                }
                field("Employee-Female";"Employee-Female")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employees - Female';
                    DrillDownPageID = "HRM-Employee List";
                }
                field(InactiveEmp;"Employee-InActive")
                {
                    ApplicationArea = Basic;
                    Caption = 'In-Active Employees';
                }
            }
        }
    }

    actions
    {
    }
}

