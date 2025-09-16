#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1521 "Workflow Responses"
{
    Caption = 'Workflow Responses';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Workflow Response";
    SourceTableView = sorting(Independent,Description);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Description;Description)
                {
                    ApplicationArea = Suite;
                    ShowCaption = false;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the workflow response.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        StyleTxt := GetStyle;
    end;

    trigger OnAfterGetRecord()
    begin
        StyleTxt := GetStyle;
    end;

    trigger OnOpenPage()
    begin
        if FindFirst then;
    end;

    var
        StyleTxt: Text;

    local procedure GetStyle(): Text
    begin
        if HasPredecessors then
          exit('Strong');
        exit('');
    end;
}

