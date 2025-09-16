#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 619 "IC Inbox/Outbox Jnl. Line Dim."
{
    Caption = 'IC Inbox/Outbox Jnl. Line Dim.';
    DataCaptionExpression = GetCaption;
    DelayedInsert = true;
    PageType = List;
    SourceTable = "IC Inbox/Outbox Jnl. Line Dim.";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Dimension Code";"Dimension Code")
                {
                    ApplicationArea = Basic;
                }
                field("Dimension Value Code";"Dimension Value Code")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }

    var
        SourceTableName: Text[100];
        CurrTableID: Integer;
        CurrLineNo: Integer;

    local procedure GetCaption(): Text[250]
    var
        ObjTransl: Record "Object Translation";
        NewTableID: Integer;
    begin
        NewTableID := GetTableID(GetFilter("Table ID"));
        if NewTableID = 0 then
          exit('');

        if NewTableID = 0 then
          SourceTableName := ''
        else
          if NewTableID <> CurrTableID then
            SourceTableName := ObjTransl.TranslateObject(ObjTransl."object type"::Table,NewTableID);

        CurrTableID := NewTableID;

        if GetFilter("Line No.") = '' then
          CurrLineNo := 0
        else
          if GetRangeMin("Line No.") = GetRangemax("Line No.") then
            CurrLineNo := GetRangeMin("Line No.")
          else
            CurrLineNo := 0;

        if NewTableID = 0 then
          exit('');

        exit(StrSubstNo('%1 %2',SourceTableName,Format(CurrLineNo)));
    end;

    local procedure GetTableID(TableIDFilter: Text[250]): Integer
    var
        NewTableID: Integer;
    begin
        if Evaluate(NewTableID,TableIDFilter) then
          exit(NewTableID);

        exit(0);
    end;
}

