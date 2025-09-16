#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51579 "Consolidated Marksheet"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Consolidated Marksheet.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = sorting("Student No.",Programme,Semester,"Register for",Stage,Unit,"Student Type");
            RequestFilterFields = "Programme Filter",Stage,"Stage Filter","Options Filter","Cummulative Year Filter","Student No.",Session;
            column(ReportForNavId_2901; 2901)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(SDesc;SDesc)
            {
            }
            column(FDesc;FDesc)
            {
            }
            column(Dept;Dept)
            {
            }
            column(PName;PName)
            {
            }
            column(Comb;Comb)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(USERID;UserId)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(Course_Registration_Session;Session)
            {
            }
            column(ColumnH_1_;ColumnH[1])
            {
            }
            column(ColumnH_8_;ColumnH[8])
            {
            }
            column(ColumnH_6_;ColumnH[6])
            {
            }
            column(ColumnH_7_;ColumnH[7])
            {
            }
            column(ColumnH_4_;ColumnH[4])
            {
            }
            column(ColumnH_3_;ColumnH[3])
            {
            }
            column(ColumnH_5_;ColumnH[5])
            {
            }
            column(ColumnH_2_;ColumnH[2])
            {
            }
            column(ColumnH_15_;ColumnH[15])
            {
            }
            column(ColumnH_14_;ColumnH[14])
            {
            }
            column(ColumnH_13_;ColumnH[13])
            {
            }
            column(ColumnH_12_;ColumnH[12])
            {
            }
            column(ColumnH_10_;ColumnH[10])
            {
            }
            column(ColumnH_9_;ColumnH[9])
            {
            }
            column(ColumnH_11_;ColumnH[11])
            {
            }
            column(ColumnH_23_;ColumnH[23])
            {
            }
            column(ColumnH_22_;ColumnH[22])
            {
            }
            column(ColumnH_21_;ColumnH[21])
            {
            }
            column(ColumnH_20_;ColumnH[20])
            {
            }
            column(ColumnH_19_;ColumnH[19])
            {
            }
            column(ColumnH_18_;ColumnH[18])
            {
            }
            column(ColumnH_17_;ColumnH[17])
            {
            }
            column(ColumnH_16_;ColumnH[16])
            {
            }
            column(uColumnV_1_;uColumnV[1])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_2_;uColumnV[2])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_3_;uColumnV[3])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_4_;uColumnV[4])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_5_;uColumnV[5])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_6_;uColumnV[6])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_7_;uColumnV[7])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_8_;uColumnV[8])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_9_;uColumnV[9])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_10_;uColumnV[10])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_11_;uColumnV[11])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_12_;uColumnV[12])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_13_;uColumnV[13])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_14_;uColumnV[14])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_15_;uColumnV[15])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_16_;uColumnV[16])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_17_;uColumnV[17])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_18_;uColumnV[18])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_19_;uColumnV[19])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_20_;uColumnV[20])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_21_;uColumnV[21])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_22_;uColumnV[22])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_23_;uColumnV[23])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_30_;uColumnV[30])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_29_;uColumnV[29])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_28_;uColumnV[28])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_26_;ColumnH[26])
            {
            }
            column(ColumnH_30_;ColumnH[30])
            {
            }
            column(ColumnH_29_;ColumnH[29])
            {
            }
            column(ColumnH_28_;ColumnH[28])
            {
            }
            column(uColumnV_27_;uColumnV[27])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_27_;ColumnH[27])
            {
            }
            column(uColumnV_26_;uColumnV[26])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_25_;ColumnH[25])
            {
            }
            column(uColumnV_25_;uColumnV[25])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_24_;ColumnH[24])
            {
            }
            column(uColumnV_24_;uColumnV[24])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_1_;sColumnV[1])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_2_;sColumnV[2])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_3_;sColumnV[3])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_4_;sColumnV[4])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_5_;sColumnV[5])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_6_;sColumnV[6])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_7_;sColumnV[7])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_8_;sColumnV[8])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_9_;sColumnV[9])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_10_;sColumnV[10])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_11_;sColumnV[11])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_12_;sColumnV[12])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_13_;sColumnV[13])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_14_;sColumnV[14])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_15_;sColumnV[15])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_16_;sColumnV[16])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_17_;sColumnV[17])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_18_;sColumnV[18])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_19_;sColumnV[19])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_20_;sColumnV[20])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_21_;sColumnV[21])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_22_;sColumnV[22])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_23_;sColumnV[23])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_24_;sColumnV[24])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_25_;sColumnV[25])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_26_;sColumnV[26])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_27_;sColumnV[27])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_28_;sColumnV[28])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_29_;sColumnV[29])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_30_;sColumnV[30])
            {
                DecimalPlaces = 0:0;
            }
            column(Course_Registration__Student_No__;"Student No.")
            {
            }
            column(Cust_Name;Cust.Name)
            {
            }
            column(ColumnV_1_;ColumnV[1])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_8_;ColumnV[8])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_7_;ColumnV[7])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_6_;ColumnV[6])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_5_;ColumnV[5])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_4_;ColumnV[4])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_3_;ColumnV[3])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_2_;ColumnV[2])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_14_;ColumnV[14])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_13_;ColumnV[13])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_12_;ColumnV[12])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_11_;ColumnV[11])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_10_;ColumnV[10])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_9_;ColumnV[9])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_23_;ColumnV[23])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_22_;ColumnV[22])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_21_;ColumnV[21])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_20_;ColumnV[20])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_19_;ColumnV[19])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_18_;ColumnV[18])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_17_;ColumnV[17])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_16_;ColumnV[16])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_15_;ColumnV[15])
            {
                DecimalPlaces = 0:0;
            }
            column(SCount;SCount)
            {
            }
            column(ColumnV_30_;ColumnV[30])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_29_;ColumnV[29])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_28_;ColumnV[28])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_27_;ColumnV[27])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_26_;ColumnV[26])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_25_;ColumnV[25])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_24_;ColumnV[24])
            {
                DecimalPlaces = 0:0;
            }
            column(Consolidated_MarksheetCaption;Consolidated_MarksheetCaptionLbl)
            {
            }
            column(Year_of_Study_Caption;Year_of_Study_CaptionLbl)
            {
            }
            column(Faculty_Caption;Faculty_CaptionLbl)
            {
            }
            column(Department_Caption;Department_CaptionLbl)
            {
            }
            column(Programme_of_Study_Caption;Programme_of_Study_CaptionLbl)
            {
            }
            column(Combination_Caption;Combination_CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Intake_Caption;Intake_CaptionLbl)
            {
            }
            column(Registration_No_Caption;Registration_No_CaptionLbl)
            {
            }
            column(NamesCaption;NamesCaptionLbl)
            {
            }
            column(UNITS__Caption;UNITS__CaptionLbl)
            {
            }
            column(Serial_No_Caption;Serial_No_CaptionLbl)
            {
            }
            column(Guide_on_remarks_Caption;Guide_on_remarks_CaptionLbl)
            {
            }
            column(DataItem1102760088;P___Proceed_to_next_year___Graduate____________Q___Take_resit_exam_in_papers_failed____________R___Repeat_the_year_CaptionLbl)
            {
            }
            column(DataItem1102760089;S___Special_Exam____________T___Retake_failed_courses____________U___Missing_Marks________________Less_courses____________Z__Lbl)
            {
            }
            column(DataItem1102760090;Course_Categories______missing_marks______________Core_Required______________Elective______________Retake______________AuditCLbl)
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
                i:=0;
                TScore:=0;
                RUnits:=0;
                MissingM:=false;
                MCourse := false;
                
                
                i:=0;
                repeat
                i := i + 1;
                ColumnV[i]:='';
                until i = 80;
                i:=0;
                
                
                
                if Dept = '' then begin
                if Prog.Get("ACA-Course Registration".Programme) then begin
                PName:=Prog.Description;
                if FacultyR.Get(Prog.Faculty) then
                FDesc:=FacultyR.Description;
                
                DValue.Reset;
                DValue.SetRange(DValue.Code,Prog."School Code");
                if DValue.Find('-') then
                Dept:=DValue.Name;
                
                end;
                
                if Stages.Get("ACA-Course Registration".Programme,"ACA-Course Registration".Stage) then
                SDesc:=Stages.Description;
                
                if ProgOptions.Get("ACA-Course Registration".Programme,"ACA-Course Registration".Stage,GetFilter("Options Filter")) then
                Comb:=ProgOptions.Desription;
                
                
                end;
                
                
                "ACA-Course Registration".CalcFields("ACA-Course Registration"."Units Taken","ACA-Course Registration"."Units Passed",
                                                 "ACA-Course Registration"."Units Failed","ACA-Course Registration"."Cummulative Score",
                                                 "ACA-Course Registration"."Cummulative Units Taken");
                
                UnitsR.Reset;
                UnitsR.SetRange(UnitsR.Show,true);
                UnitsR.SetFilter(UnitsR."Student No. Filter","ACA-Course Registration"."Student No.");
                UnitsR.SetFilter(UnitsR."Stage Filter",GetFilter("Stage Filter"));
                ////UnitsR.SETFILTER(UnitsR."Reg. ID Filter","Course Registration"."Reg. Transacton ID");
                if UnitsR.Find('-') then begin
                repeat
                USkip := false;
                
                //Check if option
                
                /*
                IF UnitsR."Programme Option" <> '' THEN BEGIN
                IF UnitsR."Programme Option" <> "Course Registration".Options THEN
                USkip := TRUE;
                END;
                */
                //Check if option
                
                
                if USkip = false then begin
                Grade:='';
                UnitsR.CalcFields(UnitsR."Total Score",UnitsR."Unit Registered",UnitsR."Re-Sit",UnitsR.Audit);
                //Grades
                if UnitsR."Total Score" > 0 then begin
                Gradings.Reset;
                Gradings.SetRange(Gradings.Category,'DEFAULT');
                LastGrade:='';
                LastRemark:='';
                LastScore:=0;
                if Gradings.Find('-') then begin
                ExitDo:=false;
                repeat
                if UnitsR."Total Score" < LastScore then begin
                if ExitDo = false then begin
                Grade:=LastGrade;
                Remarks:=LastRemark;
                ExitDo:=true;
                end;
                end;
                LastGrade:=Gradings.Grade;
                LastScore:=Gradings."Up to";
                if Gradings.Failed = true then
                LastRemark:='Supplementary'
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
                
                
                //Grades
                //Course Category
                if UnitsR."Unit Type" = UnitsR."unit type"::Elective then
                CCat:='-'
                else
                CCat:='=';
                
                if UnitsR."Re-Sit" > 0 then
                CCat:='+';
                
                if UnitsR.Audit > 0 then
                CCat:='#';
                
                
                //Check if unit done
                if UnitsR."Unit Registered" <= 1 then
                CCat:='--';
                
                
                
                //Course Category
                
                
                i:=i+1;
                ColumnH[i]:=UnitsR.Code;
                uColumnV[i]:=Format(UnitsR."No. Units");
                sColumnV[i]:=CopyStr(UnitsR."Stage Code",3,2);
                if UnitsR."Total Score" = 0 then
                if CCat = '--' then
                ColumnV[i]:=''
                else begin
                MissingM:=true;
                MCourse := true;
                ColumnV[i]:='---';
                RUnits:=RUnits+UnitsR."No. Units";
                
                
                
                end
                else begin
                ColumnV[i]:=Format(ROUND(UnitsR."Total Score",1,'=')) + CCat + Grade;
                TScore:=TScore+UnitsR."Total Score";
                RUnits:=RUnits+UnitsR."No. Units";
                end;
                
                if DMarks = true then
                i:=0;
                
                end;
                until UnitsR.Next = 0;
                end;
                
                SCount:=SCount+1;
                
                
                
                if Cust.Get("ACA-Course Registration"."Student No.") then
                
                //Generate Summary
                UTaken:=0;
                UPassed:=0;
                UFailed:=0;
                CAve:=0;
                
                if DSummary = false then begin
                
                //Jump one column
                
                i:=i+1;
                ColumnH[i]:='';
                ColumnV[i]:='';
                
                
                CReg.Reset;
                CReg.SetRange(CReg."Student No.","ACA-Course Registration"."Student No.");
                CReg.SetFilter(CReg.Stage,GetFilter("ACA-Course Registration"."Stage Filter"));
                if CReg.Find('-') then begin
                repeat
                CReg.CalcFields(CReg."Units Taken",CReg."Units Passed",
                                                 CReg."Units Failed");
                
                UTaken:=UTaken+CReg."Units Taken";
                UPassed:=UPassed+CReg."Units Passed";
                UFailed:=UFailed+CReg."Units Failed";
                
                until CReg.Next = 0;
                end;
                
                
                
                
                i:=i+1;
                //calculate yearly average GR
                ColumnH[i]:='YEAR AVER';
                if UTaken > 0 then
                ColumnV[i]:=Format(ROUND(TScore/UTaken,1,'='));
                
                //ColumnV[i]:=FORMAT(ROUND(YearScore/CourseCount,1,'='));
                //CAve:=ROUND(YearScore/CourseCount,1,'=');
                
                
                
                if UTaken > 0 then begin
                //Calc Average (best 14 units)
                CAve:=0;
                UnitCount:=0;
                YearScore:=0;
                CourseCount:=0;
                DontCont:=false;
                
                StudUnits2.Reset;
                StudUnits2.SetCurrentkey(StudUnits2."Student No.",StudUnits2."Final Score");
                StudUnits2.Ascending:=false;
                StudUnits2.SetRange(StudUnits2."Student No.","ACA-Course Registration"."Student No.");
                StudUnits2.SetRange(StudUnits2."Unit Type",StudUnits2."unit type"::Core);
                StudUnits2.SetFilter(StudUnits2.Stage,"ACA-Course Registration".GetFilter("ACA-Course Registration"."Cummulative Year Filter"));
                //StudUnits2.SETRANGE(StudUnits2."Reg. Transacton ID","Course Registration"."Reg. Transacton ID");
                if StudUnits2.Find('-') then begin
                repeat
                if UnitCount < 14 then begin
                //MESSAGE('%1',StudUnits2."Final Score");
                
                CourseCount:=CourseCount+1;
                UnitCount:=UnitCount+1;//StudUnits2."No. Of Units";
                YearScore:=YearScore+StudUnits2."Final Score";
                
                
                //ColumnV[i]:=FORMAT(ROUND(YearScore/CourseCount,1,'='));
                CAve:=ROUND(YearScore/CourseCount,1,'=');
                
                
                end else
                DontCont:=true;
                until StudUnits2.Next = 0;
                end;
                
                if DontCont = false then begin
                StudUnits2.Reset;
                StudUnits2.SetCurrentkey(StudUnits2."Student No.",StudUnits2."Final Score");
                StudUnits2.Ascending:=false;
                StudUnits2.SetRange(StudUnits2."Student No.","ACA-Course Registration"."Student No.");
                StudUnits2.SetRange(StudUnits2."Unit Type",StudUnits2."unit type"::Elective);
                StudUnits2.SetFilter(StudUnits2.Stage,"ACA-Course Registration".GetFilter("ACA-Course Registration"."Cummulative Year Filter"));
                //StudUnits2.SETRANGE(StudUnits2."Reg. Transacton ID","Course Registration"."Reg. Transacton ID");
                if StudUnits2.Find('-') then begin
                repeat
                if UnitCount < 14 then begin
                //MESSAGE('%1',StudUnits2."Final Score");
                CourseCount:=CourseCount+1;
                UnitCount:=UnitCount+1;//StudUnits2."No. Of Units";
                YearScore:=YearScore+StudUnits2."Final Score";
                
                //ColumnV[i]:=FORMAT(ROUND(YearScore/CourseCount,1,'='));
                CAve:=ROUND(YearScore/CourseCount,1,'=');
                
                end else
                DontCont:=true;
                until StudUnits2.Next = 0;
                end;
                end;
                
                
                //Calc Average (best 14 units)
                
                
                end;
                
                
                i:=i+1;
                ColumnH[i]:='%Unt Passed';
                if UTaken > 0 then
                ColumnV[i]:=Format(ROUND(UPassed/UTaken*100,1,'='));
                
                
                i:=i+1;
                ColumnH[i]:='Reg Units';
                ColumnV[i]:=Format(RUnits);
                
                i:=i+1;
                ColumnH[i]:='Papers Failed';
                ColumnV[i]:=Format(UFailed);
                
                i:=i+1;
                ColumnH[i]:='Cumm Aver';
                if "ACA-Course Registration"."Cummulative Units Taken" > 0 then
                ColumnV[i]:=Format(ROUND(CAve,1,'='));
                //ColumnV[i]:=FORMAT(ROUND("Course Registration"."Cummulative Score"/"Course Registration"."Cummulative Units Taken",1,'='));
                //ColumnV[i]:=FORMAT(ROUND("Course Registration"."Cummulative Score"/UTaken,1,'='));
                
                i:=i+1;
                ColumnH[i]:='Srg Rmk';
                if UFailed = 0 then begin
                ColumnV[i]:='P';
                end;
                
                if UFailed > 0 then begin
                ColumnV[i]:='Q';
                end;
                
                if MCourse = true then
                ColumnV[i]:='U';
                
                
                if Prog.Get("ACA-Course Registration".Programme) then begin
                if "ACA-Course Registration"."Units Taken" < Prog."Min No. of Courses" then
                ColumnV[i]:='?';
                end;
                
                if Cust.Status=Cust.Status::Discontinued then
                ColumnV[i]:='Z';
                
                if (UTaken < 1) or ((UPassed<14) and (ColumnV[i]='P')) then   //BKK
                ColumnV[i]:='?';
                
                
                i:=i+1;
                ColumnH[i]:='Brd Rmk';
                ColumnV[i]:='';
                
                
                
                
                end;
                //Generate Summary

            end;

            trigger OnPreDataItem()
            begin
                SCount:=0;
                Session:=CReg.Session;
                "ACA-Course Registration".SetFilter(Programme,GetFilter("Programme Filter"));
                //PKK "Course Registration".SETFILTER(Stage,GETFILTER("Stage Filter"));
                "ACA-Course Registration".SetFilter(Options,GetFilter("Options Filter"));
                
                UnitsR.Reset;
                UnitsR.ModifyAll(UnitsR.Show,false);
                
                CReg.Reset;
                CReg.SetFilter(CReg.Programme,GetFilter("Programme Filter"));
                CReg.SetFilter(CReg.Stage,GetFilter("Stage Filter"));
                if CReg.Find('-') then begin
                repeat
                StudUnits.Reset;
                StudUnits.SetCurrentkey(StudUnits."Reg. Transacton ID",StudUnits."Student No.");
                StudUnits.SetFilter(StudUnits."Reg. Transacton ID",CReg."Reg. Transacton ID");
                StudUnits.SetFilter(StudUnits."Student No.",CReg."Student No.");
                StudUnits.SetFilter(StudUnits.Stage,GetFilter("Stage Filter"));/*BKK*/
                StudUnits.SetRange(StudUnits.Taken,true);
                if StudUnits.Find('-') then begin
                repeat
                UnitsR.Reset;
                UnitsR.SetCurrentkey(UnitsR."Programme Code",UnitsR."Stage Code",UnitsR.Code);
                UnitsR.SetRange(UnitsR."Programme Code",StudUnits.Programme);
                UnitsR.SetRange(UnitsR."Stage Code",StudUnits.Stage);
                UnitsR.SetRange(UnitsR.Code,StudUnits.Unit);
                if UnitsR.Find('-') then begin
                if UnitsR.Show = false then begin
                UnitsR.Show:=true;
                UnitsR.Modify;
                end;
                end;
                until StudUnits.Next = 0;
                end;
                until CReg.Next = 0;
                end;
                
                
                
                FDesc:='';
                Dept:='';
                SDesc:='';
                Comb:='';

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
        Charges: Record UnknownRecord61515;
        ColumnH: array [80] of Text[100];
        ColumnV: array [80] of Text[30];
        i: Integer;
        TColumnV: array [80] of Decimal;
        SCount: Integer;
        UnitsR: Record UnknownRecord61517;
        uColumnV: array [80] of Text[30];
        sColumnV: array [80] of Text[30];
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
        CCat: Text[30];
        TScore: Decimal;
        RUnits: Decimal;
        SkipCount: Integer;
        MissingM: Boolean;
        DValue: Record "Dimension Value";
        FacultyR: Record UnknownRecord61587;
        FDesc: Text[200];
        Dept: Text[200];
        PName: Text[200];
        SDesc: Text[200];
        Comb: Text[200];
        ProgOptions: Record UnknownRecord61554;
        DMarks: Boolean;
        DSummary: Boolean;
        USkip: Boolean;
        CReg: Record UnknownRecord61532;
        UTaken: Integer;
        UPassed: Integer;
        UFailed: Integer;
        MCourse: Boolean;
        StudUnits: Record UnknownRecord61549;
        StudUnits2: Record UnknownRecord61549;
        UnitCount: Integer;
        YearScore: Decimal;
        CourseCount: Decimal;
        DontCont: Boolean;
        CAve: Decimal;
        Intake: Record UnknownRecord61532;
        CAverage: Decimal;
        Consolidated_MarksheetCaptionLbl: label 'Consolidated Marksheet';
        Year_of_Study_CaptionLbl: label 'Year of Study:';
        Faculty_CaptionLbl: label 'Faculty:';
        Department_CaptionLbl: label 'Department:';
        Programme_of_Study_CaptionLbl: label 'Programme of Study:';
        Combination_CaptionLbl: label 'Combination:';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Intake_CaptionLbl: label 'Intake:';
        Registration_No_CaptionLbl: label 'Registration No.';
        NamesCaptionLbl: label 'Names';
        UNITS__CaptionLbl: label 'UNITS=>';
        Serial_No_CaptionLbl: label 'Serial No.';
        Guide_on_remarks_CaptionLbl: label 'Guide on remarks:';
        P___Proceed_to_next_year___Graduate____________Q___Take_resit_exam_in_papers_failed____________R___Repeat_the_year_CaptionLbl: label 'P - Proceed to next year / Graduate;           Q - Take resit exam in papers failed;           R - Repeat the year;';
        S___Special_Exam____________T___Retake_failed_courses____________U___Missing_Marks________________Less_courses____________Z__Lbl: label 'S - Special Exam;           T - Retake failed courses;           U - Missing Marks;           ? - Less courses;           Z - Discontinued';
        Course_Categories______missing_marks______________Core_Required______________Elective______________Retake______________AuditCLbl: label 'Course Categories: --- missing marks;           = Core/Required;           - Elective;           + Retake;           # Audit';
}

