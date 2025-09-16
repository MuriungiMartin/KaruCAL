#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 791 "G/L Accounts ListPart"
{
    Caption = 'G/L Accounts ListPart';
    Editable = false;
    PageType = ListPart;
    SourceTable = "G/L Account";
    SourceTableView = where("Account Type"=const(Posting));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the record.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the record.';
                }
                field("Income/Balance";"Income/Balance")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies is the general ledger account is an income statement account or a balance sheet account.';
                }
            }
        }
    }

    actions
    {
    }
}

