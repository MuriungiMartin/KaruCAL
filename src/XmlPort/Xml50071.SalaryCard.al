#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50071 "Salary Card"
{
    Format = VariableText;

    schema
    {
        textelement(Roots)
        {
            tableelement(UnknownTable61091;UnknownTable61091)
            {
                XmlName = 'SalaryCard';
                SourceTableView = where(Field9=filter("08/01/23"),Field7=const(8),Field8=const(2023));
                fieldelement(a1;"PRL-Employee Transactions"."Employee Code")
                {
                }
                fieldelement(a2;"PRL-Employee Transactions"."Transaction Code")
                {
                }
                fieldelement(a3;"PRL-Employee Transactions".Amount)
                {
                }
                fieldelement(a4;"PRL-Employee Transactions"."Period Month")
                {
                }
                fieldelement(a5;"PRL-Employee Transactions"."Period Year")
                {
                }
                fieldelement(a6;"PRL-Employee Transactions"."Payroll Period")
                {
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }
}

