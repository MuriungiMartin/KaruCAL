#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 447 "Finance Charge Memo Lines"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Finance Charge Memo Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the line type.';

                    trigger OnValidate()
                    begin
                        TypeOnAfterValidate;
                        NoOnAfterValidate;
                        SetShowMandatoryConditions
                    end;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = TypeIsGLAccount;
                    ToolTip = 'Specifies the number of the general ledger account this finance charge memo line is for.';

                    trigger OnValidate()
                    begin
                        NoOnAfterValidate;
                    end;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the posting date of the customer ledger entry that this finance charge memo line is for.';
                    Visible = false;
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document date of the customer ledger entry this finance charge memo line is for.';
                    Visible = false;
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = TypeIsCustomerLedgerEntry;
                    ToolTip = 'Specifies the document type of the customer ledger entry this finance charge memo line is for.';

                    trigger OnValidate()
                    begin
                        DocumentTypeOnAfterValidate;
                    end;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = TypeIsCustomerLedgerEntry;
                    ToolTip = 'Specifies the document number of the customer ledger entry this finance charge memo line is for.';

                    trigger OnValidate()
                    begin
                        DocumentNoOnAfterValidate;
                    end;
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the due date of the customer ledger entry this finance charge memo line is for.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an entry description, based on the contents of the Type field.';
                }
                field("Original Amount";"Original Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the original amount of the customer ledger entry that this finance charge memo line is for.';
                    Visible = false;
                }
                field("Remaining Amount";"Remaining Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the remaining amount of the customer ledger entry this finance charge memo line is for.';
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the amount in the currency that is represented by the currency code on the finance charge memo header.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Insert &Ext. Text")
                {
                    AccessByPermission = TableData "Extended Text Header"=R;
                    ApplicationArea = Basic;
                    Caption = 'Insert &Ext. Text';
                    Image = Text;
                    ToolTip = 'Insert the extended item description that is set up for the item that is being processed on the line.';

                    trigger OnAction()
                    begin
                        InsertExtendedText(true);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetShowMandatoryConditions;
    end;

    var
        TransferExtendedText: Codeunit "Transfer Extended Text";
        TypeIsGLAccount: Boolean;
        TypeIsCustomerLedgerEntry: Boolean;

    local procedure InsertExtendedText(Unconditionally: Boolean)
    begin
        if TransferExtendedText.FinChrgMemoCheckIfAnyExtText(Rec,Unconditionally) then begin
          CurrPage.SaveRecord;
          TransferExtendedText.InsertFinChrgMemoExtText(Rec);
        end;
        if TransferExtendedText.MakeUpdate then
          CurrPage.Update;
    end;

    local procedure FormUpdateAttachedLines()
    begin
        if CheckAttachedLines then begin
          CurrPage.SaveRecord;
          UpdateAttachedLines;
          CurrPage.Update(false);
        end;
    end;

    local procedure TypeOnAfterValidate()
    begin
        InsertExtendedText(false);
        FormUpdateAttachedLines;
    end;

    local procedure NoOnAfterValidate()
    begin
        InsertExtendedText(false);
    end;

    local procedure DocumentTypeOnAfterValidate()
    begin
        FormUpdateAttachedLines;
    end;

    local procedure DocumentNoOnAfterValidate()
    begin
        FormUpdateAttachedLines;
    end;

    local procedure SetShowMandatoryConditions()
    begin
        TypeIsGLAccount := Type = Type::"G/L Account";
        TypeIsCustomerLedgerEntry := Type = Type::"Customer Ledger Entry"
    end;
}

