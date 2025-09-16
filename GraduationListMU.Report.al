#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51583 "Graduation List MU"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Graduation List MU.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code","Stage Filter";
            column(ReportForNavId_1410; 1410)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Programme_Description;Description)
            {
            }
            column(Graduation_ListCaption;Graduation_ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
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
                column(ReportForNavId_3691; 3691)
                {
                }
                column(Course_Registration__Student_No__Caption;"ACA-Course Registration".FieldCaption("Student No."))
                {
                }
                column(NamesCaption;NamesCaptionLbl)
                {
                }
                column(Registered__Units_Caption;Registered__Units_CaptionLbl)
                {
                }
                column(Passed_Core__Units_Caption;Passed_Core__Units_CaptionLbl)
                {
                }
                column(Passed_Electives__Units_Caption;Passed_Electives__Units_CaptionLbl)
                {
                }
                column(Failed_Core__Course_Caption;Failed_Core__Course_CaptionLbl)
                {
                }
                column(Failed_Elective__Course_Caption;Failed_Elective__Course_CaptionLbl)
                {
                }
                column(RemarksCaption;RemarksCaptionLbl)
                {
                }
                column(ClassCaption;ClassCaptionLbl)
                {
                }
                column(Average_ScoreCaption;Average_ScoreCaptionLbl)
                {
                }
                column(Programme_Stages_Programme_Code;"Programme Code")
                {
                }
                column(Programme_Stages_Code;Code)
                {
                }
                dataitem(UnknownTable61532;UnknownTable61532)
                {
                    DataItemLink = Programme=field("Programme Code"),Stage=field(Code);
                    column(ReportForNavId_2901; 2901)
                    {
                    }
                    column(Course_Registration__Student_No__;"Student No.")
                    {
                    }
                    column(Names;Names)
                    {
                    }
                    column(TotalUnits;TotalUnits)
                    {
                    }
                    column(CPassedUnits;CPassedUnits)
                    {
                    }
                    column(CFailedCourse;CFailedCourse)
                    {
                    }
                    column(EPassedUnits;EPassedUnits)
                    {
                    }
                    column(EFailedCourse;EFailedCourse)
                    {
                    }
                    column(Remark;Remark)
                    {
                    }
                    column(MRemark;MRemark)
                    {
                    }
                    column(MeanScore;MeanScore)
                    {
                    }
                    column(Course_Registration_Reg__Transacton_ID;"Reg. Transacton ID")
                    {
                    }
                    column(Course_Registration_Programme;Programme)
                    {
                    }
                    column(Course_Registration_Semester;Semester)
                    {
                    }
                    column(Course_Registration_Register_for;"Register for")
                    {
                    }
                    column(Course_Registration_Stage;Stage)
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

                    trigger OnAfterGetRecord()
                    begin
                        RCount:=RCount+1;
                        Remark:='';
                        MRemark:='';
                        Names:='';
                        MUnits:=0;


                        EPassedUnits:=0;
                        EPassedCourse:=0;
                        EFailedUnits:=0;
                        EFailedCourse:=0;
                        CPassedUnits:=0;
                        CPassedCourse:=0;
                        CFailedUnits:=0;
                        CFailedCourse:=0;
                        TotalCourse:=0;
                        TotalUnits:=0;
                        TotalScore:=0;



                        if Cust.Get("ACA-Course Registration"."Student No.") then
                        Names:=Cust.Name;



                        Grading.Reset;
                        Grading.SetRange(Grading.Category,'DEFAULT');
                        Grading.SetRange(Grading.Failed,true);
                        if Grading.Find('+') then
                        FailScore:=Grading."Up to";

                        StudUnits.Reset;
                        StudUnits.SetRange(StudUnits."Student No.","ACA-Course Registration"."Student No.");
                        StudUnits.SetRange(StudUnits.Programme,"ACA-Course Registration".Programme);
                        //StudUnits.SETFILTER(StudUnits.Stage,'Y2S1..Y4S2');
                        StudUnits.SetRange(StudUnits.Taken,true);
                        StudUnits.SetRange(StudUnits."Allow Supplementary",false);
                        StudUnits.SetRange(StudUnits.Audit,false);
                        if StudUnits.Find('-') then begin
                        repeat
                        StudUnits.CalcFields(StudUnits."Total Score");

                        TotalCourse:=TotalCourse+1;
                        TotalUnits:=TotalUnits+StudUnits."No. Of Units";
                        TotalScore:=TotalScore+StudUnits."Total Score";


                        if StudUnits."Course Type"=StudUnits."course type"::Elective then begin
                        if StudUnits."Total Score" > FailScore then begin
                        EPassedUnits:=EPassedUnits+StudUnits."No. Of Units";
                        EPassedCourse:=EPassedCourse+1;
                        end else begin
                        EFailedUnits:=EFailedUnits+StudUnits."No. Of Units";
                        EFailedCourse:=EFailedCourse+1;
                        end;

                        end else begin
                        if StudUnits."Total Score" > FailScore then begin
                        CPassedUnits:=CPassedUnits+StudUnits."No. Of Units";
                        CPassedCourse:=CPassedCourse+1;
                        end else begin
                        CFailedUnits:=CFailedUnits+StudUnits."No. Of Units";
                        CFailedCourse:=CFailedCourse+1;
                        end;


                        end;

                        until StudUnits.Next = 0;
                        end;



                        if Prog.Get("ACA-Course Registration".Programme) then begin
                        Prog.CalcFields(Prog."Mandatory Units");
                        MUnits:=Prog."Mandatory Units";
                        if Prog."Min Pass Units" <= CPassedUnits then
                        Remark:='GRADUATING'
                        else
                        Remark:='NOT GRADUATING';

                        end;

                        if EFailedCourse > 1 then
                        Remark:='NOT GRADUATING';

                        if CFailedCourse > 0 then
                        Remark:='NOT GRADUATING';




                        //Determine Class
                        if TotalScore > 0 then begin
                        if TotalCourse > 0 then
                        MeanScore:=TotalScore/TotalCourse;
                        end;

                        if MeanScore > 0 then begin
                        Gradings.Reset;
                        Gradings.SetRange(Gradings.Category,'GRAD');
                        LastGrade:='';
                        LastScore:=0;
                        if Gradings.Find('-') then begin
                        ExitDo:=false;
                        repeat
                        if MeanScore < LastScore then begin
                        if ExitDo = false then begin
                        ExitDo:=true;
                        MeanGrade:=LastGrade;
                        MRemark:=LastRemark;
                        end;
                        end;
                        LastGrade:=Gradings.Grade;
                        LastScore:=Gradings."Up to";
                        LastRemark:=Gradings.Description;

                        until Gradings.Next = 0;

                        if ExitDo = false then begin
                        Gradings2.Reset;
                        Gradings2.SetRange(Gradings2.Category,'GRAD');
                        if Gradings2.Find('+') then begin
                        MeanGrade:=Gradings2.Grade;
                        MRemark:=Gradings2.Description;
                        end;

                        end;
                        end;

                        end else begin
                        Grade:='';
                        MRemark:='';
                        end;


                        //Determine Class

                        //Check Fee Bal
                        if Cust.Get("ACA-Course Registration"."Student No.") then begin
                        Cust.CalcFields(Cust."Balance (LCY)");
                        if Cust."Balance (LCY)" > 0 then
                        Remarks:='NOT GRADUATING-FEE';

                        end;
                    end;
                }
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
        Names: Text[200];
        UnitsReg: Integer;
        UnitsPassed: Integer;
        UnitsCR: Integer;
        Grading: Record UnknownRecord61569;
        Gradings: Record UnknownRecord61569;
        Gradings2: Record UnknownRecord61569;
        StudUnits: Record UnknownRecord61549;
        FailScore: Decimal;
        Remark: Text[150];
        RCount: Integer;
        Prog: Record UnknownRecord61511;
        MUnits: Integer;
        Cust: Record Customer;
        TotalCourse: Integer;
        TotalUnits: Integer;
        EPassedUnits: Integer;
        EPassedCourse: Integer;
        EFailedUnits: Integer;
        EFailedCourse: Integer;
        CPassedUnits: Integer;
        CPassedCourse: Integer;
        CFailedUnits: Integer;
        CFailedCourse: Integer;
        TotalScore: Decimal;
        LastGrade: Code[20];
        LastScore: Decimal;
        ExitDo: Boolean;
        Desc: Text[200];
        OScore: Decimal;
        OUnits: Integer;
        MeanScore: Decimal;
        MeanGrade: Code[20];
        MRemark: Text[200];
        LastRemark: Text[200];
        Grade: Text[200];
        Graduation_ListCaptionLbl: label 'Graduation List';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        NamesCaptionLbl: label 'Names';
        Registered__Units_CaptionLbl: label 'Registered (Units)';
        Passed_Core__Units_CaptionLbl: label 'Passed Core (Units)';
        Passed_Electives__Units_CaptionLbl: label 'Passed Electives (Units)';
        Failed_Core__Course_CaptionLbl: label 'Failed Core (Course)';
        Failed_Elective__Course_CaptionLbl: label 'Failed Elective (Course)';
        RemarksCaptionLbl: label 'Remarks';
        ClassCaptionLbl: label 'Class';
        Average_ScoreCaptionLbl: label 'Average Score';
}

