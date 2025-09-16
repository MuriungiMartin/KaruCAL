#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5346 "CRM Pricelevel List"
{
    Caption = 'Microsoft Dynamics CRM Price List';
    Editable = false;
    PageType = List;
    SourceTable = "CRM Pricelevel";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name;Name)
                {
                    ApplicationArea = Suite;
                    Caption = 'Name';
                    StyleExpr = FirstColumnStyle;
                    ToolTip = 'Specifies the name of the record.';
                }
                field(StateCode;StateCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'Status';
                }
                field(StatusCode;StatusCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'Status Reason';
                }
                field(TransactionCurrencyIdName;TransactionCurrencyIdName)
                {
                    ApplicationArea = Suite;
                    Caption = 'Currency';
                    ToolTip = 'Specifies the currency that amounts are shown in.';
                }
                field(ExchangeRate;ExchangeRate)
                {
                    ApplicationArea = Suite;
                    Caption = 'Exchange Rate';
                    ToolTip = 'Specifies the currency exchange rate.';
                }
                field(Coupled;Coupled)
                {
                    ApplicationArea = Suite;
                    Caption = 'Coupled';
                    ToolTip = 'Specifies the coupling mark of the record.';
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
        if CRMIntegrationRecord.FindRecordIDFromID(PriceLevelId,Database::"Customer Price Group",RecordID) then
          if CurrentlyCoupledCRMPricelevel.PriceLevelId = PriceLevelId then begin
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
        CurrentlyCoupledCRMPricelevel: Record "CRM Pricelevel";
        Coupled: Text;
        FirstColumnStyle: Text;


    procedure SetCurrentlyCoupledCRMPricelevel(CRMPricelevel: Record "CRM Pricelevel")
    begin
        CurrentlyCoupledCRMPricelevel := CRMPricelevel;
    end;
}

