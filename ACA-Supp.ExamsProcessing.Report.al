#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78007 "ACA-Supp. Exams Processing"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = where(Reversed=filter(No));
            RequestFilterFields = "Student No.",Programme,Stage,Semester;
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            dataitem(UnknownTable78002;UnknownTable78002)
            {
                DataItemLink = "Student No."=field("Student No."),Programme=field(Programme),Semester=field(Semester);
                column(ReportForNavId_1000000005; 1000000005)
                {
                }

                trigger OnAfterGetRecord()
                var
                    "ACA-Student Units": Record UnknownRecord61549;
                begin
                      //ExamProcess.UpdateStudentUvbnits("Student Units"."Student No.","Student Units".Programme,"Student Units".Semester,"Student Units".Stage);
                    // // // // // // CLEAR(TotMarks);

                    progress.Update(1,"ACA-Course Registration"."Student No.");
                    progress.Update(2,"Aca-Special Exams Details".Programme);
                    progress.Update(3,"Aca-Special Exams Details"."Unit Code");
                     // EResults.RESET;
                     // EResults.SETFILTER(EResults."Student No.","Student Units"."Student No.");
                     // EResults.SETFILTER(EResults.Programme,"Student Units".Programme);
                     // EResults.SETFILTER(EResults.Unit,"Student Units".Unit);
                    //  EResults.SETFILTER(EResults.Semester,"Student Units".Semester);
                    //  EResults.SETFILTER(EResults."Reg. Transaction ID","Student Units"."Reg. Transacton ID");
                     // IF EResults.FIND('-') THEN BEGIN
                     // REPEAT
                     // BEGIN
                     //    EResults.VALIDATE(EResults.Score);
                        // EResults.CALCFIELDS(EResults.Stager);
                        // EResults.SETCURRENTKEY(EResults."Student No.",EResults.Programme,EResults.Stage,EResults.Unit,
                        // EResults.Semester,EResults.Exam,EResults."Reg. Transaction ID",EResults."Re-Sited",
                       //  EResults."Entry No");
                       //  IF EResults.Stage<>EResults.Stager THEN BEGIN
                        // EResults.Stage:=EResults.Stager;
                       //   EResults.RENAME(EResults."Student No.",EResults.Programme,EResults.Stager,EResults.Unit,
                       //  EResults.Semester,EResults.Exam,EResults."Reg. Transaction ID",EResults."Re-Sited",
                       //  EResults."Entry No");

                        // EResults.MODIFY;
                        // END;
                       // TotMarks:=TotMarks+EResults.Contribution;

                     // END;
                     // UNTIL EResults.NEXT=0;
                     // END;
                       // ERROR(FORMAT(TotMarks));
                    //CALCFIELDS("ACA-Student Units"."Total Score");

                     // "ACA-Student Units"."Final Score":="ACA-Student Units"."Total Score";
                     // "ACA-Student Units"."Total Marks":="ACA-Student Units"."Total Score";
                     // "ACA-Student Units".MODIFY;
                    // // // // // // //  TotMarks:="Aca-Special Exams Details"."Total Marks";

                    //CALCFIELDS("Student Units"."Credited Hours",
                    //"Student Units"."CATs Marks","Student Units"."EXAMs Marks");
                    //IF   "Student Units"."Credited Hours"<>0 THEN
                     // "Student Units"."Credit Hours":="Student Units"."Credited Hours";
                    //IF UnitsR.GET("Aca-Special Exams Details".Programme,"Aca-Special Exams Details".Stage,"ACA-Student Units".Unit) THEN //BEGIN
                    //"ACA-Student Units"."No. Of Units":=UnitsR."No. Units";
                    //"Student Units"."Unit Type":=UnitsR."Unit Type";
                    //END;
                    // // // // // // //  "Units/Subj".RESET;
                    // // // // // // //  "Units/Subj".SETRANGE("Units/Subj"."Programme Code","Aca-Special Exams Details".Programme);
                    // // // // // // //  "Units/Subj".SETRANGE("Units/Subj".Code,"Aca-Special Exams Details"."Unit Code");
                    // // // // // // //  "Units/Subj".SETRANGE("Units/Subj"."Stage Code","Aca-Special Exams Details".Stage);
                    // // // // // // //  IF "Units/Subj".FIND('-') THEN;
                     // "ACA-Student Units".Description:="Units/Subj".Desription;

                     // "ACA-Student Units".CALCFIELDS("ACA-Student Units"."Total Score");
                      //"Student Units".CALCFIELDS("Student Units"."Ignore in Final Average");
                     // "ACA-Student Units"."Ignore in Cumm  Average":="ACA-Student Units"."Ignore in Final Average";
                     // "ACA-Student Units".MODIFY;
                           // CLEAR(TotMarks);
                           // TotMarks:="Student Units"."Total Score";
                    // // // // // //  IF (GetGradeStatus(TotMarks,"ACA-Student Units".Programme,"ACA-Student Units".Unit)) OR
                    // // // // // //  ("ACA-Student Units"."Final Score"=0)  THEN BEGIN
                    // // // // // //  "ACA-Student Units"."Result Status":='FAIL';
                    // // // // // //  "ACA-Student Units".Failed:=TRUE;
                    // // // // // //  END ELSE BEGIN
                    // // // // // //  "ACA-Student Units"."Result Status":='PASS';
                    // // // // // //  END;
                    // // //  CLEAR(Gradeaqq2);
                    // // //  "ACA-Student Units".Grade:=GetGrade(
                    // // //  TotMarks,"ACA-Student Units".Programme,"ACA-Student Units".Unit);
                    // // //  "ACA-Student Units".Grade:=GetGrade("ACA-Student Units"."Total Score","ACA-Student Units".Programme,"ACA-Student Units".Unit);
                    // // //  Gradeaqq2:=GetGrade("ACA-Student Units"."Final Score","ACA-Student Units".Programme,"ACA-Student Units".Unit);
                    // // //  MODIFY;
                     // "Student Units"."GPA Points":=GetGPAPoints("Student Units"."Final Score","Student Units".Unit);
                      //"Student Units"."Unit Points":=((GetGPAPoints("Student Units"."Final Score","Student Units".Unit))*
                      //  ("Student Units"."Credit Hours"));


                    //"Student Units".SETCURRENTKEY(Programme,Stage,Unit,Semester,"Reg. Transacton ID","Student No.",ENo
                    //);
                    // "Student Units".RENAME(
                    //"Student Units".Programme,"Student Units".Stage,"Student Units".Unit,
                    //"Student Units".Semester,"Student Units"."Reg. Transacton ID","Student Units"."Student No.",
                    //"Student Units".ENo,
                    // GetGrade("Student Units"."Final Score",
                    // "Student Units".Unit),
                    //"Student Units"."Academic Year"
                    // );

                      //"Student Units".MODIFY;

                    // Update Supplimentary
                    // // // // // // IF "ACA-Student Units"."Register for"="ACA-Student Units"."Register for"::Supplimentary THEN BEGIN
                    // // // // // // StudUnits.RESET;
                    // // // // // // StudUnits.SETRANGE(StudUnits."Student No.","ACA-Student Units"."Student No.");
                    // // // // // // StudUnits.SETRANGE(StudUnits.Unit,"ACA-Student Units".Unit);
                    // // // // // // StudUnits.SETRANGE(StudUnits."Re-Take",FALSE);
                    // // // // // // StudUnits.SETRANGE(StudUnits."Supp Taken",FALSE);
                    // // // // // // IF StudUnits.FIND('-') THEN BEGIN
                    // // // // // // REPEAT
                    // // // // // // StudUnits."Supp Taken":=TRUE;
                    // // // // // // StudUnits.MODIFY;
                    // // // // // // UNTIL StudUnits.NEXT=0;
                    // // // // // // END;
                    // // // // // // END;

                    // // // // // // // // // EResults.RESET;
                    // // // // // // // // // EResults.SETRANGE(EResults."Student No.","ACA-Student Units"."Student No.");
                    // // // // // // // // // EResults.SETRANGE(EResults.Unit,"ACA-Student Units".Unit);
                    // // // // // // // // // EResults.SETRANGE(EResults.Programme,"ACA-Student Units".Programme);
                    // // // // // // // // // EResults.SETRANGE(EResults.Stage,"ACA-Student Units".Stage);
                    // // // // // // // // // EResults.SETRANGE(EResults.Semester,"ACA-Student Units".Semester);
                    // // // // // // // // // EResults.SETRANGE(EResults."Re-Take",FALSE);
                    // // // // // // // // // IF EResults.FIND('-') THEN BEGIN
                    // // // // // // // // // REPEAT
                    // // // // // // // // // EResults.CALCFIELDS(EResults."Re-Sit");
                    // // // // // // // // // EResults."Re-Sited":=EResults."Re-Sit";
                    // // // // // // // // // EResults.MODIFY;
                    // // // // // // // // // UNTIL EResults.NEXT=0;
                    // // // // // // // // // END;

                    "ACA-Student Units".Reset;
                    "ACA-Student Units".SetRange("ACA-Student Units"."Student No.","Aca-Special Exams Details"."Student No.");
                    "ACA-Student Units".SetRange("ACA-Student Units".Semester,"Aca-Special Exams Details".Semester);
                    "ACA-Student Units".SetRange("ACA-Student Units".Unit,"Aca-Special Exams Details"."Unit Code");
                    if "ACA-Student Units".Find('-') then begin
                     "ACA-Student Units"."Supp. Cons. Mark Pref.":='';
                     if "ACA-Student Units"."Supp. Grade"='E' then
                     "ACA-Student Units"."Supp. Cons. Mark Pref." :='^';
                    // // // // // // // "ACA-Student Units".CALCFIELDS("ACA-Student Units"."CATs Marks Exists","ACA-Student Units"."EXAMs Marks Exists");
                    // // // // // // // IF (("ACA-Student Units"."CATs Marks Exists"=FALSE) AND ("ACA-Student Units"."EXAMs Marks Exists"=FALSE)) THEN BEGIN
                    // // // // // // // "ACA-Student Units"."Consolidated Mark Pref." :='x';
                    // // // // // // //  END ELSE IF (("ACA-Student Units"."CATs Marks Exists"=TRUE) AND ("ACA-Student Units"."EXAMs Marks Exists"=FALSE)) THEN BEGIN
                    // // // // // // // "ACA-Student Units"."Consolidated Mark Pref." :='c';
                    // // // // // // //  END ELSE IF (("ACA-Student Units"."CATs Marks Exists"=FALSE) AND ("ACA-Student Units"."EXAMs Marks Exists"=TRUE)) THEN BEGIN
                    // // // // // // // "ACA-Student Units"."Consolidated Mark Pref." :='e';
                    // // // // // // //  END;
                    "ACA-Student Units".Modify;
                    end;
                end;
            }
            dataitem(UnknownTable61549;UnknownTable61549)
            {
                DataItemLink = "Student No."=field("Student No."),Programme=field(Programme),Semester=field(Semester);
                column(ReportForNavId_1000000001; 1000000001)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    "ACA-Student Units".CalcFields("ACA-Student Units"."No of Supplementaries","ACA-Student Units"."Supp. Exam Score");

                    stud_Units2.Reset;
                    stud_Units2.SetRange("Reg. Reversed",false);
                    stud_Units2.SetRange("Student No.","ACA-Student Units"."Student No.");
                    stud_Units2.SetRange(Semester,"ACA-Student Units".Semester);
                    stud_Units2.SetRange(Unit,"ACA-Student Units".Unit);
                    //stud_Units2.SETRANGE("Reg. Transacton ID","ACA-Student Units"."Reg. Transacton ID");
                    if stud_Units2.Find('-') then begin
                    // IF (("ACA-Student Units"."Supp. Exam Score"=0) OR ("ACA-Student Units"."No of Supplementaries"=0)) THEN BEGIN
                     if ("ACA-Student Units"."Supp. Exam Score"=0) then begin
                      stud_Units2."Supp. Exam Marks":="ACA-Student Units"."Total Marks";
                      stud_Units2."Supp. Academic Year":="ACA-Student Units"."Academic Year";
                      stud_Units2."Supp. Exam Score":="ACA-Student Units"."Total Marks";
                      stud_Units2."Supp. Final Score":="ACA-Student Units"."Total Marks";
                      stud_Units2."Supp. Total Score":="ACA-Student Units"."Total Marks";
                      stud_Units2."Supp. Total Marks":="ACA-Student Units"."Total Marks";
                      stud_Units2."Supp. Grade":="ACA-Student Units".Grade;
                      stud_Units2."Supp. Weighted Units":="ACA-Student Units"."Total Marks"*"ACA-Student Units".Units;
                      stud_Units2.Modify;
                      end;
                      end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                 // ExamProcess.UpdateCourseReg("Course Registration"."Student No.","Course Registration".Programme,"Course Registration".Stage,"Course Registration".Semester);
                 Clear(sName);
                 cust.Reset;
                 cust.SetRange(cust."No.","ACA-Course Registration"."Student No.");
                 if cust.Find('-') then
                 sName:=cust.Name;
            end;

            trigger OnPostDataItem()
            begin
                 // ExamProcess.UpdateCourseReg("Course Registration"."Student No.","Course Registration".Programme,"Course Registration".Stage,"Course Registration".Semester);
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

    trigger OnPostReport()
    begin
         progress.Close;
    end;

    trigger OnPreReport()
    begin
         progress.Open('Processing 6 of 7.\Computing Transcript Parameters..\This may take long depending on the class size.....'+
         '\No.: #1############################################\Prog.: #2############################################\Unit: #3############################################');
    end;

    var
        ExamProcess: Codeunit "Exams Processing";
        EResults: Record UnknownRecord61548;
        UnitsR: Record UnknownRecord61517;
        "Units/Subj": Record UnknownRecord61517;
        Sem: Record UnknownRecord61692;
        StudUnits: Record UnknownRecord61549;
        stduntz: Record UnknownRecord61549;
        TotalCatMarks: Decimal;
        TotalCatContributions: Decimal;
        TotalMainExamContributions: Decimal;
        TotalExamMark: Decimal;
        FinalExamMark: Decimal;
        FinalCATMarks: Decimal;
        Gradez: Code[10];
        TotalMarks: Decimal;
        Gradings: Record UnknownRecord61599;
        LastGrade: Code[20];
        LastScore: Decimal;
        ExitDo: Boolean;
        Gradings2: Record UnknownRecord61599;
        Gradeaqq2: Code[10];
        TotMarks: Decimal;
        sName: Code[250];
        cust: Record Customer;
        progress: Dialog;
        UnitsRegister: Record UnknownRecord61517;
        ACAStudentUnits: Record UnknownRecord61549;
        stud_Units2: Record UnknownRecord61549;
}

