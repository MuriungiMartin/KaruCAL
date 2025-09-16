#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 8616 "Config. Management"
{

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'You must specify a company name.';
        Text001: label 'Do you want to copy the data from the %1 table in %2?';
        Text002: label 'Data from the %1 table in %2 has been copied successfully.';
        Text003: label 'Do you want to copy the data from the selected tables in %1?';
        Text004: label 'Data from the selected tables in %1 has been copied successfully.';
        Text006: label 'The base company must not be the same as the current company.';
        Text007: label 'The %1 table in %2 already contains data.\\You must delete the data from the table before you can use this function.';
        Text009: label 'There is no data in the %1 table in %2.\\You must set up the table in %3 manually.';
        TempFieldRec: Record "Field" temporary;
        ConfigProgressBar: Codeunit "Config. Progress Bar";
        HideDialog: Boolean;
        Text023: label 'Processing tables';


    procedure CopyDataDialog(NewCompanyName: Text[30];var ConfigLine: Record "Config. Line")
    var
        ConfirmTableText: Text[250];
        MessageTableText: Text[250];
        SingleTable: Boolean;
    begin
        with ConfigLine do begin
          if NewCompanyName = '' then
            Error(Text000);
          if not FindFirst then
            exit;
          SingleTable := Next = 0;
          if SingleTable then begin
            ConfirmTableText := StrSubstNo(Text001,Name,NewCompanyName);
            MessageTableText := StrSubstNo(Text002,Name,NewCompanyName);
          end else begin
            ConfirmTableText := StrSubstNo(Text003,NewCompanyName);
            MessageTableText := StrSubstNo(Text004,NewCompanyName);
          end;
          if not Confirm(ConfirmTableText,SingleTable) then
            exit;
          if FindSet then
            repeat
              CopyData(ConfigLine);
            until Next = 0;
          Commit;
          Message(MessageTableText)
        end;
    end;

    local procedure CopyData(var ConfigLine: Record "Config. Line")
    var
        BaseCompanyName: Text[30];
    begin
        with ConfigLine do begin
          CheckBlocked;
          FilterGroup := 2;
          BaseCompanyName := GetRangemax("Company Filter (Source Table)");
          FilterGroup := 0;
          if BaseCompanyName = COMPANYNAME then
            Error(Text006);
          CalcFields("No. of Records","No. of Records (Source Table)");
          if "No. of Records" <> 0 then
            Error(
              Text007,
              Name,COMPANYNAME);
          if "No. of Records (Source Table)" = 0 then
            Error(
              Text009,
              Name,BaseCompanyName,COMPANYNAME);
          TransferContents("Table ID",BaseCompanyName,true);
        end;
    end;


    procedure TransferContents(TableID: Integer;NewCompanyName: Text[30];CopyTable: Boolean): Boolean
    begin
        TempFieldRec.DeleteAll;
        if CopyTable then
          MarkPostValidationData(Database::Contact,5053);
        TransferContent(TableID,NewCompanyName,CopyTable);
        TempFieldRec.DeleteAll;
        exit(true);
    end;

    local procedure TransferContent(TableNumber: Integer;NewCompanyName: Text[30];CopyTable: Boolean)
    var
        FieldRec: Record "Field";
        FromCompanyRecRef: RecordRef;
        ToCompanyRecRef: RecordRef;
        FromCompanyFieldRef: FieldRef;
        ToCompanyFieldRef: FieldRef;
    begin
        if not CopyTable then
          exit;
        FromCompanyRecRef.Open(TableNumber,false,NewCompanyName);
        if FromCompanyRecRef.IsEmpty then begin
          FromCompanyRecRef.Close;
          exit;
        end;
        FromCompanyRecRef.Find('-');
        ToCompanyRecRef.Open(TableNumber,false,COMPANYNAME);
        FieldRec.SetRange(TableNo,TableNumber);
        repeat
          if FieldRec.FindSet then begin
            ToCompanyRecRef.Init;
            repeat
              if not TempFieldRec.Get(TableNumber,FieldRec."No.") then begin
                FromCompanyFieldRef := FromCompanyRecRef.Field(FieldRec."No.");
                ToCompanyFieldRef := ToCompanyRecRef.Field(FieldRec."No.");
                ToCompanyFieldRef.Value(FromCompanyFieldRef.Value);
              end;
            until FieldRec.Next = 0;
            ToCompanyRecRef.Insert(true);
          end;
        until FromCompanyRecRef.Next = 0;
        // Treatment of fields that require post-validation:
        TempFieldRec.SetRange(TableNo,TableNumber);
        if TempFieldRec.FindSet then begin
          FromCompanyRecRef.Find('-');
          repeat
            ToCompanyRecRef.SetPosition(FromCompanyRecRef.GetPosition);
            ToCompanyRecRef.Find('=');
            TempFieldRec.FindSet;
            repeat
              FromCompanyFieldRef := FromCompanyRecRef.Field(TempFieldRec."No.");
              ToCompanyFieldRef := ToCompanyRecRef.Field(TempFieldRec."No.");
              ToCompanyFieldRef.Value(FromCompanyFieldRef.Value);
            until TempFieldRec.Next = 0;
            ToCompanyRecRef.Modify(true);
          until FromCompanyRecRef.Next = 0;
        end;

        FromCompanyRecRef.Close;
        ToCompanyRecRef.Close;
    end;

    local procedure MarkPostValidationData(TableNo: Integer;FieldNo: Integer)
    begin
        TempFieldRec.Init;
        TempFieldRec.TableNo := TableNo;
        TempFieldRec."No." := FieldNo;
        if TempFieldRec.Insert then;
    end;


    procedure FindPage(TableID: Integer): Integer
    begin
        case TableID of
          Database::"Company Information":
            exit(Page::"Company Information");
          Database::"Responsibility Center":
            exit(Page::"Responsibility Center List");
          Database::"Accounting Period":
            exit(Page::"Accounting Periods");
          Database::"General Ledger Setup":
            exit(Page::"General Ledger Setup");
          Database::"No. Series":
            exit(Page::"No. Series");
          Database::"No. Series Line":
            exit(Page::"No. Series Lines");
          Database::"G/L Account":
            exit(Page::"Chart of Accounts");
          Database::"Gen. Business Posting Group":
            exit(Page::"Gen. Business Posting Groups");
          Database::"Gen. Product Posting Group":
            exit(Page::"Gen. Product Posting Groups");
          Database::"General Posting Setup":
            exit(Page::"General Posting Setup");
          Database::"VAT Business Posting Group":
            exit(Page::"VAT Business Posting Groups");
          Database::"VAT Product Posting Group":
            exit(Page::"VAT Product Posting Groups");
          Database::"VAT Posting Setup":
            exit(Page::"VAT Posting Setup");
          Database::"Acc. Schedule Name":
            exit(Page::"Account Schedule Names");
          Database::"Column Layout Name":
            exit(Page::"Column Layout Names");
          Database::"G/L Budget Name":
            exit(Page::"G/L Budget Names");
          Database::"VAT Statement Template":
            exit(Page::"VAT Statement Templates");
          Database::"Tariff Number":
            exit(Page::"Tariff Numbers");
          Database::"Transaction Type":
            exit(Page::"Transaction Types");
          Database::"Transaction Specification":
            exit(Page::"Transaction Specifications");
          Database::"Transport Method":
            exit(Page::"Transport Methods");
          Database::"Entry/Exit Point":
            exit(Page::"Entry/Exit Points");
          Database::Area:
            exit(Page::Areas);
          Database::Territory:
            exit(Page::Territories);
          Database::"Tax Jurisdiction":
            exit(Page::"Tax Jurisdictions");
          Database::"Tax Group":
            exit(Page::"Tax Groups");
          Database::"Tax Detail":
            exit(Page::"Tax Details");
          Database::"Tax Area":
            exit(Page::"Tax Area");
          Database::"Tax Area Line":
            exit(Page::"Tax Area Line");
          Database::"Source Code":
            exit(Page::"Source Codes");
          Database::"Reason Code":
            exit(Page::"Reason Codes");
          Database::"Standard Text":
            exit(Page::"Standard Text Codes");
          Database::"Business Unit":
            exit(Page::"Business Unit List");
          Database::Dimension:
            exit(Page::Dimensions);
          Database::"Default Dimension Priority":
            exit(Page::"Default Dimension Priorities");
          Database::"Dimension CombinationAllo":
            exit(Page::"Dimension Combinations");
          Database::"Analysis View":
            exit(Page::"Analysis View List");
          Database::"Post Code":
            exit(Page::"Post Codes");
          Database::"Country/Region":
            exit(Page::"Countries/Regions");
          Database::Language:
            exit(Page::Languages);
          Database::Currency:
            exit(Page::Currencies);
          Database::"Bank Account":
            exit(Page::"Bank Account List");
          Database::"Bank Account Posting Group":
            exit(Page::"Bank Account Posting Groups");
          Database::"Change Log Setup (Table)":
            exit(Page::"Change Log Setup (Table) List");
          Database::"Change Log Setup (Field)":
            exit(Page::"Change Log Setup (Field) List");
          Database::"Sales & Receivables Setup":
            exit(Page::"Sales & Receivables Setup");
          Database::Customer:
            exit(Page::"Customer List");
          Database::"Customer Posting Group":
            exit(Page::"Customer Posting Groups");
          Database::"Payment Terms":
            exit(Page::"Payment Terms");
          Database::"Payment Method":
            exit(Page::"Payment Methods");
          Database::"Reminder Terms":
            exit(Page::"Reminder Terms");
          Database::"Reminder Level":
            exit(Page::"Reminder Levels");
          Database::"Reminder Text":
            exit(Page::"Reminder Text");
          Database::"Finance Charge Terms":
            exit(Page::"Finance Charge Terms");
          Database::"Shipment Method":
            exit(Page::"Shipment Methods");
          Database::"Shipping Agent":
            exit(Page::"Shipping Agents");
          Database::"Shipping Agent Services":
            exit(Page::"Shipping Agent Services");
          Database::"Customer Discount Group":
            exit(Page::"Customer Disc. Groups");
          Database::"Salesperson/Purchaser":
            exit(Page::"Salespersons/Purchasers");
          Database::"Marketing Setup":
            exit(Page::"Marketing Setup");
          Database::"Duplicate Search String Setup":
            exit(Page::"Duplicate Search String Setup");
          Database::Contact:
            exit(Page::"Contact List");
          Database::"Business Relation":
            exit(Page::"Business Relations");
          Database::"Mailing Group":
            exit(Page::"Mailing Groups");
          Database::"Industry Group":
            exit(Page::"Industry Groups");
          Database::"Web Source":
            exit(Page::"Web Sources");
          Database::"Interaction Group":
            exit(Page::"Interaction Groups");
          Database::"Interaction Template":
            exit(Page::"Interaction Templates");
          Database::"Job Responsibility":
            exit(Page::"Job Responsibilities");
          Database::"Organizational Level":
            exit(Page::"Organizational Levels");
          Database::"Campaign Status":
            exit(Page::"Campaign Status");
          Database::Activity:
            exit(Page::Activity);
          Database::Team:
            exit(Page::Teams);
          Database::"Profile Questionnaire Header":
            exit(Page::"Profile Questionnaires");
          Database::"Sales Cycle":
            exit(Page::"Sales Cycles");
          Database::"Close Opportunity Code":
            exit(Page::"Close Opportunity Codes");
          Database::"Customer Template":
            exit(Page::"Customer Template List");
          Database::"Service Mgt. Setup":
            exit(Page::"Service Mgt. Setup");
          Database::"Service Item":
            exit(Page::"Service Item List");
          Database::"Service Hour":
            exit(Page::"Default Service Hours");
          Database::"Work-Hour Template":
            exit(Page::"Work-Hour Templates");
          Database::"Resource Service Zone":
            exit(Page::"Resource Service Zones");
          Database::Loaner:
            exit(Page::"Loaner List");
          Database::"Skill Code":
            exit(Page::"Skill Codes");
          Database::"Fault Reason Code":
            exit(Page::"Fault Reason Codes");
          Database::"Service Cost":
            exit(Page::"Service Costs");
          Database::"Service Zone":
            exit(Page::"Service Zones");
          Database::"Service Order Type":
            exit(Page::"Service Order Types");
          Database::"Service Item Group":
            exit(Page::"Service Item Groups");
          Database::"Service Shelf":
            exit(Page::"Service Shelves");
          Database::"Service Status Priority Setup":
            exit(Page::"Service Order Status Setup");
          Database::"Repair Status":
            exit(Page::"Repair Status Setup");
          Database::"Service Price Group":
            exit(Page::"Service Price Groups");
          Database::"Serv. Price Group Setup":
            exit(Page::"Serv. Price Group Setup");
          Database::"Service Price Adjustment Group":
            exit(Page::"Serv. Price Adjmt. Group");
          Database::"Serv. Price Adjustment Detail":
            exit(Page::"Serv. Price Adjmt. Detail");
          Database::"Resolution Code":
            exit(Page::"Resolution Codes");
          Database::"Fault Area":
            exit(Page::"Fault Areas");
          Database::"Symptom Code":
            exit(Page::"Symptom Codes");
          Database::"Fault Code":
            exit(Page::"Fault Codes");
          Database::"Fault/Resol. Cod. Relationship":
            exit(Page::"Fault/Resol. Cod. Relationship");
          Database::"Contract Group":
            exit(Page::"Service Contract Groups");
          Database::"Service Contract Template":
            exit(Page::"Service Contract Template");
          Database::"Service Contract Account Group":
            exit(Page::"Serv. Contract Account Groups");
          Database::"Troubleshooting Header":
            exit(Page::Troubleshooting);
          Database::"Purchases & Payables Setup":
            exit(Page::"Purchases & Payables Setup");
          Database::Vendor:
            exit(Page::"Vendor List");
          Database::"Vendor Posting Group":
            exit(Page::"Vendor Posting Groups");
          Database::Purchasing:
            exit(Page::"Purchasing Codes");
          Database::"Inventory Setup":
            exit(Page::"Inventory Setup");
          Database::"Nonstock Item Setup":
            exit(Page::"Nonstock Item Setup");
          Database::"Item Tracking Code":
            exit(Page::"Item Tracking Codes");
          Database::Item:
            exit(Page::"Item List");
          Database::"Nonstock Item":
            exit(Page::"Nonstock Item List");
          Database::"Inventory Posting Group":
            exit(Page::"Inventory Posting Groups");
          Database::"Inventory Posting Setup":
            exit(Page::"Inventory Posting Setup");
          Database::"Unit of Measure":
            exit(Page::"Units of Measure");
          Database::"Customer Price Group":
            exit(Page::"Customer Price Groups");
          Database::"Item Discount Group":
            exit(Page::"Item Disc. Groups");
          Database::Manufacturer:
            exit(Page::Manufacturers);
          Database::"Item Category":
            exit(Page::"Item Categories");
          Database::"Rounding Method":
            exit(Page::"Rounding Methods");
          Database::Location:
            exit(Page::"Location List");
          Database::"Transfer Route":
            exit(Page::"Transfer Routes");
          Database::"Stockkeeping Unit":
            exit(Page::"Stockkeeping Unit List");
          Database::"Warehouse Setup":
            exit(Page::"Warehouse Setup");
          Database::"Resources Setup":
            exit(Page::"Resources Setup");
          Database::Resource:
            exit(Page::"Resource List");
          Database::"Resource Group":
            exit(Page::"Resource Groups");
          Database::"Work Type":
            exit(Page::"Work Types");
          Database::"Jobs Setup":
            exit(Page::"Jobs Setup");
          Database::"Job Posting Group":
            exit(Page::"Job Posting Groups");
          Database::"FA Setup":
            exit(Page::"Fixed Asset Setup");
          Database::"Fixed Asset":
            exit(Page::"Fixed Asset List");
          Database::Insurance:
            exit(Page::"Insurance List");
          Database::"FA Posting Group":
            exit(Page::"FA Posting Groups");
          Database::"FA Journal Template":
            exit(Page::"FA Journal Templates");
          Database::"FA Reclass. Journal Template":
            exit(Page::"FA Reclass. Journal Templates");
          Database::"Insurance Journal Template":
            exit(Page::"Insurance Journal Templates");
          Database::"Depreciation Book":
            exit(Page::"Depreciation Book List");
          Database::"FA Class":
            exit(Page::"FA Classes");
          Database::"FA Subclass":
            exit(Page::"FA Subclasses");
          Database::"FA Location":
            exit(Page::"FA Locations");
          Database::"Insurance Type":
            exit(Page::"Insurance Types");
          Database::Maintenance:
            exit(Page::Maintenance);
          Database::"Human Resources Setup":
            exit(Page::"Human Resources Setup");
          Database::o:
            exit(Page::"Employee List");
          Database::"Cause of Absence":
            exit(Page::"Causes of Absence");
          Database::"Cause of Inactivity":
            exit(Page::"Causes of Inactivity");
          Database::"Grounds for Termination":
            exit(Page::"Grounds for Termination");
          Database::"Employment Contract":
            exit(Page::"Employment Contracts");
          Database::Qualification:
            exit(Page::Qualifications);
          Database::Relative:
            exit(Page::Relatives);
          Database::"Misc. Article":
            exit(Page::"Misc. Article Information");
          Database::Confidential:
            exit(Page::Confidential);
          Database::"Employee Statistics Group":
            exit(Page::"Employee Statistics Groups");
          Database::Union:
            exit(Page::Unions);
          Database::"Manufacturing Setup":
            exit(Page::"Manufacturing Setup");
          Database::Family:
            exit(Page::Family);
          Database::"Production BOM Header":
            exit(Page::"Production BOM");
          Database::"Capacity Unit of Measure":
            exit(Page::"Capacity Units of Measure");
          Database::"Work Shift":
            exit(Page::"Work Shifts");
          Database::"Shop Calendar":
            exit(Page::"Shop Calendars");
          Database::"Work Center Group":
            exit(Page::"Work Center Groups");
          Database::"Standard Task":
            exit(Page::"Standard Tasks");
          Database::"Routing Link":
            exit(Page::"Routing Links");
          Database::Stop:
            exit(Page::"Stop Codes");
          Database::Scrap:
            exit(Page::"Scrap Codes");
          Database::"Machine Center":
            exit(Page::"Machine Center List");
          Database::"Work Center":
            exit(Page::"Work Center List");
          Database::"Routing Header":
            exit(Page::Routing);
          Database::"Cost Type":
            exit(Page::"Cost Type List");
          Database::"Cost Journal Template":
            exit(Page::"Cost Journal Templates");
          Database::"Cost Allocation Source":
            exit(Page::"Cost Allocation");
          Database::"Cost Allocation Target":
            exit(Page::"Cost Allocation Target List");
          Database::"Cost Accounting Setup":
            exit(Page::"Cost Accounting Setup");
          Database::"Cost Budget Name":
            exit(Page::"Cost Budget Names");
          Database::"Cost Center":
            exit(Page::"Chart of Cost Centers");
          Database::"Cost Object":
            exit(Page::"Chart of Cost Objects");
          Database::"Cash Flow Setup":
            exit(Page::"Cash Flow Setup");
          Database::"Cash Flow Forecast":
            exit(Page::"Cash Flow Forecast List");
          Database::"Cash Flow Account":
            exit(Page::"Chart of Cash Flow Accounts");
          Database::"Cash Flow Manual Expense":
            exit(Page::"Cash Flow Manual Expenses");
          Database::"Cash Flow Manual Revenue":
            exit(Page::"Cash Flow Manual Revenues");
          Database::"IC Partner":
            exit(Page::"IC Partner List");
          Database::"Base Calendar":
            exit(Page::"Base Calendar List");
          Database::"Finance Charge Text":
            exit(Page::"Reminder Text");
          Database::"Currency for Fin. Charge Terms":
            exit(Page::"Currencies for Fin. Chrg Terms");
          Database::"Currency for Reminder Level":
            exit(Page::"Currencies for Reminder Level");
          Database::"Currency Exchange Rate":
            exit(Page::"Currency Exchange Rates");
          Database::"VAT Statement Name":
            exit(Page::"VAT Statement Names");
          Database::"VAT Statement Line":
            exit(Page::"VAT Statement");
          Database::"No. Series Relationship":
            exit(Page::"No. Series Relationships");
          Database::"User Setup":
            exit(Page::"User Setup");
          Database::"Gen. Journal Template":
            exit(Page::"General Journal Template List");
          Database::"Gen. Journal Batch":
            exit(Page::"General Journal Batches");
          Database::"Gen. Journal Line":
            exit(Page::"General Journal");
          Database::"Item Journal Template":
            exit(Page::"Item Journal Template List");
          Database::"Item Journal Batch":
            exit(Page::"Item Journal Batches");
          Database::"Customer Bank Account":
            exit(Page::"Customer Bank Account List");
          Database::"Vendor Bank Account":
            exit(Page::"Vendor Bank Account List");
          Database::"Cust. Invoice Disc.":
            exit(Page::"Cust. Invoice Discounts");
          Database::"Vendor Invoice Disc.":
            exit(Page::"Vend. Invoice Discounts");
          Database::"Dimension Value":
            exit(Page::"Dimension Value List");
          Database::"Dimension Value Combination":
            exit(Page::"Dimension Combinations");
          Database::"Default Dimension":
            exit(Page::"Default Dimensions");
          Database::"Dimension Translation":
            exit(Page::"Dimension Translations");
          Database::"Dimension Set Entry":
            exit(Page::"Dimension Set Entries");
          Database::"VAT Report Setup":
            exit(Page::"VAT Report Setup");
          Database::"VAT Registration No. Format":
            exit(Page::"VAT Registration No. Formats");
          Database::"G/L Entry":
            exit(Page::"General Ledger Entries");
          Database::"Cust. Ledger Entry":
            exit(Page::"Customer Ledger Entries");
          Database::"Vendor Ledger Entry":
            exit(Page::"Vendor Ledger Entries");
          Database::"Item Ledger Entry":
            exit(Page::"Item Ledger Entries");
          Database::"Sales Header":
            exit(Page::"Sales List");
          Database::"Purchase Header":
            exit(Page::"Purchase List");
          Database::"G/L Register":
            exit(Page::"G/L Registers");
          Database::"Item Register":
            exit(Page::"Item Registers");
          Database::"Item Journal Line":
            exit(Page::"Item Journal Lines");
          Database::"Sales Shipment Header":
            exit(Page::"Posted Sales Shipments");
          Database::"Sales Invoice Header":
            exit(Page::"Posted Sales Invoices");
          Database::"Sales Cr.Memo Header":
            exit(Page::"Posted Sales Credit Memos");
          Database::"Purch. Rcpt. Header":
            exit(Page::"Posted Purchase Receipts");
          Database::"Purch. Inv. Header":
            exit(Page::"Posted Purchase Invoices");
          Database::"Purch. Cr. Memo Hdr.":
            exit(Page::"Posted Purchase Credit Memos");
          Database::"Sales Price":
            exit(Page::"Sales Prices");
          Database::"Purchase Price":
            exit(Page::"Purchase Prices");
          Database::"VAT Entry":
            exit(Page::"VAT Entries");
          Database::"FA Ledger Entry":
            exit(Page::"FA Ledger Entries");
          Database::"Value Entry":
            exit(Page::"Value Entries");
          Database::"Source Code Setup":
            exit(Page::"Source Code Setup");
          else
            exit(0);
        end;
    end;


    procedure GetConfigTables(var AllObj: Record AllObj;IncludeWithDataOnly: Boolean;IncludeRelatedTables: Boolean;IncludeDimensionTables: Boolean;IncludeLicensedTablesOnly: Boolean;IncludeReferringTable: Boolean)
    var
        TempInt: Record "Integer" temporary;
        TableInfo: Record "Table Information";
        ConfigLine: Record "Config. Line";
        "Field": Record "Field";
        ConfigPackageMgt: Codeunit "Config. Package Management";
        NextLineNo: Integer;
        NextVertNo: Integer;
        Include: Boolean;
    begin
        if not HideDialog then
          ConfigProgressBar.Init(AllObj.Count,1,Text023);

        TempInt.DeleteAll;

        NextLineNo := 10000;
        ConfigLine.Reset;
        if ConfigLine.FindLast then
          NextLineNo := ConfigLine."Line No." + 10000;

        NextVertNo := 0;
        ConfigLine.SetCurrentkey("Vertical Sorting");
        if ConfigLine.FindLast then
          NextVertNo := ConfigLine."Vertical Sorting" + 1;

        if AllObj.FindSet then
          repeat
            if not HideDialog then
              ConfigProgressBar.Update(AllObj."Object Name");
            Include := true;
            if IncludeWithDataOnly then begin
              Include := false;
              TableInfo.SetRange("Company Name",COMPANYNAME);
              TableInfo.SetRange("Table No.",AllObj."Object ID");
              if TableInfo.FindFirst then
                if TableInfo."No. of Records" > 0 then
                  Include := true;
            end;
            if Include then begin
              if IncludeReferringTable then
                InsertTempInt(TempInt,AllObj."Object ID",IncludeLicensedTablesOnly);
              if IncludeRelatedTables then begin
                ConfigPackageMgt.SetFieldFilter(Field,AllObj."Object ID",0);
                Field.SetFilter(RelationTableNo,'<>%1&<>%2&..%3',0,AllObj."Object ID",99000999);
                if Field.FindSet then
                  repeat
                    InsertTempInt(TempInt,Field.RelationTableNo,IncludeLicensedTablesOnly);
                  until Field.Next = 0;
              end;
              if IncludeDimensionTables then
                if CheckDimTables(AllObj."Object ID") then begin
                  InsertDimTables(TempInt,IncludeLicensedTablesOnly);
                  IncludeDimensionTables := false;
                end;
            end;
          until AllObj.Next = 0;

        if TempInt.FindSet then
          repeat
            InsertConfigLine(TempInt.Number,NextLineNo,NextVertNo);
          until TempInt.Next = 0;

        if not HideDialog then
          ConfigProgressBar.Close;
    end;

    local procedure InsertConfigLine(TableID: Integer;var NextLineNo: Integer;var NextVertNo: Integer)
    var
        ConfigLine: Record "Config. Line";
    begin
        ConfigLine.Init;
        ConfigLine.Validate("Line Type",ConfigLine."line type"::Table);
        ConfigLine.Validate("Table ID",TableID);
        ConfigLine."Line No." := NextLineNo;
        NextLineNo := NextLineNo + 10000;
        ConfigLine."Vertical Sorting" := NextVertNo;
        NextVertNo := NextVertNo + 1;
        ConfigLine.Insert(true);
    end;

    local procedure CheckDimTables(TableID: Integer): Boolean
    var
        "Field": Record "Field";
    begin
        Field.SetRange(TableNo,TableID);
        Field.SetRange(Class,Field.Class::Normal);
        if Field.FindSet then
          repeat
            if IsDimSetIDField(Field.TableNo,Field."No.") then
              exit(true);
          until Field.Next = 0;
    end;

    local procedure InsertDimTables(var TempInt: Record "Integer";IncludeLicensedTablesOnly: Boolean)
    begin
        InsertTempInt(TempInt,Database::Dimension,IncludeLicensedTablesOnly);
        InsertTempInt(TempInt,Database::"Dimension Value",IncludeLicensedTablesOnly);
        InsertTempInt(TempInt,Database::"Dimension CombinationAllo",IncludeLicensedTablesOnly);
        InsertTempInt(TempInt,Database::"Dimension Value Combination",IncludeLicensedTablesOnly);
        InsertTempInt(TempInt,Database::"Dimension Set Entry",IncludeLicensedTablesOnly);
        InsertTempInt(TempInt,Database::"Dimension Set Tree Node",IncludeLicensedTablesOnly);
        InsertTempInt(TempInt,Database::"Default Dimension",IncludeLicensedTablesOnly);
        InsertTempInt(TempInt,Database::"Default Dimension Priority",IncludeLicensedTablesOnly);
    end;


    procedure IsDefaultDimTable(TableID: Integer): Boolean
    begin
        case TableID of
          Database::"G/L Account",
          Database::Customer,
          Database::Vendor,
          Database::Item,
          Database::"Resource Group",
          Database::Resource,
          Database::Job,
          Database::"Bank Account",
          Database::o,
          Database::"Fixed Asset",
          Database::Insurance,
          Database::"Responsibility Center",
          Database::"Work Center",
          Database::"Salesperson/Purchaser",
          Database::Campaign,
          Database::"Customer Template",
          Database::"Cash Flow Manual Expense",
          Database::"Cash Flow Manual Revenue":
            exit(true);
          else
            exit(false);
        end;
    end;


    procedure IsDimSetIDTable(TableID: Integer): Boolean
    var
        RecRef: RecordRef;
    begin
        RecRef.Open(TableID);
        exit(RecRef.FieldExist(Database::"Dimension Set Entry"));
    end;

    local procedure IsDimSetIDField(TableID: Integer;FieldID: Integer): Boolean
    var
        ConfigValidateMgt: Codeunit "Config. Validate Management";
    begin
        exit(
          (FieldID = Database::"Dimension Set Entry") or
          (ConfigValidateMgt.GetRelationTableID(TableID,FieldID) = Database::"Dimension Value"));
    end;


    procedure IsSystemTable(TableID: Integer): Boolean
    begin
        if (TableID > 2000000000) and not (TableID in [Database::"Permission Set",Database::Permission]) then
          exit(true);

        exit(false);
    end;


    procedure AssignParentLineNos()
    var
        ConfigLine: Record "Config. Line";
        LastAreaLineNo: Integer;
        LastGroupLineNo: Integer;
    begin
        with ConfigLine do begin
          Reset;
          SetCurrentkey("Vertical Sorting");
          if FindSet then
            repeat
              case "Line Type" of
                "line type"::Area:
                  begin
                    "Parent Line No." := 0;
                    LastAreaLineNo := "Line No.";
                    LastGroupLineNo := 0;
                  end;
                "line type"::Group:
                  begin
                    "Parent Line No." := LastAreaLineNo;
                    LastGroupLineNo := "Line No.";
                  end;
                "line type"::Table:
                  begin
                    if LastGroupLineNo <> 0 then
                      "Parent Line No." := LastGroupLineNo
                    else
                      "Parent Line No." := LastAreaLineNo;
                  end;
              end;
              Modify;
            until Next = 0;
        end;
    end;


    procedure MakeTableFilter(var ConfigLine: Record "Config. Line";Export: Boolean) "Filter": Text
    var
        AddDimTables: Boolean;
    begin
        Filter := '';
        if ConfigLine.FindSet then
          repeat
            ConfigLine.CheckBlocked;
            if (ConfigLine."Table ID" > 0) and (ConfigLine.Status <= ConfigLine.Status::"In Progress") then
              Filter += Format(ConfigLine."Table ID") + '|';
            AddDimTables := AddDimTables or ConfigLine."Dimensions as Columns";
          until ConfigLine.Next = 0;
        if AddDimTables and not Export then
          Filter += StrSubstNo('%1|%2|',Database::"Dimension Value",Database::"Default Dimension");
        if Filter <> '' then
          Filter := CopyStr(Filter,1,StrLen(Filter) - 1);

        exit(Filter);
    end;


    procedure SetHideDialog(NewHideDialog: Boolean)
    begin
        HideDialog := NewHideDialog;
    end;

    local procedure InsertTempInt(var TempInt: Record "Integer";TableId: Integer;IncludeLicensedTablesOnly: Boolean)
    var
        ConfigLine: Record "Config. Line";
    begin
        TempInt.Number := TableId;

        ConfigLine.Init;
        ConfigLine."Line Type" := ConfigLine."line type"::Table;
        ConfigLine."Table ID" := TableId;
        if IncludeLicensedTablesOnly then begin
          ConfigLine.CalcFields("Licensed Table");
          if ConfigLine."Licensed Table" then
            if TempInt.Insert then;
        end else
          if TempInt.Insert then;
    end;


    procedure DimensionFieldID(): Integer
    begin
        exit(999999900);
    end;
}

