#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 60022 "ELECT-Voter Login"
{
    PageType = Card;
    SourceTable = UnknownTable60000;
    SourceTableView = where("Is Active"=filter(Yes));

    layout
    {
        area(content)
        {
            grid(General)
            {
                field(StudNo;UserNames)
                {
                    ApplicationArea = Basic;
                    Caption = 'Student No.';

                    trigger OnValidate()
                    begin
                        if "Election Code"='' then begin Error('There is no active election in the Filter');
                          CurrPage.Close;
                          end;
                    end;
                }
                field(Password;Passwords)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ballot ID';
                }
            }
        }
    }

    actions
    {
    }

    var
        UserNames: Code[20];
        Passwords: Text[20];
}

