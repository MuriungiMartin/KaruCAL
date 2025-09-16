#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 823 "Name/Value Lookup"
{
    Caption = 'Name/Value Lookup';
    Editable = false;
    PageType = List;
    SourceTable = "Name/Value Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control1000)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name.';
                }
                field(Value;Value)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the value.';
                }
            }
        }
    }

    actions
    {
    }


    procedure AddItem(ItemName: Text[250];ItemValue: Text[250])
    var
        NextID: Integer;
    begin
        LockTable;
        if FindLast then
          NextID := ID + 1
        else
          NextID := 1;

        Init;
        ID := NextID;
        Name := ItemName;
        Value := ItemValue;
        Insert;
    end;
}

