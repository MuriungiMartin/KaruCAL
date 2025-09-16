#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1400 DocumentNoVisibility
{

    trigger OnRun()
    begin
    end;


    procedure SalesDocumentNoIsVisible(DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;DocNo: Code[20]): Boolean
    var
        NoSeries: Record "No. Series";
        SalesNoSeriesSetup: Page "Sales No. Series Setup";
        DocNoSeries: Code[10];
    begin
        if DocNo <> '' then
          exit(false);

        DocNoSeries := DetermineSalesSeriesNo(DocType);

        if not NoSeries.Get(DocNoSeries) then begin
          SalesNoSeriesSetup.SetFieldsVisibility(DocType);
          SalesNoSeriesSetup.RunModal;
          DocNoSeries := DetermineSalesSeriesNo(DocType);
          if not NoSeries.Get(DocNoSeries) then
            exit(true);
        end;

        exit(ForceShowNoSeriesForDocNo(DocNoSeries));
    end;


    procedure PurchaseDocumentNoIsVisible(DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";DocNo: Code[20]): Boolean
    var
        NoSeries: Record "No. Series";
        PurchaseNoSeriesSetup: Page "Purchase No. Series Setup";
        DocNoSeries: Code[10];
    begin
        if DocNo <> '' then
          exit(false);

        DocNoSeries := DeterminePurchaseSeriesNo(DocType);

        if not NoSeries.Get(DocNoSeries) then begin
          PurchaseNoSeriesSetup.SetFieldsVisibility(DocType);
          PurchaseNoSeriesSetup.RunModal;
          DocNoSeries := DeterminePurchaseSeriesNo(DocType);
          if not NoSeries.Get(DocNoSeries) then
            exit(true);
        end;

        exit(ForceShowNoSeriesForDocNo(DocNoSeries));
    end;


    procedure CustomerNoIsVisible(): Boolean
    var
        NoSeries: Record "No. Series";
        NoSeriesCode: Code[10];
    begin
        NoSeriesCode := DetermineCustomerSeriesNo;

        if not NoSeries.Get(NoSeriesCode) then
          exit(true);

        exit(ForceShowNoSeriesForDocNo(NoSeriesCode));
    end;


    procedure VendorNoIsVisible(): Boolean
    var
        NoSeries: Record "No. Series";
        NoSeriesCode: Code[10];
    begin
        NoSeriesCode := DetermineVendorSeriesNo;

        if not NoSeries.Get(NoSeriesCode) then
          exit(true);

        exit(ForceShowNoSeriesForDocNo(NoSeriesCode));
    end;


    procedure ItemNoIsVisible(): Boolean
    var
        NoSeries: Record "No. Series";
        NoSeriesCode: Code[10];
    begin
        NoSeriesCode := DetermineItemSeriesNo;

        if not NoSeries.Get(NoSeriesCode) then
          exit(true);

        exit(ForceShowNoSeriesForDocNo(NoSeriesCode));
    end;


    procedure FixedAssetNoIsVisible(): Boolean
    var
        NoSeries: Record "No. Series";
        NoSeriesCode: Code[10];
    begin
        NoSeriesCode := DetermineFixedAssetSeriesNo;

        if not NoSeries.Get(NoSeriesCode) then
          exit(true);

        exit(ForceShowNoSeriesForDocNo(NoSeriesCode));
    end;


    procedure CustomerNoSeriesIsDefault(): Boolean
    var
        NoSeries: Record "No. Series";
    begin
        if NoSeries.Get(DetermineCustomerSeriesNo) then
          exit(NoSeries."Default Nos.");

        exit(false);
    end;


    procedure VendorNoSeriesIsDefault(): Boolean
    var
        NoSeries: Record "No. Series";
    begin
        if NoSeries.Get(DetermineVendorSeriesNo) then
          exit(NoSeries."Default Nos.");

        exit(false);
    end;


    procedure ItemNoSeriesIsDefault(): Boolean
    var
        NoSeries: Record "No. Series";
    begin
        if NoSeries.Get(DetermineItemSeriesNo) then
          exit(NoSeries."Default Nos.");
    end;


    procedure FixedAssetNoSeriesIsDefault(): Boolean
    var
        NoSeries: Record "No. Series";
    begin
        if NoSeries.Get(DetermineFixedAssetSeriesNo) then
          exit(NoSeries."Default Nos.");
    end;

    local procedure DetermineSalesSeriesNo(DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo): Code[10]
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get;
        case DocType of
          Doctype::Quote:
            exit(SalesReceivablesSetup."Quote Nos.");
          Doctype::Order:
            exit(SalesReceivablesSetup."Order Nos.");
          Doctype::Invoice:
            exit(SalesReceivablesSetup."Invoice Nos.");
          Doctype::"Credit Memo":
            exit(SalesReceivablesSetup."Credit Memo Nos.");
          Doctype::"Blanket Order":
            exit(SalesReceivablesSetup."Blanket Order Nos.");
          Doctype::"Return Order":
            exit(SalesReceivablesSetup."Return Order Nos.");
          Doctype::Reminder:
            exit(SalesReceivablesSetup."Reminder Nos.");
          Doctype::FinChMemo:
            exit(SalesReceivablesSetup."Fin. Chrg. Memo Nos.");
        end;
    end;

    local procedure DeterminePurchaseSeriesNo(DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"): Code[10]
    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
    begin
        PurchasesPayablesSetup.Get;
        case DocType of
          Doctype::Quote:
            exit(PurchasesPayablesSetup."Quote Nos.");
          Doctype::Order:
            exit(PurchasesPayablesSetup."Order Nos.");
          Doctype::Invoice:
            exit(PurchasesPayablesSetup."Invoice Nos.");
          Doctype::"Credit Memo":
            exit(PurchasesPayablesSetup."Credit Memo Nos.");
          Doctype::"Blanket Order":
            exit(PurchasesPayablesSetup."Blanket Order Nos.");
          Doctype::"Return Order":
            exit(PurchasesPayablesSetup."Return Order Nos.");
        end;
    end;

    local procedure DetermineCustomerSeriesNo(): Code[10]
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get;
        exit(SalesReceivablesSetup."Customer Nos.");
    end;

    local procedure DetermineVendorSeriesNo(): Code[10]
    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
    begin
        PurchasesPayablesSetup.Get;
        exit(PurchasesPayablesSetup."Vendor Nos.");
    end;

    local procedure DetermineItemSeriesNo(): Code[10]
    var
        InventorySetup: Record "Inventory Setup";
    begin
        InventorySetup.Get;
        exit(InventorySetup."Item Nos.");
    end;

    local procedure DetermineFixedAssetSeriesNo(): Code[10]
    var
        FASetup: Record "FA Setup";
    begin
        FASetup.Get;
        exit(FASetup."Fixed Asset Nos.");
    end;

    local procedure ForceShowNoSeriesForDocNo(NoSeriesCode: Code[10]): Boolean
    var
        NoSeries: Record "No. Series";
        NoSeriesRelationship: Record "No. Series Relationship";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        SeriesDate: Date;
    begin
        SeriesDate := WorkDate;
        NoSeries.Get(NoSeriesCode);

        NoSeriesRelationship.SetRange(Code,NoSeriesCode);
        if not NoSeriesRelationship.IsEmpty then
          exit(true);

        if NoSeries."Manual Nos." or (NoSeries."Default Nos." = false) then
          exit(true);

        exit(NoSeriesMgt.GetNextNo3(NoSeriesCode,SeriesDate,false,true) = '');
    end;
}

