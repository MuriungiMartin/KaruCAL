#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78085 "Special Exam Att. Checklist"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Special Exam Att. Checklist.rdlc';

    dataset
    {
        dataitem(Coregsz1;UnknownTable61532)
        {
            CalcFields = Names;
            DataItemTableView = where(Reversed=filter(No));
            PrintOnlyIfDetail = true;
            RequestFilterFields = Programme,Semester,"Student No.";
            column(ReportForNavId_7801; 7801)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(USERID;UserId)
            {
            }
            column(StdNo;Coregsz1."Student No.")
            {
            }
            column(FDesc;SValue.Name)
            {
            }
            column(ProgCode;Prog.Code)
            {
            }
            column(Prog_Description;Prog.Description)
            {
            }
            column(Names;Coregsz1.Names)
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
            column(StageCode;Coregsz1.GetFilter(Stage))
            {
            }
            column(Prog_Unit_Filter;"Unit Filter")
            {
            }
            column(AYear;Academic_Year_CaptionLbl)
            {
            }
            column(Sem;Coregsz1.Semester)
            {
            }
            column(School;School_CaptionLbl)
            {
            }
            column(Prog_Intake_Filter;'')
            {
            }
            dataitem(UnknownTable78002;UnknownTable78002)
            {
                DataItemLink = Programme=field(Programme),"Student No."=field("Student No."),Semester=field(Semester);
                DataItemTableView = where(Category=filter(Supplementary|Special));
                column(ReportForNavId_1000000014; 1000000014)
                {
                }
                column(SemCode;"Aca-Special Exams Details".Semester)
                {
                }
                dataitem(StudUnits;UnknownTable61549)
                {
                    DataItemLink = Programme=field(Programme),"Student No."=field("Student No."),Semester=field(Semester);
                    DataItemTableView = sorting("Student No.",Unit) order(ascending) where("Reg Reversed"=filter(No));
                    RequestFilterFields = Unit;
                    column(ReportForNavId_2992; 2992)
                    {
                    }
                    column(UnitCode;StudUnits.Unit)
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
                    column(Ucode;StudUnits.Unit)
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
                    column(Student_Units_Reg__Transacton_ID;"Reg. Transacton ID")
                    {
                    }
                    column(Student_Units_ENo;ENo)
                    {
                    }
                    column(Student_Units_Registered_Programe;"Registered Programe")
                    {
                    }
                    column(Student_Units_Session_Code;"Session Code")
                    {
                    }
                    column(StudSem;StudUnits.Semester)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                          "Units/Subj".Reset;
                          "Units/Subj".SetRange("Units/Subj"."Programme Code",Coregsz1.Programme);
                          "Units/Subj".SetRange("Units/Subj".Code,StudUnits.Unit);
                           if "Units/Subj".Find('-') then begin
                           UnitDesc:="Units/Subj".Desription;
                           "UnitNo.":="Units/Subj"."No. Units";
                           end;
                        RCount:=RCount+1;
                        GCount:=GCount+1;
                        //Names:='';
                    end;

                    trigger OnPreDataItem()
                    begin
                         // "Student Units".setfilter("Student Units".Unit,Programme.getfilter(Programme."Unit Filter"));
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                Names:='';
                Prog.Reset;
                Prog.SetRange(Code,Coregsz1.Programme);
                if Prog.Find('-') then;
                DValue.Reset;
                DValue.SetRange(Code,Prog."Department Code");
                if DValue.Find('-') then;


                SValue.Reset;
                SValue.SetRange(Code,Prog."School Code");
                if SValue.Find('-') then;


                Coregsz1.CalcFields("Student Name");
                // // IF Cust.GET("ACA-Student Units"."Student No.") THEN
                Names:=Coregsz1."Student Name";
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
}

