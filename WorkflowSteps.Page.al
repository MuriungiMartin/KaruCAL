#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1503 "Workflow Steps"
{
    Caption = 'Workflow Steps';
    Editable = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = "Workflow Step Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                IndentationColumn = Indent;
                IndentationControls = "Event Description";
                field("Event Description";"Event Description")
                {
                    ApplicationArea = Suite;
                    Caption = 'When Event';
                    Lookup = false;
                    ToolTip = 'Specifies the workflow event that triggers the related workflow response.';
                }
                field("Response Description";"Response Description")
                {
                    ApplicationArea = Suite;
                    Caption = 'Then Response';
                    Lookup = false;
                    ToolTip = 'Specifies the workflow response that is that triggered by the related workflow event.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnFindRecord(Which: Text): Boolean
    begin
        SetCurrentkey(Order);
        Ascending(true);

        exit(Find(Which));
    end;
}

