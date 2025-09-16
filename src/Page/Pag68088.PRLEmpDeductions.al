#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68088 "PRL-Emp. Deductions"
{
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable61094;

    layout
    {
        area(content)
        {
            repeater(Control1102756000)
            {
                field("Employee Code";"Employee Code")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Code";"Transaction Code")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Period Month";"Period Month")
                {
                    ApplicationArea = Basic;
                }
                field("Period Year";"Period Year")
                {
                    ApplicationArea = Basic;
                }
                field("Payroll Period";"Payroll Period")
                {
                    ApplicationArea = Basic;
                }
                field("Payroll Code";"Payroll Code")
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

