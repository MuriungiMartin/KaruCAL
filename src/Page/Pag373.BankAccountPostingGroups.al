#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 373 "Bank Account Posting Groups"
{
    ApplicationArea = Basic;
    Caption = 'Bank Account Posting Groups';
    PageType = List;
    SourceTable = "Bank Account Posting Group";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for the posting group.';
                }
                field("G/L Bank Account No.";"G/L Bank Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general ledger account to which bank account entries in this posting group are posted.';
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
}

