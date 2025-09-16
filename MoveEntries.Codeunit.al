#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 361 MoveEntries
{
    Permissions = TableData "G/L Entry"=rm,
                  TableData "Cust. Ledger Entry"=rm,
                  TableData "Vendor Ledger Entry"=rm,
                  TableData "Item Ledger Entry"=rm,
                  TableData "Job Ledger Entry"=rm,
                  TableData "Res. Ledger Entry"=rm,
                  TableData "Bank Account Ledger Entry"=rm,
                  TableData "Check Ledger Entry"=rm,
                  TableData "Reminder/Fin. Charge Entry"=rm,
                  TableData "Value Entry"=rm,
                  TableData "Avg. Cost Adjmt. Entry Point"=rd,
                  TableData "Inventory Adjmt. Entry (Order)"=rm,
                  TableData "Service Ledger Entry"=rm,
                  TableData "Warranty Ledger Entry"=rm;

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'You cannot delete %1 %2 because it has ledger entries in a fiscal year that has not been closed yet.';
        Text001: label 'You cannot delete %1 %2 because there are one or more open ledger entries.';
        Text002: label 'There are item entries that have not been adjusted for item %1. ';
        Text003: label 'If you delete this item the inventory valuation will be incorrect. ';
        Text004: label 'Use the %2 batch job before deleting the item.';
        Text005: label 'Adjust Cost - Item Entries';
        Text006: label 'You cannot delete %1 %2 because it has ledger entries.';
        Text007: label 'You cannot delete %1 %2 because there are outstanding purchase order lines.';
        Text008: label 'There are item entries that have not been completely invoiced for item %1. ';
        Text009: label 'Invoice all item entries before deleting the item.';
        AccountingPeriod: Record "Accounting Period";
        GLEntry: Record "G/L Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        CheckLedgEntry: Record "Check Ledger Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        ResLedgEntry: Record "Res. Ledger Entry";
        JobLedgEntry: Record "Job Ledger Entry";
        PurchOrderLine: Record "Purchase Line";
        ReminderEntry: Record "Reminder/Fin. Charge Entry";
        ValueEntry: Record "Value Entry";
        AvgCostAdjmt: Record "Avg. Cost Adjmt. Entry Point";
        InvtAdjmtEntryOrder: Record "Inventory Adjmt. Entry (Order)";
        ServLedgEntry: Record "Service Ledger Entry";
        WarrantyLedgEntry: Record "Warranty Ledger Entry";
        Text010: label 'You cannot delete %1 %2 because it has ledger entries after %3.';
        Text011: label 'You cannot delete %1 %2 because it has budget ledger entries\';
        Text012: label ' after %3 in %4 = %5.';
        Text013: label 'You cannot delete %1 %2 because prepaid contract entries exist in %3.';
        Text014: label 'You cannot delete %1 %2, because open prepaid contract entries exist in %3.';
        Text015: label 'You cannot delete %1 %2 because there are outstanding purchase return order lines.';


    procedure MoveGLEntries(GLAcc: Record "G/L Account")
    var
        GLSetup: Record "General Ledger Setup";
        BudgetName: Record "G/L Budget Name";
        GLBudgetEntry: Record "G/L Budget Entry";
        CalcGLAccWhereUsed: Codeunit "Calc. G/L Acc. Where-Used";
    begin
        if GLAcc."Account Type" = GLAcc."account type"::Posting then begin
          GLAcc.CalcFields(Balance);
          GLAcc.TestField(Balance,0);
        end;

        GLEntry.SetCurrentkey("G/L Account No.");
        GLEntry.SetRange("G/L Account No.",GLAcc."No.");
        AccountingPeriod.SetRange(Closed,false);
        if AccountingPeriod.FindFirst then
          GLEntry.SetFilter("Posting Date",'>=%1',AccountingPeriod."Starting Date");
        if not GLEntry.IsEmpty then
          Error(
            Text000,
            GLAcc.TableCaption,GLAcc."No.");

        GLSetup.Get;
        if GLSetup."Allow G/L Acc. Deletion Before" <> 0D then begin
          GLEntry.SetFilter("Posting Date",'>=%1',GLSetup."Allow G/L Acc. Deletion Before");
          if not GLEntry.IsEmpty then
            Error(
              Text010,
              GLAcc.TableCaption,GLAcc."No.",GLSetup."Allow G/L Acc. Deletion Before");
          GLBudgetEntry.LockTable;
          GLBudgetEntry.SetCurrentkey("Budget Name","G/L Account No.",Date);
          GLBudgetEntry.SetRange("G/L Account No.",GLAcc."No.");
          GLBudgetEntry.SetFilter(Date,'>=%1',GLSetup."Allow G/L Acc. Deletion Before");
          if GLBudgetEntry.FindFirst then
            Error(
              Text011 + Text012,
              GLAcc.TableCaption,GLAcc."No.",GLSetup."Allow G/L Acc. Deletion Before",
              BudgetName.TableCaption,GLBudgetEntry."Budget Name");
        end;
        if GLSetup."Check G/L Account Usage" then
          CalcGLAccWhereUsed.DeleteGLNo(GLAcc."No.");

        GLEntry.Reset;
        GLEntry.SetCurrentkey("G/L Account No.");
        GLEntry.SetRange("G/L Account No.",GLAcc."No.");
        GLEntry.ModifyAll("G/L Account No.",'');
    end;


    procedure MoveCustEntries(Cust: Record Customer)
    begin
        CustLedgEntry.Reset;
        CustLedgEntry.SetCurrentkey("Customer No.","Posting Date");
        CustLedgEntry.SetRange("Customer No.",Cust."No.");
        AccountingPeriod.SetRange(Closed,false);
        if AccountingPeriod.FindFirst then
          CustLedgEntry.SetFilter("Posting Date",'>=%1',AccountingPeriod."Starting Date");
        if not CustLedgEntry.IsEmpty then
          Error(
            Text000,
            Cust.TableCaption,Cust."No.");

        CustLedgEntry.Reset;
        if not CustLedgEntry.SetCurrentkey("Customer No.",Open) then
          CustLedgEntry.SetCurrentkey("Customer No.");
        CustLedgEntry.SetRange("Customer No.",Cust."No.");
        CustLedgEntry.SetRange(Open,true);
        if not CustLedgEntry.IsEmpty then
          Error(
            Text001,
            Cust.TableCaption,Cust."No.");

        ReminderEntry.Reset;
        ReminderEntry.SetCurrentkey("Customer No.");
        ReminderEntry.SetRange("Customer No.",Cust."No.");
        ReminderEntry.ModifyAll("Customer No.",'');

        CustLedgEntry.SetRange(Open);
        CustLedgEntry.ModifyAll("Customer No.",'');

        ServLedgEntry.Reset;
        ServLedgEntry.SetRange("Customer No.",Cust."No.");
        AccountingPeriod.SetRange(Closed,false);
        if AccountingPeriod.FindFirst then
          ServLedgEntry.SetFilter("Posting Date",'>=%1',AccountingPeriod."Starting Date");
        if not ServLedgEntry.IsEmpty then
          Error(
            Text000,
            Cust.TableCaption,Cust."No.");

        ServLedgEntry.SetRange("Posting Date");
        ServLedgEntry.SetRange(Open,true);
        if not ServLedgEntry.IsEmpty then
          Error(
            Text001,
            Cust.TableCaption,Cust."No.");

        ServLedgEntry.SetRange(Open);
        ServLedgEntry.ModifyAll("Customer No.",'');

        ServLedgEntry.Reset;
        ServLedgEntry.SetRange("Bill-to Customer No.",Cust."No.");
        AccountingPeriod.SetRange(Closed,false);
        if AccountingPeriod.FindFirst then
          ServLedgEntry.SetFilter("Posting Date",'>=%1',AccountingPeriod."Starting Date");
        if not ServLedgEntry.IsEmpty then
          Error(
            Text000,
            Cust.TableCaption,Cust."No.");

        ServLedgEntry.SetRange("Posting Date");
        ServLedgEntry.SetRange(Open,true);
        if not ServLedgEntry.IsEmpty then
          Error(
            Text001,
            Cust.TableCaption,Cust."No.");

        ServLedgEntry.SetRange(Open);
        ServLedgEntry.ModifyAll("Bill-to Customer No.",'');

        WarrantyLedgEntry.LockTable;
        WarrantyLedgEntry.SetRange("Customer No.",Cust."No.");
        WarrantyLedgEntry.ModifyAll("Customer No.",'');

        WarrantyLedgEntry.SetRange("Customer No.");
        WarrantyLedgEntry.SetRange("Bill-to Customer No.",Cust."No.");
        WarrantyLedgEntry.ModifyAll("Bill-to Customer No.",'');
    end;


    procedure MoveVendorEntries(Vend: Record Vendor)
    begin
        VendLedgEntry.Reset;
        VendLedgEntry.SetCurrentkey("Vendor No.","Posting Date");
        VendLedgEntry.SetRange("Vendor No.",Vend."No.");
        AccountingPeriod.SetRange(Closed,false);
        if AccountingPeriod.FindFirst then
          VendLedgEntry.SetFilter("Posting Date",'>=%1',AccountingPeriod."Starting Date");
        if not VendLedgEntry.IsEmpty then
          Error(
            Text000,
            Vend.TableCaption,Vend."No.");

        VendLedgEntry.Reset;
        if not VendLedgEntry.SetCurrentkey("Vendor No.",Open) then
          VendLedgEntry.SetCurrentkey("Vendor No.");
        VendLedgEntry.SetRange("Vendor No.",Vend."No.");
        VendLedgEntry.SetRange(Open,true);
        if not VendLedgEntry.IsEmpty then
          Error(
            Text001,
            Vend.TableCaption,Vend."No.");

        VendLedgEntry.SetRange(Open);
        VendLedgEntry.ModifyAll("Vendor No.",'');

        WarrantyLedgEntry.LockTable;
        WarrantyLedgEntry.SetRange("Vendor No.",Vend."No.");
        WarrantyLedgEntry.ModifyAll("Vendor No.",'');
    end;


    procedure MoveBankAccEntries(BankAcc: Record "Bank Account")
    begin
        BankAccLedgEntry.Reset;
        BankAccLedgEntry.SetCurrentkey("Bank Account No.","Posting Date");
        BankAccLedgEntry.SetRange("Bank Account No.",BankAcc."No.");
        AccountingPeriod.SetRange(Closed,false);
        if AccountingPeriod.FindFirst then
          BankAccLedgEntry.SetFilter("Posting Date",'>=%1',AccountingPeriod."Starting Date");
        if not BankAccLedgEntry.IsEmpty then
          Error(
            Text000,
            BankAcc.TableCaption,BankAcc."No.");

        BankAccLedgEntry.Reset;
        if not BankAccLedgEntry.SetCurrentkey("Bank Account No.",Open) then
          BankAccLedgEntry.SetCurrentkey("Bank Account No.");
        BankAccLedgEntry.SetRange("Bank Account No.",BankAcc."No.");
        BankAccLedgEntry.SetRange(Open,true);
        if not BankAccLedgEntry.IsEmpty then
          Error(
            Text001,
            BankAcc.TableCaption,BankAcc."No.");

        BankAccLedgEntry.SetRange(Open);
        BankAccLedgEntry.ModifyAll("Bank Account No.",'');
        CheckLedgEntry.SetCurrentkey("Bank Account No.");
        CheckLedgEntry.SetRange("Bank Account No.",BankAcc."No.");
        CheckLedgEntry.ModifyAll("Bank Account No.",'');
    end;


    procedure MoveItemEntries(Item: Record Item)
    begin
        ItemLedgEntry.Reset;
        ItemLedgEntry.SetCurrentkey("Item No.");
        ItemLedgEntry.SetRange("Item No.",Item."No.");
        AccountingPeriod.SetRange(Closed,false);
        if AccountingPeriod.FindFirst then
          ItemLedgEntry.SetFilter("Posting Date",'>=%1',AccountingPeriod."Starting Date");
        if not ItemLedgEntry.IsEmpty then
          Error(
            Text000,
            Item.TableCaption,Item."No.");

        ItemLedgEntry.Reset;
        ItemLedgEntry.SetCurrentkey("Item No.");
        ItemLedgEntry.SetRange("Item No.",Item."No.");
        ItemLedgEntry.SetRange("Completely Invoiced",false);
        if not ItemLedgEntry.IsEmpty then
          Error(
            Text008 +
            Text003 +
            Text009,Item."No.");
        ItemLedgEntry.SetRange("Completely Invoiced");

        ItemLedgEntry.SetCurrentkey("Item No.",Open);
        ItemLedgEntry.SetRange(Open,true);
        if not ItemLedgEntry.IsEmpty then
          Error(
            Text001,
            Item.TableCaption,Item."No.");

        ItemLedgEntry.SetCurrentkey("Item No.","Applied Entry to Adjust");
        ItemLedgEntry.SetRange(Open,false);
        ItemLedgEntry.SetRange("Applied Entry to Adjust",true);
        if not ItemLedgEntry.IsEmpty then
          Error(
            Text002 +
            Text003 +
            Text004,
            Item."No.",Text005);
        ItemLedgEntry.SetRange("Applied Entry to Adjust");

        if Item."Costing Method" = Item."costing method"::Average then begin
          AvgCostAdjmt.Reset;
          AvgCostAdjmt.SetRange("Item No.",Item."No.");
          AvgCostAdjmt.SetRange("Cost Is Adjusted",false);
          if not AvgCostAdjmt.IsEmpty then
            Error(
              Text002 +
              Text003 +
              Text004,
              Item."No.",Text005);
        end;

        ItemLedgEntry.SetRange(Open);
        ItemLedgEntry.ModifyAll("Item No.",'');

        ValueEntry.Reset;
        ValueEntry.SetCurrentkey("Item No.");
        ValueEntry.SetRange("Item No.",Item."No.");
        ValueEntry.ModifyAll("Item No.",'');

        AvgCostAdjmt.Reset;
        AvgCostAdjmt.SetRange("Item No.",Item."No.");
        AvgCostAdjmt.DeleteAll;

        InvtAdjmtEntryOrder.Reset;
        InvtAdjmtEntryOrder.SetRange("Item No.",Item."No.");
        InvtAdjmtEntryOrder.SetRange("Order Type",InvtAdjmtEntryOrder."order type"::Production);
        InvtAdjmtEntryOrder.ModifyAll("Cost is Adjusted",true);
        InvtAdjmtEntryOrder.SetRange("Order Type");
        InvtAdjmtEntryOrder.ModifyAll("Item No.",'');

        ServLedgEntry.Reset;
        ServLedgEntry.SetRange("Item No. (Serviced)",Item."No.");
        AccountingPeriod.SetRange(Closed,false);
        if AccountingPeriod.FindFirst then
          ServLedgEntry.SetFilter("Posting Date",'>=%1',AccountingPeriod."Starting Date");
        if not ServLedgEntry.IsEmpty then
          Error(
            Text000,
            Item.TableCaption,Item."No.");

        ServLedgEntry.SetRange("Posting Date");
        ServLedgEntry.SetRange(Open,true);
        if not ServLedgEntry.IsEmpty then
          Error(
            Text001,
            Item.TableCaption,Item."No.");

        ServLedgEntry.SetRange(Open);
        ServLedgEntry.ModifyAll("Item No. (Serviced)",'');

        ServLedgEntry.SetRange("Item No. (Serviced)");
        ServLedgEntry.SetRange(Type,ServLedgEntry.Type::Item);
        ServLedgEntry.SetRange("No.",Item."No.");
        AccountingPeriod.SetRange(Closed,false);
        if AccountingPeriod.FindFirst then
          ServLedgEntry.SetFilter("Posting Date",'>=%1',AccountingPeriod."Starting Date");
        if not ServLedgEntry.IsEmpty then
          Error(
            Text000,
            Item.TableCaption,Item."No.");

        ServLedgEntry.SetRange("Posting Date");
        ServLedgEntry.SetRange(Open,true);
        if not ServLedgEntry.IsEmpty then
          Error(
            Text001,
            Item.TableCaption,Item."No.");

        ServLedgEntry.SetRange(Open);
        ServLedgEntry.ModifyAll("No.",'');

        WarrantyLedgEntry.LockTable;
        WarrantyLedgEntry.SetRange("Item No. (Serviced)",Item."No.");
        WarrantyLedgEntry.ModifyAll("Item No. (Serviced)",'');

        WarrantyLedgEntry.SetRange("Item No. (Serviced)");
        WarrantyLedgEntry.SetRange(Type,WarrantyLedgEntry.Type::Item);
        WarrantyLedgEntry.SetRange("No.",Item."No.");
        WarrantyLedgEntry.ModifyAll("No.",'');
    end;


    procedure MoveResEntries(Res: Record Resource)
    begin
        ResLedgEntry.Reset;
        ResLedgEntry.SetCurrentkey("Resource No.","Posting Date");
        ResLedgEntry.SetRange("Resource No.",Res."No.");
        AccountingPeriod.SetRange(Closed,false);
        if AccountingPeriod.FindFirst then
          ResLedgEntry.SetFilter("Posting Date",'>=%1',AccountingPeriod."Starting Date");
        if not ResLedgEntry.IsEmpty then
          Error(
            Text000,
            Res.TableCaption,Res."No.");

        ResLedgEntry.Reset;
        ResLedgEntry.SetCurrentkey("Resource No.");
        ResLedgEntry.SetRange("Resource No.",Res."No.");
        ResLedgEntry.ModifyAll("Resource No.",'');

        ServLedgEntry.Reset;
        ServLedgEntry.SetRange(Type,ServLedgEntry.Type::Resource);
        ServLedgEntry.SetRange("No.",Res."No.");
        AccountingPeriod.SetRange(Closed,false);
        if AccountingPeriod.FindFirst then
          ServLedgEntry.SetFilter("Posting Date",'>=%1',AccountingPeriod."Starting Date");
        if not ServLedgEntry.IsEmpty then
          Error(
            Text000,
            Res.TableCaption,Res."No.");

        ServLedgEntry.SetRange("Posting Date");
        ServLedgEntry.SetRange(Open,true);
        if not ServLedgEntry.IsEmpty then
          Error(
            Text001,
            Res.TableCaption,Res."No.");

        ServLedgEntry.SetRange(Open);
        ServLedgEntry.ModifyAll("No.",'');

        WarrantyLedgEntry.LockTable;
        WarrantyLedgEntry.SetRange(Type,WarrantyLedgEntry.Type::Resource);
        WarrantyLedgEntry.SetRange("No.",Res."No.");
        WarrantyLedgEntry.ModifyAll("No.",'');
    end;


    procedure MoveJobEntries(Job: Record Job)
    begin
        JobLedgEntry.SetCurrentkey("Job No.");
        JobLedgEntry.SetRange("Job No.",Job."No.");

        if not JobLedgEntry.IsEmpty then
          Error(
            Text006,
            Job.TableCaption,Job."No.");

        PurchOrderLine.SetCurrentkey("Document Type");
        PurchOrderLine.SetFilter(
          "Document Type",'%1|%2',
          PurchOrderLine."document type"::Order,
          PurchOrderLine."document type"::"Return Order");
        PurchOrderLine.SetRange("Job No.",Job."No.");
        if PurchOrderLine.FindFirst then begin
          if PurchOrderLine."Document Type" = PurchOrderLine."document type"::Order then
            Error(Text007,Job.TableCaption,Job."No.");
          if PurchOrderLine."Document Type" = PurchOrderLine."document type"::"Return Order" then
            Error(Text015,Job.TableCaption,Job."No.");
        end;

        ServLedgEntry.Reset;
        ServLedgEntry.SetRange("Job No.",Job."No.");
        AccountingPeriod.SetRange(Closed,false);
        if AccountingPeriod.FindFirst then
          ServLedgEntry.SetFilter("Posting Date",'>=%1',AccountingPeriod."Starting Date");
        if not ServLedgEntry.IsEmpty then
          Error(
            Text000,
            Job.TableCaption,Job."No.");

        ServLedgEntry.SetRange("Posting Date");
        ServLedgEntry.SetRange(Open,true);
        if not ServLedgEntry.IsEmpty then
          Error(
            Text001,
            Job.TableCaption,Job."No.");

        ServLedgEntry.SetRange(Open);
        ServLedgEntry.ModifyAll("Job No.",'');
    end;


    procedure MoveServiceItemLedgerEntries(ServiceItem: Record "Service Item")
    var
        ResultDescription: Text;
    begin
        ServLedgEntry.LockTable;

        ResultDescription := CheckIfServiceItemCanBeDeleted(ServLedgEntry,ServiceItem."No.");
        if ResultDescription <> '' then
          Error(ResultDescription);

        ServLedgEntry.ModifyAll("Service Item No. (Serviced)",'');

        WarrantyLedgEntry.LockTable;
        WarrantyLedgEntry.SetRange("Service Item No. (Serviced)",ServiceItem."No.");
        WarrantyLedgEntry.ModifyAll("Service Item No. (Serviced)",'');
    end;


    procedure MoveServContractLedgerEntries(ServiceContractHeader: Record "Service Contract Header")
    begin
        if ServiceContractHeader.Prepaid then begin
          ServLedgEntry.Reset;
          ServLedgEntry.SetCurrentkey(Type,"No.");
          ServLedgEntry.SetRange(Type,ServLedgEntry.Type::"Service Contract");
          ServLedgEntry.SetRange("No.",ServiceContractHeader."Contract No.");
          ServLedgEntry.SetRange(Prepaid,true);
          ServLedgEntry.SetRange("Moved from Prepaid Acc.",false);
          ServLedgEntry.SetRange(Open,false);
          if not ServLedgEntry.IsEmpty then
            Error(
              Text013,
              ServiceContractHeader.TableCaption,ServiceContractHeader."Contract No.",ServLedgEntry.TableCaption);
          ServLedgEntry.SetRange(Open,true);
          if not ServLedgEntry.IsEmpty then
            Error(
              Text014,
              ServiceContractHeader.TableCaption,ServiceContractHeader."Contract No.",ServLedgEntry.TableCaption);
        end;

        ServLedgEntry.Reset;
        ServLedgEntry.SetRange("Service Contract No.",ServiceContractHeader."Contract No.");
        AccountingPeriod.SetRange(Closed,false);
        if AccountingPeriod.FindFirst then
          ServLedgEntry.SetFilter("Posting Date",'>=%1',AccountingPeriod."Starting Date");
        if not ServLedgEntry.IsEmpty then
          Error(
            Text000,
            ServiceContractHeader.TableCaption,ServiceContractHeader."Contract No.");

        ServLedgEntry.SetRange("Posting Date");
        ServLedgEntry.SetRange(Open,true);
        if not ServLedgEntry.IsEmpty then
          Error(
            Text001,
            ServiceContractHeader.TableCaption,ServiceContractHeader."Contract No.");

        ServLedgEntry.SetRange(Open);
        ServLedgEntry.ModifyAll("Service Contract No.",'');

        ServLedgEntry.SetRange("Service Contract No.");
        ServLedgEntry.SetRange(Type,ServLedgEntry.Type::"Service Contract");
        ServLedgEntry.SetRange("No.",ServiceContractHeader."Contract No.");
        AccountingPeriod.SetRange(Closed,false);
        if AccountingPeriod.FindFirst then
          ServLedgEntry.SetFilter("Posting Date",'>=%1',AccountingPeriod."Starting Date");
        if not ServLedgEntry.IsEmpty then
          Error(
            Text000,
            ServiceContractHeader.TableCaption,ServiceContractHeader."Contract No.");

        ServLedgEntry.SetRange("Posting Date");
        ServLedgEntry.SetRange(Open,true);
        if not ServLedgEntry.IsEmpty then
          Error(
            Text001,
            ServiceContractHeader.TableCaption,ServiceContractHeader."Contract No.");

        ServLedgEntry.SetRange(Open);
        ServLedgEntry.ModifyAll("No.",'');

        WarrantyLedgEntry.LockTable;
        WarrantyLedgEntry.SetRange("Service Contract No.",ServiceContractHeader."Contract No.");
        WarrantyLedgEntry.ModifyAll("Service Contract No.",'');
    end;


    procedure MoveServiceCostLedgerEntries(ServiceCost: Record "Service Cost")
    begin
        ServLedgEntry.Reset;
        ServLedgEntry.SetRange(Type,ServLedgEntry.Type::"Service Cost");
        ServLedgEntry.SetRange("No.",ServiceCost.Code);
        AccountingPeriod.SetRange(Closed,false);
        if AccountingPeriod.FindFirst then
          ServLedgEntry.SetFilter("Posting Date",'>=%1',AccountingPeriod."Starting Date");
        if not ServLedgEntry.IsEmpty then
          Error(
            Text000,
            ServiceCost.TableCaption,ServiceCost.Code);

        ServLedgEntry.SetRange("Posting Date");
        ServLedgEntry.SetRange(Open,true);
        if not ServLedgEntry.IsEmpty then
          Error(
            Text001,
            ServiceCost.TableCaption,ServiceCost.Code);

        ServLedgEntry.SetRange(Open);
        ServLedgEntry.ModifyAll("No.",'');

        WarrantyLedgEntry.LockTable;
        WarrantyLedgEntry.SetRange(Type,WarrantyLedgEntry.Type::"Service Cost");
        WarrantyLedgEntry.SetRange("No.",ServiceCost.Code);
        WarrantyLedgEntry.ModifyAll("No.",'');
    end;


    procedure MoveCashFlowEntries(CashFlowAccount: Record "Cash Flow Account")
    var
        CFForecastEntry: Record "Cash Flow Forecast Entry";
        CFSetup: Record "Cash Flow Setup";
        CFWorksheetLine: Record "Cash Flow Worksheet Line";
    begin
        CashFlowAccount.LockTable;

        if CashFlowAccount."Account Type" = CashFlowAccount."account type"::Entry then begin
          CashFlowAccount.CalcFields(Amount);
          CashFlowAccount.TestField(Amount,0);
        end;

        CFForecastEntry.Reset;
        CFForecastEntry.SetCurrentkey("Cash Flow Account No.");
        CFForecastEntry.SetRange("Cash Flow Account No.",CashFlowAccount."No.");
        AccountingPeriod.SetRange(Closed,false);
        if AccountingPeriod.FindFirst then
          CFForecastEntry.SetFilter("Cash Flow Date",'>%1',AccountingPeriod."Starting Date");
        if not CFForecastEntry.IsEmpty then
          Error(
            Text000,
            CashFlowAccount.TableCaption,CashFlowAccount."No.");

        CFSetup.Get;
        if CFSetup."Receivables CF Account No." = CashFlowAccount."No." then
          CFSetup.ModifyAll("Receivables CF Account No.",'');

        if CFSetup."Payables CF Account No." = CashFlowAccount."No." then
          CFSetup.ModifyAll("Payables CF Account No.",'');

        if CFSetup."Sales Order CF Account No." = CashFlowAccount."No." then
          CFSetup.ModifyAll("Sales Order CF Account No.",'');

        if CFSetup."Purch. Order CF Account No." = CashFlowAccount."No." then
          CFSetup.ModifyAll("Purch. Order CF Account No.",'');

        if CFSetup."FA Budget CF Account No." = CashFlowAccount."No." then
          CFSetup.ModifyAll("FA Budget CF Account No.",'');

        if CFSetup."FA Disposal CF Account No." = CashFlowAccount."No." then
          CFSetup.ModifyAll("FA Disposal CF Account No.",'');

        if CFSetup."Service CF Account No." = CashFlowAccount."No." then
          CFSetup.ModifyAll("Service CF Account No.",'');

        CFWorksheetLine.Reset;
        CFWorksheetLine.SetRange("Cash Flow Account No.",CashFlowAccount."No.");
        CFWorksheetLine.ModifyAll("Cash Flow Account No.",'');

        CFForecastEntry.Reset;
        CFForecastEntry.SetCurrentkey("Cash Flow Forecast No.");
        CFForecastEntry.SetRange("Cash Flow Account No.",CashFlowAccount."No.");
        CFForecastEntry.ModifyAll("Cash Flow Account No.",'');
    end;


    procedure MoveDocRelatedEntries(TableNo: Integer;DocNo: Code[20])
    var
        ItemLedgEntry2: Record "Item Ledger Entry";
        ValueEntry2: Record "Value Entry";
        CostCalcMgt: Codeunit "Cost Calculation Management";
    begin
        ItemLedgEntry2.LockTable;
        ItemLedgEntry2.SetCurrentkey("Document No.");
        ItemLedgEntry2.SetRange("Document No.",DocNo);
        ItemLedgEntry2.SetRange("Document Type",CostCalcMgt.GetDocType(TableNo));
        ItemLedgEntry2.SetFilter("Document Line No.",'<>0');
        ItemLedgEntry2.ModifyAll("Document Line No.",0);

        ValueEntry2.LockTable;
        ValueEntry2.SetCurrentkey("Document No.");
        ValueEntry2.SetRange("Document No.",DocNo);
        ValueEntry2.SetRange("Document Type",CostCalcMgt.GetDocType(TableNo));
        ValueEntry2.SetFilter("Document Line No.",'<>0');
        ValueEntry2.ModifyAll("Document Line No.",0);
    end;


    procedure CheckIfServiceItemCanBeDeleted(var ServiceLedgerEntry: Record "Service Ledger Entry";ServiceItemNo: Code[20]): Text
    var
        ServiceItem: Record "Service Item";
    begin
        ServiceLedgerEntry.Reset;
        ServiceLedgerEntry.SetCurrentkey("Service Item No. (Serviced)");
        ServiceLedgerEntry.SetRange("Service Item No. (Serviced)",ServiceItemNo);
        AccountingPeriod.SetRange(Closed,false);
        if AccountingPeriod.FindFirst then
          ServiceLedgerEntry.SetFilter("Posting Date",'>=%1',AccountingPeriod."Starting Date");
        if not ServiceLedgerEntry.IsEmpty then
          exit(StrSubstNo(Text000,ServiceItem.TableCaption,ServiceItemNo));

        ServiceLedgerEntry.SetRange("Posting Date");
        ServiceLedgerEntry.SetRange(Open,true);
        if not ServiceLedgerEntry.IsEmpty then
          exit(StrSubstNo(Text001,ServiceItem.TableCaption,ServiceItemNo));

        ServiceLedgerEntry.SetRange(Open);
        exit('');
    end;
}

