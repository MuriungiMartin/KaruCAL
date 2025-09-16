#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5142 "Save Segment Criteria"
{
    Caption = 'Save Segment Criteria';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = All;
                    Caption = 'Code';
                    ToolTip = 'Specifies the code for the segment criteria that you want to save.';

                    trigger OnValidate()
                    var
                        SavedSegCriteria: Record "Saved Segment Criteria";
                    begin
                        if Code <> '' then begin
                          SavedSegCriteria.Code := Code;
                          SavedSegCriteria.Insert;
                          SavedSegCriteria.Delete;
                        end;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'Specifies a description of the segment.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction in [Action::OK,Action::LookupOK] then
          OKOnPush;
    end;

    var
        ExitAction: action;
        "Code": Code[10];
        Description: Text[50];


    procedure GetValues(var GetFormAction: action;var GetCode: Code[10];var GetDescription: Text[50])
    begin
        GetFormAction := ExitAction;
        GetCode := Code;
        GetDescription := Description;
    end;


    procedure SetValues(SetFormAction: action;SetCode: Code[10];SetDescription: Text[50])
    begin
        ExitAction := SetFormAction;
        Code := SetCode;
        Description := SetDescription;
    end;

    local procedure OKOnPush()
    var
        SavedSegCriteria: Record "Saved Segment Criteria";
    begin
        SavedSegCriteria.Code := Code;
        SavedSegCriteria.TestField(Code);
        ExitAction := Action::OK;
        CurrPage.Close;
    end;
}

