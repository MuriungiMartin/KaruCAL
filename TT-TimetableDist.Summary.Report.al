#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 74502 "TT-Timetable Dist. Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/TT-Timetable Dist. Summary.rdlc';

    dataset
    {
        dataitem(UnknownTable74517;UnknownTable74517)
        {
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
            column(AcademicYearz;"TT-Units"."Academic Year")
            {
            }
            column(Semes;"TT-Units".Semester)
            {
            }
            column(UnCode;"TT-Units"."Unit Code")
            {
            }
            column(ProgCode;"TT-Units"."Programme Code")
            {
            }
            column(UName;"TT-Units"."Unit Name")
            {
            }
            column(Singles;"TT-Units"."No. of Singles")
            {
            }
            column(Doubles;"TT-Units"."No. of Doubles")
            {
            }
            column(Tripples;"TT-Units"."No. of Tripples")
            {
            }
            column(IsTimetrabled;IsTimetrabled)
            {
            }
            column(LFiltersApplied;LFiltersApplied)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ACAProgramme.Reset;
                ACAProgramme.SetRange(Code,"TT-Units"."Programme Code");
                if ACAProgramme.Find('-') then;

                ACAUnitsSubjects.Reset;
                ACAUnitsSubjects.SetRange(Code,"TT-Units"."Unit Code");
                ACAUnitsSubjects.SetRange("Programme Code","TT-Units"."Programme Code");
                if ACAUnitsSubjects.Find('-') then;

                ACAProgramme.Reset;
                ACAProgramme.SetRange(Code,"TT-Units"."Programme Code");
                if ACAProgramme.Find('-') then begin

                  end;


                ACAUnitsSubjects2.Reset;
                ACAUnitsSubjects2.SetRange("Programme Code","TT-Units"."Programme Code");
                ACAUnitsSubjects2.SetRange(Code,"TT-Units"."Unit Code");
                if ACAUnitsSubjects2.Find('-') then begin

                  end;

                "TT-Units".CalcFields("TT-Units"."Unit Name","TT-Units"."No. of Singles","TT-Units"."No. of Doubles","TT-Units"."No. of Tripples");
                if (("TT-Units"."No. of Singles"+"TT-Units"."No. of Doubles"+"TT-Units"."No. of Tripples")>0) then
                  IsTimetrabled:=true
                  else IsTimetrabled:=false;
            end;

            trigger OnPreDataItem()
            begin
                Clear(LFiltersApplied);
                LFiltersApplied:="TT-Units".GetFilters;
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
        LessonTypeRep: Integer;
        IsTimetrabled: Boolean;
}

