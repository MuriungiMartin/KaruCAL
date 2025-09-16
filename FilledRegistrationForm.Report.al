#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51517 "Filled Registration Form"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Filled Registration Form.rdlc';
    UseRequestPage = true;

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = sorting("Reg. Transacton ID","Student No.",Programme,Semester,"Register for",Stage,Unit,"Student Type","Entry No.");
            RequestFilterFields = "Student No.","Reg. Transacton ID";
            column(ReportForNavId_2901; 2901)
            {
            }
            column(Cust_Name;Cust.Name)
            {
            }
            column(Cust__No__;Cust."No.")
            {
            }
            column(Course_Registration__Course_Registration__Stage;"ACA-Course Registration".Stage)
            {
            }
            column(Course_Registration__Course_Registration__Semester;"ACA-Course Registration".Semester)
            {
            }
            column(Prog_Description;Prog.Description)
            {
            }
            column(School;School)
            {
            }
            column(UPPERCASE_COMPANYNAME_;UpperCase(COMPANYNAME))
            {
            }
            column(Dept;Dept)
            {
            }
            column(COURSE_REGISTRATION_FORMCaption;COURSE_REGISTRATION_FORMCaptionLbl)
            {
            }
            column(LEVEL_Caption;LEVEL_CaptionLbl)
            {
            }
            column(SEMESTER_Caption;SEMESTER_CaptionLbl)
            {
            }
            column(PROGRAMME_Caption;PROGRAMME_CaptionLbl)
            {
            }
            column(FACULTY_Caption;FACULTY_CaptionLbl)
            {
            }
            column(NAME_Caption;NAME_CaptionLbl)
            {
            }
            column(REG__NO_Caption;REG__NO_CaptionLbl)
            {
            }
            column(UNIT_CODECaption;UNIT_CODECaptionLbl)
            {
            }
            column(CFCaption;CFCaptionLbl)
            {
            }
            column(UNIT_DESCRIPTIONCaption;UNIT_DESCRIPTIONCaptionLbl)
            {
            }
            column(LECTURERCaption;LECTURERCaptionLbl)
            {
            }
            column(LECTURER_SIGNCaption;LECTURER_SIGNCaptionLbl)
            {
            }
            column(No_Caption;No_CaptionLbl)
            {
            }
            column(DEPARTMENT_Caption;DEPARTMENT_CaptionLbl)
            {
            }
            column(Chairman_of_DepartmentCaption;Chairman_of_DepartmentCaptionLbl)
            {
            }
            column(SIGNED____________________________DATE_______________________Caption;SIGNED____________________________DATE_______________________CaptionLbl)
            {
            }
            column(OriginalCaption;OriginalCaptionLbl)
            {
            }
            column(Student_Signature____________________________________________Caption;Student_Signature____________________________________________CaptionLbl)
            {
            }
            column(The_Information_has_been_Certified_by_the_Undersign_Caption;The_Information_has_been_Certified_by_the_Undersign_CaptionLbl)
            {
            }
            column(Date_____________________________________________________________Caption;Date_____________________________________________________________CaptionLbl)
            {
            }
            column(Dean_of_FacultyCaption;Dean_of_FacultyCaptionLbl)
            {
            }
            column(SIGNED____________________________DATE_______________________Caption_Control1102755027;SIGNED____________________________DATE_______________________Caption_Control1102755027Lbl)
            {
            }
            column(DuplicateCaption;DuplicateCaptionLbl)
            {
            }
            column(TriplicateCaption;TriplicateCaptionLbl)
            {
            }
            column(QuadricateCaption;QuadricateCaptionLbl)
            {
            }
            column(PeatricateCaption;PeatricateCaptionLbl)
            {
            }
            column(AdmissionsCaption;AdmissionsCaptionLbl)
            {
            }
            column(FacultyCaption;FacultyCaptionLbl)
            {
            }
            column(DepartmentCaption;DepartmentCaptionLbl)
            {
            }
            column(StudentCaption;StudentCaptionLbl)
            {
            }
            column(Postgraduate_StudentCaption;Postgraduate_StudentCaptionLbl)
            {
            }
            column(DataItem1102755037;No_student_will_be_allowed_to_sit_for_Exams_unless_they_register_for_courses_and_submit_this_form_to_the_relevant_authoritiesLbl)
            {
            }
            column(NBCaption;NBCaptionLbl)
            {
            }
            column(Course_Registration_Reg__Transacton_ID;"Reg. Transacton ID")
            {
            }
            column(Course_Registration_Student_No_;"Student No.")
            {
            }
            column(Course_Registration_Programme;Programme)
            {
            }
            column(Course_Registration_Register_for;"Register for")
            {
            }
            column(Course_Registration_Unit;Unit)
            {
            }
            column(Course_Registration_Student_Type;"Student Type")
            {
            }
            column(Course_Registration_Entry_No_;"Entry No.")
            {
            }
            dataitem(UnknownTable61549;UnknownTable61549)
            {
                DataItemLink = Semester=field(Semester),"Student No."=field("Student No."),"Reg. Transacton ID"=field("Reg. Transacton ID");
                column(ReportForNavId_2992; 2992)
                {
                }
                column(Student_Units_Unit;Unit)
                {
                }
                column(Student_Units__Student_Units___No__Of_Units_;"ACA-Student Units"."No. Of Units")
                {
                }
                column(UnitDesc;UnitDesc)
                {
                }
                column(LecName;LecName)
                {
                }
                column(Nm;Nm)
                {
                }
                column(Student_Units_Programme;Programme)
                {
                }
                column(Student_Units_Stage;Stage)
                {
                }
                column(Student_Units_Semester;Semester)
                {
                }
                column(Student_Units_Reg__Transacton_ID;"Reg. Transacton ID")
                {
                }
                column(Student_Units_Student_No_;"Student No.")
                {
                }
                column(Student_Units_ENo;ENo)
                {
                }

                trigger OnAfterGetRecord()
                begin
                      Units.Reset;
                     // Units.SETRANGE(Units."Programme Code","Student Units".Programme);
                    //  Units.SETRANGE(Units."Stage Code","Student Units".Stage);
                      Units.SetRange(Units.Code,"ACA-Student Units".Unit);
                      if Units.Find('-') then
                      UnitDesc:=Units.Desription
                      else
                      UnitDesc:='';
                      Nm:=Nm+1;
                    "ACA-Student Units".CalcFields(Lecturer);
                    LecName:='';
                    if Emp.Get("ACA-Student Units".Lecturer) then
                    LecName:=Emp."First Name";
                end;
            }

            trigger OnAfterGetRecord()
            begin
                   if Cust.Get("ACA-Course Registration"."Student No.") then
                   Cust.CalcFields(Cust.Balance);

                   if Prog.Get("ACA-Course Registration".Programme) then begin
                   Dim.Reset;
                   Dim.SetRange(Dim."Dimension Code",'FACULTY');
                   Dim.SetRange(Dim.Code,Prog."School Code");
                   if Dim.Find('-') then
                   School:=Dim.Name;
                  end;
                   if Prog.Get("ACA-Course Registration".Programme) then begin
                   Dim.Reset;
                   Dim.SetRange(Dim."Dimension Code",'DEPARTMENT');
                   Dim.SetRange(Dim.Code,Prog."Department Code");
                   if Dim.Find('-') then
                   Dept:=Dim.Name;
                  end;

                  AcademicY.Reset;
                  AcademicY.SetRange(AcademicY.Current,true);
                  if AcademicY.Find('-') then
                  Nm:=0;
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
        Cust: Record Customer;
        Prog: Record UnknownRecord61511;
        AcademicY: Record UnknownRecord61382;
        School: Code[100];
        Dim: Record "Dimension Value";
        Units: Record UnknownRecord61517;
        UnitDesc: Text[100];
        Nm: Integer;
        Dept: Code[100];
        Emp: Record UnknownRecord61188;
        LecName: Text[100];
        COURSE_REGISTRATION_FORMCaptionLbl: label 'COURSE REGISTRATION FORM';
        LEVEL_CaptionLbl: label 'LEVEL:';
        SEMESTER_CaptionLbl: label 'SEMESTER:';
        PROGRAMME_CaptionLbl: label 'PROGRAMME:';
        FACULTY_CaptionLbl: label 'FACULTY:';
        NAME_CaptionLbl: label 'NAME:';
        REG__NO_CaptionLbl: label 'REG. NO.';
        UNIT_CODECaptionLbl: label 'UNIT CODE';
        CFCaptionLbl: label 'CF';
        UNIT_DESCRIPTIONCaptionLbl: label 'UNIT DESCRIPTION';
        LECTURERCaptionLbl: label 'LECTURER';
        LECTURER_SIGNCaptionLbl: label 'LECTURER SIGN';
        No_CaptionLbl: label 'No.';
        DEPARTMENT_CaptionLbl: label 'DEPARTMENT:';
        Chairman_of_DepartmentCaptionLbl: label 'Chairman of Department';
        SIGNED____________________________DATE_______________________CaptionLbl: label 'SIGNED: __________________________DATE_______________________';
        OriginalCaptionLbl: label 'Original';
        Student_Signature____________________________________________CaptionLbl: label 'Student Signature:...........................................';
        The_Information_has_been_Certified_by_the_Undersign_CaptionLbl: label 'The Information has been Certified by the Undersign.';
        Date_____________________________________________________________CaptionLbl: label 'Date.............................................................';
        Dean_of_FacultyCaptionLbl: label 'Dean of Faculty';
        SIGNED____________________________DATE_______________________Caption_Control1102755027Lbl: label 'SIGNED: __________________________DATE_______________________';
        DuplicateCaptionLbl: label 'Duplicate';
        TriplicateCaptionLbl: label 'Triplicate';
        QuadricateCaptionLbl: label 'Quadricate';
        PeatricateCaptionLbl: label 'Peatricate';
        AdmissionsCaptionLbl: label '-     Admissions';
        FacultyCaptionLbl: label '-     Faculty';
        DepartmentCaptionLbl: label '-     Department';
        StudentCaptionLbl: label '-     Student';
        Postgraduate_StudentCaptionLbl: label '-     Postgraduate Student';
        No_student_will_be_allowed_to_sit_for_Exams_unless_they_register_for_courses_and_submit_this_form_to_the_relevant_authoritiesLbl: label 'No student will be allowed to sit for Exams unless they register for courses and submit this form to the relevant authorities';
        NBCaptionLbl: label 'NB';
}

