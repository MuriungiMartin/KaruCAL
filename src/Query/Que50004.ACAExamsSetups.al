#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 50004 "ACA-Exams Setups"
{

    elements
    {
        dataitem(ExamSetups;UnknownTable61567)
        {
            column(ExamCategory;Category)
            {
            }
            column(ExamCode;"Code")
            {
            }
            column(MaxScore;"Max. Score")
            {
            }
            dataitem(Progs;UnknownTable61511)
            {
                DataItemLink = "Exam Category"=ExamSetups.Category;
                SqlJoinType = InnerJoin;
                DataItemTableFilter = Code=filter(<>"");
                column(ProgCode;"Code")
                {
                }
            }
        }
    }
}

