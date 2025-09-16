#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69026 "ACA-Marksheet Header"
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
                      if Prog.Get(ProgrammeFilter) then
                      ExamCategory:=Prog."Exam Category";

                       CurrPage.Marksheet.Page.GetExamCaption(ExamCategory);
                       CurrPage.Update;

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
            field("Register For";RegisterFor)
            {
                ApplicationArea = Basic;

                trigger OnValidate()
                begin
                    SetMatrixFilter;
                end;
            }
            field(ExamCategory;ExamCategory)
            {
                ApplicationArea = Basic;
                TableRelation = "ACA-Exam Category".Code;
            }
            field("Student No. Filter";"Student No. Filter")
            {
                ApplicationArea = Basic;
                Caption = 'Student No. Filter';
                TableRelation = Customer;

                trigger OnValidate()
                begin
                       SetMatrixFilter;
                end;
            }
            part(Marksheet;"ACA-Marksheet Lines")
            {
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
          if UserSetup.Get(UserId) then
          if (UserSetup.Lecturer=false) and (UserSetup."Can Edit Marks"=false) then Error('Please note that this window is only active for Deans and HODs');
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
        ExamCategory: Code[20];
        Prog: Record UnknownRecord61511;
        ExamSetup: Record UnknownRecord61567;
        RegisterFor: Option Stage,"Unit/Subject",Supplementary;
        UserSetup: Record "User Setup";
        "Student No. Filter": Code[20];


    procedure SetMatrixFilter()
    begin
           CurrPage.Marksheet.Page.Load(ProgrammeFilter,StageFilter,SemesterFilter,UnitFilter,ExamCategory,RegisterFor,"Student No. Filter");
           CurrPage.Update;
    end;
}

