#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1297 "Transfer Difference to Account"
{
    Caption = 'Transfer Difference to Account';
    DataCaptionExpression = '';
    PageType = StandardDialog;
    SourceTable = "Gen. Journal Line";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Amount;Amount)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the total amount (including tax) that the journal line consists of.';
                }
                field("Account Type";"Account Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of account that the entry on the journal line will be posted to.';
                    ValuesAllowed = "G/L Account",Customer,Vendor,"Bank Account";
                }
                field("Account No.";"Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the account number that the entry on the journal line will be posted to.';
                }
                field(DescriptionTxt;DescriptionTxt)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Description';
                    ToolTip = 'Specifies text that describes this direct payment posting. By default, the text in the Transaction Text field is inserted.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        DescriptionTxt := Description;
        CurrPage.Editable := true;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction = Action::LookupOK then
          Validate(Description,DescriptionTxt)
    end;

    var
        DescriptionTxt: Text[50];
}

