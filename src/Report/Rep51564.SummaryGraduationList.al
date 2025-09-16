#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51564 "Summary Graduation List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Summary Graduation List.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code","Semester Filter","Stage Filter";
            column(ReportForNavId_1410; 1410)
            {
            }
            column(EXAM_PERIOD____FORMAT_DATE2DMY_Semesters_From_3__;'EXAM PERIOD: '+Format(Date2dmy(Semesters.From,3)))
            {
            }
            column(PROGRAMME____Programme_Description;'PROGRAMME: '+"ACA-Programme".Description)
            {
            }
            column(FORMAT_UPPERCASE_Depts_Description__; Format(UpperCase(Depts.Description)))
            {
            }
            column(FORMAT_UPPERCASE_Dimensions_Name__; Format(UpperCase(Dimensions.Name)))
            {
            }
            column(SEMESTER____Semesters_Description;'SEMESTER: '+Semesters.Description)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(TIME;Time)
            {
            }
            column(USERID;UserId)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(KIMATHI_UNIVERISTYCaption;KIMATHI_UNIVERISTYCaptionLbl)
            {
            }
            column(UNIVERSITY_EXAMINATIONS_Caption;UNIVERSITY_EXAMINATIONS_CaptionLbl)
            {
            }
            column(GRADUATION_LIST_SUMMARYCaption;GRADUATION_LIST_SUMMARYCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(ProgrammeCaption;ProgrammeCaptionLbl)
            {
            }
            column(Final_StageCaption;Final_StageCaptionLbl)
            {
            }
            column(CodeCaption;CodeCaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            column(Programme_Code;Code)
            {
            }
            column(Programme_Stage_Filter;"Stage Filter")
            {
            }
            dataitem(UnknownTable61516;UnknownTable61516)
            {
                DataItemLink = "Programme Code"=field(Code),Code=field("Stage Filter");
                DataItemTableView = where("Reg. ID"=const(YES));
                column(ReportForNavId_3691; 3691)
                {
                }
                column(ProgDesc;ProgDesc)
                {
                }
                column(Programme_Stages_Code;Code)
                {
                }
                column(Programme_Stages__Programme_Stages___Programme_Code_;"ACA-Programme Stages"."Programme Code")
                {
                }
                column(Pass;Pass)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    "ACA-Programme Stages".CalcFields("ACA-Programme Stages"."Pass Count");
                    Pass:=Pass+"ACA-Programme Stages"."Pass Count" ;
                    /*
                    ProcessedSenate.RESET;
                    ProcessedSenate.SETRANGE(ProcessedSenate.Programme,"Programme Stages"."Programme Code");
                    ProcessedSenate.SETRANGE(ProcessedSenate.Stage,"Programme Stages".Code);
                    ProcessedSenate.SETRANGE(ProcessedSenate.Semester,Programme.GETFILTER("Semester Filter"));
                    IF ProcessedSenate.FIND('-') THEN
                    ProcessedSenate.DELETEALL;
                    
                    Registration.RESET;
                    Registration.SETRANGE(Registration.Programme,"Programme Stages"."Programme Code");
                    Registration.SETRANGE(Registration.Semester,Programme.GETFILTER("Semester Filter"));
                    Registration.SETRANGE(Registration.Stage,"Programme Stages".Code);
                    Registration.SETRANGE(Registration.Reversed,FALSE);
                    IF Registration.FIND('-') THEN REPEAT
                     ProcessedSenate.INIT;
                     ProcessedSenate.Programme:="Programme Stages"."Programme Code";
                     ProcessedSenate.Stage:="Programme Stages".Code;
                     ProcessedSenate.StudentNo:=Registration."Student No.";
                     ProcessedSenate.Semester:=Programme.GETFILTER("Semester Filter");
                     IF Student.GET(Registration."Student No.") THEN
                     ProcessedSenate.Status:=FORMAT(Student.Status);
                     IF Registration."Registration Status" <> 0 THEN
                     ProcessedSenate.Status:=FORMAT(Registration."Registration Status");
                     IF SenateEntry.GET(Registration.Programme,Registration.Stage,Registration.Semester,Registration."Student No.")=FALSE THEN
                      ProcessedSenate.INSERT;
                     ProgressWindow.UPDATE(1,Registration."Student No.");
                    
                    UNTIL Registration.NEXT = 0;
                    
                    
                    
                    SRProcess.RESET;
                    SRProcess.SETRANGE(Programme,"Programme Stages"."Programme Code");
                    SRProcess.SETRANGE(Semester,Programme.GETFILTER("Semester Filter"));
                    SRProcess.SETRANGE(Stage,"Programme Stages".Code);
                    IF SRProcess.FIND('-') THEN BEGIN
                    REPEAT
                    SRProcess.CALCFIELDS("TotalPassed Cumulatively","TotalPerProgramme Cumulatively");
                    
                    
                    IF SRProcess."TotalPassed Cumulatively" >= SRProcess."TotalPerProgramme Cumulatively" THEN
                    Pass:=Pass+1
                    
                    UNTIL SRProcess.NEXT = 0;
                    END;
                    */

                end;

                trigger OnPreDataItem()
                begin
                    "ACA-Programme Stages".SetFilter("ACA-Programme Stages"."Semester Filter","ACA-Programme".GetFilter("ACA-Programme"."Semester Filter"));
                    "ACA-Programme Stages".SetFilter("ACA-Programme Stages"."Date Filter","ACA-Programme".GetFilter("ACA-Programme"."Date Filter"));
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Pass:=0;
                Supp:=0;
                Rep:=0;

                TotalIncome:=0;
                TotalReg:=0;
                ProgDesc:="ACA-Programme".Description;
                ProgressWindow.Open('Processing Report #1############');


                //GET YEAR OF STUDY
                   Semesters.Reset;
                   Semesters.SetRange(Semesters.Code,"ACA-Programme".GetFilter("Semester Filter"));
                   if Semesters.Find('-') then
                //YEAR



                //GET DEPT
                 Dimensions.Reset;
                 Dimensions.SetRange(Dimensions."Dimension Code",'DEPARTMENT');
                 Dimensions.SetRange(Dimensions.Code,"ACA-Programme"."School Code");
                 if Dimensions.Find('-') then
                //DEPT

                //GET FACULTY
                FacDesc := '';
                 Depts.Reset;
                 Depts.SetRange(Depts.Code,Faculty);
                 if Depts.Find('-') then begin
                   FacDesc := 'DEAN ' + Format(UpperCase(Depts.Description));
                 end;

                //END FACULTY
            end;

            trigger OnPreDataItem()
            begin
                if "ACA-Programme".GetFilter(Code) = '' then
                Error('Please specify the Programme/Course filter.');
                if "ACA-Programme".GetFilter("Semester Filter") = '' then
                Error('Please specify the Semester filter.');
                if(AcademicYr = '' )then
                //ERROR('Please define the academic year for this report');

                // Update Students units results
                StudUnits.Reset;
                StudUnits.SetFilter(StudUnits.Programme,"ACA-Programme".GetFilter(Code));
                StudUnits.SetFilter(StudUnits.Stage,"ACA-Programme".GetFilter("Stage Filter"));
                StudUnits.SetFilter(StudUnits.Semester,"ACA-Programme".GetFilter("Semester Filter"));
                if StudUnits.Find('-') then begin
                repeat
                StudUnits.CalcFields(StudUnits."Total Score");
                StudUnits.CalcFields(StudUnits."Registration Status");
                StudUnits."Final Score":=StudUnits."Total Score";
                if GetGradeStatus(StudUnits."Total Score",StudUnits.Programme)=false then begin
                StudUnits."Result Status":='PASS';
                end else begin
                StudUnits."Result Status":='FAIL';
                end;
                if StudUnits."Total Score"=0 then
                StudUnits."Result Status":='FAIL';

                CReg.Reset;
                CReg.SetRange(CReg."Student No.",StudUnits."Student No.");
                CReg.SetRange(CReg.Programme,StudUnits.Programme);
                CReg.SetRange(CReg.Semester,StudUnits.Semester);
                CReg.SetRange(CReg.Stage,StudUnits.Stage);
                if CReg.Find('-') then begin
                CReg.CalcFields(CReg."Units Taken");
                CReg.CalcFields(CReg."Units Failed");
                CReg.CalcFields(CReg."Units Passed");

                ExamsDone:=CReg."Units Taken";
                FailCount:=CReg."Units Failed";


                if CopyStr(Format(ExamsDone/2),2,2)='.' then begin
                if (ExamsDone<>0) and (FailCount<>0) then
                if (ExamsDone/(FailCount+1)) <=2 then
                StudUnits."Result Status":='REPEAT';
                end else begin
                if (ExamsDone<>0) and (FailCount<>0) then
                if (ExamsDone/FailCount) <=2 then
                StudUnits."Result Status":='REPEAT';;
                end;
                CReg.CalcFields(CReg."Units Passed");
                CReg.CalcFields(CReg."Units Failed");
                CReg.CalcFields(CReg."Units Repeat");

                CReg."Exam Status":='';
                if (CReg."Units Failed"=0) and (CReg."Units Repeat"=0) and (CReg."Units Passed"<>0) then
                CReg."Exam Status":='PASS';
                if (CReg."Units Failed"<>0)  then
                CReg."Exam Status":='FAIL';
                if  (CReg."Units Repeat"<>0)  then
                CReg."Exam Status":='REPEAT';

                if CReg."Registration Status"<>0 then
                CReg."Exam Status":=Format(CReg."Registration Status");

                CReg.Modify;
                end;
                if StudUnits."Registration Status"<>0 then
                StudUnits."Result Status":=Format(StudUnits."Registration Status");
                StudUnits.Modify;
                until StudUnits.Next=0;
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
        TotalIncome: Decimal;
        TotalReg: Integer;
        Sem: Text[250];
        ProgDesc: Text[250];
        Pass: Integer;
        Supp: Integer;
        Rep: Integer;
        AcademicYr: Text[30];
        Depts: Record UnknownRecord61587;
        Semesters: Record UnknownRecord61518;
        Dimensions: Record "Dimension Value";
        FacDesc: Text[250];
        Registration: Record UnknownRecord61532;
        Student: Record Customer;
        ProgressWindow: Dialog;
        StudUnits: Record UnknownRecord61549;
        CReg: Record UnknownRecord61532;
        ExamsDone: Integer;
        FailCount: Integer;
        Cust: Record Customer;
        Prog: Record UnknownRecord61511;
        Stages: Record UnknownRecord61516;
        KIMATHI_UNIVERISTYCaptionLbl: label 'KIMATHI UNIVERISTY';
        UNIVERSITY_EXAMINATIONS_CaptionLbl: label 'UNIVERSITY EXAMINATIONS ';
        GRADUATION_LIST_SUMMARYCaptionLbl: label 'GRADUATION LIST SUMMARY';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        ProgrammeCaptionLbl: label 'Programme';
        Final_StageCaptionLbl: label 'Final Stage';
        CodeCaptionLbl: label 'Code';
        TotalCaptionLbl: label 'Total';


    procedure GetGradeStatus(var AvMarks: Decimal;var ProgCode: Code[20]) F: Boolean
    var
        LastGrade: Code[20];
        LastRemark: Code[20];
        ExitDo: Boolean;
        LastScore: Decimal;
        Gradings: Record UnknownRecord61599;
        Gradings2: Record UnknownRecord61599;
        GradeCategory: Code[20];
        GLabel: array [6] of Code[20];
        i: Integer;
        GLabel2: array [6] of Code[100];
        FStatus: Boolean;
        ProgrammeRec: Record UnknownRecord61511;
    begin
        F:=false;

        GradeCategory:='';
        ProgrammeRec.Reset;
        if ProgrammeRec.Get(ProgCode) then
        GradeCategory:=ProgrammeRec."Exam Category";
        if GradeCategory='' then Error('Please note that you must specify Exam Category in Programme Setup');

        if AvMarks > 0 then begin
        Gradings.Reset;
        Gradings.SetRange(Gradings.Category,GradeCategory);
        LastGrade:='';
        LastRemark:='';
        LastScore:=0;
        if Gradings.Find('-') then begin
        ExitDo:=false;
        repeat
        LastScore:=Gradings."Up to";
        if AvMarks < LastScore then begin
        if ExitDo = false then begin

        F:=Gradings.Failed;
        ExitDo:=true;
        end;
        end;

        until Gradings.Next = 0;


        end;

        end else begin


        end;
    end;
}

