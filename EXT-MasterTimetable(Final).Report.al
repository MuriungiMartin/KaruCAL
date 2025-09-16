#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 74550 "EXT-Master Timetable (Final)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/EXT-Master Timetable (Final).rdlc';

    dataset
    {
        dataitem(UnknownTable74568;UnknownTable74568)
        {
            RequestFilterFields = Programme,Unit,Semester,Lecturer,"Date Code","Period Code",Department,"Period Type","Room Code";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(ProgName;ACAProgramme.Description)
            {
            }
            column(UnitName;ACAUnitsSubjects.Desription)
            {
            }
            column(LectName;HRMEmployeeC."First Name"+' '+HRMEmployeeC."Middle Name"+' '+HRMEmployeeC."Last Name")
            {
            }
            column(CompName;CompanyInformation.Name)
            {
            }
            column(CompAddress1;CompanyInformation.Address)
            {
            }
            column(CompAddress2;CompanyInformation."Address 2")
            {
            }
            column(CompCity;CompanyInformation.City)
            {
            }
            column(Phone1;CompanyInformation."Phone No.")
            {
            }
            column(Phone2;CompanyInformation."Phone No. 2")
            {
            }
            column(Email;CompanyInformation."E-Mail")
            {
            }
            column(HomepAge;CompanyInformation."Home Page")
            {
            }
            column(ProgrammeCode;"EXT-Timetable FInal Collector".Programme)
            {
            }
            column(UnitCode;"EXT-Timetable FInal Collector".Unit)
            {
            }
            column(Semes;"EXT-Timetable FInal Collector".Semester)
            {
            }
            column(LessonCode;"EXT-Timetable FInal Collector"."Period Code")
            {
            }
            column(DayOfWeek;"EXT-Timetable FInal Collector"."Date Code")
            {
            }
            column(LectureRoom;"EXT-Timetable FInal Collector"."Lecture Room")
            {
            }
            column(LecturerCode;"EXT-Timetable FInal Collector".Lecturer)
            {
            }
            column(DepartmentLCode;"EXT-Timetable FInal Collector".Department)
            {
            }
            column(RoomType;"EXT-Timetable FInal Collector"."Room Type")
            {
            }
            column(CampusCode;"EXT-Timetable FInal Collector"."Campus Code")
            {
            }
            column(RoomCode;"EXT-Timetable FInal Collector"."Room Code")
            {
            }
            column(BuldingOrBlock;"EXT-Timetable FInal Collector"."Block/Building")
            {
            }
            column(Faculty;"EXT-Timetable FInal Collector"."School or Faculty")
            {
            }
            column(LessomCategory;"EXT-Timetable FInal Collector"."Period Category")
            {
            }
            column(LessonOrder;"EXT-Timetable FInal Collector"."Period Order")
            {
            }
            column(DayOrder;"EXT-Timetable FInal Collector"."Date Order")
            {
            }
            column(RecordId;"EXT-Timetable FInal Collector"."Record ID")
            {
            }
            column(AllocatedStatus;"EXT-Timetable FInal Collector".Allocated)
            {
            }
            column(LessonType;"EXT-Timetable FInal Collector"."Period Type")
            {
            }
            column(LessonStart;TTDailyLessons."Start Time")
            {
            }
            column(LessonStop;TTDailyLessons."End Time")
            {
            }
            column(TimetableEntry;'['+"EXT-Timetable FInal Collector".Programme+';'+"EXT-Timetable FInal Collector".Unit+';'+"EXT-Timetable FInal Collector".Lecturer+';'+"EXT-Timetable FInal Collector"."Room Code"+';]')
            {
            }
            column(LFiltersApplied;LFiltersApplied)
            {
            }
            column(bgColor;Format(TTProgrammes."Timetable Color"))
            {
            }

            trigger OnAfterGetRecord()
            begin

                TTProgrammes.Reset;
                TTProgrammes.SetRange(Semester,"EXT-Timetable FInal Collector".Semester);
                TTProgrammes.SetRange("Programme Code","EXT-Timetable FInal Collector".Programme);
                if TTProgrammes.Find('-') then;
                if DontUseColor=true then TTProgrammes."Timetable Color":=TTProgrammes."timetable color"::White;
                ACAProgramme.Reset;
                ACAProgramme.SetRange(Code,"EXT-Timetable FInal Collector".Programme);
                if ACAProgramme.Find('-') then;

                ACAUnitsSubjects.Reset;
                ACAUnitsSubjects.SetRange(Code,"EXT-Timetable FInal Collector".Unit);
                ACAUnitsSubjects.SetRange("Programme Code","EXT-Timetable FInal Collector".Programme);
                if ACAUnitsSubjects.Find('-') then;

                TTDailyLessons.Reset;
                TTDailyLessons.SetRange(Semester,"EXT-Timetable FInal Collector".Semester);
                TTDailyLessons.SetRange("Date Code","EXT-Timetable FInal Collector"."Date Code");
                TTDailyLessons.SetRange("Period Code","EXT-Timetable FInal Collector"."Period Code");
                if TTDailyLessons.Find('-') then begin

                  end;
                // //  CountedColumns:=CountedColumns+1;
                // //  IF CountedColumns=5 THEN CountedColumns:=1;
                HRMEmployeeC.Reset;
                HRMEmployeeC.SetRange("No.","EXT-Timetable FInal Collector".Lecturer);
                if HRMEmployeeC.Find('-') then begin

                  end;

                ACAProgramme.Reset;
                ACAProgramme.SetRange(Code,"EXT-Timetable FInal Collector".Programme);
                if ACAProgramme.Find('-') then begin

                  end;


                ACAUnitsSubjects2.Reset;
                ACAUnitsSubjects2.SetRange("Programme Code","EXT-Timetable FInal Collector".Programme);
                ACAUnitsSubjects2.SetRange(Code,"EXT-Timetable FInal Collector".Unit);
                if ACAUnitsSubjects2.Find('-') then begin

                  end;
            end;

            trigger OnPreDataItem()
            begin
                Clear(LFiltersApplied);
                LFiltersApplied:="EXT-Timetable FInal Collector".GetFilters;
                DontUseColor:=false;
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
        CompanyInformation.Reset;
        if CompanyInformation.Find('-') then;
    end;

    var
        CompanyInformation: Record "Company Information";
        ACAProgramme: Record UnknownRecord61511;
        ACAUnitsSubjects: Record UnknownRecord61517;
        OutputLayout: Option Potrait,Landscape;
        IncludeProgSummary: Boolean;
        IncludeLectSummary: Boolean;
        IncludeUnitSummary: Boolean;
        TTDailyLessons: Record UnknownRecord74552;
        LFiltersApplied: Text[1024];
        HRMEmployeeC: Record UnknownRecord61188;
        ACAProgramme2: Record UnknownRecord61511;
        ACAUnitsSubjects2: Record UnknownRecord61517;
        CountedColumnsProgs: Integer;
        CountedColumnsLects: Integer;
        CountedColumnsUnits: Integer;
        TTProgrammes: Record UnknownRecord74553;
        DontUseColor: Boolean;
}

