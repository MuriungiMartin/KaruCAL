#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 90053 BulkSMSSetup
{
    PageType = Card;
    SourceTable = UnknownTable90051;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("User Name";"User Name")
                {
                    ApplicationArea = Basic;
                }
                field(PasswordTemp;PasswordTemp)
                {
                    ApplicationArea = Basic;
                    Caption = 'Password';
                    ExtendedDatatype = Masked;

                    trigger OnValidate()
                    begin
                        SetPassword(PasswordTemp);
                        Commit;
                        CurrPage.Update;
                    end;
                }
                field(Credits;Credits)
                {
                    ApplicationArea = Basic;
                }
                field("Credits Checked At";"Credits Checked At")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(GetCredits)
            {
                ApplicationArea = Basic;
                Caption = 'Get Credits';
                Image = Currencies;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    GetCredits;
                    CurrPage.Update;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        PasswordTemp := '';
        if ("User Name" <> '') and (not IsNullGuid("Password Key")) then
          PasswordTemp := '**********';
    end;

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
          Init;
          Insert;
        end;
    end;

    var
        PasswordTemp: Text;
}

