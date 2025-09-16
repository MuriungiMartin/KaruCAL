#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 383 "Bank Account Statement"
{
    Caption = 'Bank Account Statement';
    InsertAllowed = false;
    PageType = ListPlus;
    SaveValues = true;
    SourceTable = "Bank Account Statement";

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field("Bank Account No.";"Bank Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of the bank account that has been reconciled with this Bank Account Statement.';
                }
                field("Statement No.";"Statement No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of the bank''s statement that has been reconciled with the bank account.';
                }
                field("Statement Date";"Statement Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the date on the bank''s statement that has been reconciled with the bank account.';
                }
                field("Balance Last Statement";"Balance Last Statement")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the ending balance on the bank account statement from the last posted bank account reconciliation.';
                }
                field("Statement Ending Balance";"Statement Ending Balance")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the ending balance on the bank''s statement that has been reconciled with the bank account.';
                }
            }
            part(Control11;"Bank Account Statement Lines")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Bank Account No."=field("Bank Account No."),
                              "Statement No."=field("Statement No.");
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
        area(navigation)
        {
            group("St&atement")
            {
                Caption = 'St&atement';
                action("&Card")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Card';
                    Image = EditLines;
                    RunObject = Page "Bank Account Card";
                    RunPageLink = "No."=field("Bank Account No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or change detailed information about the record that is being processed on the journal line.';
                }
            }
        }
    }
}

