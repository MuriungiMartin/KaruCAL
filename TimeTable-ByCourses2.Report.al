#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51551 "Time Table - By Courses 2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Time Table - By Courses 2.rdlc';

    dataset
    {
        dataitem(UnknownTable61514;UnknownTable61514)
        {
            RequestFilterFields = Exams,"Programme Filter","Stage Filter","Unit Filter","Class Filter","Unit Class Filter","Semester Filter","Student Type","Lecturer Filter","Exam Filter","Lecture Room Filter";
            column(ReportForNavId_3407; 3407)
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
            column(GETFILTER__Programme_Filter__;GetFilter("Programme Filter"))
            {
            }
            column(GETFILTER__Stage_Filter__;GetFilter("Stage Filter"))
            {
            }
            column(GETFILTER__Unit_Filter__;GetFilter("Unit Filter"))
            {
            }
            column(GETFILTER__Semester_Filter__;GetFilter("Semester Filter"))
            {
            }
            column(GETFILTER__Lecture_Room_Filter__;GetFilter("Lecture Room Filter"))
            {
            }
            column(GETFILTER__Class_Filter__;GetFilter("Class Filter"))
            {
            }
            column(TTType;TTType)
            {
            }
            column(L_1_;L[1])
            {
            }
            column(L_2_;L[2])
            {
            }
            column(L_3_;L[3])
            {
            }
            column(L_4_;L[4])
            {
            }
            column(L_5_;L[5])
            {
            }
            column(L_6_;L[6])
            {
            }
            column(L_7_;L[7])
            {
            }
            column(L_8_;L[8])
            {
            }
            column(L_9_;L[9])
            {
            }
            column(L_10_;L[10])
            {
            }
            column(L_11_;L[11])
            {
            }
            column(L_12_;L[12])
            {
            }
            column(Day_Of_Week_Remarks;Remarks)
            {
            }
            column(Time_Table_Caption;Time_Table_CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Programme_Filter_Caption;Programme_Filter_CaptionLbl)
            {
            }
            column(Year_Filter_Caption;Year_Filter_CaptionLbl)
            {
            }
            column(Unit_Filter_Caption;Unit_Filter_CaptionLbl)
            {
            }
            column(Semester_Filter_Caption;Semester_Filter_CaptionLbl)
            {
            }
            column(Lecture_Room_Filter_Caption;Lecture_Room_Filter_CaptionLbl)
            {
            }
            column(Class_Filter_Caption;Class_Filter_CaptionLbl)
            {
            }
            column(Day_Of_Week_No_;"No.")
            {
            }
            column(Day_Of_Week_Day;Day)
            {
            }
            dataitem(UnknownTable61517;UnknownTable61517)
            {
                DataItemTableView = sorting(Code);
                column(ReportForNavId_2955; 2955)
                {
                }
                column(T_1_;T[1])
                {
                }
                column(T_8_;T[8])
                {
                }
                column(T_7_;T[7])
                {
                }
                column(T_6_;T[6])
                {
                }
                column(T_5_;T[5])
                {
                }
                column(T_12_;T[12])
                {
                }
                column(T_11_;T[11])
                {
                }
                column(T_10_;T[10])
                {
                }
                column(T_4_;T[4])
                {
                }
                column(T_3_;T[3])
                {
                }
                column(T_2_;T[2])
                {
                }
                column(COPYSTR__Units_Subjects__Code_1_3_;CopyStr("ACA-Units/Subjects".Code,1,3))
                {
                }
                column(T_9_;T[9])
                {
                }
                column(Units_Subjects_Code;Code)
                {
                }
                column(Units_Subjects_Programme_Code;"Programme Code")
                {
                }
                column(Units_Subjects_Stage_Code;"Stage Code")
                {
                }
                column(Units_Subjects_Entry_No;"Entry No")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    SCode:=false;
                    if PCode <> CopyStr("ACA-Units/Subjects".Code,1,3) then begin
                    UnitFilter:=CopyStr("ACA-Units/Subjects".Code,1,3) + '*';

                    T[1]:='';
                    T[2]:='';
                    T[3]:='';
                    T[4]:='';
                    T[5]:='';
                    T[6]:='';
                    T[7]:='';
                    T[8]:='';
                    T[9]:='';
                    T[10]:='';
                    T[11]:='';
                    T[12]:='';
                    T[13]:='';
                    T[14]:='';



                    SOutput:= false;

                    PrevU:=false;
                    PrevP:=false;

                    if PUnit="ACA-Units/Subjects".Code then
                    PrevU:=true;

                    PUnit:="ACA-Units/Subjects".Code;

                    if PProg="ACA-Units/Subjects"."Programme Code" then
                    PrevP:=true;

                    PProg:="ACA-Units/Subjects"."Programme Code";


                    //IF (PrevP=TRUE) AND (PrevU=TRUE) THEN
                    //EXIT;


                    TimeTable.Reset;
                    TimeTable.SetRange(TimeTable.Released,false);
                    TimeTable.SetRange(TimeTable."Day of Week","ACA-Day Of Week".Day);
                    //TimeTable.SETFILTER(TimeTable.Programme,"Units/Subjects"."Programme Code");
                    TimeTable.SetFilter(TimeTable.Stage,"ACA-Day Of Week".GetFilter("ACA-Day Of Week"."Stage Filter"));
                    TimeTable.SetFilter(TimeTable.Unit,UnitFilter);
                    TimeTable.SetFilter(TimeTable.Semester,"ACA-Day Of Week".GetFilter("ACA-Day Of Week"."Semester Filter"));
                    TimeTable.SetFilter(TimeTable."Lecture Room","ACA-Day Of Week".GetFilter("ACA-Day Of Week"."Lecture Room Filter"));
                    TimeTable.SetFilter(TimeTable.Class,"ACA-Day Of Week".GetFilter("ACA-Day Of Week"."Class Filter"));
                    TimeTable.SetFilter(TimeTable."Unit Class","ACA-Day Of Week".GetFilter("ACA-Day Of Week"."Unit Class Filter"));
                    TimeTable.SetFilter(TimeTable.Lecturer,"ACA-Day Of Week".GetFilter("ACA-Day Of Week"."Lecturer Filter"));
                    TimeTable.SetFilter(TimeTable.Exam,"ACA-Day Of Week".GetFilter("ACA-Day Of Week"."Exam Filter"));
                    if TimeTable.Find('-') then begin
                    repeat
                    SOutput:=true;
                    Lec:='';

                    LUnits.Reset;
                    LUnits.SetRange(LUnits.Programme,TimeTable.Programme);
                    LUnits.SetRange(LUnits.Stage,TimeTable.Stage);
                    LUnits.SetRange(LUnits.Unit,TimeTable.Unit);
                    LUnits.SetRange(LUnits.Semester,TimeTable.Semester);
                    LUnits.SetRange(LUnits.Class,TimeTable.Class);
                    LUnits.SetRange(LUnits."Unit Class",TimeTable."Unit Class");
                    if LUnits.Find('-') then begin
                    Emp.Reset;
                    Emp.SetRange(Emp."No.",LUnits.Lecturer);
                    if Emp.Find('-') then
                    Lec:=Emp."Last Name";
                    end;

                    Lessons.Reset;
                    Lessons.SetRange(Lessons.Code,TimeTable.Period);
                    if Lessons.Find('-') then begin
                    if (TimeTable."Unit Class" = '') and (TimeTable.Class <> '') then begin
                    T[Lessons."No."] :=T[Lessons."No."] + '['
                     + TimeTable.Unit + ' ' + TimeTable.Class + ' ' + Lec + ' ' +  TimeTable."Lecture Room" + '] ';

                    end else if (TimeTable.Class = '') and (TimeTable."Unit Class" = '') then  begin
                    T[Lessons."No."] :=T[Lessons."No."] + '[' + TimeTable.Unit + ' ' + Lec + ' ' +  TimeTable."Lecture Room" + '] ';


                    end else begin
                    T[Lessons."No."] :=T[Lessons."No."] + '['
                     + TimeTable.Unit + ' ' + TimeTable.Class + ' ' + Lec + ' ' +  TimeTable."Lecture Room" + ','
                     +  TimeTable."Unit Class" + '] ';
                    end;

                    end;
                    until TimeTable.Next = 0;
                    end;


                    end else
                    SCode:=true;



                    PCode := CopyStr("ACA-Units/Subjects".Code,1,3);
                end;

                trigger OnPreDataItem()
                begin
                    //"Units/Subjects".RESET;
                    //IF "Day Of Week".GETFILTER("Day Of Week"."Programme Filter") <> '' THEN
                    "ACA-Units/Subjects".SetFilter("ACA-Units/Subjects"."Programme Code","ACA-Day Of Week".GetFilter("ACA-Day Of Week"."Programme Filter"));
                    //IF "Day Of Week".GETFILTER("Day Of Week"."Stage Filter") <> '' THEN
                    "ACA-Units/Subjects".SetFilter("ACA-Units/Subjects"."Stage Code","ACA-Day Of Week".GetFilter("ACA-Day Of Week"."Stage Filter"));
                end;
            }

            trigger OnAfterGetRecord()
            begin
                TTType:='TEACHING';
                if "ACA-Day Of Week".Exams = true then
                TTType:='EXAM';
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

    trigger OnPreReport()
    begin
        Lessons.Reset;
        if Lessons.Find('-') then begin
        repeat
        L[Lessons."No."]:=Lessons.Code;
        until Lessons.Next = 0;
        end;
    end;

    var
        TimeTable: Record UnknownRecord61540;
        Lessons: Record UnknownRecord61542;
        L: array [14] of Text[100];
        T: array [14] of Text[250];
        CellCont: Text[250];
        i: Integer;
        LUnits: Record UnknownRecord61541;
        Lec: Text[250];
        Emp: Record UnknownRecord61188;
        LName: Text[200];
        SOutput: Boolean;
        PUnit: Code[20];
        PrevU: Boolean;
        PrevP: Boolean;
        PProg: Code[20];
        PCode: Code[20];
        SCode: Boolean;
        UnitFilter: Code[20];
        TTType: Text[50];
        Time_Table_CaptionLbl: label 'Time Table:';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Programme_Filter_CaptionLbl: label 'Programme Filter:';
        Year_Filter_CaptionLbl: label 'Year Filter:';
        Unit_Filter_CaptionLbl: label 'Unit Filter:';
        Semester_Filter_CaptionLbl: label 'Semester Filter:';
        Lecture_Room_Filter_CaptionLbl: label 'Lecture Room Filter:';
        Class_Filter_CaptionLbl: label 'Class Filter:';
}

