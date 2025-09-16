#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 90022 "FIN-Salary Grades"
{
    PageType = List;
    SourceTable = UnknownTable61790;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee Category";"Employee Category")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Salary Grade code";"Salary Grade code")
                {
                    ApplicationArea = Basic;
                }
                field("Grade Description";"Grade Description")
                {
                    ApplicationArea = Basic;
                }
                field("Grade Level";"Grade Level")
                {
                    ApplicationArea = Basic;
                }
                field("House Allowance";"House Allowance")
                {
                    ApplicationArea = Basic;
                }
                field("Leave Allowance";"Leave Allowance")
                {
                    ApplicationArea = Basic;
                }
                field("In-Patient Medical Ceilling";"In-Patient Medical Ceilling")
                {
                    ApplicationArea = Basic;
                }
                field("Out-Patient Medical Ceilling";"Out-Patient Medical Ceilling")
                {
                    ApplicationArea = Basic;
                }
                field("Optical/Dental Ceiling";"Optical/Dental Ceiling")
                {
                    ApplicationArea = Basic;
                }
                field("Annual Leave Days";"Annual Leave Days")
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

