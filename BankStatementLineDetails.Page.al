#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1221 "Bank Statement Line Details"
{
    Caption = 'Bank Statement Line Details';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = "Data Exch. Field";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name;GetFieldName)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Name';
                    ToolTip = 'Specifies the name of a column in the imported bank statement file.';
                }
                field(Value;Value)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the value in a column in the imported bank statement file, such as account number, posting date, and amount.';
                }
            }
        }
    }

    actions
    {
    }
}

