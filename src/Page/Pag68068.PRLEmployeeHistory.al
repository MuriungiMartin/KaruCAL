#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68068 "PRL-Employee History"
{
    PageType = List;
    SourceTable = UnknownTable61093;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field("Employee Code";"Employee Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Basic Pay";"Basic Pay")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Gross Pay";"Gross Pay")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Net Pay";"Net Pay")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Allowances;Allowances)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Deductions;Deductions)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(PAYE;PAYE)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(NSSF;NSSF)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(NHIF;NHIF)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Payroll Period";"Payroll Period")
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

