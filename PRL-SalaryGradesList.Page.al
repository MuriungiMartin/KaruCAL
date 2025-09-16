#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68082 "PRL-Salary Grades List"
{
    Editable = true;
    PageType = Card;
    SourceTable = UnknownTable61120;

    layout
    {
        area(content)
        {
            repeater(Control1102756000)
            {
                field("Salary Grade";"Salary Grade")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Salary Amount";"Salary Amount")
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
                field(Ceiling_salary;Ceiling_salary)
                {
                    ApplicationArea = Basic;
                }
                field(Basic_salary;Basic_salary)
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

