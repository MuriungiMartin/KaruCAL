#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5144 "Saved Segment Criteria Subform"
{
    Caption = 'Saved Segment Criteria Subform';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Saved Segment Criteria Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                IndentationColumn = ActionTableIndent;
                IndentationControls = ActionTable;
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the segment criteria line.';
                    Visible = false;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    ToolTip = 'Specifies the type of information the line shows. There are two options: Action or Filter.';
                    Visible = false;
                }
                field(ActionTable;ActionTable)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Action/Table';
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    ToolTip = 'Specifies the actions that you have performed (adding or removing contacts) in order to define the segment criteria. The related table is shown under each action.';
                }
                field("Filter";Filter)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Filter';
                    ToolTip = 'Specifies which segment criteria are shown.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        StyleIsStrong := Type = Type::Action;
        if Type <> Type::Action then
          ActionTableIndent := 1
        else
          ActionTableIndent := 0;
    end;

    var
        [InDataSet]
        StyleIsStrong: Boolean;
        [InDataSet]
        ActionTableIndent: Integer;
}

