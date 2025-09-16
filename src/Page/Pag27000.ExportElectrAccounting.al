#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 27000 "Export Electr. Accounting"
{
    ApplicationArea = Basic;
    Caption = 'Export Electr. Accounting';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PromotedActionCategories = 'New,Process,Report,Export';
    ShowFilter = false;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(ExportType;ExportType)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Export Type';
                OptionCaption = 'Chart of Accounts,Trial Balance,Transactions,Auxiliary Accounts';
                ToolTip = 'Specifies which accounting information is exported, such as the trial balance or specific transactions.';

                trigger OnValidate()
                begin
                    EnableControls;
                end;
            }
            field(Year;Year)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Year';
                DecimalPlaces = 0:0;
                MaxValue = 2099;
                MinValue = 2000;
                ShowMandatory = true;
                ToolTip = 'Specifies for which year accounting information is exported. ';
            }
            field(Month;Month)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Month';
                DecimalPlaces = 0:0;
                Enabled = not ClosingBalanceSheet;
                MaxValue = 12;
                MinValue = 1;
                ShowMandatory = true;
                ToolTip = 'Specifies for which month accounting information is exported. ';
            }
            field(DeliveryType;DeliveryType)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Delivery Type';
                Enabled = EnableDeliveryType;
                OptionCaption = 'Normal,Complementary';
                ToolTip = 'Specifies if the exported accounting information will complement existing information. ';

                trigger OnValidate()
                begin
                    EnableControls;
                end;
            }
            field(UpdateDate;UpdateDate)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Update Date';
                Enabled = EnableUpdateDate;
                ShowMandatory = true;
                ToolTip = 'Specifies when the accounting information was last exported.';
            }
            field(RequestType;RequestType)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Request Type';
                Enabled = EnableRequestType;
                OptionCaption = 'AF,FC,DE,CO';
                ToolTip = 'Specifies the request type for the exported information.';

                trigger OnValidate()
                begin
                    EnableControls;
                end;
            }
            field(OrderNumber;OrderNumber)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Order Number';
                Enabled = EnableOrderNumber;
                ShowMandatory = true;
                ToolTip = 'Specifies the order number that will be assigned to the export.';
            }
            field(ProcessNumber;ProcessNumber)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Process Number';
                Enabled = EnableProcessNumber;
                ShowMandatory = true;
                ToolTip = 'Specifies the process number that will be assigned to the export.';
            }
            field(ClosingBalanceSheet;ClosingBalanceSheet)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Closing Balance Sheet';
                Enabled = EnableClosingBalanceSheet;
                ToolTip = 'Specifies if the exported trial balance will include closing balances.';
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Export)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Export...';
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Export the specified accounting information.';

                trigger OnAction()
                begin
                    case ExportType of
                      Exporttype::"Chart of Accounts":
                        ExportAccounts.ExportChartOfAccounts(Year,Month);
                      Exporttype::"Trial Balance":
                        ExportAccounts.ExportBalanceSheet(Year,Month,DeliveryType,UpdateDate,ClosingBalanceSheet);
                      Exporttype::Transactions:
                        ExportAccounts.ExportTransactions(Year,Month,RequestType,OrderNumber,ProcessNumber);
                      Exporttype::"Auxiliary Accounts":
                        ExportAccounts.ExportAuxiliaryAccounts(Year,Month,RequestType,OrderNumber,ProcessNumber);
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Year := Date2dmy(WorkDate,3);
        Month := Date2dmy(WorkDate,2);
        EnableControls;
    end;

    var
        ExportAccounts: Codeunit "Export Accounts";
        ExportType: Option "Chart of Accounts","Trial Balance",Transactions,"Auxiliary Accounts";
        Month: Integer;
        Year: Integer;
        DeliveryType: Option Normal,Complementary;
        UpdateDate: Date;
        RequestType: Option AF,FC,DE,CO;
        OrderNumber: Text[13];
        ProcessNumber: Text[10];
        ClosingBalanceSheet: Boolean;
        EnableUpdateDate: Boolean;
        EnableDeliveryType: Boolean;
        EnableRequestType: Boolean;
        EnableOrderNumber: Boolean;
        EnableProcessNumber: Boolean;
        EnableClosingBalanceSheet: Boolean;

    local procedure EnableControls()
    begin
        ResetControls;

        case ExportType of
          Exporttype::"Trial Balance":
            begin
              EnableDeliveryType := true;
              EnableClosingBalanceSheet := true;
              if DeliveryType = Deliverytype::Complementary then begin
                EnableUpdateDate := true;
                UpdateDate := WorkDate;
              end;
            end;
          Exporttype::Transactions,
          Exporttype::"Auxiliary Accounts":
            begin
              EnableRequestType := true;
              if RequestType in [Requesttype::AF,Requesttype::FC] then
                EnableOrderNumber := true
              else
                EnableProcessNumber := true;
            end;
        end;
    end;

    local procedure ResetControls()
    begin
        EnableDeliveryType := false;
        EnableUpdateDate := false;
        EnableRequestType := false;
        EnableOrderNumber := false;
        EnableProcessNumber := false;
        EnableClosingBalanceSheet := false;

        UpdateDate := 0D;
    end;
}

