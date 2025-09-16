#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51534 "Time Table - By Exam"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Time Table - By Exam.rdlc';

    dataset
    {
        dataitem(UnknownTable61514;UnknownTable61514)
        {
            RequestFilterFields = "Programme Filter","Stage Filter","Unit Filter","Class Filter","Unit Class Filter","Semester Filter","Student Type","Lecturer Filter","Exam Filter","Lecture Room Filter";
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
            column(GETFILTER__Exam_Filter__;GetFilter("Exam Filter"))
            {
            }
            column(GETFILTER__Class_Filter__;GetFilter("Class Filter"))
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
            column(T_1_;T[1])
            {
            }
            column(T_2_;T[2])
            {
            }
            column(T_3_;T[3])
            {
            }
            column(T_4_;T[4])
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
            column(Day_Of_Week_Day;Day)
            {
            }
            column(Time_TableCaption;Time_TableCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Programme_Filter_Caption;Programme_Filter_CaptionLbl)
            {
            }
            column(Stage_Filter_Caption;Stage_Filter_CaptionLbl)
            {
            }
            column(Unit_Filter_Caption;Unit_Filter_CaptionLbl)
            {
            }
            column(Semester_Filter_Caption;Semester_Filter_CaptionLbl)
            {
            }
            column(Exam_Filter_Caption;Exam_Filter_CaptionLbl)
            {
            }
            column(Class_Filter_Caption;Class_Filter_CaptionLbl)
            {
            }
            column(Day_Of_Week_No_;"No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
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

                TimeTable.Reset;
                TimeTable.SetRange(TimeTable.Released,false);
                TimeTable.SetRange(TimeTable."Day of Week","ACA-Day Of Week".Day);
                TimeTable.SetFilter(TimeTable.Programme,"ACA-Day Of Week".GetFilter("ACA-Day Of Week"."Programme Filter"));
                TimeTable.SetFilter(TimeTable.Stage,"ACA-Day Of Week".GetFilter("ACA-Day Of Week"."Stage Filter"));
                TimeTable.SetFilter(TimeTable.Unit,"ACA-Day Of Week".GetFilter("ACA-Day Of Week"."Unit Filter"));
                TimeTable.SetFilter(TimeTable.Semester,"ACA-Day Of Week".GetFilter("ACA-Day Of Week"."Semester Filter"));
                TimeTable.SetFilter(TimeTable."Lecture Room","ACA-Day Of Week".GetFilter("ACA-Day Of Week"."Lecture Room Filter"));
                TimeTable.SetFilter(TimeTable.Class,"ACA-Day Of Week".GetFilter("ACA-Day Of Week"."Class Filter"));
                TimeTable.SetFilter(TimeTable."Unit Class","ACA-Day Of Week".GetFilter("ACA-Day Of Week"."Unit Class Filter"));
                TimeTable.SetFilter(TimeTable.Lecturer,"ACA-Day Of Week".GetFilter("ACA-Day Of Week"."Lecturer Filter"));
                TimeTable.SetFilter(TimeTable.Exam,"ACA-Day Of Week".GetFilter("ACA-Day Of Week"."Exam Filter"));
                if TimeTable.Find('-') then begin
                repeat
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
                 + TimeTable.Unit + ' ' + TimeTable.Class + ' ' + Lec + ' ' +  TimeTable."Lecture Room" + ' ' + TimeTable."Exam Date" + ']';

                end else if (TimeTable.Class = '') and (TimeTable."Unit Class" = '') then  begin
                T[Lessons."No."] :=T[Lessons."No."] + '['
                 + TimeTable.Unit + ' ' + Lec + ' ' +  TimeTable."Lecture Room" + ' ' + TimeTable."Exam Date" +  ']';


                end else begin
                T[Lessons."No."] :=T[Lessons."No."] + '['
                 + TimeTable.Unit + ' ' + TimeTable.Class + ' ' + Lec + ' ' +  TimeTable."Lecture Room" + ' '
                 +  TimeTable."Unit Class" + ' ' + TimeTable."Exam Date" + ']';
                end;

                end;
                until TimeTable.Next = 0;
                end;

                //T[Lessons."No."] :=T[Lessons."No."] + '(' + TimeTable.Programme + ',' + TimeTable.Stage
                // + ',' + TimeTable.Unit + ',' + TimeTable.Class + ',' + TimeTable."Lecture Room" + ') ';
            end;
        }
        dataitem(UnknownTable61517;UnknownTable61517)
        {
            column(ReportForNavId_2955; 2955)
            {
            }
            column(Units_Subjects_Code;Code)
            {
            }
            column(Units_Subjects_Desription;Desription)
            {
            }
            column(KEY_Caption;KEY_CaptionLbl)
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

            trigger OnPreDataItem()
            begin
                "ACA-Units/Subjects".Reset;
                "ACA-Units/Subjects".SetRange("ACA-Units/Subjects"."Programme Code","ACA-Day Of Week".GetFilter("ACA-Day Of Week"."Programme Filter"));
                "ACA-Units/Subjects".SetRange("ACA-Units/Subjects"."Stage Code","ACA-Day Of Week".GetFilter("ACA-Day Of Week"."Stage Filter"));
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
        Time_TableCaptionLbl: label 'Time Table';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Programme_Filter_CaptionLbl: label 'Programme Filter:';
        Stage_Filter_CaptionLbl: label 'Stage Filter:';
        Unit_Filter_CaptionLbl: label 'Unit Filter:';
        Semester_Filter_CaptionLbl: label 'Semester Filter:';
        Exam_Filter_CaptionLbl: label 'Exam Filter:';
        Class_Filter_CaptionLbl: label 'Class Filter:';
        KEY_CaptionLbl: label 'KEY:';
}

