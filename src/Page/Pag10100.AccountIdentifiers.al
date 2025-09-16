#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 10100 "Account Identifiers"
{
    Caption = 'Account Identifiers';
    PageType = Card;
    SourceTable = UnknownTable10100;

    layout
    {
        area(content)
        {
            repeater(Control1030000)
            {
                field("Business No.";"Business No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the business number for the account identifier.';
                    Visible = false;
                }
                field("Program Identifier";"Program Identifier")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the program identifier.';
                }
                field("Reference No.";"Reference No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the reference number for the account identifier.';
                }
                field("Business Number";"Business Number")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the business number for the account identifier.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Company.Get;
        "Business No." := Company."Federal ID No.";
    end;

    var
        Company: Record "Company Information";
}

