#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51581 "Exam Attendance."
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Exam Attendance..rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            column(ReportForNavId_4; 4)
            {
            }
        }
        dataitem(Prog;UnknownTable61511)
        {
            DataItemTableView = sorting(Code);
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Code","Stage Filter","Semester Filter","Unit Filter","Intake Filter";
            column(ReportForNavId_7801; 7801)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(USERID;UserId)
            {
            }
            column(FDesc;FDesc)
            {
            }
            column(Prog_Description;Description)
            {
            }
            column(Dept;Dept)
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
            column(Prog_Code;Code)
            {
            }
            column(Prog_Semester_Filter;"Semester Filter")
            {
            }
            column(Prog_Stage_Filter;"Stage Filter")
            {
            }
            column(Prog_Unit_Filter;"Unit Filter")
            {
            }
            column(CompName;cOMPiNF.Name)
            {
            }
            column(CompLogo;cOMPiNF.Picture)
            {
            }
            column(Prog_Intake_Filter;"Intake Filter")
            {
            }
            dataitem(UnknownTable61549;UnknownTable61549)
            {
                DataItemLink = Programme=field(Code);
                DataItemTableView = sorting("Student No.",Unit) order(ascending);
                column(ReportForNavId_2992; 2992)
                {
                }
                column(Student_Units__Student_Units__Unit;"ACA-Student Units".Unit)
                {
                }
                column(UnitDesc;UnitDesc)
                {
                }
                column(CurrReport_PAGENO;CurrReport.PageNo)
                {
                }
                column(Student_Units__Student_No__;"ACA-Student Units"."Student No.")
                {
                }
                column(RCount;RCount)
                {
                }
                column(Names;Names)
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
                column(Student_Units_Semester;Semester)
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
                column(Unit_StudentUnits;"ACA-Student Units".Unit)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    RCount:=RCount+1;
                    GCount:=GCount+1;
                    Names:='';

                    if Cust.Get("ACA-Student Units"."Student No.") then
                    Names:=Cust.Name;
                end;

                trigger OnPreDataItem()
                begin
                    // "Student Units".setfilter("Student Units".Unit,Programme.getfilter(Programme."Unit Filter"));
                      "Units/Subj".Reset;
                      "Units/Subj".SetRange("Units/Subj"."Programme Code",Prog.Code);
                      "Units/Subj".SetRange("Units/Subj".Code,Prog.GetFilter(Prog."Unit Filter"));
                       if "Units/Subj".Find('-') then begin
                       UnitDesc:="Units/Subj".Desription;
                       "UnitNo.":="Units/Subj"."No. Units";
                       end;
                end;
            }

            trigger OnAfterGetRecord()
            begin

                FDesc:='';
                Dept:='';


                DValue.Reset;
                DValue.SetRange(DValue.Code,Prog."School Code");
                if DValue.Find('-') then
                FDesc:=DValue.Name;

                DValue.Reset;
                DValue.SetRange(DValue.Code,Prog."Department Code");
                if DValue.Find('-') then
                Dept:=DValue.Name;

                RCount:=0;
            end;

            trigger OnPreDataItem()
            begin
                   cOMPiNF.Get;
                   cOMPiNF.CalcFields(Picture);
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
        RCount: Integer;
        Cust: Record Customer;
        Names: Text[200];
        DValue: Record "Dimension Value";
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
        cOMPiNF: Record "Company Information";
}

