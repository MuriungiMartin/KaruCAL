#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51023 "Student's Statement"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Student's Statement.rdlc';
    EnableHyperlinks = false;

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = where("Customer Posting Group"=const('STUDENT'),"Customer Type"=const(Student),"Current Semester"=filter(<>''));
            RequestFilterFields = "Current Semester","In Current Sem","Date Filter";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(No;Customer."No.")
            {
            }
            column(Name;Customer.Name)
            {
            }
            column(DebitAmount;Customer."Debit Amount")
            {
            }
            column(CreditAmount;Customer."Credit Amount")
            {
            }
            column(Balance;Customer.Balance)
            {
            }
            column(Number;Number)
            {
            }
            column(ClassCode;Customer."Class Code")
            {
            }
            column(CourseDet;Customer."Course Details")
            {
            }

            trigger OnAfterGetRecord()
            begin
                Number:=Number+1;
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
        Number: Integer;
}

