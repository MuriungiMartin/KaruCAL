#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 66666 MobileAppServices
{

    trigger OnRun()
    begin
    end;


    procedure ExamAttendanceLogin(Username: Text;UserPassword: Text) ReturnMessage: Text[250]
    var
        TXTIncorrectDetails: label 'Incorrect Username or Password';
        TXTCorrectDetails: label 'Login Successful';
        FullNames: Text;
        Emps: Record UnknownRecord61188;
    begin
        ReturnMessage:='FAILED';
        if ((Username='') or (UserPassword='')) then ReturnMessage:='FAILED'
        else begin
        Emps.Reset;
        Emps.SetRange(Emps."No.",Username);
        if Emps.Find('-') then begin
                if ((Emps."Portal Password" = UserPassword) or (Emps."ID Number" = UserPassword)) then begin
                  ReturnMessage := 'SUCCESS';
                end else begin
                  ReturnMessage:='FAILED';
                end;
        end;
        end;
    end;


    procedure VerifyExamCard(StudentNo: Code[20];LectureNo: Code[20];UnitCode: Code[20];ExamHallID: Code[20];ExamStart: Time;ExamEnd: Time) ReturnValExamCardVerification: Text[250]
    var
        ACAAcademicYear: Record UnknownRecord61382;
        ACASemester: Record UnknownRecord61692;
        ACAExamAttendanceRegister: Record UnknownRecord66671;
        Studs: Record Customer;
        ACACourseRegistration: Record UnknownRecord61532;
        ACAStudentUnits: Record UnknownRecord61549;
    begin
        ReturnValExamCardVerification:='FAILED::Invalid Student Number';
        ACAAcademicYear.Reset;
        ACAAcademicYear.SetRange(Current,true);
        if not (ACAAcademicYear.Find('-')) then ReturnValExamCardVerification:='FAILED::Current Academic Year is Not Specified'
        else begin

        ACASemester.Reset;
        ACASemester.SetRange("Current Semester",true);
        if not ACASemester.Find('-') then ReturnValExamCardVerification:='FAILED::Current Semester is Not Specified'
         else begin

        if StudentNo = '' then ReturnValExamCardVerification:='FAILED::invalid Student Number'
        else begin
        Studs.Reset;
        Studs.SetRange("No.",StudentNo);
        if not (Studs.Find('-')) then ReturnValExamCardVerification:='FAILED::Invalid Student Number'
        else begin

        ACACourseRegistration.Reset;
        ACACourseRegistration.SetRange("Academic Year",ACAAcademicYear.Code);
        ACACourseRegistration.SetRange(Semester,ACASemester.Code);
        ACACourseRegistration.SetRange("Student No.",StudentNo);
        ACACourseRegistration.SetRange(Reversed,false);
        if not (ACACourseRegistration.Find('-')) then
         ReturnValExamCardVerification:='FAILED::'+StudentNo+' Not registered for '+ACASemester.Code+', '+ACAAcademicYear.Code
        else begin

        ACAStudentUnits.Reset;
        ACAStudentUnits.SetRange("Student No.",StudentNo);
        ACAStudentUnits.SetRange(Semester,ACASemester.Code);
        ACAStudentUnits.SetRange(Unit,UnitCode);
        if not (ACAStudentUnits.Find('-')) then ReturnValExamCardVerification:='FAILED::'+
        StudentNo+'Not registered for '+UnitCode+' in '+ACASemester.Code else begin

        ACAExamAttendanceRegister.Reset;
        ACAExamAttendanceRegister.SetRange("Student No.",StudentNo);
        ACAExamAttendanceRegister.SetRange("Semester Code",ACASemester.Code);
        ACAExamAttendanceRegister.SetRange("Academic Year",ACAAcademicYear.Code);
        ACAExamAttendanceRegister.SetRange("Unit Code",UnitCode);
        if ACAExamAttendanceRegister.Find('-') then ReturnValExamCardVerification:='FAILED::ID already verified'
         else begin
           //Create an Attendance Register Entry here
        ACAExamAttendanceRegister.Init;
        ACAExamAttendanceRegister."Student No.":=StudentNo;
        ACAExamAttendanceRegister."Lecturer No.":=LectureNo;
        ACAExamAttendanceRegister."Programme Code":=ACACourseRegistration.Programme;
        ACAExamAttendanceRegister."Unit Code":=UnitCode;
        ACAExamAttendanceRegister."Exam Date":=Today;
        ACAExamAttendanceRegister."Exam Start Time":=ExamStart;
        ACAExamAttendanceRegister."Exam End Time":=ExamEnd;
        ACAExamAttendanceRegister."Exam Hall ID":=ExamHallID;
        ACAExamAttendanceRegister."Semester Code":=ACASemester.Code;
        ACAExamAttendanceRegister."Academic Year":=ACAAcademicYear.Code;
        ACAExamAttendanceRegister.Insert;
        ReturnValExamCardVerification:='SUCCESS::'+StudentNo+' - '+Studs.Name;
        end;
        end;
        end;
        end;
        end;
        end;
        end;
    end;


    procedure UpdateExamNotes(LectureNo: Code[20];ProgrammeCode: Code[20];UnitCode: Code[20];ExamHallID: Code[20];ExamStart: Time;ExamEnd: Time;Notes1: Text[250];Notes2: Text[250])
    var
        ACAAcademicYear: Record UnknownRecord61382;
        ACASemester: Record UnknownRecord61692;
        ACAExamAttendanceNotes: Record UnknownRecord66672;
    begin
        ACAAcademicYear.Reset;
        ACAAcademicYear.SetRange(Current,true);
        if not (ACAAcademicYear.Find('-')) then Error('Current Academic Year is Not Specified');

        ACASemester.Reset;
        ACASemester.SetRange("Current Semester",true);
        if ACASemester.Find('-') then Error('Current Semester is Not Specified');

        ACAExamAttendanceNotes.Reset;
        ACAExamAttendanceNotes.SetRange("Semester Code",ACASemester.Code);
        ACAExamAttendanceNotes.SetRange("Academic Year",ACAAcademicYear.Code);
        ACAExamAttendanceNotes.SetRange("Lecturer No.",LectureNo);
        ACAExamAttendanceNotes.SetRange("Unit Code",UnitCode);
        if ACAExamAttendanceNotes.Find('-') then begin
        ACAExamAttendanceNotes."Notes 1":=Notes1;
        ACAExamAttendanceNotes."Notes 2":=Notes2;
        ACAExamAttendanceNotes.Modify;
          end else begin
           //Create an Attendance Register Entry here
        ACAExamAttendanceNotes.Init;
        ACAExamAttendanceNotes."Lecturer No.":=LectureNo;
        ACAExamAttendanceNotes."Programme Code":=ProgrammeCode;
        ACAExamAttendanceNotes."Unit Code":=UnitCode;
        ACAExamAttendanceNotes."Exam Date":=Today;
        ACAExamAttendanceNotes."Exam Start Time":=ExamStart;
        ACAExamAttendanceNotes."Exam End Time":=ExamEnd;
        ACAExamAttendanceNotes."Exam Hall ID":=ExamHallID;
        ACAExamAttendanceNotes."Semester Code":=ACASemester.Code;
        ACAExamAttendanceNotes."Academic Year":=ACAAcademicYear.Code;
        ACAExamAttendanceNotes."Notes 1":=Notes1;
        ACAExamAttendanceNotes."Notes 2":=Notes2;
        ACAExamAttendanceNotes.Insert;
        Message('Successfully posted notes');
        end;
    end;


    procedure VerifyServerDates() ServerDate: Code[20]
    var
        CurrDate: Code[10];
        CurrMonth: Code[10];
        CurrYear: Code[10];
    begin
        Clear(CurrDate);Clear(CurrMonth);Clear(CurrYear);
        CurrDate:=Format(Date2dmy(Today,1));CurrMonth:=Format(Date2dmy(Today,2));CurrYear:=Format(Date2dmy(Today,3));
        if StrLen(CurrDate)=1 then
          CurrDate:='0'+CurrDate;
        if StrLen(CurrMonth)=1 then
          CurrMonth:='0'+CurrMonth;
        ServerDate:=CurrDate+'/'+CurrMonth+'/'+CurrYear;
    end;
}

