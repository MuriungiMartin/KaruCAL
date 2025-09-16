#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77077 "Posted Bank Recon. - Posted"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Bank Account Statement";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Bank Account No.";"Bank Account No.")
                {
                    ApplicationArea = Basic;
                }
                field("Statement No.";"Statement No.")
                {
                    ApplicationArea = Basic;
                }
                field("Statement Ending Balance";"Statement Ending Balance")
                {
                    ApplicationArea = Basic;
                }
                field("Statement Date";"Statement Date")
                {
                    ApplicationArea = Basic;
                }
                field("Balance Last Statement";"Balance Last Statement")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Reconcilliation Report")
            {
                ApplicationArea = Basic;
                Caption = 'Reconcilliation Report';
                Image = Accounts;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    BankAccountStatement.Reset;
                    BankAccountStatement.SetRange("Bank Account No.",Rec."Bank Account No.");
                    BankAccountStatement.SetRange("Statement No.",Rec."Statement No.");
                    if BankAccountStatement.Find('-') then begin
                      Report.Run(77077,true,false,BankAccountStatement);
                      end;
                end;
            }
        }
    }

    var
        BankAccountStatement: Record "Bank Account Statement";
}

