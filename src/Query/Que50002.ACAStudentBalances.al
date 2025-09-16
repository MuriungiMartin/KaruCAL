#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 50002 "ACA-Student Balances"
{

    elements
    {
        dataitem(Customer;Customer)
        {
            DataItemTableFilter = "Customer Posting Group"=filter('STUDENT');
            column(StudentNo;"No.")
            {
            }
            column(Name;Name)
            {
            }
            column(Address;Address)
            {
            }
            column(Address2;"Address 2")
            {
            }
            column(Phone;"Phone No.")
            {
            }
            column(Debit;"Debit Amount")
            {
            }
            column(Credit;"Credit Amount")
            {
            }
            column(Balance;Balance)
            {
            }
            column(Email;"E-Mail")
            {
            }
            column(Gender;Gender)
            {
            }
            column(Settlement;"Settlement Type")
            {
            }
            column(Intake;"Intake Code")
            {
            }
            column(Programme;"Current Programme")
            {
            }
            dataitem(UnknownTable61532;UnknownTable61532)
            {
                DataItemLink = "Student No."=Customer."No.";
                SqlJoinType = InnerJoin;
                DataItemTableFilter = Reversed=filter(No);
                Description = 'CourseReg';
                column(Semester;Semester)
                {
                }
            }
        }
    }
}

