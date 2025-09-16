#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 6037 "Change Customer in Contract"
{
    Caption = 'Change Customer in Contract';
    ProcessingOnly = true;

    dataset
    {
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
                    field(ContractNoText;ContractNoText)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Contract No.';
                        DrillDown = true;
                        Editable = false;
                        ToolTip = 'Specifies all billable profits for the job task, expressed in the local currency.';

                        trigger OnDrillDown()
                        begin
                            Page.RunModal(Page::"Service Contract List",TempServContract);
                        end;
                    }
                    field(ServiceItemNoText;ServiceItemNoText)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Service Item No.';
                        DrillDown = true;
                        Editable = false;

                        trigger OnDrillDown()
                        begin
                            Page.RunModal(Page::"Service Item List",TempServItem);
                        end;
                    }
                    field("ServContract.""Customer No.""";ServContract."Customer No.")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Existing Customer No.';
                        Editable = false;
                    }
                    field("ServContract.""Ship-to Code""";ServContract."Ship-to Code")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Existing Ship-to Code';
                        Editable = false;
                    }
                    field(NewCustomerNo;NewCustomerNo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Customer No.';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            Clear(Cust);
                            Cust."No." := NewCustomerNo;
                            Cust.SetFilter(Blocked,'<>%1',Cust.Blocked::All);
                            if Page.RunModal(0,Cust) = Action::LookupOK then
                              if Cust."No." <> '' then begin
                                VerifyCustNo(Cust."No.",NewShiptoCode);
                                NewCustomerNo := Cust."No.";
                              end;
                        end;

                        trigger OnValidate()
                        begin
                            if NewCustomerNo <> '' then
                              VerifyCustNo(NewCustomerNo,NewShiptoCode);
                        end;
                    }
                    field(NewShiptoCode;NewShiptoCode)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Ship-to Code';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            Clear(ShipToAddr);
                            ShipToAddr.SetRange("Customer No.",NewCustomerNo);
                            ShipToAddr.Code := NewShiptoCode;
                            if Page.RunModal(0,ShipToAddr) = Action::LookupOK then begin
                              ShipToAddr.Get(ShipToAddr."Customer No.",ShipToAddr.Code);
                              NewShiptoCode := ShipToAddr.Code;
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            if NewShiptoCode <> '' then
                              ShipToAddr.Get(NewCustomerNo,NewShiptoCode);
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            ServContractMgt.GetAffectedItemsOnCustChange(
              ContractNo,
              TempServContract,
              TempServItem,
              false,
              ServContractLine."contract type"::Contract);

            if TempServContract.Count > 1 then
              ContractNoText := Text004
            else
              ContractNoText := TempServContract."Contract No.";

            if TempServItem.Count > 1 then
              ServiceItemNoText := Text004
            else
              ServiceItemNoText := TempServItem."No.";
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    var
        ServItem: Record "Service Item";
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        CounterBreak: Integer;
        ItemCounter: Integer;
    begin
        ServItem.LockTable;
        ServContractLine.LockTable;
        ServContract.LockTable;
        Clear(TempServContract);
        Clear(TempServItem);
        ServContractMgt.GetAffectedItemsOnCustChange(
          ContractNo,
          TempServContract,
          TempServItem,
          false,
          ServContractLine."contract type"::Contract);

        Window.Open(
          Text005 +
          Text006 +
          '#1###' +
          Text007 +
          '#2###  @3@@@@@@@@@\\' +
          Text008 +
          '#4###' +
          Text007 +
          '#5###  @6@@@@@@@@@\\');
        Window.Update(2,TempServContract.Count);
        Window.Update(5,TempServItem.Count);

        CounterTotal := TempServContract.Count;
        Counter := 0;
        ItemCounter := 0;
        CounterBreak := ROUND(CounterTotal / 100,1,'>');
        if TempServContract.Find('-') then
          repeat
            Counter := Counter + 1;
            ItemCounter := ItemCounter + 1;
            if Counter >= CounterBreak then begin
              Counter := 0;
              Window.Update(3,ROUND(ItemCounter / CounterTotal * 10000,1));
            end;
            Window.Update(1,ItemCounter);
            ServContract.Get(TempServContract."Contract Type",TempServContract."Contract No.");
            ServContractMgt.ChangeCustNoOnServContract(NewCustomerNo,NewShiptoCode,ServContract)
          until TempServContract.Next = 0
        else
          Window.Update(3,10000);

        CounterTotal := TempServItem.Count;
        Counter := 0;
        ItemCounter := 0;
        CounterBreak := ROUND(CounterTotal / 100,1,'>');
        if TempServItem.Find('-') then
          repeat
            Counter := Counter + 1;
            ItemCounter := ItemCounter + 1;
            if Counter >= CounterBreak then begin
              Counter := 0;
              Window.Update(6,ROUND(ItemCounter / CounterTotal * 10000,1));
            end;
            Window.Update(4,ItemCounter);
            ServItem.Get(TempServItem."No.");
            ServContractMgt.ChangeCustNoOnServItem(NewCustomerNo,NewShiptoCode,ServItem)
          until TempServItem.Next = 0
        else
          Window.Update(6,10000);
    end;

    trigger OnPreReport()
    begin
        if NewCustomerNo = '' then
          Error(Text000);
        Cust.Get(NewCustomerNo);
        if NewShiptoCode <> '' then
          ShipToAddr.Get(NewCustomerNo,NewShiptoCode);
        if (NewShiptoCode = ServContract."Ship-to Code") and
           (NewCustomerNo = ServContract."Customer No.")
        then
          Error(Text011);

        if not Confirm(Text002,false) then
          CurrReport.Quit;

        if TempServContract.Count > 1 then
          if not Confirm(
               Text009,false,
               TempServContract.Count,
               TempServItem.Count)
          then
            CurrReport.Quit;
    end;

    var
        Text000: label 'You must fill in the New Customer No. field.';
        ServContract: Record "Service Contract Header";
        Cust: Record Customer;
        ShipToAddr: Record "Ship-to Address";
        ServContractLine: Record "Service Contract Line";
        TempServContract: Record "Service Contract Header" temporary;
        TempServItem: Record "Service Item" temporary;
        ServContractMgt: Codeunit ServContractManagement;
        ContractNo: Code[20];
        NewCustomerNo: Code[20];
        NewShiptoCode: Code[10];
        Text002: label 'If you change the customer number or the ship-to code, the related service orders and sales invoices will not be updated.\\Do you want to continue?';
        Text004: label '(Multiple)';
        ContractNoText: Text[20];
        ServiceItemNoText: Text[20];
        Text005: label 'Updating related objects...\\';
        Text006: label 'Contract     ';
        Text007: label ' from ';
        Text008: label 'Service item ';
        Text009: label 'Are you sure that you want to change the customer number in %1 related contracts/quotes and %2 related service items?';
        Text010: label 'You cannot select a customer with the status Blocked.';
        Text011: label 'The customer number and the ship-to code that you have selected are the same as the ones on this document.';


    procedure SetRecord(ContrNo: Code[20])
    begin
        ContractNo := ContrNo;
        ServContract.Get(ServContract."contract type"::Contract,ContractNo);
        ServContract.TestField("Change Status",ServContract."change status"::Open);
    end;

    local procedure VerifyCustNo(CustNo: Code[20];ShiptoCode: Code[20])
    begin
        if CustNo <> '' then begin
          Cust.Get(CustNo);
          if Cust.Blocked = Cust.Blocked::All then
            Error(Text010);
          if not ShipToAddr.Get(CustNo,ShiptoCode) then
            NewShiptoCode := '';
        end;
    end;


    procedure InitializeRequest(NewCustomerNoFrom: Code[20];NewShipToCodeFrom: Code[10])
    begin
        NewCustomerNo := NewCustomerNoFrom;
        NewShiptoCode := NewShipToCodeFrom;
    end;
}

