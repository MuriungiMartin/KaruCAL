#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 50001 "ACA Load Student Units"
{

    elements
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableFilter = Reversed=filter(No);
            column(Student_No;"Student No.")
            {
            }
            column(Semester;Semester)
            {
            }
            column(Programme;Programme)
            {
            }
            column(Stage;Stage)
            {
            }
            dataitem(UnknownTable61549;UnknownTable61549)
            {
                DataItemLink = "Student No."=ACA_Course_Registration."Student No.",Semester=ACA_Course_Registration.Semester,Programme=ACA_Course_Registration.Programme,Stage=ACA_Course_Registration.Stage;
                column(Unit;Unit)
                {
                }
                column(Description;Description)
                {
                }
            }
        }
    }
}

