#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69028 "ACA-Timetable Header"
{

    layout
    {
        area(content)
        {
            field(ProgrammeFilter;ProgrammeFilter)
            {
                ApplicationArea = Basic;
                Caption = 'Programme Filter';
                TableRelation = "ACA-Programme".Code;

                trigger OnValidate()
                begin


                      SetMatrixFilter;
                end;
            }
            field(StageFilter;StageFilter)
            {
                ApplicationArea = Basic;
                Caption = 'Stage Filter';
                TableRelation = "ACA-Programme Stages".Code;

                trigger OnValidate()
                begin
                       SetMatrixFilter;
                end;
            }
            field(SemesterFilter;SemesterFilter)
            {
                ApplicationArea = Basic;
                Caption = 'Semester Filter';
                TableRelation = "ACA-Programme Semesters".Semester;

                trigger OnValidate()
                begin
                        SetMatrixFilter;
                end;
            }
            field(UnitFilter;UnitFilter)
            {
                ApplicationArea = Basic;
                Caption = 'Unit Filter';
                TableRelation = "ACA-Units/Subjects".Code;

                trigger OnValidate()
                begin
                     SetMatrixFilter;
                end;
            }
            field("Day Filter";DayFilter)
            {
                ApplicationArea = Basic;
                TableRelation = "ACA-Day Of Week".Day;

                trigger OnValidate()
                begin
                      SetMatrixFilter;
                end;
            }
            field(Type;Type)
            {
                ApplicationArea = Basic;

                trigger OnValidate()
                begin
                       CurrPage.Marksheet.Page.GetExamCaption(Type);
                       CurrPage.Update;
                end;
            }
            part(Marksheet;"ACA-Timetable Lines")
            {
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
           CurrPage.Marksheet.Page.GetExamCaption(Type);
           CurrPage.Update;
    end;

    trigger OnOpenPage()
    begin
           SetMatrixFilter;
    end;

    var
        ExamHeader: Integer;
        ProgrammeFilter: Code[20];
        StageFilter: Code[20];
        SemesterFilter: Code[20];
        UnitFilter: Code[20];
        StudUnits: Record UnknownRecord61549;
        DayFilter: Code[20];
        Type: Option Teaching,Exam;
        Prog: Record UnknownRecord61511;
        ExamSetup: Record UnknownRecord61567;


    procedure SetMatrixFilter()
    begin
           CurrPage.Marksheet.Page.Load(ProgrammeFilter,StageFilter,SemesterFilter,UnitFilter,DayFilter,Type);
           CurrPage.Update;
    end;
}

