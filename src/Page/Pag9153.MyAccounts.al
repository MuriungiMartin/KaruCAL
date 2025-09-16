#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9153 "My Accounts"
{
    Caption = 'My Accounts';
    PageType = ListPart;
    SourceTable = "My Account";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Account No.";"Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the G/L account number.';

                    trigger OnValidate()
                    begin
                        GetGLAccount;
                    end;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Name';
                    DrillDown = false;
                    Lookup = false;
                    ToolTip = 'Specifies the name of the cash account.';
                }
                field(Balance;Balance)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Balance';
                    ToolTip = 'Specifies the balance on the bank account.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Open)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Open';
                Image = ViewDetails;
                RunObject = Page "G/L Account Card";
                RunPageLink = "No."=field("Account No.");
                RunPageMode = View;
                RunPageView = sorting("No.");
                ShortCutKey = 'Return';
                ToolTip = 'Open the card for the selected record.';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        GetGLAccount;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(GLAccount);
    end;

    trigger OnOpenPage()
    begin
        SetRange("User ID",UserId);
    end;

    var
        GLAccount: Record "G/L Account";

    local procedure GetGLAccount()
    begin
        Clear(GLAccount);

        if GLAccount.Get("Account No.") then
          GLAccount.CalcFields(Balance);
    end;
}

