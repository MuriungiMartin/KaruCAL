#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5169 "Profile Questn. Line Subform"
{
    Caption = 'Lines';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Profile Questionnaire Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Set;Set)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Select';

                    trigger OnValidate()
                    begin
                        TestField(Type,Type::Answer);

                        if Set then begin
                          TempProfileQuestionnaireLine.Init;
                          TempProfileQuestionnaireLine.Validate("Profile Questionnaire Code","Profile Questionnaire Code");
                          TempProfileQuestionnaireLine.Validate("Line No.","Line No.");
                          TempProfileQuestionnaireLine.Insert;
                        end else begin
                          TempProfileQuestionnaireLine.Get("Profile Questionnaire Code","Line No.");
                          TempProfileQuestionnaireLine.Delete;
                        end;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    ToolTip = 'Specifies the profile question or answer.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Set := TempProfileQuestionnaireLine.Get("Profile Questionnaire Code","Line No.");
        StyleIsStrong := Type = Type::Question;
    end;

    var
        TempProfileQuestionnaireLine: Record "Profile Questionnaire Line" temporary;
        Set: Boolean;
        [InDataSet]
        StyleIsStrong: Boolean;


    procedure SetProfileQnLine(var FromProfileQuestionnaireLine: Record "Profile Questionnaire Line")
    begin
        with FromProfileQuestionnaireLine do begin
          ClearSettings;
          if Find('-') then
            repeat
              TempProfileQuestionnaireLine := FromProfileQuestionnaireLine;
              TempProfileQuestionnaireLine.Insert;
            until Next = 0;
        end;
    end;

    local procedure ClearSettings()
    begin
        if TempProfileQuestionnaireLine.FindFirst then
          TempProfileQuestionnaireLine.DeleteAll;
    end;
}

