#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5345 "CRM TransactionCurrency List"
{
    ApplicationArea = Basic;
    Caption = 'Microsoft Dynamics CRM Transaction Currencies';
    Editable = false;
    PageType = List;
    SourceTable = "CRM Transactioncurrency";
    SourceTableView = sorting(ISOCurrencyCode);
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field(ISOCurrencyCode;ISOCurrencyCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'ISO Currency Code';
                    StyleExpr = FirstColumnStyle;
                    ToolTip = 'Specifies the ISO currency code, which is required in Dynamics CRM.';
                }
                field(CurrencyName;CurrencyName)
                {
                    ApplicationArea = Suite;
                    Caption = 'Currency Name';
                    ToolTip = 'Specifies the name of the currency.';
                }
                field(Coupled;Coupled)
                {
                    ApplicationArea = Suite;
                    Caption = 'Coupled';
                    ToolTip = 'Specifies if the Dynamics CRM record is coupled to Dynamics NAV.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        CRMIntegrationRecord: Record "CRM Integration Record";
        RecordID: RecordID;
    begin
        if CRMIntegrationRecord.FindRecordIDFromID(TransactionCurrencyId,Database::Currency,RecordID) then
          if CurrentlyCoupledCRMTransactioncurrency.TransactionCurrencyId = TransactionCurrencyId then begin
            Coupled := 'Current';
            FirstColumnStyle := 'Strong';
          end else begin
            Coupled := 'Yes';
            FirstColumnStyle := 'Subordinate';
          end
        else begin
          Coupled := 'No';
          FirstColumnStyle := 'None';
        end;
    end;

    trigger OnInit()
    begin
        Codeunit.Run(Codeunit::"CRM Integration Management");
    end;

    var
        CurrentlyCoupledCRMTransactioncurrency: Record "CRM Transactioncurrency";
        Coupled: Text;
        FirstColumnStyle: Text;


    procedure SetCurrentlyCoupledCRMTransactioncurrency(CRMTransactioncurrency: Record "CRM Transactioncurrency")
    begin
        CurrentlyCoupledCRMTransactioncurrency := CRMTransactioncurrency;
    end;
}

