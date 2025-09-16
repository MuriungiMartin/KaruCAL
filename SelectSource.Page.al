#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1266 "Select Source"
{
    Caption = 'Select Source';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = StandardDialog;
    SourceTable = "XML Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                IndentationColumn = Depth;
                IndentationControls = Name;
                ShowAsTree = true;
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Element';
                    StyleExpr = StyleText;
                    ToolTip = 'Specifies the name of the imported record.';
                }
                field(Value;Value)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Example Value';
                    ToolTip = 'Specifies the value of the imported record.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        SetStyle;
    end;

    trigger OnOpenPage()
    begin
        CurrPage.LookupMode := true;
    end;

    var
        StyleText: Text;

    local procedure SetStyle()
    begin
        if HasChildNodes then
          StyleText := 'Strong'
        else
          StyleText := '';
    end;
}

