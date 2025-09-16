#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51554 "Student Transcript"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Student Transcript.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = where("Customer Type"=const(Student));
            RequestFilterFields = "No.";
            column(ReportForNavId_6836; 6836)
            {
            }
            column(Prog_Description;Prog.Description)
            {
            }
            column(Customer_Customer_Name;Customer.Name)
            {
            }
            column(Customer_Customer__No__;Customer."No.")
            {
            }
            column(RemarkCaption;RemarkCaptionLbl)
            {
            }
            column(GradeCaption;GradeCaptionLbl)
            {
            }
            column(DescriptionCaption;DescriptionCaptionLbl)
            {
            }
            column(Student_No_Caption;Student_No_CaptionLbl)
            {
            }
            column(ACADEMIC_TRANSCRIPTCaption;ACADEMIC_TRANSCRIPTCaptionLbl)
            {
            }
            column(ProgrammeCaption;ProgrammeCaptionLbl)
            {
            }
            column(Student_Name_Caption;Student_Name_CaptionLbl)
            {
            }
            column(Units_CodeCaption;Units_CodeCaptionLbl)
            {
            }
            column(KARATINA_UNIVERSITYCaption;KARATINA_UNIVERSITYCaptionLbl)
            {
            }
            dataitem(UnknownTable61549;UnknownTable61549)
            {
                DataItemLink = "Student No."=field("No.");
                RequestFilterFields = "Reg. Transacton ID",Programme,Stage,Semester;
                column(ReportForNavId_2992; 2992)
                {
                }
                column(Student_Units_Unit;Unit)
                {
                }
                column(UDesc;UDesc)
                {
                }
                column(Student_Units_Grade;Grade)
                {
                }
                column(Student_Units_Remarks;Remarks)
                {
                }
                column(Student_Units__Total_Score_;"Total Score")
                {
                }
                column(MeanGrade;MeanGrade)
                {
                }
                column(Mean_Grade_Caption;Mean_Grade_CaptionLbl)
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
                    UDesc:='';
                    Units.Reset;
                    Units.SetRange(Units."Programme Code","ACA-Student Units".Programme);
                    Units.SetRange(Units.Code,Unit);
                    if Units.Find('-') then
                    UDesc:=Units.Desription;

                    if "ACA-Student Units".Taken = true then begin



                    if "ACA-Student Units"."Total Score" > 0 then begin
                    Gradings.Reset;
                    Gradings.SetRange(Gradings.Category,'DEFAULT');
                    LastGrade:='';
                    LastRemark:='';
                    LastScore:=0;
                    if Gradings.Find('-') then begin
                    ExitDo:=false;
                    repeat
                    if "ACA-Student Units"."Total Score" < LastScore then begin
                    if ExitDo = false then begin
                    ExitDo:=true;
                    Grade:=LastGrade;
                    Remarks:=LastRemark;
                    end;
                    end;
                    LastGrade:=Gradings.Grade;
                    LastScore:=Gradings."Up to";
                    if Gradings.Failed = true then
                    LastRemark:='Suplimentary'
                    else
                    LastRemark:=Gradings.Remarks;

                    until Gradings.Next = 0;

                    if ExitDo = false then begin
                    Gradings2.Reset;
                    Gradings2.SetRange(Gradings2.Category,'DEFAULT');
                    if Gradings2.Find('+') then begin
                    Grade:=Gradings2.Grade;
                    Remarks:=Gradings2.Remarks;
                    end;

                    end;
                    end;

                    end else begin
                    Grade:='';
                    Remarks:='Not Done';
                    end;


                    OUnits:=OUnits + 1;
                    OScore:=OScore + "ACA-Student Units"."Total Score";

                    end else begin
                    Grade:='';
                    Remarks:='**Exempted**';


                    end;
                end;
            }
            dataitem(UnknownTable61569;UnknownTable61569)
            {
                column(ReportForNavId_6400; 6400)
                {
                }
                column(Grading_System_Setup1_Description;Description)
                {
                }
                column(Grading_System_Setup1_Remarks;Remarks)
                {
                }
                column(Grading_System_Setup1__Grading_System_Setup1__Grade;"ACA-Grading System Setup1".Grade)
                {
                }
                column(Grading_System_Setup1_RemarksCaption;FieldCaption(Remarks))
                {
                }
                column(MarksCaption;MarksCaptionLbl)
                {
                }
                column(Key_to_Grading_System_Caption;Key_to_Grading_System_CaptionLbl)
                {
                }
                column(GradeCaption_Control1102760044;GradeCaption_Control1102760044Lbl)
                {
                }
                column(Date_________________________________________________________________________________________________Caption;Date_________________________________________________________________________________________________CaptionLbl)
                {
                }
                column(Date__________________________________________________________________________________________________________Caption;Date__________________________________________________________________________________________________________CaptionLbl)
                {
                }
                column(DataItem1102760023;HOD______________________________________________________________________________________________________________________CaptLbl)
                {
                }
                column(Register_________________________________________________________________________________________________Caption;Register_________________________________________________________________________________________________CaptionLbl)
                {
                }
                column(Signed_Caption;Signed_CaptionLbl)
                {
                }
                column(Grading_System_Setup1_Category;Category)
                {
                }
                column(Grading_System_Setup1_Up_to;"Up to")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin

                CReg.Reset;
                CReg.SetRange(CReg."Student No.",Customer."No.");
                if CReg.Find('+') then begin
                if Prog.Get(CReg.Programme) then
                RFound:=true;

                end;

                OUnits:=0;
                OScore:=0;
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
        Stages: Record UnknownRecord61516;
        RFound: Boolean;
        UDesc: Text[200];
        Units: Record UnknownRecord61517;
        Result: Decimal;
        Grade: Text[150];
        Remarks: Text[150];
        Gradings: Record UnknownRecord61569;
        Gradings2: Record UnknownRecord61569;
        TotalScore: Decimal;
        LastGrade: Code[20];
        LastScore: Decimal;
        ExitDo: Boolean;
        Desc: Text[200];
        OScore: Decimal;
        OUnits: Integer;
        MeanScore: Decimal;
        MeanGrade: Code[20];
        LastRemark: Text[200];
        CReg: Record UnknownRecord61532;
        RemarkCaptionLbl: label 'Remark';
        GradeCaptionLbl: label 'Grade';
        DescriptionCaptionLbl: label 'Description';
        Student_No_CaptionLbl: label 'Student No.';
        ACADEMIC_TRANSCRIPTCaptionLbl: label 'ACADEMIC TRANSCRIPT';
        ProgrammeCaptionLbl: label 'Programme';
        Student_Name_CaptionLbl: label 'Student Name:';
        Units_CodeCaptionLbl: label 'Units Code';
        KARATINA_UNIVERSITYCaptionLbl: label 'KARATINA UNIVERSITY';
        Mean_Grade_CaptionLbl: label 'Mean Grade:';
        MarksCaptionLbl: label 'Marks';
        Key_to_Grading_System_CaptionLbl: label 'Key to Grading System:';
        GradeCaption_Control1102760044Lbl: label 'Grade';
        Date_________________________________________________________________________________________________CaptionLbl: label 'Date:  ..............................................................................................';
        Date__________________________________________________________________________________________________________CaptionLbl: label 'Date:  .......................................................................................................';
        HOD______________________________________________________________________________________________________________________CaptLbl: label 'HOD:  ...................................................................................................................';
        Register_________________________________________________________________________________________________CaptionLbl: label 'Register:  ..............................................................................................';
        Signed_CaptionLbl: label 'Signed:';
}

