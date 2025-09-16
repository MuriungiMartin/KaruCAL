#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 6030 "Create Contract Invoices"
{
    Caption = 'Create Contract Invoices';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Service Contract Header";"Service Contract Header")
        {
            DataItemTableView = sorting("Bill-to Customer No.","Contract Type","Combine Invoices","Next Invoice Date") where("Contract Type"=const(Contract),Status=const(Signed),"Change Status"=const(Locked));
            RequestFilterFields = "Bill-to Customer No.","Contract No.";
            column(ReportForNavId_9952; 9952)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Counter1 := Counter1 + 1;
                Counter2 := Counter2 + 1;
                if Counter2 >= CounterBreak then begin
                  Counter2 := 0;
                  Window.Update(1,ROUND(Counter1 / CounterTotal * 10000,1));
                end;
                Clear(ServContractMgt);
                ServContractMgt.InitCodeUnit;
                ServContractHeader := "Service Contract Header";
                with ServContractHeader do begin
                  TestField("Serv. Contract Acc. Gr. Code");
                  ServContractAccGr.Get("Serv. Contract Acc. Gr. Code");
                  ServContractAccGr.TestField("Non-Prepaid Contract Acc.");
                  if Prepaid then
                    ServContractAccGr.TestField("Prepaid Contract Acc.");
                  Cust.Get("Customer No.");
                  ResultDescription := '';
                  ServContractMgt.GetNextInvoicePeriod(ServContractHeader,InvoiceFrom,InvoiceTo);
                  ContractExist := CheckIfCombinationExists("Service Contract Header");
                  if "Amount per Period" > 0 then begin
                    if not ServContractMgt.CheckIfServiceExist(ServContractHeader) then
                      ResultDescription := Text006;
                    if ResultDescription = '' then begin
                      InvoicedAmount := ROUND(
                          ServContractMgt.CalcContractAmount(ServContractHeader,InvoiceFrom,InvoiceTo),
                          Currency."Amount Rounding Precision");
                      if InvoicedAmount = 0 then
                        CurrReport.Skip;
                      if not "Combine Invoices" or (LastCustomer <> "Bill-to Customer No.") or not LastContractCombined
                      then begin
                        InvoiceNo := ServContractMgt.CreateServHeader(ServContractHeader,PostingDate,ContractExist);
                        NoOfInvoices := NoOfInvoices + 1;
                      end;
                      ResultDescription := InvoiceNo;
                      ServContractMgt.CreateAllServLines(InvoiceNo,ServContractHeader);
                      LastCustomer := "Bill-to Customer No.";
                      LastContractCombined := "Combine Invoices";
                    end;
                  end else
                    if "Annual Amount" = 0 then
                      ResultDescription := StrSubstNo(Text009,FieldCaption("Annual Amount"))
                    else
                      ResultDescription := '';
                end;
                ServContractMgt.FinishCodeunit;
            end;

            trigger OnPostDataItem()
            begin
                if not HideDialog then begin
                  if CreateInvoices = Createinvoices::"Create Invoices" then
                    if NoOfInvoices > 1 then
                      Message(Text010,NoOfInvoices)
                    else
                      Message(Text011,NoOfInvoices);
                end;
            end;

            trigger OnPreDataItem()
            begin
                if CreateInvoices = Createinvoices::"Print Only" then begin
                  Clear(ContractInvoicingTest);
                  ContractInvoicingTest.InitVariables(PostingDate,InvoiceToDate);
                  ContractInvoicingTest.SetTableview("Service Contract Header");
                  ContractInvoicingTest.RunModal;
                  CurrReport.Break;
                end;

                if PostingDate = 0D then
                  Error(Text000);

                if not HideDialog then
                  if PostingDate > WorkDate then
                    if not Confirm(Text001) then
                      Error(Text002);

                if InvoiceToDate = 0D then
                  Error(Text003);

                if not HideDialog then
                  if InvoiceToDate > WorkDate then
                    if not Confirm(Text004) then
                      Error(Text002);

                LastCustomer := '';
                LastContractCombined := false;
                SetFilter("Next Invoice Date",'<>%1&<=%2',0D,InvoiceToDate);
                if GetFilter("Invoice Period") <> '' then
                  SetFilter("Invoice Period",GetFilter("Invoice Period") + '&<>%1',"invoice period"::None)
                else
                  SetFilter("Invoice Period",'<>%1',"invoice period"::None);
                ServContractMgt.CheckMultipleCurrenciesForCustomers("Service Contract Header");
                Window.Open(
                  Text005 +
                  '@1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

                CounterTotal := Count;
                Counter1 := 0;
                Counter2 := 0;
                CounterBreak := ROUND(CounterTotal / 100,1,'>');
                Currency.InitRoundingPrecision;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PostingDate;PostingDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posting Date';
                    }
                    field(InvoiceToDate;InvoiceToDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Invoice to Date';
                    }
                    field(CreateInvoices;CreateInvoices)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Action';
                        OptionCaption = 'Create Invoices,Print Only';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        if not SetOptionsCalled then
          PostingDate := WorkDate;
        NoOfInvoices := 0;
    end;

    var
        Text000: label 'You have not filled in the posting date.';
        Text001: label 'The posting date is later than the work date.\\Confirm that this is the correct date.';
        Text002: label 'The program has stopped the batch job at your request.';
        Text003: label 'You must fill in the Invoice-to Date field.';
        Text004: label 'The Invoice-to Date is later than the work date.\\Confirm that this is the correct date.';
        Text005: label 'Creating contract invoices...\\';
        Text006: label 'Service Order is missing.';
        Text009: label '%1 is missing.';
        Text010: label '%1 invoices were created.';
        Text011: label '%1 invoice was created.';
        Cust: Record Customer;
        ServContractHeader: Record "Service Contract Header";
        ServContractAccGr: Record "Service Contract Account Group";
        Currency: Record Currency;
        ContractInvoicingTest: Report "Contract Invoicing";
        ServContractMgt: Codeunit ServContractManagement;
        Window: Dialog;
        InvoicedAmount: Decimal;
        NoOfInvoices: Integer;
        CounterTotal: Integer;
        Counter1: Integer;
        Counter2: Integer;
        CounterBreak: Integer;
        ResultDescription: Text[80];
        InvoiceNo: Code[20];
        LastCustomer: Code[20];
        InvoiceFrom: Date;
        InvoiceTo: Date;
        PostingDate: Date;
        InvoiceToDate: Date;
        LastContractCombined: Boolean;
        CreateInvoices: Option "Create Invoices","Print Only";
        ContractExist: Boolean;
        HideDialog: Boolean;
        SetOptionsCalled: Boolean;

    local procedure CheckIfCombinationExists(FromServContract: Record "Service Contract Header"): Boolean
    var
        ServContract2: Record "Service Contract Header";
    begin
        ServContract2.SetCurrentkey("Customer No.","Bill-to Customer No.");
        ServContract2.SetFilter("Contract No.",'<>%1',FromServContract."Contract No.");
        ServContract2.SetRange("Customer No.",FromServContract."Customer No.");
        ServContract2.SetRange("Bill-to Customer No.",FromServContract."Bill-to Customer No.");
        exit(ServContract2.FindFirst);
    end;


    procedure SetOptions(NewPostingDate: Date;NewInvoiceToDate: Date;NewCreateInvoices: Option "Create Invoices","Print Only")
    begin
        SetOptionsCalled := true;
        PostingDate := NewPostingDate;
        InvoiceToDate := NewInvoiceToDate;
        CreateInvoices := NewCreateInvoices;
    end;


    procedure SetHideDialog(NewHideDialog: Boolean)
    begin
        HideDialog := NewHideDialog;
    end;
}

