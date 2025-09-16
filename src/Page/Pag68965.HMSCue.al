#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68965 "HMS-Cue"
{
    PageType = CardPart;
    SourceTable = UnknownTable61760;

    layout
    {
        area(content)
        {
            cuegroup("Registration Statistics")
            {
                Caption = 'Registration Statistics';
                field(Students;Students)
                {
                    ApplicationArea = Basic;
                    Caption = 'Students';
                    DrillDownPageID = "HMS-Patient Student List";
                }
                field(Employees;Employees)
                {
                    ApplicationArea = Basic;
                    Caption = 'Employees';
                    DrillDownPageID = "HMS-Patient Employee List";
                }
                field(Dependants;Dependants)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dependants';
                    DrillDownPageID = "HMS-Patient Relative List";
                }
                field(InactiveEmp;"Other Patients")
                {
                    ApplicationArea = Basic;
                    Caption = 'Other Patients';
                    DrillDownPageID = "HMS-Patient Others List";
                }
            }
        }
    }

    actions
    {
    }
}

