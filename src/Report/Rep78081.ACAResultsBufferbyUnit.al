#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78081 "ACA-Results Buffer by Unit"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ACA-Results Buffer by Unit.rdlc';

    dataset
    {
        dataitem(ResultsBufferMarks;UnknownTable78054)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(AcadYear;ResultsBufferMarks."Academic Year")
            {
            }
            column(Semsz;ResultsBufferMarks.Semester)
            {
            }
            column(Programsz;ResultsBufferMarks.Programme)
            {
            }
            column(UnitCode;ResultsBufferMarks."Unit Code")
            {
            }
            column(Lecturersz;ResultsBufferMarks.Lecturer)
            {
            }
            column(StudentNo;ResultsBufferMarks."Student No.")
            {
            }
            column(StudentName;ResultsBufferMarks."Student Name")
            {
            }
            column(ExamScore;ResultsBufferMarks."Exam Score")
            {
            }
            column(CATScore;ResultsBufferMarks."CAT Score")
            {
            }
            column(TotalScore;ResultsBufferMarks."Total Score")
            {
            }
            column(FeeBalance;ResultsBufferMarks."Fee Balance")
            {
            }
            column(CurrentBilling;ResultsBufferMarks."Current Semester Billing")
            {
            }
            column(DepartmentCode;ResultsBufferMarks."Department Code")
            {
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

    labels
    {
    }

    var
        CompanyInformation: Record "Company Information";
}

