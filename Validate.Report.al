#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51034 Validate
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Validate.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(no;Customer."No.")
            {
            }
            column(name;Customer.Name)
            {
            }
            column(Gender;Customer.Gender)
            {
            }
            column(Dept;Customer."Global Dimension 2 Code")
            {
            }

            trigger OnAfterGetRecord()
            begin
                     if Gender>1 then begin
                     Gender:=Gender-1;
                     Modify;
                     end;
            end;
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

    labels
    {
    }

    var
        unitofNeasure: Record "Item Unit of Measure";
}

