#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 74501 "TT-Master Timetable (Final) 2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/TT-Master Timetable (Final) 2.rdlc';

    dataset
    {
        dataitem(UnknownTable74523;UnknownTable74523)
        {
            RequestFilterFields = Programme,Unit,Semester,Lecturer,"Day of Week","Lesson Code",Department,"Lesson Type","Room Code";
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
            column(ProgrammeCode;"TT-Timetable FInal Collector".Programme)
            {
            }
            column(UnitCode;"TT-Timetable FInal Collector".Unit)
            {
            }
            column(Semes;"TT-Timetable FInal Collector".Semester)
            {
            }
            column(LessonCode;"TT-Timetable FInal Collector"."Lesson Code")
            {
            }
            column(DayOfWeek;"TT-Timetable FInal Collector"."Day of Week")
            {
            }
            column(LectureRoom;"TT-Timetable FInal Collector"."Lecture Room")
            {
            }
            column(LecturerCode;"TT-Timetable FInal Collector".Lecturer)
            {
            }
            column(DepartmentLCode;"TT-Timetable FInal Collector".Department)
            {
            }
            column(RoomType;"TT-Timetable FInal Collector"."Room Type")
            {
            }
            column(CampusCode;"TT-Timetable FInal Collector"."Campus Code")
            {
            }
            column(RoomCode;"TT-Timetable FInal Collector"."Room Code")
            {
            }
            column(BuldingOrBlock;"TT-Timetable FInal Collector"."Block/Building")
            {
            }
            column(Faculty;"TT-Timetable FInal Collector"."School or Faculty")
            {
            }
            column(LessomCategory;"TT-Timetable FInal Collector"."Lesson Category")
            {
            }
            column(LessonOrder;"TT-Timetable FInal Collector"."Lesson Order")
            {
            }
            column(DayOrder;"TT-Timetable FInal Collector"."Day Order")
            {
            }
            column(RecordId;"TT-Timetable FInal Collector"."Record ID")
            {
            }
            column(AllocatedStatus;"TT-Timetable FInal Collector".Allocated)
            {
            }
            column(LessonType;"TT-Timetable FInal Collector"."Lesson Type")
            {
            }
            column(LessonStart;TTDailyLessons."Start Time")
            {
            }
            column(LessonStop;TTDailyLessons."End Time")
            {
            }
            column(TimetableEntry;'['+"TT-Timetable FInal Collector".Programme+';'+"TT-Timetable FInal Collector".Unit+';'+"TT-Timetable FInal Collector".Lecturer+';'+"TT-Timetable FInal Collector"."Room Code"+';]')
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
                TTProgrammes.SetRange(Semester,"TT-Timetable FInal Collector".Semester);
                TTProgrammes.SetRange("Programme Code","TT-Timetable FInal Collector".Programme);
                if TTProgrammes.Find('-') then;
                if DontUseColor=true then TTProgrammes."Timetable Color":=TTProgrammes."timetable color"::White;

                ACAProgramme.Reset;
                ACAProgramme.SetRange(Code,"TT-Timetable FInal Collector".Programme);
                if ACAProgramme.Find('-') then;

                ACAUnitsSubjects.Reset;
                ACAUnitsSubjects.SetRange(Code,"TT-Timetable FInal Collector".Unit);
                ACAUnitsSubjects.SetRange("Programme Code","TT-Timetable FInal Collector".Programme);
                if ACAUnitsSubjects.Find('-') then;

                TTDailyLessons.Reset;
                TTDailyLessons.SetRange(Semester,"TT-Timetable FInal Collector".Semester);
                TTDailyLessons.SetRange("Day Code","TT-Timetable FInal Collector"."Day of Week");
                TTDailyLessons.SetRange("Lesson Code","TT-Timetable FInal Collector"."Lesson Code");
                if TTDailyLessons.Find('-') then begin

                  end;

                HRMEmployeeC.Reset;
                HRMEmployeeC.SetRange("No.","TT-Timetable FInal Collector".Lecturer);
                if HRMEmployeeC.Find('-') then begin

                  end;

                ACAProgramme.Reset;
                ACAProgramme.SetRange(Code,"TT-Timetable FInal Collector".Programme);
                if ACAProgramme.Find('-') then begin

                  end;


                ACAUnitsSubjects2.Reset;
                ACAUnitsSubjects2.SetRange("Programme Code","TT-Timetable FInal Collector".Programme);
                ACAUnitsSubjects2.SetRange(Code,"TT-Timetable FInal Collector".Unit);
                if ACAUnitsSubjects2.Find('-') then begin

                  end;
            end;

            trigger OnPreDataItem()
            begin

                DontUseColor:=false;
                Clear(LFiltersApplied);
                LFiltersApplied:="TT-Timetable FInal Collector".GetFilters;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(ColorOption;DontUseColor)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dont Use Colors?';
                }
            }
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
        TTDailyLessons: Record UnknownRecord74503;
        LFiltersApplied: Text[1024];
        HRMEmployeeC: Record UnknownRecord61188;
        TTLegendProgrammes: Record UnknownRecord74525;
        TTLegendLecturers: Record UnknownRecord74526;
        TTLegendUnits: Record UnknownRecord74527;
        ACAProgramme2: Record UnknownRecord61511;
        ACAUnitsSubjects2: Record UnknownRecord61517;
        CountedColumnsProgs: Integer;
        CountedColumnsLects: Integer;
        CountedColumnsUnits: Integer;
        TTProgrammes: Record UnknownRecord74504;
        DontUseColor: Boolean;
}

