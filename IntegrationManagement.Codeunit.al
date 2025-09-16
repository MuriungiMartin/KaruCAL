#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5150 "Integration Management"
{
    Permissions = TableData "Sales Invoice Header"=rm,
                  TableData "Sales Invoice Line"=rm;
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        IntegrationIsActivated: Boolean;
        PageServiceNameTok: label 'Integration %1';
        IntegrationServicesEnabledMsg: label 'Integration services have been enabled.\The %1 service should be restarted.', Comment='%1 - product name';
        IntegrationServicesDisabledMsg: label 'Integration services have been disabled.\The %1 service should be restarted.', Comment='%1 - product name';


    procedure GetDatabaseTableTriggerSetup(TableID: Integer;var Insert: Boolean;var Modify: Boolean;var Delete: Boolean;var Rename: Boolean)
    begin
        if COMPANYNAME = '' then
          exit;

        if not GetIntegrationActivated then
          exit;

        if IsIntegrationRecord(TableID) or IsIntegrationRecordChild(TableID) then begin
          Insert := true;
          Modify := true;
          Delete := true;
          Rename := true;
        end;
    end;


    procedure OnDatabaseInsert(RecRef: RecordRef)
    var
        TimeStamp: DateTime;
    begin
        if not GetIntegrationActivated then
          exit;

        TimeStamp := CurrentDatetime;
        UpdateParentIntegrationRecord(RecRef,TimeStamp);
        InsertUpdateIntegrationRecord(RecRef,TimeStamp);
    end;


    procedure OnDatabaseModify(RecRef: RecordRef)
    var
        TimeStamp: DateTime;
    begin
        if not GetIntegrationActivated then
          exit;

        TimeStamp := CurrentDatetime;
        UpdateParentIntegrationRecord(RecRef,TimeStamp);
        InsertUpdateIntegrationRecord(RecRef,TimeStamp);
    end;


    procedure OnDatabaseDelete(RecRef: RecordRef)
    var
        SalesHeader: Record "Sales Header";
        IntegrationRecord: Record "Integration Record";
        SkipDeletion: Boolean;
        TimeStamp: DateTime;
    begin
        if not GetIntegrationActivated then
          exit;

        TimeStamp := CurrentDatetime;
        UpdateParentIntegrationRecord(RecRef,TimeStamp);
        if IsIntegrationRecord(RecRef.Number) then begin
          IntegrationRecord.SetRange("Record ID",RecRef.RecordId);
          if IntegrationRecord.FindFirst then begin
            // Handle exceptions where "Deleted On" should not be set.
            if RecRef.Number = Database::"Sales Header" then begin
              RecRef.SetTable(SalesHeader);
              SkipDeletion := SalesHeader.Invoice;
            end;

            if not SkipDeletion then
              IntegrationRecord."Deleted On" := TimeStamp;

            Clear(IntegrationRecord."Record ID");
            IntegrationRecord."Modified On" := TimeStamp;
            IntegrationRecord.Modify;
          end;
        end;
    end;


    procedure OnDatabaseRename(RecRef: RecordRef;XRecRef: RecordRef)
    var
        IntegrationRecord: Record "Integration Record";
        TimeStamp: DateTime;
    begin
        if not GetIntegrationActivated then
          exit;

        TimeStamp := CurrentDatetime;
        UpdateParentIntegrationRecord(RecRef,TimeStamp);
        if IsIntegrationRecord(RecRef.Number) then begin
          IntegrationRecord.SetRange("Record ID",XRecRef.RecordId);
          if IntegrationRecord.FindFirst then begin
            IntegrationRecord."Record ID" := RecRef.RecordId;
            IntegrationRecord.Modify;
          end;
        end;
        InsertUpdateIntegrationRecord(RecRef,TimeStamp);
    end;

    local procedure UpdateParentIntegrationRecord(RecRef: RecordRef;TimeStamp: DateTime)
    var
        Currency: Record Currency;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        Customer: Record Customer;
        ShipToAddress: Record "Ship-to Address";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        SalesPrice: Record "Sales Price";
        CustomerPriceGroup: Record "Customer Price Group";
        ParentRecRef: RecordRef;
    begin
        // Handle cases where entities change should update the parent record
        // Function must not fail even if the parent record cannot be found
        case RecRef.Number of
          Database::"Sales Line":
            begin
              RecRef.SetTable(SalesLine);
              if SalesHeader.Get(SalesLine."Document Type",SalesLine."Document No.") then begin
                ParentRecRef.GetTable(SalesHeader);
                InsertUpdateIntegrationRecord(ParentRecRef,TimeStamp);
              end;
            end;
          Database::"Sales Invoice Line":
            begin
              RecRef.SetTable(SalesInvoiceLine);
              if SalesInvoiceHeader.Get(SalesInvoiceLine."Document No.") then begin
                ParentRecRef.GetTable(SalesInvoiceHeader);
                InsertUpdateIntegrationRecord(ParentRecRef,TimeStamp);
              end;
            end;
          Database::"Sales Price":
            begin
              RecRef.SetTable(SalesPrice);
              if SalesPrice."Sales Type" <> SalesPrice."sales type"::"Customer Price Group" then
                exit;

              if CustomerPriceGroup.Get(SalesPrice."Sales Code") then begin
                ParentRecRef.GetTable(CustomerPriceGroup);
                InsertUpdateIntegrationRecord(ParentRecRef,TimeStamp);
              end;
            end;
          Database::"Ship-to Address":
            begin
              RecRef.SetTable(ShipToAddress);
              if Customer.Get(ShipToAddress."Customer No.") then begin
                ParentRecRef.GetTable(Customer);
                InsertUpdateIntegrationRecord(ParentRecRef,TimeStamp);
              end;
            end;
          Database::"Currency Exchange Rate":
            begin
              RecRef.SetTable(CurrencyExchangeRate);
              if Currency.Get(CurrencyExchangeRate."Currency Code") then begin
                ParentRecRef.GetTable(Currency);
                InsertUpdateIntegrationRecord(ParentRecRef,TimeStamp);
              end;
            end;
        end;
    end;


    procedure SetupIntegrationTables()
    var
        TempNameValueBuffer: Record "Name/Value Buffer" temporary;
        TableId: Integer;
    begin
        CreateIntegrationPageList(TempNameValueBuffer);
        TempNameValueBuffer.FindFirst;
        repeat
          Evaluate(TableId,TempNameValueBuffer.Value);
          InitializeIntegrationRecords(TableId);
        until TempNameValueBuffer.Next = 0;
    end;


    procedure CreateIntegrationPageList(var TempNameValueBuffer: Record "Name/Value Buffer" temporary)
    var
        NextId: Integer;
    begin
        with TempNameValueBuffer do begin
          DeleteAll;
          NextId := 1;

          AddToIntegrationPageList(Page::"Resource List",Database::Resource,TempNameValueBuffer,NextId);
          AddToIntegrationPageList(Page::"Payment Terms",Database::"Payment Terms",TempNameValueBuffer,NextId);
          AddToIntegrationPageList(Page::"Shipment Methods",Database::"Shipment Method",TempNameValueBuffer,NextId);
          AddToIntegrationPageList(Page::"Shipping Agents",Database::"Shipping Agent",TempNameValueBuffer,NextId);
          AddToIntegrationPageList(Page::Currencies,Database::Currency,TempNameValueBuffer,NextId);
          AddToIntegrationPageList(Page::"Salespersons/Purchasers",Database::"Salesperson/Purchaser",TempNameValueBuffer,NextId);
          AddToIntegrationPageList(Page::"Customer Card",Database::Customer,TempNameValueBuffer,NextId);
          AddToIntegrationPageList(Page::"Item Card",Database::Item,TempNameValueBuffer,NextId);
          AddToIntegrationPageList(Page::"Sales Order",Database::"Sales Header",TempNameValueBuffer,NextId);
          AddToIntegrationPageList(Page::"Sales Invoice",Database::"Sales Header",TempNameValueBuffer,NextId);
          AddToIntegrationPageList(Page::"Posted Sales Invoice",Database::"Sales Invoice Header",TempNameValueBuffer,NextId);
          AddToIntegrationPageList(Page::"Units of Measure",Database::"Unit of Measure",TempNameValueBuffer,NextId);
          AddToIntegrationPageList(Page::"Ship-to Address",Database::"Ship-to Address",TempNameValueBuffer,NextId);
          AddToIntegrationPageList(Page::"Contact Card",Database::Contact,TempNameValueBuffer,NextId);
          AddToIntegrationPageList(Page::"Countries/Regions",Database::"Country/Region",TempNameValueBuffer,NextId);
        end;
    end;


    procedure IsIntegrationServicesEnabled(): Boolean
    var
        WebService: Record "Web Service";
    begin
        exit(WebService.Get(WebService."object type"::Codeunit,'Integration Service'));
    end;


    procedure IsIntegrationActivated(): Boolean
    begin
        exit(IntegrationIsActivated);
    end;


    procedure EnableIntegrationServices()
    begin
        if IsIntegrationServicesEnabled then
          exit;

        SetupIntegrationService;
        SetupIntegrationServices;

        Message(IntegrationServicesEnabledMsg,ProductName.Full);
    end;


    procedure DisableIntegrationServices()
    begin
        if not IsIntegrationServicesEnabled then
          exit;

        DeleteIntegrationService;
        DeleteIntegrationServices;

        Message(IntegrationServicesDisabledMsg,ProductName.Full);
    end;


    procedure SetConnectorIsEnabledForSession(IsEnabled: Boolean)
    begin
        IntegrationIsActivated := IsEnabled;
    end;


    procedure IsIntegrationRecord(TableID: Integer): Boolean
    begin
        exit(TableID in
          [Database::Resource,
           Database::"Payment Terms",
           Database::"Shipment Method",
           Database::"Shipping Agent",
           Database::Currency,
           Database::"Salesperson/Purchaser",
           Database::Customer,
           Database::Item,
           Database::"Sales Header",
           Database::"Sales Invoice Header",
           Database::"Unit of Measure",
           Database::"Ship-to Address",
           Database::Contact,
           Database::"Country/Region",
           Database::"Customer Price Group"]);
    end;


    procedure IsIntegrationRecordChild(TableID: Integer): Boolean
    begin
        exit(TableID in
          [Database::"Sales Line",
           Database::"Currency Exchange Rate",
           Database::"Sales Invoice Line",
           Database::"Sales Price"]);
    end;

    local procedure GetIntegrationActivated(): Boolean
    var
        CRMConnectionSetup: Record "CRM Connection Setup";
    begin
        if not IntegrationIsActivated then begin
          CRMConnectionSetup.SetRange("Is Enabled",true);
          IntegrationIsActivated := CRMConnectionSetup.Count > 0;
        end;

        exit(IntegrationIsActivated);
    end;

    local procedure SetupIntegrationService()
    var
        WebService: Record "Web Service";
        WebServiceManagement: Codeunit "Web Service Management";
    begin
        WebServiceManagement.CreateWebService(WebService."object type"::Codeunit,5151,'Integration Service',true);
    end;

    local procedure DeleteIntegrationService()
    var
        WebService: Record "Web Service";
    begin
        if WebService.Get(WebService."object type"::Codeunit,'Integration Service') then
          WebService.Delete;
    end;

    local procedure SetupIntegrationServices()
    var
        TempNameValueBuffer: Record "Name/Value Buffer" temporary;
        WebService: Record "Web Service";
        Objects: Record AllObj;
        WebServiceManagement: Codeunit "Web Service Management";
        PageId: Integer;
    begin
        CreateIntegrationPageList(TempNameValueBuffer);
        TempNameValueBuffer.FindFirst;

        repeat
          Evaluate(PageId,TempNameValueBuffer.Name);

          Objects.SetRange("Object Type",Objects."object type"::Page);
          Objects.SetRange("Object ID",PageId);
          if Objects.FindFirst then
            WebServiceManagement.CreateWebService(WebService."object type"::Page,Objects."Object ID",
              StrSubstNo(PageServiceNameTok,Objects."Object Name"),true);
        until TempNameValueBuffer.Next = 0;
    end;

    local procedure DeleteIntegrationServices()
    var
        TempNameValueBuffer: Record "Name/Value Buffer" temporary;
        WebService: Record "Web Service";
        Objects: Record AllObj;
        PageId: Integer;
    begin
        CreateIntegrationPageList(TempNameValueBuffer);
        TempNameValueBuffer.FindFirst;

        WebService.SetRange("Object Type",WebService."object type"::Page);
        repeat
          Evaluate(PageId,TempNameValueBuffer.Name);
          WebService.SetRange("Object ID",PageId);

          Objects.SetRange("Object Type",WebService."object type"::Page);
          Objects.SetRange("Object ID",PageId);
          if Objects.FindFirst then begin
            WebService.SetRange("Service Name",StrSubstNo(PageServiceNameTok,Objects."Object Name"));
            if WebService.FindFirst then
              WebService.Delete;
          end;
        until TempNameValueBuffer.Next = 0;
    end;

    local procedure InitializeIntegrationRecords(TableID: Integer)
    var
        RecRef: RecordRef;
    begin
        with RecRef do begin
          Open(TableID,false);
          if FindSet(false) then
            repeat
              InsertUpdateIntegrationRecord(RecRef,CurrentDatetime);
            until Next = 0;
          Close;
        end;
    end;

    local procedure InsertUpdateIntegrationRecord(RecRef: RecordRef;IntegrationLastModified: DateTime)
    var
        IntegrationRecord: Record "Integration Record";
        Contact: Record Contact;
    begin
        if IsIntegrationRecord(RecRef.Number) then
          with IntegrationRecord do begin
            SetRange("Record ID",RecRef.RecordId);
            if FindFirst then begin
              // Handle exceptions where entities change state and should not be integrated.
              if RecRef.Number = Database::Contact then begin
                RecRef.SetTable(Contact);
                if Contact.Type = Contact.Type::Company then begin
                  Clear("Record ID");
                  "Deleted On" := IntegrationLastModified;
                end;
              end;
              "Modified On" := IntegrationLastModified;
              Modify;
            end else begin
              // Handle exceptions where entities should not be integrated.
              if RecRef.Number = Database::Contact then begin
                RecRef.SetTable(Contact);
                if Contact.Type = Contact.Type::Company then
                  exit;
              end;
              Reset;
              Init;
              "Integration ID" := CreateGuid;
              "Record ID" := RecRef.RecordId;
              "Table ID" := RecRef.Number;
              "Modified On" := IntegrationLastModified;
              Insert;
            end;
          end;
    end;

    local procedure AddToIntegrationPageList(PageId: Integer;TableId: Integer;var TempNameValueBuffer: Record "Name/Value Buffer" temporary;var NextId: Integer)
    begin
        with TempNameValueBuffer do begin
          Init;
          ID := NextId;
          NextId := NextId + 1;
          Name := Format(PageId);
          Value := Format(TableId);
          Insert;
        end;
    end;
}

