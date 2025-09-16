#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 77226 "Supp. Exam Attendance Cklst"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Supp. Exam Attendance Cklst.rdlc';

    dataset
    {
        dataitem(StudUnits;UnknownTable78002)
        {
            DataItemTableView = sorting("Student No.","Unit Code","Academic Year",Semester,Sequence,Category) order(ascending);
            RequestFilterFields = Semester,Programme,"Unit Code";
            column(ReportForNavId_2992; 2992)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(USERID;UserId)
            {
            }
            column(StdNo;StudUnits."Student No.")
            {
            }
            column(FDesc;SValue.Name)
            {
            }
            column(seqs;seqs)
            {
            }
            column(ProgCode;Prog.Code)
            {
            }
            column(Prog_Description;Prog.Description)
            {
            }
            column(Names;Cust.Name)
            {
            }
            column(Dept;DValue.Name)
            {
            }
            column(Prog_GETFILTER__Exam_Date__;Today)
            {
            }
            column(Examination_Attendance_ChecklistCaption;Examination_Attendance_ChecklistCaptionLbl)
            {
            }
            column(School_Caption;School_CaptionLbl)
            {
            }
            column(Programme_of_Study_Caption;Programme_of_Study_CaptionLbl)
            {
            }
            column(Department_Caption;Department_CaptionLbl)
            {
            }
            column(Exam_Date_Caption;Exam_Date_CaptionLbl)
            {
            }
            column(Academic_Year_Caption;Academic_Year_CaptionLbl)
            {
            }
            column(Prog_Code;Prog.Code)
            {
            }
            column(SemCode;StudUnits.Semester)
            {
            }
            column(StageCode;StudUnits.Stage)
            {
            }
            column(Prog_Unit_Filter;StudUnits.GetFilter("Unit Code"))
            {
            }
            column(AYear;Academic_Year_CaptionLbl)
            {
            }
            column(Sem;StudUnits.Semester)
            {
            }
            column(School;School_CaptionLbl)
            {
            }
            column(Prog_Intake_Filter;'')
            {
            }
            column(UnitCode;StudUnits."Unit Code")
            {
            }
            column(UnitDesc;"Units/Subj".Desription)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(UnitSubj;"Units/Subj".Code)
            {
            }
            column(Student_Units__Student_No__;"Student No.")
            {
            }
            column(RCount;RCount)
            {
            }
            column(Ucode;StudUnits."Unit Code")
            {
            }
            column(RCount_Control1000000002;RCount)
            {
            }
            column(GCount;GCount)
            {
            }
            column(Title_of_Paper_Caption;Title_of_Paper_CaptionLbl)
            {
            }
            column(Registration_NumberCaption;Registration_NumberCaptionLbl)
            {
            }
            column(Serial_NumberCaption;Serial_NumberCaptionLbl)
            {
            }
            column(Name_of_CandidateCaption;Name_of_CandidateCaptionLbl)
            {
            }
            column(SignCaption;SignCaptionLbl)
            {
            }
            column(RemarksCaption;RemarksCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(NAME_OF_INVIGILATORSCaption;NAME_OF_INVIGILATORSCaptionLbl)
            {
            }
            column(V1___________________________________________________Caption;V1___________________________________________________CaptionLbl)
            {
            }
            column(CHIEF_INVIGILATOR_SIGNATURECaption;CHIEF_INVIGILATOR_SIGNATURECaptionLbl)
            {
            }
            column(TOTAL_NO_OF_CANDIDATES_ON_THE_SHEETCaption;TOTAL_NO_OF_CANDIDATES_ON_THE_SHEETCaptionLbl)
            {
            }
            column(GRAND_TOTALCaption;GRAND_TOTALCaptionLbl)
            {
            }
            column(EmptyStringCaption;EmptyStringCaptionLbl)
            {
            }
            column(V2___________________________________________________Caption;V2___________________________________________________CaptionLbl)
            {
            }
            column(V3___________________________________________________Caption;V3___________________________________________________CaptionLbl)
            {
            }
            column(Student_Units_Programme;Programme)
            {
            }
            column(Student_Units_Stage;Stage)
            {
            }
            column(Student_Units_Semester;StudUnits.Semester)
            {
            }
            column(Student_Units_Reg__Transacton_ID;StudUnits.Sequence)
            {
            }
            column(Student_Units_ENo;StudUnits.Sequence)
            {
            }
            column(Student_Units_Registered_Programe;StudUnits.Programme)
            {
            }
            column(Student_Units_Session_Code;StudUnits."Exam Session")
            {
            }
            column(StudSem;StudUnits.Semester)
            {
            }

            trigger OnAfterGetRecord()
            begin
                 Names:='';
                Prog.Reset;
                Prog.SetRange(Code,StudUnits.Programme);
                if Prog.Find('-') then;
                DValue.Reset;
                DValue.SetRange(Code,Prog."Department Code");
                if DValue.Find('-') then;


                SValue.Reset;
                SValue.SetRange(Code,Prog."School Code");
                if SValue.Find('-') then;


                Clear(Cust);
                if Cust.Get(StudUnits."Student No.") then;
                // // IF Cust.GET("ACA-Student Units"."Student No.") THEN
                Names:=Cust.Name;

                  "Units/Subj".Reset;
                  "Units/Subj".SetRange("Units/Subj"."Programme Code",StudUnits.Programme);
                  "Units/Subj".SetRange("Units/Subj".Code,StudUnits."Unit Code");
                   if "Units/Subj".Find('-') then begin
                   UnitDesc:="Units/Subj".Desription;
                   "UnitNo.":="Units/Subj"."No. Units";
                   end;
                RCount:=RCount+1;
                GCount:=GCount+1;
                //Names:='';
                ACASuppAttendanceSequence.Init;
                ACASuppAttendanceSequence."Programme Code" := StudUnits.Programme;
                ACASuppAttendanceSequence."Unit Code" := StudUnits."Unit Code";
                ACASuppAttendanceSequence."Student No.":=StudUnits."Student No.";
                ACASuppAttendanceSequence.User_ID := UserId;
                if ACASuppAttendanceSequence.Insert(true) then;

                Clear(seqs);
                Clear(ACASuppAttendanceSequence2);
                ACASuppAttendanceSequence2.Reset;
                ACASuppAttendanceSequence2.SetRange(User_ID,UserId);
                ACASuppAttendanceSequence2.SetRange("Unit Code",StudUnits."Unit Code");
                ACASuppAttendanceSequence2.SetRange("Programme Code",StudUnits.Programme);
                ACASuppAttendanceSequence2.SetRange("Student No.",StudUnits."Student No.");
                if ACASuppAttendanceSequence2.Find('-') then begin
                  seqs := ACASuppAttendanceSequence2."Seq.";
                  end;
            end;

            trigger OnPreDataItem()
            begin
                 // "Student Units".setfilter("Student Units".Unit,Programme.getfilter(Programme."Unit Filter"));
                 if StudUnits.GetFilter(Semester) = '' then Error('Semester Filter is missing');
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

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
        Clear(ACASuppAttendanceSequence);
        ACASuppAttendanceSequence.Reset;
        ACASuppAttendanceSequence.SetRange(User_ID,UserId);
        if ACASuppAttendanceSequence.Find('-') then ACASuppAttendanceSequence.DeleteAll;
    end;

    var
        RCount: Integer;
        Cust: Record Customer;
        Names: Text[200];
        DValue: Record "Dimension Value";
        SValue: Record "Dimension Value";
        FacultyR: Record UnknownRecord61587;
        FDesc: Text[200];
        Dept: Text[200];
        UnitDesc: Text[100];
        "UnitNo.": Decimal;
        "Units/Subj": Record UnknownRecord61517;
        GCount: Integer;
        Examination_Attendance_ChecklistCaptionLbl: label 'Examination Attendance Checklist';
        School_CaptionLbl: label 'School:';
        Programme_of_Study_CaptionLbl: label 'Programme of Study:';
        Department_CaptionLbl: label 'Department:';
        Exam_Date_CaptionLbl: label 'Exam Date:';
        Academic_Year_CaptionLbl: label 'Academic Year:';
        Title_of_Paper_CaptionLbl: label 'Title of Paper:';
        Registration_NumberCaptionLbl: label 'Registration Number';
        Serial_NumberCaptionLbl: label 'Serial Number';
        Name_of_CandidateCaptionLbl: label 'Name of Candidate';
        SignCaptionLbl: label 'Sign';
        RemarksCaptionLbl: label 'Remarks';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        NAME_OF_INVIGILATORSCaptionLbl: label 'NAME OF INVIGILATORS';
        V1___________________________________________________CaptionLbl: label '1. .................................................';
        CHIEF_INVIGILATOR_SIGNATURECaptionLbl: label 'CHIEF INVIGILATOR SIGNATURE';
        TOTAL_NO_OF_CANDIDATES_ON_THE_SHEETCaptionLbl: label 'TOTAL NO OF CANDIDATES ON THE SHEET';
        GRAND_TOTALCaptionLbl: label 'GRAND TOTAL';
        EmptyStringCaptionLbl: label '...................................................................';
        V2___________________________________________________CaptionLbl: label '2. .................................................';
        V3___________________________________________________CaptionLbl: label '3. .................................................';
        Prog: Record UnknownRecord61511;
        ACASuppAttendanceSequence: Record UnknownRecord77769;
        ACASuppAttendanceSequence2: Record UnknownRecord77769;
        seqs: Integer;
}

