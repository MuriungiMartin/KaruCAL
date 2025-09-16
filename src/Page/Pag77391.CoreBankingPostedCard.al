#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77391 "Core_Banking_Posted_Card"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Core_Banking Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Statement No";"Statement No")
                {
                    ApplicationArea = Basic;
                }
                field(Bank_Code;Bank_Code)
                {
                    ApplicationArea = Basic;
                }
                field("Bank Name";"Bank Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Total Amount";"Total Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Number of Transactions";"Number of Transactions")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            group(Control1000000007)
            {
                part(Control1000000008;Core_Banking_Details)
                {
                    Enabled = false;
                    SubPageLink = "Statement No"=field("Statement No"),
                                  Bank_Code=field(Bank_Code);
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(ImportStatement)
            {
                ApplicationArea = Basic;
                Caption = 'Import Statement';
                Image = ExternalDocument;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Rec.TestField("Statement No");
                    if Confirm('Import Statement?',true) = false then Error('Cancelled!');
                    if Confirm('Arrange your CSV file in the following order of columns:\Transaction Date\Bank Code\Student No\Transaction no\Trans. Decription',true)= false then;
                    Core_Banking_ActiveStatements.Init;
                    Core_Banking_ActiveStatements.User_Id := UserId;
                    if Core_Banking_ActiveStatements.Insert(true) then;
                    Clear(Core_Banking_ActiveStatements);
                    Core_Banking_ActiveStatements.Reset;
                    Core_Banking_ActiveStatements.SetRange(User_Id,UserId);
                    if Core_Banking_ActiveStatements.Find('-') then begin
                      Core_Banking_ActiveStatements."Statement No" := Rec."Statement No";
                      Core_Banking_ActiveStatements.Modify;
                      end;
                    Xmlport.Run(77380,false,true);
                end;
            }
            action(CloseStatement)
            {
                ApplicationArea = Basic;
                Caption = 'Close Statement';
            }
            action("ReopenState,ment")
            {
                ApplicationArea = Basic;
                Caption = 'Re-open for Importation';
            }
            action(PostStatement)
            {
                ApplicationArea = Basic;
                Caption = 'Post Statement';
                Image = PostingEntries;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    if Confirm('Post all unposted Receipts',true)=false then Error('Cancelled!');
                    // Post Receipts on the Statement
                    Rec.Validate("Batch Is Posted",true);
                    if Rec.Modify then;
                end;
            }
        }
    }

    var
        Core_Banking_ActiveStatements: Record UnknownRecord77383;
        Customer: Record Customer;
}

