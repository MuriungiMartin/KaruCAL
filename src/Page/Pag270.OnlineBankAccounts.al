#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 270 "Online Bank Accounts"
{
    Caption = 'Select which bank account to set up';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Online Bank Acc. Link";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                InstructionalText = 'Select which bank account to set up.';
                field("Bank Account No.";"Bank Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the bank account code.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the bank account name.';
                }
            }
        }
    }

    actions
    {
    }


    procedure SetRecs(var OnlineBankAccLink: Record "Online Bank Acc. Link")
    begin
        OnlineBankAccLink.Reset;
        OnlineBankAccLink.FindSet;
        repeat
          Rec := OnlineBankAccLink;
          Insert;
        until OnlineBankAccLink.Next = 0
    end;
}

