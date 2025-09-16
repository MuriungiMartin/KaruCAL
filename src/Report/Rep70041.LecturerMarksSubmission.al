#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 70041 "Lecturer Marks Submission"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Lecturer Marks Submission.rdlc';

    dataset
    {
        dataitem(UnknownTable65202;UnknownTable65202)
        {
            RequestFilterFields = Programme,Semester,"Campus Code",Lecturer,Unit,"School Code","Department Code";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(Lecturer_ACALecturersUnits;"ACA-Lecturers Units".Lecturer)
            {
            }
            column(Programme_ACALecturersUnits;"ACA-Lecturers Units".Programme)
            {
            }
            column(Stage_ACALecturersUnits;"ACA-Lecturers Units".Stage)
            {
            }
            column(Unit_ACALecturersUnits;"ACA-Lecturers Units".Unit)
            {
            }
            column(Semester_ACALecturersUnits;"ACA-Lecturers Units".Semester)
            {
            }
            column(Remarks_ACALecturersUnits;"ACA-Lecturers Units".Remarks)
            {
            }
            column(NoOfHours_ACALecturersUnits;"ACA-Lecturers Units"."No. Of Hours")
            {
            }
            column(NoOfHoursContracted_ACALecturersUnits;"ACA-Lecturers Units"."No. Of Hours Contracted")
            {
            }
            column(AvailableFrom_ACALecturersUnits;"ACA-Lecturers Units"."Available From")
            {
            }
            column(AvailableTo_ACALecturersUnits;"ACA-Lecturers Units"."Available To")
            {
            }
            column(TimeTableHours_ACALecturersUnits;"ACA-Lecturers Units"."Time Table Hours")
            {
            }
            column(MinimumContracted_ACALecturersUnits;"ACA-Lecturers Units"."Minimum Contracted")
            {
            }
            column(Class_ACALecturersUnits;"ACA-Lecturers Units".Class)
            {
            }
            column(UnitClass_ACALecturersUnits;"ACA-Lecturers Units"."Unit Class")
            {
            }
            column(StudentType_ACALecturersUnits;"ACA-Lecturers Units"."Student Type")
            {
            }
            column(Allocation_ACALecturersUnits;"ACA-Lecturers Units".Allocation)
            {
            }
            column(Description_ACALecturersUnits;"ACA-Lecturers Units".Description)
            {
            }
            column(Rate_ACALecturersUnits;"ACA-Lecturers Units".Rate)
            {
            }
            column(Credithours_ACALecturersUnits;"ACA-Lecturers Units"."Credit hours")
            {
            }
            column(LectHrs_ACALecturersUnits;"ACA-Lecturers Units"."Lect. Hrs")
            {
            }
            column(PractHrs_ACALecturersUnits;"ACA-Lecturers Units"."Pract. Hrs")
            {
            }
            column(TutHrs_ACALecturersUnits;"ACA-Lecturers Units"."Tut. Hrs")
            {
            }
            column(ClassType_ACALecturersUnits;"ACA-Lecturers Units"."Class Type")
            {
            }
            column(UnitStudentsCount_ACALecturersUnits;"ACA-Lecturers Units"."Unit Students Count")
            {
            }
            column(UnitResultsCount_ACALecturersUnits;"ACA-Lecturers Units"."Unit Results Count")
            {
            }
            column(Claimed_ACALecturersUnits;"ACA-Lecturers Units".Claimed)
            {
            }
            column(ClaimedAmount_ACALecturersUnits;"ACA-Lecturers Units"."Claimed Amount")
            {
            }
            column(ClaimedDate_ACALecturersUnits;"ACA-Lecturers Units"."Claimed Date")
            {
            }
            column(CampusCode_ACALecturersUnits;"ACA-Lecturers Units"."Campus Code")
            {
            }
            column(ClassSize_ACALecturersUnits;"ACA-Lecturers Units"."Class Size")
            {
            }
            column(Posted_ACALecturersUnits;"ACA-Lecturers Units".Posted)
            {
            }
            column(PostedBy_ACALecturersUnits;"ACA-Lecturers Units"."Posted By")
            {
            }
            column(PostedOn_ACALecturersUnits;"ACA-Lecturers Units"."Posted On")
            {
            }
            column(Amount_ACALecturersUnits;"ACA-Lecturers Units".Amount)
            {
            }
            column(Approved_ACALecturersUnits;"ACA-Lecturers Units".Approved)
            {
            }
            column(CATsSubmitted_ACALecturersUnits;"ACA-Lecturers Units"."CATs Submitted")
            {
            }
            column(ExamsSubmitted_ACALecturersUnits;"ACA-Lecturers Units"."Exams Submitted")
            {
            }
            column(EngagementTerms_ACALecturersUnits;"ACA-Lecturers Units"."Engagement Terms")
            {
            }
            column(UnitCost_ACALecturersUnits;"ACA-Lecturers Units"."Unit Cost")
            {
            }
            column(MarksSubmitted_ACALecturersUnits;"ACA-Lecturers Units"."Marks Submitted")
            {
            }
            column(RegisteredStudents_ACALecturersUnits;"ACA-Lecturers Units"."Registered Students")
            {
            }
            column(Claimtopay_ACALecturersUnits;"ACA-Lecturers Units"."Claim to pay")
            {
            }
            column(GroupType_ACALecturersUnits;"ACA-Lecturers Units"."Group Type")
            {
            }
            column(NumberofStudentsRegistered_ACALecturersUnits;"ACA-Lecturers Units"."Number of Students Registered")
            {
            }
            column(NumberofCATmarksSubmitted_ACALecturersUnits;"ACA-Lecturers Units"."Number of CAT marks Submitted")
            {
            }
            column(NumberofEXAMmarksSubmitted_ACALecturersUnits;"ACA-Lecturers Units"."Number of EXAM marks Submitted")
            {
            }
            column(NumberofCATBufferSubmitted_ACALecturersUnits;"ACA-Lecturers Units"."Number of CAT Buffer Submitted")
            {
            }
            column(NumberofEXAMBuffSubmitted_ACALecturersUnits;"ACA-Lecturers Units"."Number of EXAM Buff Submitted")
            {
            }
            column(CompanyINfoName;CompanyINfo.Name)
            {
            }
            column(CompanyINfoPicture;CompanyINfo.Picture)
            {
            }
            column(ExamCount;ExamCount)
            {
            }
            column(CatCount;CatCount)
            {
            }
            column(MissingCAT;MissingCAT)
            {
            }
            column(MissingExam;MissingExam)
            {
            }
            column(ProgrammeName;ProgrammeName)
            {
            }
            column(LecturerName;LecturerName)
            {
            }
            column(SchoolCode_ACALecturersUnits;"ACA-Lecturers Units"."School Code")
            {
            }
            column(DepartmentCode_ACALecturersUnits;"ACA-Lecturers Units"."Department Code")
            {
            }
            column(DepartmentName;DepartmentName)
            {
            }
            column(SchoolName;SchoolName)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ExamCount:=0;
                CatCount:=0;
                MissingCAT:=0;
                MissingExam:=0;

                "ACA-Lecturers Units".CalcFields("Number of EXAM Buff Submitted","Number of CAT Buffer Submitted","Number of EXAM marks Submitted","Number of CAT marks Submitted",
                "Number of Students Registered","School Code");
                ExamCount:="ACA-Lecturers Units"."Number of EXAM Buff Submitted"+"ACA-Lecturers Units"."Number of EXAM marks Submitted";
                CatCount:="ACA-Lecturers Units"."Number of CAT Buffer Submitted"+"ACA-Lecturers Units"."Number of CAT marks Submitted";
                MissingCAT:="ACA-Lecturers Units"."Number of Students Registered"-CatCount;
                MissingExam:="ACA-Lecturers Units"."Number of Students Registered"-ExamCount;

                if MissingCAT<0 then
                  MissingCAT:=0;
                if MissingExam<0 then
                  MissingExam:=0;

                LecturerName:='';
                ProgrammeName:='';
                HrEmp.Reset;
                HrEmp.SetRange("No.","ACA-Lecturers Units".Lecturer);
                if HrEmp.FindFirst then
                LecturerName:=HrEmp.FullName;

                Progs.Reset;
                Progs.SetRange(Code,"ACA-Lecturers Units".Programme);
                if Progs.FindFirst then begin
                  Progs.CalcFields("Department Name");
                  ProgrammeName:=Progs.Description;
                  DepartmentName:=Progs."Department Name";
                  end;
                  DimValues.Reset;
                  DimValues.SetRange("Dimension Code",'SCHOOL');
                  DimValues.SetRange(Code,"ACA-Lecturers Units"."School Code");
                  if DimValues.FindFirst then begin
                    SchoolName:=DimValues.Name;
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

    trigger OnPreReport()
    begin
        CompanyINfo.Get;
        CompanyINfo.CalcFields(Picture);
    end;

    var
        ExamCount: Integer;
        CatCount: Integer;
        MissingCAT: Integer;
        MissingExam: Integer;
        CompanyINfo: Record "Company Information";
        HrEmp: Record UnknownRecord61188;
        Progs: Record UnknownRecord61511;
        ProgrammeName: Text;
        LecturerName: Text;
        SchoolName: Text;
        DepartmentName: Text;
        DimValues: Record "Dimension Value";
}

