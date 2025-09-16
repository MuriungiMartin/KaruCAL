#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 83 "Change Global Dimensions"
{
    Caption = 'Change Global Dimensions';
    Permissions = TableData "G/L Entry"=imd,
                  TableData "Cust. Ledger Entry"=imd,
                  TableData "Vendor Ledger Entry"=imd,
                  TableData "Item Ledger Entry"=imd,
                  TableData "Sales Shipment Header"=imd,
                  TableData "Sales Shipment Line"=imd,
                  TableData "Sales Invoice Header"=imd,
                  TableData "Sales Invoice Line"=imd,
                  TableData "Sales Cr.Memo Header"=imd,
                  TableData "Sales Cr.Memo Line"=imd,
                  TableData "Purch. Rcpt. Header"=imd,
                  TableData "Purch. Rcpt. Line"=imd,
                  TableData "Purch. Inv. Header"=imd,
                  TableData "Purch. Inv. Line"=imd,
                  TableData "Purch. Cr. Memo Hdr."=imd,
                  TableData "Purch. Cr. Memo Line"=imd,
                  TableData "Job Ledger Entry"=imd,
                  TableData "Standard Sales Line"=imd,
                  TableData "Standard Purchase Line"=imd,
                  TableData "Res. Ledger Entry"=imd,
                  TableData "Bank Account Ledger Entry"=imd,
                  TableData "Phys. Inventory Ledger Entry"=imd,
                  TableData "Issued Reminder Header"=imd,
                  TableData "Issued Fin. Charge Memo Header"=imd,
                  TableData "Detailed Cust. Ledg. Entry"=imd,
                  TableData "Detailed Vendor Ledg. Entry"=imd,
                  TableData "Job Task"=imd,
                  TableData "Job WIP Entry"=imd,
                  TableData "Job WIP G/L Entry"=imd,
                  TableData "Sales Header Archive"=imd,
                  TableData "Sales Line Archive"=imd,
                  TableData "Purchase Header Archive"=imd,
                  TableData "Purchase Line Archive"=imd,
                  TableData "FA Ledger Entry"=imd,
                  TableData "Maintenance Ledger Entry"=imd,
                  TableData "Ins. Coverage Ledger Entry"=imd,
                  TableData "Value Entry"=imd,
                  TableData "Capacity Ledger Entry"=imd,
                  TableData "Service Ledger Entry"=imd,
                  TableData "Warranty Ledger Entry"=imd,
                  TableData "Service Contract Header"=imd,
                  TableData "Filed Service Contract Header"=imd,
                  TableData "Filed Contract Line"=imd,
                  TableData "Return Shipment Header"=imd,
                  TableData "Return Shipment Line"=imd,
                  TableData "Return Receipt Header"=imd,
                  TableData "Return Receipt Line"=imd,
                  TableData "Dimensions Field Map"=imd,
                  TableData UnknownTableData10124=imd,
                  TableData UnknownTableData10143=imd,
                  TableData UnknownTableData10144=imd;
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
                    field(NewGlobalDim1Code;NewGlobalDim1Code)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Global Dimension 1 Code';
                        TableRelation = Dimension;
                        ToolTip = 'Specifies the dimension that is currently defined as Global Dimension 1.';

                        trigger OnValidate()
                        begin
                            if NewGlobalDim1Code = NewGlobalDim2Code then
                              NewGlobalDim2Code := '';
                        end;
                    }
                    field(NewGlobalDim2Code;NewGlobalDim2Code)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Global Dimension 2 Code';
                        TableRelation = Dimension;
                        ToolTip = 'Specifies the dimension that is currently defined as Global Dimension 2.';

                        trigger OnValidate()
                        begin
                            if NewGlobalDim1Code = NewGlobalDim2Code then
                              NewGlobalDim1Code := '';
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
            GLSetup.Get;
            NewGlobalDim1Code := GLSetup."Global Dimension 1 Code";
            NewGlobalDim2Code := GLSetup."Global Dimension 2 Code";
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        if ChangeGlobalDim then begin
          GLSetup.Validate("Global Dimension 1 Code",NewGlobalDim1Code);
          GLSetup.Validate("Global Dimension 2 Code",NewGlobalDim2Code);
          GLSetup.Modify(true);
          Message(
            Text004,
            ConfirmationMessage);
        end;
    end;

    trigger OnPreReport()
    var
        Dim: Record Dimension;
    begin
        if NewGlobalDim1Code <> GLSetup."Global Dimension 1 Code" then begin
          ConfirmationMessage :=
            GLSetup.FieldCaption("Global Dimension 1 Code") + ' (' +
            GLSetup.FieldCaption("Shortcut Dimension 1 Code") + ')';
          if NewGlobalDim2Code <> GLSetup."Global Dimension 2 Code" then
            ConfirmationMessage := ConfirmationMessage + Text000 +
              GLSetup.FieldCaption("Global Dimension 2 Code") + ' (' +
              GLSetup.FieldCaption("Shortcut Dimension 2 Code") + ')';
        end else
          if NewGlobalDim2Code <> GLSetup."Global Dimension 2 Code" then
            ConfirmationMessage :=
              GLSetup.FieldCaption("Global Dimension 2 Code") + ' (' +
              GLSetup.FieldCaption("Shortcut Dimension 2 Code") + ')';

        if ConfirmationMessage <> '' then begin
          if (NewGlobalDim1Code = GLSetup."Global Dimension 2 Code") and
             (NewGlobalDim2Code = GLSetup."Global Dimension 1 Code")
          then begin
            Message(Text001);
            CurrReport.Quit;
          end;
          if Dim.CheckIfDimUsed(NewGlobalDim1Code,1,'','',0) then
            Error(
              Text002,
              Dim.GetCheckDimErr,GLSetup.FieldCaption("Global Dimension 1 Code"));
          if Dim.CheckIfDimUsed(NewGlobalDim2Code,2,'','',0) then
            Error(
              Text002,
              Dim.GetCheckDimErr,GLSetup.FieldCaption("Global Dimension 2 Code"));
          if not Confirm(Text003,false,ConfirmationMessage) then
            CurrReport.Quit;
        end else
          CurrReport.Quit;
    end;

    var
        Text000: label ' and ';
        Text001: label 'You must run this batch job twice to reverse the global dimensions.';
        Text002: label '%1\You cannot use it as %2.';
        Text003: label 'Are you sure that you want to change:\%1?';
        Text004: label 'The following dimensions have been successfully changed:\%1.';
        Text005: label 'Database information\';
        Text006: label ' No. of Records        #1######\';
        Text007: label ' Progress              @2@@@@@@@@@@@@@\';
        Text008: label ' Estimated Ending Time #3#######################\';
        Text009: label 'Table information\';
        Text010: label ' Company               #4#######################\';
        Text011: label ' Table                 #5#######################\';
        Text012: label ' No. of Records        #6######\';
        Text013: label ' Progress              @7@@@@@@@@@@@@@';
        Text014: label 'Please wait while the operation is being completed.';
        Text015: label '<Hours24>:<Minutes,2>';
        DimVal: Record "Dimension Value";
        ItemBudgetEntry: Record "Item Budget Entry";
        GLSetup: Record "General Ledger Setup";
        GLAcc: Record "G/L Account";
        GLEntry: Record "G/L Entry";
        Cust: Record Customer;
        CustLedgEntry: Record "Cust. Ledger Entry";
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        Vend: Record Vendor;
        VendorLedgEntry: Record "Vendor Ledger Entry";
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        Item: Record Item;
        ItemLedgEntry: Record "Item Ledger Entry";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        GenJnlLine: Record "Gen. Journal Line";
        ItemJnlLine: Record "Item Journal Line";
        GLBudgetEntry: Record "G/L Budget Entry";
        SalesShptHeader: Record "Sales Shipment Header";
        SaleShptLine: Record "Sales Shipment Line";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        ReturnRcptHeader: Record "Return Receipt Header";
        ReturnRcptLine: Record "Return Receipt Line";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        ServHeader: Record "Service Header";
        ServLine: Record "Service Line";
        ServShptHeader: Record "Service Shipment Header";
        ServShptLine: Record "Service Shipment Line";
        ServInvHeader: Record "Service Invoice Header";
        ServInvLine: Record "Service Invoice Line";
        ServCrMemoHeader: Record "Service Cr.Memo Header";
        ServCrMemoLine: Record "Service Cr.Memo Line";
        ReturnShptHeader: Record "Return Shipment Header";
        ReturnShptLine: Record "Return Shipment Line";
        ResGr: Record "Resource Group";
        Res: Record Resource;
        Job: Record Job;
        JobLedgEntry: Record "Job Ledger Entry";
        ResLedgEntry: Record "Res. Ledger Entry";
        StdSalesLine: Record "Standard Sales Line";
        StdPurchLine: Record "Standard Purchase Line";
        ValueEntry: Record "Value Entry";
        CapLedgEntry: Record "Capacity Ledger Entry";
        ResJnlLine: Record "Res. Journal Line";
        JobJnlLine: Record "Job Journal Line";
        GenJnlAlloc: Record "Gen. Jnl. Allocation";
        ReqLine: Record "Requisition Line";
        BankAcc: Record "Bank Account";
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        PhysInvtLedgEntry: Record "Phys. Inventory Ledger Entry";
        ReminderHeader: Record "Reminder Header";
        IssuedReminderHeader: Record "Issued Reminder Header";
        FinChrgMemoHeader: Record "Finance Charge Memo Header";
        IssuedFinChrgMemoHeader: Record "Issued Fin. Charge Memo Header";
        Employee: Record Employee;
        ProdOrder: Record "Production Order";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderComp: Record "Prod. Order Component";
        FA: Record "Fixed Asset";
        FALedgEntry: Record "FA Ledger Entry";
        FAAlloc: Record "FA Allocation";
        FAJnlLine: Record "FA Journal Line";
        MaintenanceLedgEntry: Record "Maintenance Ledger Entry";
        Insurance: Record Insurance;
        InsCovLedgEntry: Record "Ins. Coverage Ledger Entry";
        InsuranceJnlLine: Record "Insurance Journal Line";
        RespCenter: Record "Responsibility Center";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        Campaign: Record Campaign;
        CustomerTemplate: Record "Customer Template";
        SalesHeaderArchive: Record "Sales Header Archive";
        SalesLineArchive: Record "Sales Line Archive";
        PurchHeaderArchive: Record "Purchase Header Archive";
        PurchLineArchive: Record "Purchase Line Archive";
        DimSetEntry: Record "Dimension Set Entry";
        DefaultDim: Record "Default Dimension";
        DimBuf: Record "Dimension Buffer";
        WarrantyLedgerEntry: Record "Warranty Ledger Entry";
        ServiceLedgerEntry: Record "Service Ledger Entry";
        ItemCharge: Record "Item Charge";
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        TransferShipmentHeader: Record "Transfer Shipment Header";
        TransferShipmentLine: Record "Transfer Shipment Line";
        TransferReceiptHeader: Record "Transfer Receipt Header";
        TransferReceiptLine: Record "Transfer Receipt Line";
        WorkCenter: Record "Work Center";
        PlanningComponent: Record "Planning Component";
        ServItemLine: Record "Service Item Line";
        JobTask: Record "Job Task";
        JobTaskDim: Record "Job Task Dimension";
        JobWIPEntry: Record "Job WIP Entry";
        JobWIPGLEntry: Record "Job WIP G/L Entry";
        StdGenJnlLine: Record "Standard General Journal Line";
        StdItemJnlLine: Record "Standard Item Journal Line";
        ServCtrHeader: Record "Service Contract Header";
        FiledServCtrHeader: Record "Filed Service Contract Header";
        StdServLine: Record "Standard Service Line";
        TempDefaultDimDimensionsFieldMap: Record "Dimensions Field Map" temporary;
        TempDimSetDimensionsFieldMap: Record "Dimensions Field Map" temporary;
        IndicatorWindow: Dialog;
        DepositHeader: Record UnknownRecord10140;
        PostedDepositHeader: Record UnknownRecord10143;
        PostedDepositLine: Record UnknownRecord10144;
        BankRecLine: Record UnknownRecord10121;
        PostedBankRecLine: Record UnknownRecord10124;
        NewGlobalDim1Code: Code[20];
        NewGlobalDim2Code: Code[20];
        DatabaseRecords: Integer;
        CheckedDatabaseRecords: Integer;
        TableRecords: Integer;
        CheckedTableRecords: Integer;
        StartTime: Time;
        StartDate: Date;
        ConfirmationMessage: Text[250];

    local procedure ChangeGlobalDim(): Boolean
    var
        DimFilter: Text[250];
        TempTableOption: Option DefaultDimTables,DimSetTables;
    begin
        InitializeTablesForModification;
        OpenIndicator;
        CountRowsAndLockTable(TempDefaultDimDimensionsFieldMap);
        CountRowsAndLockTable(TempDimSetDimensionsFieldMap);
        CountRowsAndLockExceptionalCases;

        DimVal.SetCurrentkey(Code,"Global Dimension No.");
        DimVal.SetRange("Global Dimension No.",1,2);
        DimVal.ModifyAll("Global Dimension No.",0);
        DimVal.Reset;
        if NewGlobalDim1Code <> '' then begin
          DimVal.SetRange("Dimension Code",NewGlobalDim1Code);
          DimVal.ModifyAll("Global Dimension No.",1);
        end;
        if NewGlobalDim2Code <> '' then begin
          DimVal.SetRange("Dimension Code",NewGlobalDim2Code);
          DimVal.ModifyAll("Global Dimension No.",2);
        end;

        if NewGlobalDim1Code <> '' then
          if NewGlobalDim2Code <> '' then
            DimFilter := NewGlobalDim1Code + '|' + NewGlobalDim2Code
          else
            DimFilter := NewGlobalDim1Code
        else
          if NewGlobalDim2Code <> '' then
            DimFilter := NewGlobalDim2Code
          else
            DimFilter := '';
        DefaultDim.SetFilter("Dimension Code",DimFilter);
        DimBuf.SetFilter("Dimension Code",DimFilter);
        JobTaskDim.SetFilter("Dimension Code",DimFilter);  // PS55126

        StartTime := Time;
        StartDate := Today;

        ChangeGlobalsInTables(Temptableoption::DefaultDimTables);
        ChangeGlobalsInTables(Temptableoption::DimSetTables);
        UpdateExceptionalCases;

        IndicatorWindow.Close;
        exit(true);
    end;

    local procedure GetDefaultJobTaskDim(JobNo: Code[20];JobTaskNo: Code[20];var GlobalDim1Value: Code[20];var GlobalDim2Value: Code[20])
    begin
        GlobalDim1Value := '';
        GlobalDim2Value := '';

        JobTaskDim.SetRange("Job No.",JobNo);
        JobTaskDim.SetRange("Job Task No.",JobTaskNo);
        if JobTaskDim.FindSet then
          repeat
            if JobTaskDim."Dimension Code" = NewGlobalDim1Code then
              GlobalDim1Value := JobTaskDim."Dimension Value Code";
            if JobTaskDim."Dimension Code" = NewGlobalDim2Code then
              GlobalDim2Value := JobTaskDim."Dimension Value Code";
          until JobTaskDim.Next = 0;
    end;

    local procedure OpenIndicator()
    begin
        IndicatorWindow.Open(
          Text005 +
          Text006 +
          Text007 +
          Text008 +
          Text009 +
          Text010 +
          Text011 +
          Text012 +
          Text013);
    end;

    local procedure UpdateGeneralInfo(CompanyName: Text[100];TableName: Text[50];CurrentTableRecords: Integer)
    begin
        TableRecords := CurrentTableRecords;
        CheckedTableRecords := 0;
        IndicatorWindow.Update(1,DatabaseRecords);
        if DatabaseRecords <> 0 then
          IndicatorWindow.Update(2,ROUND(CheckedDatabaseRecords / DatabaseRecords * 10000,1))
        else
          IndicatorWindow.Update(2,0);
        if CheckedDatabaseRecords <> 0 then
          IndicatorWindow.Update(3,CalcEndingTime(Today,Time))
        else
          IndicatorWindow.Update(3,Text014);
        IndicatorWindow.Update(4,CompanyName);
        IndicatorWindow.Update(5,TableName);
        IndicatorWindow.Update(6,CurrentTableRecords);
        CheckedDatabaseRecords := CheckedDatabaseRecords + CurrentTableRecords;
    end;

    local procedure UpdateProgressInfo()
    begin
        if TableRecords <> 0 then
          IndicatorWindow.Update(7,ROUND(CheckedTableRecords / TableRecords * 10000,1))
        else
          IndicatorWindow.Update(7,0);
    end;

    local procedure CalcEndingTime(PresentDate: Date;PresentTime: Time): Text[250]
    var
        RemainingTime: Integer;
        EndingDate: Date;
        EndingTime: Time;
    begin
        if PresentDate > StartDate then
          RemainingTime := ((PresentDate - StartDate) * 8640000) + (235959T - StartTime) + (PresentTime - 000000T)
        else
          RemainingTime := (PresentTime - StartTime);
        RemainingTime := ROUND((RemainingTime / CheckedDatabaseRecords) * (DatabaseRecords - CheckedDatabaseRecords),1);
        EndingDate := StartDate + Abs(ROUND(RemainingTime / 360000,1));
        EndingTime := StartTime + Abs(ROUND(RemainingTime MOD 360000,1));
        if EndingTime < StartTime then
          EndingDate := EndingDate + 1;
        exit(Format(EndingDate) + ' ' + Format(EndingTime,0,Text015));
    end;


    procedure InitializeRequest(NewGlobalDim1CodeFrom: Code[20];NewGlobalDim2CodeFrom: Code[20])
    begin
        NewGlobalDim1Code := NewGlobalDim1CodeFrom;
        NewGlobalDim2Code := NewGlobalDim2CodeFrom;
    end;

    local procedure GetDefaultDim(No: Code[20];Global1FieldRef: FieldRef;Global2FieldRef: FieldRef)
    begin
        Global1FieldRef.Value := '';
        Global2FieldRef.Value := '';

        DefaultDim.SetRange("Table ID",Global1FieldRef.Record.Number);
        DefaultDim.SetRange("No.",No);
        if DefaultDim.FindSet then
          repeat
            if DefaultDim."Dimension Code" = NewGlobalDim1Code then
              Global1FieldRef.Value := DefaultDim."Dimension Value Code";
            if DefaultDim."Dimension Code" = NewGlobalDim2Code then
              Global2FieldRef.Value := DefaultDim."Dimension Value Code";
          until DefaultDim.Next = 0;
    end;

    local procedure AddToDefaultDimTempTable(TableNo: Integer;Global1FieldNo: Integer;Global2FieldNo: Integer;IDFieldNo: Integer)
    begin
        AddToTempTable(TempDefaultDimDimensionsFieldMap,TableNo,Global1FieldNo,Global2FieldNo,IDFieldNo);
    end;

    local procedure AddToDimSetTempTable(TableNo: Integer;Global1FieldNo: Integer;Global2FieldNo: Integer;IDFieldNo: Integer)
    begin
        AddToTempTable(TempDimSetDimensionsFieldMap,TableNo,Global1FieldNo,Global2FieldNo,IDFieldNo);
    end;

    local procedure ChangeGlobalsInTables(TempTableOption: Option DefaultDimTables,DimSetTables)
    var
        FieldRecordRef: RecordRef;
        TempRecRef: RecordRef;
        TableNoFieldRef: FieldRef;
        TableNumber: Integer;
        TableNoFieldNumber: Integer;
    begin
        case TempTableOption of
          Temptableoption::DefaultDimTables:
            FieldRecordRef.GetTable(TempDefaultDimDimensionsFieldMap);
          Temptableoption::DimSetTables:
            FieldRecordRef.GetTable(TempDimSetDimensionsFieldMap);
        end;

        // Get the field no when the "Table No." is stored.
        TableNoFieldNumber := TempDimSetDimensionsFieldMap.FieldNo("Table No.");
        with FieldRecordRef do begin
          TableNoFieldRef := Field(TableNoFieldNumber);
          if FindSet then begin
            repeat
              TableNumber := TableNoFieldRef.Value;
              TempRecRef.Open(TableNumber);
              case TempTableOption of
                Temptableoption::DefaultDimTables:
                  ChangeGlobalsWithDefaultDim(TempRecRef);
                Temptableoption::DimSetTables:
                  ChangeGlobalsWithDimensionSet(TempRecRef);
              end;
              TempRecRef.Close;
            until Next = 0;
          end
        end;
    end;

    local procedure ChangeGlobalsWithDefaultDim(RecordRefForProcessing: RecordRef)
    var
        Global1FieldNo: Integer;
        Global2FieldNo: Integer;
        NoFieldNo: Integer;
        No: Code[20];
    begin
        GetFieldNumbersFromTempTable(
          TempDefaultDimDimensionsFieldMap,RecordRefForProcessing.Number,Global1FieldNo,Global2FieldNo,NoFieldNo);
        UpdateGeneralInfo(COMPANYNAME,RecordRefForProcessing.Caption,RecordRefForProcessing.Count);
        with RecordRefForProcessing do
          if FindFirst then begin
            repeat
              No := Field(NoFieldNo).Value;
              GetDefaultDim(No,Field(Global1FieldNo),Field(Global2FieldNo));
              Modify;
              CheckedTableRecords := CheckedTableRecords + 1;
              UpdateProgressInfo;
            until Next = 0;
          end;
    end;

    local procedure ChangeGlobalsWithDimensionSet(RecordRefForProcessing: RecordRef)
    var
        Global1FieldNo: Integer;
        Global2FieldNo: Integer;
        DimSetIDFieldNo: Integer;
        DimSetID: Integer;
    begin
        GetFieldNumbersFromTempTable(
          TempDimSetDimensionsFieldMap,RecordRefForProcessing.Number,Global1FieldNo,Global2FieldNo,DimSetIDFieldNo);
        UpdateGeneralInfo(COMPANYNAME,RecordRefForProcessing.Caption,RecordRefForProcessing.Count);
        with RecordRefForProcessing do
          if Find('-') then begin
            repeat
              DimSetID := Field(DimSetIDFieldNo).Value;
              GetDimSetEntry(DimSetID,Field(Global1FieldNo),Field(Global2FieldNo));
              Modify;
              CheckedTableRecords := CheckedTableRecords + 1;
              UpdateProgressInfo;
            until Next = 0;
          end;
    end;

    local procedure GetDimSetEntry(DimSetID: Integer;Global1FieldRef: FieldRef;Global2FieldRef: FieldRef)
    begin
        Global1FieldRef.Value := '';
        Global2FieldRef.Value := '';

        DimSetEntry.SetRange("Dimension Set ID",DimSetID);
        if DimSetEntry.FindSet then
          repeat
            if DimSetEntry."Dimension Code" = NewGlobalDim1Code then
              Global1FieldRef.Value := DimSetEntry."Dimension Value Code";
            if DimSetEntry."Dimension Code" = NewGlobalDim2Code then
              Global2FieldRef.Value := DimSetEntry."Dimension Value Code";
          until DimSetEntry.Next = 0;
    end;

    local procedure CountRowsAndLockExceptionalCases()
    var
        TempRecRef: RecordRef;
    begin
        TempRecRef.GetTable(SalesLineArchive);
        CountRowsAndLock(TempRecRef,DatabaseRecords);
        TempRecRef.GetTable(PurchLineArchive);
        CountRowsAndLock(TempRecRef,DatabaseRecords);
        TempRecRef.GetTable(CustLedgEntry);
        CountRowsAndLock(TempRecRef,DatabaseRecords);
        TempRecRef.GetTable(VendorLedgEntry);
        CountRowsAndLock(TempRecRef,DatabaseRecords);
        TempRecRef.GetTable(JobTask);
        CountRowsAndLock(TempRecRef,DatabaseRecords);
    end;

    local procedure UpdateExceptionalCases()
    var
        TempRecRef: RecordRef;
    begin
        UpdateGeneralInfo(COMPANYNAME,SalesLineArchive.TableCaption,SalesLineArchive.Count);
        with SalesLineArchive do begin
          SetCurrentkey("Document Type","Document No.","Line No.","Doc. No. Occurrence","Version No.");
          if Find('-') then begin
            repeat
              TempRecRef.GetTable(SalesLineArchive);
              GetDimSetEntry(
                "Dimension Set ID",
                TempRecRef.Field(FieldNo("Shortcut Dimension 1 Code")),TempRecRef.Field(FieldNo("Shortcut Dimension 2 Code")));
              Modify;
              CheckedTableRecords := CheckedTableRecords + 1;
              UpdateProgressInfo;
            until Next = 0;
          end;
        end;

        UpdateGeneralInfo(COMPANYNAME,PurchLineArchive.TableCaption,PurchLineArchive.Count);
        with PurchLineArchive do begin
          SetCurrentkey("Document Type","Document No.","Line No.","Doc. No. Occurrence","Version No.");
          if Find('-') then begin
            repeat
              TempRecRef.GetTable(PurchLineArchive);
              GetDimSetEntry(
                "Dimension Set ID",
                TempRecRef.Field(FieldNo("Shortcut Dimension 1 Code")),TempRecRef.Field(FieldNo("Shortcut Dimension 2 Code")));
              Modify;
              CheckedTableRecords := CheckedTableRecords + 1;
              UpdateProgressInfo;
            until Next = 0;
          end;
        end;

        UpdateGeneralInfo(COMPANYNAME,CustLedgEntry.TableCaption,CustLedgEntry.Count);
        DtldCustLedgEntry.SetCurrentkey("Cust. Ledger Entry No.");
        with CustLedgEntry do
          if Find('-') then begin
            repeat
              TempRecRef.GetTable(CustLedgEntry);
              GetDimSetEntry(
                "Dimension Set ID",
                TempRecRef.Field(FieldNo("Global Dimension 1 Code")),TempRecRef.Field(FieldNo("Global Dimension 2 Code")));
              Modify;
              DtldCustLedgEntry.SetRange("Cust. Ledger Entry No.","Entry No.");
              if DtldCustLedgEntry.Find('-') then
                repeat
                  DtldCustLedgEntry."Initial Entry Global Dim. 1" := "Global Dimension 1 Code";
                  DtldCustLedgEntry."Initial Entry Global Dim. 2" := "Global Dimension 2 Code";
                  DtldCustLedgEntry.Modify;
                until DtldCustLedgEntry.Next = 0;
              CheckedTableRecords := CheckedTableRecords + 1;
              UpdateProgressInfo;
            until Next = 0;
          end;

        UpdateGeneralInfo(COMPANYNAME,VendorLedgEntry.TableCaption,VendorLedgEntry.Count);
        DtldVendLedgEntry.SetCurrentkey("Vendor Ledger Entry No.");
        with VendorLedgEntry do
          if Find('-') then begin
            repeat
              TempRecRef.GetTable(VendorLedgEntry);
              GetDimSetEntry(
                "Dimension Set ID",
                TempRecRef.Field(FieldNo("Global Dimension 1 Code")),TempRecRef.Field(FieldNo("Global Dimension 2 Code")));
              Modify;
              DtldVendLedgEntry.SetRange("Vendor Ledger Entry No.","Entry No.");
              if DtldVendLedgEntry.Find('-') then
                repeat
                  DtldVendLedgEntry."Initial Entry Global Dim. 1" := "Global Dimension 1 Code";
                  DtldVendLedgEntry."Initial Entry Global Dim. 2" := "Global Dimension 2 Code";
                  DtldVendLedgEntry.Modify;
                until DtldVendLedgEntry.Next = 0;
              CheckedTableRecords := CheckedTableRecords + 1;
              UpdateProgressInfo;
            until Next = 0;
          end;

        UpdateGeneralInfo(COMPANYNAME,JobTask.TableCaption,JobTask.Count);
        with JobTask do
          if FindSet then begin
            repeat
              GetDefaultJobTaskDim(
                "Job No.",
                "Job Task No.",
                "Global Dimension 1 Code",
                "Global Dimension 2 Code");
              Modify;
              CheckedTableRecords := CheckedTableRecords + 1;
              UpdateProgressInfo;
            until Next = 0;
          end;
    end;

    local procedure CountRowsAndLock(RecRef: RecordRef;var NumberOfRecords: Integer)
    begin
        with RecRef do begin
          LockTable;
          if FindLast then;
        end;
        NumberOfRecords := NumberOfRecords + RecRef.Count;
    end;

    local procedure CountRowsAndLockTable(var TempDimensionsFieldMap: Record "Dimensions Field Map" temporary)
    var
        TempRecRef: RecordRef;
    begin
        with TempDimensionsFieldMap do begin
          FindSet;
          repeat
            TempRecRef.Open("Table No.");
            CountRowsAndLock(TempRecRef,DatabaseRecords);
            TempRecRef.Close;
          until Next = 0;
        end;
    end;

    local procedure AddToTempTable(var TempDimensionsFieldMap: Record "Dimensions Field Map" temporary;TableNo: Integer;Global1FieldNo: Integer;Global2FieldNo: Integer;IDFieldNo: Integer)
    begin
        // populate the table with rows of the field numbers that we will use.
        TempDimensionsFieldMap."Table No." := TableNo;
        TempDimensionsFieldMap."Global Dim.1 Field No." := Global1FieldNo;
        TempDimensionsFieldMap."Global Dim.2 Field No." := Global2FieldNo;
        TempDimensionsFieldMap."ID Field No." := IDFieldNo;
        TempDimensionsFieldMap.Insert;
    end;

    local procedure GetFieldNumbersFromTempTable(var TempDimensionsFieldMap: Record "Dimensions Field Map" temporary;TableNo: Integer;var Global1FieldNo: Integer;var Global2FieldNo: Integer;var IDFieldNo: Integer)
    begin
        TempDimensionsFieldMap.Get(TableNo);
        Global1FieldNo := TempDimensionsFieldMap."Global Dim.1 Field No.";
        Global2FieldNo := TempDimensionsFieldMap."Global Dim.2 Field No.";
        IDFieldNo := TempDimensionsFieldMap."ID Field No.";
    end;


    procedure InitializeTablesForModification()
    begin
        TempDefaultDimDimensionsFieldMap.DeleteAll;
        TempDimSetDimensionsFieldMap.DeleteAll;

        AddingDefaultValueDim;

        // Initialize the tables using the Dimension Set
        AddToDimSetTempTable(
          Database::"G/L Entry",GLEntry.FieldNo("Global Dimension 1 Code"),GLEntry.FieldNo("Global Dimension 2 Code"),
          GLEntry.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Cust. Ledger Entry",CustLedgEntry.FieldNo("Global Dimension 1 Code"),
          CustLedgEntry.FieldNo("Global Dimension 2 Code"),CustLedgEntry.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Vendor Ledger Entry",VendorLedgEntry.FieldNo("Global Dimension 1 Code"),
          VendorLedgEntry.FieldNo("Global Dimension 2 Code"),VendorLedgEntry.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Item Ledger Entry",ItemLedgEntry.FieldNo("Global Dimension 1 Code"),
          ItemLedgEntry.FieldNo("Global Dimension 2 Code"),ItemLedgEntry.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Job Ledger Entry",JobLedgEntry.FieldNo("Global Dimension 1 Code"),JobLedgEntry.FieldNo("Global Dimension 2 Code"),
          JobLedgEntry.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Res. Ledger Entry",ResLedgEntry.FieldNo("Global Dimension 1 Code"),
          ResLedgEntry.FieldNo("Global Dimension 2 Code"),ResLedgEntry.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Value Entry",ValueEntry.FieldNo("Global Dimension 1 Code"),ValueEntry.FieldNo("Global Dimension 2 Code"),
          ValueEntry.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Capacity Ledger Entry",CapLedgEntry.FieldNo("Global Dimension 1 Code"),
          CapLedgEntry.FieldNo("Global Dimension 2 Code"),CapLedgEntry.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Bank Account Ledger Entry",BankAccLedgEntry.FieldNo("Global Dimension 1 Code"),
          BankAccLedgEntry.FieldNo("Global Dimension 2 Code"),BankAccLedgEntry.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Phys. Inventory Ledger Entry",PhysInvtLedgEntry.FieldNo("Global Dimension 1 Code"),
          PhysInvtLedgEntry.FieldNo("Global Dimension 2 Code"),PhysInvtLedgEntry.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"FA Ledger Entry",FALedgEntry.FieldNo("Global Dimension 1 Code"),FALedgEntry.FieldNo("Global Dimension 2 Code"),
          FALedgEntry.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Maintenance Ledger Entry",MaintenanceLedgEntry.FieldNo("Global Dimension 1 Code"),
          MaintenanceLedgEntry.FieldNo("Global Dimension 2 Code"),MaintenanceLedgEntry.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Ins. Coverage Ledger Entry",InsCovLedgEntry.FieldNo("Global Dimension 1 Code"),
          InsCovLedgEntry.FieldNo("Global Dimension 2 Code"),InsCovLedgEntry.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Service Ledger Entry",ServiceLedgerEntry.FieldNo("Global Dimension 1 Code"),
          ServiceLedgerEntry.FieldNo("Global Dimension 2 Code"),ServiceLedgerEntry.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Warranty Ledger Entry",WarrantyLedgerEntry.FieldNo("Global Dimension 1 Code"),
          WarrantyLedgerEntry.FieldNo("Global Dimension 2 Code"),WarrantyLedgerEntry.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Gen. Journal Line",GenJnlLine.FieldNo("Shortcut Dimension 1 Code"),
          GenJnlLine.FieldNo("Shortcut Dimension 2 Code"),GenJnlLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Item Journal Line",ItemJnlLine.FieldNo("Shortcut Dimension 1 Code"),
          ItemJnlLine.FieldNo("Shortcut Dimension 2 Code"),ItemJnlLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Res. Journal Line",ResJnlLine.FieldNo("Shortcut Dimension 1 Code"),
          ResJnlLine.FieldNo("Shortcut Dimension 2 Code"),ResJnlLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Job Journal Line",JobJnlLine.FieldNo("Shortcut Dimension 1 Code"),JobJnlLine.FieldNo("Shortcut Dimension 2 Code"),
          JobJnlLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Gen. Jnl. Allocation",GenJnlAlloc.FieldNo("Shortcut Dimension 1 Code"),
          GenJnlAlloc.FieldNo("Shortcut Dimension 2 Code"),GenJnlAlloc.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Requisition Line",ReqLine.FieldNo("Shortcut Dimension 1 Code"),ReqLine.FieldNo("Shortcut Dimension 2 Code"),
          ReqLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"FA Journal Line",FAJnlLine.FieldNo("Shortcut Dimension 1 Code"),FAJnlLine.FieldNo("Shortcut Dimension 2 Code"),
          FAJnlLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Insurance Journal Line",InsuranceJnlLine.FieldNo("Shortcut Dimension 1 Code"),
          InsuranceJnlLine.FieldNo("Shortcut Dimension 2 Code"),InsuranceJnlLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Planning Component",PlanningComponent.FieldNo("Shortcut Dimension 1 Code"),
          PlanningComponent.FieldNo("Shortcut Dimension 2 Code"),PlanningComponent.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Standard General Journal Line",StdGenJnlLine.FieldNo("Shortcut Dimension 1 Code"),
          StdGenJnlLine.FieldNo("Shortcut Dimension 2 Code"),StdGenJnlLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Standard Item Journal Line",StdItemJnlLine.FieldNo("Shortcut Dimension 1 Code"),
          StdItemJnlLine.FieldNo("Shortcut Dimension 2 Code"),StdItemJnlLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Sales Header",SalesHeader.FieldNo("Shortcut Dimension 1 Code"),SalesHeader.FieldNo("Shortcut Dimension 2 Code"),
          SalesHeader.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Sales Line",SalesLine.FieldNo("Shortcut Dimension 1 Code"),SalesLine.FieldNo("Shortcut Dimension 2 Code"),
          SalesLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Purchase Header",PurchHeader.FieldNo("Shortcut Dimension 1 Code"),
          PurchHeader.FieldNo("Shortcut Dimension 2 Code"),PurchHeader.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Purchase Line",PurchLine.FieldNo("Shortcut Dimension 1 Code"),PurchLine.FieldNo("Shortcut Dimension 2 Code"),
          PurchLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Standard Sales Line",StdSalesLine.FieldNo("Shortcut Dimension 1 Code"),
          StdSalesLine.FieldNo("Shortcut Dimension 2 Code"),StdSalesLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Standard Purchase Line",StdPurchLine.FieldNo("Shortcut Dimension 1 Code"),
          StdPurchLine.FieldNo("Shortcut Dimension 2 Code"),StdPurchLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Reminder Header",ReminderHeader.FieldNo("Shortcut Dimension 1 Code"),
          ReminderHeader.FieldNo("Shortcut Dimension 2 Code"),ReminderHeader.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Finance Charge Memo Header",FinChrgMemoHeader.FieldNo("Shortcut Dimension 1 Code"),
          FinChrgMemoHeader.FieldNo("Shortcut Dimension 2 Code"),FinChrgMemoHeader.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Service Header",ServHeader.FieldNo("Shortcut Dimension 1 Code"),ServHeader.FieldNo("Shortcut Dimension 2 Code"),
          ServHeader.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Service Item Line",ServItemLine.FieldNo("Shortcut Dimension 1 Code"),
          ServItemLine.FieldNo("Shortcut Dimension 2 Code"),ServItemLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Service Line",ServLine.FieldNo("Shortcut Dimension 1 Code"),ServLine.FieldNo("Shortcut Dimension 2 Code"),
          ServLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Sales Header Archive",SalesHeaderArchive.FieldNo("Shortcut Dimension 1 Code"),
          SalesHeaderArchive.FieldNo("Shortcut Dimension 2 Code"),SalesHeaderArchive.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Purchase Header Archive",PurchHeaderArchive.FieldNo("Shortcut Dimension 1 Code"),
          PurchHeaderArchive.FieldNo("Shortcut Dimension 2 Code"),PurchHeaderArchive.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Transfer Header",TransferHeader.FieldNo("Shortcut Dimension 1 Code"),
          TransferHeader.FieldNo("Shortcut Dimension 2 Code"),TransferHeader.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Transfer Line",TransferLine.FieldNo("Shortcut Dimension 1 Code"),
          TransferLine.FieldNo("Shortcut Dimension 2 Code"),TransferLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Standard Service Line",StdServLine.FieldNo("Shortcut Dimension 1 Code"),
          StdServLine.FieldNo("Shortcut Dimension 2 Code"),StdServLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Production Order",ProdOrder.FieldNo("Shortcut Dimension 1 Code"),ProdOrder.FieldNo("Shortcut Dimension 2 Code"),
          ProdOrder.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Prod. Order Line",ProdOrderLine.FieldNo("Shortcut Dimension 1 Code"),
          ProdOrderLine.FieldNo("Shortcut Dimension 2 Code"),ProdOrderLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Prod. Order Component",ProdOrderComp.FieldNo("Shortcut Dimension 1 Code"),
          ProdOrderComp.FieldNo("Shortcut Dimension 2 Code"),ProdOrderComp.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Sales Shipment Header",SalesShptHeader.FieldNo("Shortcut Dimension 1 Code"),
          SalesShptHeader.FieldNo("Shortcut Dimension 2 Code"),SalesShptHeader.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Sales Shipment Line",SaleShptLine.FieldNo("Shortcut Dimension 1 Code"),
          SaleShptLine.FieldNo("Shortcut Dimension 2 Code"),SaleShptLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Service Invoice Header",SalesInvHeader.FieldNo("Shortcut Dimension 1 Code"),
          SalesInvHeader.FieldNo("Shortcut Dimension 2 Code"),SalesInvHeader.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Service Invoice Line",SalesInvLine.FieldNo("Shortcut Dimension 1 Code"),
          SalesInvLine.FieldNo("Shortcut Dimension 2 Code"),SalesInvLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Return Receipt Header",ReturnRcptHeader.FieldNo("Shortcut Dimension 1 Code"),
          ReturnRcptHeader.FieldNo("Shortcut Dimension 2 Code"),ReturnRcptHeader.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Return Receipt Line",ReturnRcptLine.FieldNo("Shortcut Dimension 1 Code"),
          ReturnRcptLine.FieldNo("Shortcut Dimension 2 Code"),ReturnRcptLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Service Cr.Memo Header",SalesCrMemoHeader.FieldNo("Shortcut Dimension 1 Code"),
          SalesCrMemoHeader.FieldNo("Shortcut Dimension 2 Code"),SalesCrMemoHeader.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Service Cr.Memo Line",SalesCrMemoLine.FieldNo("Shortcut Dimension 1 Code"),
          SalesCrMemoLine.FieldNo("Shortcut Dimension 2 Code"),SalesCrMemoLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Service Shipment Header",ServShptHeader.FieldNo("Shortcut Dimension 1 Code"),
          ServShptHeader.FieldNo("Shortcut Dimension 2 Code"),ServShptHeader.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Service Shipment Line",ServShptLine.FieldNo("Shortcut Dimension 1 Code"),
          ServShptLine.FieldNo("Shortcut Dimension 2 Code"),ServShptLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Sales Invoice Header",ServInvHeader.FieldNo("Shortcut Dimension 1 Code"),
          ServInvHeader.FieldNo("Shortcut Dimension 2 Code"),ServInvHeader.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Sales Invoice Line",ServInvLine.FieldNo("Shortcut Dimension 1 Code"),
          ServInvLine.FieldNo("Shortcut Dimension 2 Code"),ServInvLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Sales Cr.Memo Header",ServCrMemoHeader.FieldNo("Shortcut Dimension 1 Code"),
          ServCrMemoHeader.FieldNo("Shortcut Dimension 2 Code"),ServCrMemoHeader.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Sales Cr.Memo Line",ServCrMemoLine.FieldNo("Shortcut Dimension 1 Code"),
          ServCrMemoLine.FieldNo("Shortcut Dimension 2 Code"),ServCrMemoLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Purch. Rcpt. Header",PurchRcptHeader.FieldNo("Shortcut Dimension 1 Code"),
          PurchRcptHeader.FieldNo("Shortcut Dimension 2 Code"),PurchRcptHeader.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Purch. Rcpt. Line",PurchRcptLine.FieldNo("Shortcut Dimension 1 Code"),
          PurchRcptLine.FieldNo("Shortcut Dimension 2 Code"),PurchRcptLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Purch. Inv. Header",PurchInvHeader.FieldNo("Shortcut Dimension 1 Code"),
          PurchInvHeader.FieldNo("Shortcut Dimension 2 Code"),PurchInvHeader.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Purch. Inv. Line",PurchInvLine.FieldNo("Shortcut Dimension 1 Code"),
          PurchInvLine.FieldNo("Shortcut Dimension 2 Code"),PurchInvLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Return Shipment Header",ReturnShptHeader.FieldNo("Shortcut Dimension 1 Code"),
          ReturnShptHeader.FieldNo("Shortcut Dimension 2 Code"),ReturnShptHeader.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Return Shipment Line",ReturnShptLine.FieldNo("Shortcut Dimension 1 Code"),
          ReturnShptLine.FieldNo("Shortcut Dimension 2 Code"),ReturnShptLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Purch. Cr. Memo Hdr.",PurchCrMemoHeader.FieldNo("Shortcut Dimension 1 Code"),
          PurchCrMemoHeader.FieldNo("Shortcut Dimension 2 Code"),PurchCrMemoHeader.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Purch. Cr. Memo Line",PurchCrMemoLine.FieldNo("Shortcut Dimension 1 Code"),
          PurchCrMemoLine.FieldNo("Shortcut Dimension 2 Code"),PurchCrMemoLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Issued Reminder Header",IssuedReminderHeader.FieldNo("Shortcut Dimension 1 Code"),
          IssuedReminderHeader.FieldNo("Shortcut Dimension 2 Code"),IssuedReminderHeader.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Issued Fin. Charge Memo Header",IssuedFinChrgMemoHeader.FieldNo("Shortcut Dimension 1 Code"),
          IssuedFinChrgMemoHeader.FieldNo("Shortcut Dimension 2 Code"),IssuedFinChrgMemoHeader.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Transfer Shipment Header",TransferShipmentHeader.FieldNo("Shortcut Dimension 1 Code"),
          TransferShipmentHeader.FieldNo("Shortcut Dimension 2 Code"),TransferShipmentHeader.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Transfer Shipment Line",TransferShipmentLine.FieldNo("Shortcut Dimension 1 Code"),
          TransferShipmentLine.FieldNo("Shortcut Dimension 2 Code"),TransferShipmentLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Transfer Receipt Header",TransferReceiptHeader.FieldNo("Shortcut Dimension 1 Code"),
          TransferReceiptHeader.FieldNo("Shortcut Dimension 2 Code"),TransferReceiptHeader.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Transfer Receipt Line",TransferReceiptLine.FieldNo("Shortcut Dimension 1 Code"),
          TransferReceiptLine.FieldNo("Shortcut Dimension 2 Code"),TransferReceiptLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"G/L Budget Entry",GLBudgetEntry.FieldNo("Global Dimension 1 Code"),
          GLBudgetEntry.FieldNo("Global Dimension 2 Code"),GLBudgetEntry.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"FA Allocation",FAAlloc.FieldNo("Global Dimension 1 Code"),FAAlloc.FieldNo("Global Dimension 2 Code"),
          FAAlloc.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Service Contract Header",ServCtrHeader.FieldNo("Shortcut Dimension 1 Code"),
          ServCtrHeader.FieldNo("Shortcut Dimension 2 Code"),ServCtrHeader.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Filed Service Contract Header",FiledServCtrHeader.FieldNo("Shortcut Dimension 1 Code"),
          FiledServCtrHeader.FieldNo("Shortcut Dimension 2 Code"),FiledServCtrHeader.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Job WIP Entry",JobWIPEntry.FieldNo("Global Dimension 1 Code"),JobWIPEntry.FieldNo("Global Dimension 2 Code"),
          JobWIPEntry.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Job WIP G/L Entry",JobWIPGLEntry.FieldNo("Global Dimension 1 Code"),
          JobWIPGLEntry.FieldNo("Global Dimension 2 Code"),JobWIPGLEntry.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Item Budget Entry",ItemBudgetEntry.FieldNo("Global Dimension 1 Code"),
          ItemBudgetEntry.FieldNo("Global Dimension 2 Code"),ItemBudgetEntry.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Deposit Header",DepositHeader.FieldNo("Shortcut Dimension 1 Code"),
          DepositHeader.FieldNo("Shortcut Dimension 2 Code"),DepositHeader.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Bank Rec. Line",BankRecLine.FieldNo("Shortcut Dimension 1 Code"),BankRecLine.FieldNo("Shortcut Dimension 2 Code"),
          BankRecLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Posted Deposit Header",PostedDepositHeader.FieldNo("Shortcut Dimension 1 Code"),
          PostedDepositHeader.FieldNo("Shortcut Dimension 2 Code"),PostedDepositHeader.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Posted Deposit Line",PostedDepositLine.FieldNo("Shortcut Dimension 1 Code"),
          PostedDepositLine.FieldNo("Shortcut Dimension 2 Code"),PostedDepositLine.FieldNo("Dimension Set ID"));
        AddToDimSetTempTable(
          Database::"Posted Bank Rec. Line",PostedBankRecLine.FieldNo("Shortcut Dimension 1 Code"),
          PostedBankRecLine.FieldNo("Shortcut Dimension 2 Code"),PostedBankRecLine.FieldNo("Dimension Set ID"));
    end;

    local procedure AddingDefaultValueDim()
    begin
        AddToDefaultDimTempTable(
          Database::"G/L Account",GLAcc.FieldNo("Global Dimension 1 Code"),GLAcc.FieldNo("Global Dimension 2 Code"),
          GLAcc.FieldNo("No."));
        AddToDefaultDimTempTable(
          Database::Customer,Cust.FieldNo("Global Dimension 1 Code"),Cust.FieldNo("Global Dimension 2 Code"),Cust.FieldNo("No."));
        AddToDefaultDimTempTable(
          Database::Vendor,Vend.FieldNo("Global Dimension 1 Code"),Vend.FieldNo("Global Dimension 2 Code"),Vend.FieldNo("No."));
        AddToDefaultDimTempTable(
          Database::Item,Item.FieldNo("Global Dimension 1 Code"),Item.FieldNo("Global Dimension 2 Code"),Item.FieldNo("No."));
        AddToDefaultDimTempTable(
          Database::"Resource Group",ResGr.FieldNo("Global Dimension 1 Code"),ResGr.FieldNo("Global Dimension 2 Code"),
          ResGr.FieldNo("No."));
        AddToDefaultDimTempTable(
          Database::Resource,Res.FieldNo("Global Dimension 1 Code"),Res.FieldNo("Global Dimension 2 Code"),Res.FieldNo("No."));
        AddToDefaultDimTempTable(
          Database::Job,Job.FieldNo("Global Dimension 1 Code"),Job.FieldNo("Global Dimension 2 Code"),Job.FieldNo("No."));
        AddToDefaultDimTempTable(
          Database::"Bank Account",BankAcc.FieldNo("Global Dimension 1 Code"),BankAcc.FieldNo("Global Dimension 2 Code"),
          BankAcc.FieldNo("No."));
        AddToDefaultDimTempTable(
          Database::o,Employee.FieldNo("Global Dimension 1 Code"),Employee.FieldNo("Global Dimension 2 Code"),
          Employee.FieldNo("No."));
        AddToDefaultDimTempTable(
          Database::"Fixed Asset",FA.FieldNo("Global Dimension 1 Code"),FA.FieldNo("Global Dimension 2 Code"),FA.FieldNo("No."));
        AddToDefaultDimTempTable(
          Database::Insurance,Insurance.FieldNo("Global Dimension 1 Code"),Insurance.FieldNo("Global Dimension 2 Code"),
          Insurance.FieldNo("No."));
        AddToDefaultDimTempTable(
          Database::"Responsibility Center",RespCenter.FieldNo("Global Dimension 1 Code"),
          RespCenter.FieldNo("Global Dimension 2 Code"),RespCenter.FieldNo(Code));
        AddToDefaultDimTempTable(
          Database::"Salesperson/Purchaser",SalespersonPurchaser.FieldNo("Global Dimension 1 Code"),
          SalespersonPurchaser.FieldNo("Global Dimension 2 Code"),SalespersonPurchaser.FieldNo(Code));
        AddToDefaultDimTempTable(
          Database::Campaign,Campaign.FieldNo("Global Dimension 1 Code"),Campaign.FieldNo("Global Dimension 2 Code"),
          Campaign.FieldNo("No."));
        AddToDefaultDimTempTable(
          Database::"Customer Template",CustomerTemplate.FieldNo("Global Dimension 1 Code"),
          CustomerTemplate.FieldNo("Global Dimension 2 Code"),CustomerTemplate.FieldNo(Code));
        AddToDefaultDimTempTable(
          Database::"Item Charge",ItemCharge.FieldNo("Global Dimension 1 Code"),ItemCharge.FieldNo("Global Dimension 2 Code"),
          ItemCharge.FieldNo("No."));
        AddToDefaultDimTempTable(
          Database::"Work Center",WorkCenter.FieldNo("Global Dimension 1 Code"),WorkCenter.FieldNo("Global Dimension 2 Code"),
          WorkCenter.FieldNo("No."));
    end;
}

