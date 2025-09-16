#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51471 "Suggest Attendance Entries"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Suggest Attendance Entries.rdlc';

    dataset
    {
        dataitem(UnknownTable61540;UnknownTable61540)
        {
            RequestFilterFields = Programme,Stage,Unit,Semester,"Date Filter";
            column(ReportForNavId_9807; 9807)
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
            column(Time_Table_Programme;Programme)
            {
            }
            column(Time_Table_Stage;Stage)
            {
            }
            column(Time_Table_Unit;Unit)
            {
            }
            column(Time_Table_Semester;Semester)
            {
            }
            column(Time_Table__Day_of_Week_;"Day of Week")
            {
            }
            column(Time_Table_Period;Period)
            {
            }
            column(Time_TableCaption;Time_TableCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Time_Table_ProgrammeCaption;FieldCaption(Programme))
            {
            }
            column(Time_Table_StageCaption;FieldCaption(Stage))
            {
            }
            column(Time_Table_UnitCaption;FieldCaption(Unit))
            {
            }
            column(Time_Table_SemesterCaption;FieldCaption(Semester))
            {
            }
            column(Time_Table__Day_of_Week_Caption;FieldCaption("Day of Week"))
            {
            }
            column(Time_Table_PeriodCaption;FieldCaption(Period))
            {
            }
            column(Time_Table_Lecture_Room;"Lecture Room")
            {
            }
            column(Time_Table_Class;Class)
            {
            }
            column(Time_Table_Unit_Class;"Unit Class")
            {
            }
            column(Time_Table_Exam;Exam)
            {
            }
            column(Time_Table_Released;Released)
            {
            }

            trigger OnAfterGetRecord()
            begin
                MinDate:="ACA-Time Table".GetRangeMin("ACA-Time Table"."Date Filter");
                MaxDate:="ACA-Time Table".GetRangemax("ACA-Time Table"."Date Filter");
                repeat

                if Date2dwy(MinDate,1) = 1 then
                DayCode:='MON';
                if Date2dwy(MinDate,1) = 2 then
                DayCode:='TUE';
                if Date2dwy(MinDate,1) = 3 then
                DayCode:='WED';
                if Date2dwy(MinDate,1) = 4 then
                DayCode:='THUR';
                if Date2dwy(MinDate,1) = 5 then
                DayCode:='FRI';
                if Date2dwy(MinDate,1) = 6 then
                DayCode:='SAT';
                if Date2dwy(MinDate,1) = 7 then
                DayCode:='SUN';

                if DayCode = "ACA-Time Table"."Day of Week" then begin
                if not Actual.Get(MinDate,Programme,Stage,Unit,Semester,Period,"Day of Week","Lecture Room") then begin
                Actual.Init;
                Actual."RFQ No.":="ACA-Time Table".Programme;
                //Actual."RFQ Line No.":="Time Table".Stage;
                Actual."Quote No.":="ACA-Time Table".Unit;
                Actual."Vendor No.":="ACA-Time Table".Semester;
                Actual."Item No.":="ACA-Time Table".Period;
                Actual.Description:="ACA-Time Table"."Day of Week";
                Actual."Unit Of Measure":="ACA-Time Table"."Lecture Room";
                //Actual.Total:=MinDate;
                if Periods.Get("ACA-Time Table".Period) then
                Actual."Line Amount":=Periods.Hours;
                Actual.Insert;

                end;
                end;

                MinDate :=CalcDate('1D',MinDate);
                until MinDate > MaxDate
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
        DateFilter: Text[100];
        Actual: Record UnknownRecord61550;
        TTable: Record UnknownRecord61540;
        MinDate: Date;
        MaxDate: Date;
        DayCode: Code[20];
        Periods: Record UnknownRecord61514;
        Time_TableCaptionLbl: label 'Time Table';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

