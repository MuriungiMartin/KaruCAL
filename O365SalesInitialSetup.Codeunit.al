#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 2110 "O365 Sales Initial Setup"
{
    Permissions = TableData "Sales Document Icon"=rimd;

    trigger OnRun()
    begin
        InitializeO365SalesCompany;
        InitializeAccountingPeriod; // ensure accounting period is always valid
    end;

    var
        O365SalesInitialSetup: Record "O365 Sales Initial Setup";
        OverrideDefaultsWithSalesSetupQst: label 'We would like to update some configuration data but have detected some existing invoices. Would you like to update the configuration data anyway?';
        ConfigTemplateManagement: Codeunit "Config. Template Management";
        HideDialogs: Boolean;
        SetupCompleteMsg: label 'Welcome! We have prepared your company and are now ready to send your first invoice. To review your settings at any time, you can run the set up guide in settings.';
        CreateInvoiceMsg: label 'Create Invoice';
        DefaultBankLbl: label 'Default';
        TaxableCodeTxt: label 'TAXABLE', Locked=true;
        TaxableDescriptionTxt: label 'Taxable';


    procedure HideConfirmDialog()
    begin
        HideDialogs := true;
    end;

    local procedure InitializeO365SalesCompany()
    var
        Type: Integer;
        Overwrite: Boolean;
    begin
        // Override defaults for O365 Sales
        if not O365SalesInitialSetup.Get then
          exit;
        if O365SalesInitialSetup."Is initialized" then
          exit;

        if not (IsNewCompany or HideDialogs) then
          Overwrite := Confirm(OverrideDefaultsWithSalesSetupQst);

        if IsNewCompany or Overwrite then begin
          InitializeCompanySetup;
          InitializeBankAccount;
          InitializeSalesAndReceivablesSetup;
          InitializePaymentRegistrationSetup;
          InitializeReportSelection;
          InitializeNotifications;
          InitializeExtensions;
          InitializeNoSeries;
        end;

        InitializeCustomerTemplate;
        InitializeItemTemplate;
        InitializeTax;

        for Type := 0 to 5 do
          InsertIcon(Type);

        O365SalesInitialSetup."Is initialized" := true;
        O365SalesInitialSetup.Modify;

        if not HideDialogs then
          NotifySetupComplete;
    end;

    local procedure InitializePaymentRegistrationSetup()
    var
        PaymentRegistrationSetup: Record "Payment Registration Setup";
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        if not GenJournalBatch.Get(
             O365SalesInitialSetup."Payment Reg. Template Name",
             O365SalesInitialSetup."Payment Reg. Batch Name")
        then
          exit;

        with PaymentRegistrationSetup do begin
          DeleteAll;
          Init;
          Validate("Journal Template Name",GenJournalBatch."Journal Template Name");
          Validate("Journal Batch Name",GenJournalBatch.Name);
          Insert(true);
        end;
    end;

    local procedure InitializeSalesAndReceivablesSetup()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        with SalesReceivablesSetup do begin
          Get;
          "Default Item Quantity" := true;
          "Create Item from Description" := true;
          "Stockout Warning" := false;
          Modify(true);
        end;
    end;

    local procedure InitializeCustomerTemplate()
    var
        ConfigTemplateHeader: Record "Config. Template Header";
        Customer: Record Customer;
    begin
        ConfigTemplateHeader.SetFilter(Code,'<>%1',O365SalesInitialSetup."Default Customer Template");
        ConfigTemplateHeader.SetRange("Table ID",Database::Customer);
        ConfigTemplateHeader.DeleteAll(true);

        ConfigTemplateManagement.ReplaceDefaultValueForAllTemplates(
          Database::Customer,Customer.FieldNo("Payment Method Code"),O365SalesInitialSetup."Default Payment Method Code");
        ConfigTemplateManagement.ReplaceDefaultValueForAllTemplates(
          Database::Customer,Customer.FieldNo("Payment Terms Code"),O365SalesInitialSetup."Default Payment Terms Code");
    end;

    local procedure InitializeItemTemplate()
    var
        ConfigTemplateHeader: Record "Config. Template Header";
    begin
        ConfigTemplateHeader.SetFilter(Code,'<>%1',O365SalesInitialSetup."Default Item Template");
        ConfigTemplateHeader.SetRange("Table ID",Database::Item);
        ConfigTemplateHeader.DeleteAll(true);
    end;

    local procedure InitializeReportSelection()
    var
        ReportSelections: Record "Report Selections";
        ReportLayoutSelection: Record "Report Layout Selection";
        CustomReportLayout: Record "Custom Report Layout";
    begin
        CustomReportLayout.SetRange(Code,'MS-1303-Blue');
        CustomReportLayout.SetRange("Report ID",Report::"Standard Sales - Draft Invoice");
        if not CustomReportLayout.FindFirst then
          exit;

        ReportSelections.SetRange(Usage,ReportSelections.Usage::"S.Invoice Draft");
        ReportSelections.DeleteAll;

        ReportSelections.Usage := ReportSelections.Usage::"S.Invoice Draft";
        ReportSelections.NewRecord;
        ReportSelections.Validate("Report ID",Report::"Standard Sales - Draft Invoice");
        ReportSelections.Insert(true);

        if ReportLayoutSelection.Get(Report::"Standard Sales - Draft Invoice",COMPANYNAME) then
          ReportLayoutSelection.Delete;
        ReportLayoutSelection.Init;
        ReportLayoutSelection.Validate("Report ID",Report::"Standard Sales - Draft Invoice");
        ReportLayoutSelection.Validate(Type,ReportLayoutSelection.Type::"Custom Layout");
        ReportLayoutSelection.Validate("Custom Report Layout Code",CustomReportLayout.Code);
        ReportLayoutSelection.Insert(true);
    end;

    local procedure InitializeNotifications()
    var
        MyNotifications: Record "My Notifications";
        MyNotificationsPage: Page "My Notifications";
    begin
        // Disable all notifications
        MyNotificationsPage.InitializeNotificationsWithDefaultState;
        if MyNotifications.FindSet then
          repeat
            MyNotifications.Validate(Enabled,false);
            MyNotifications.Modify(true);
          until MyNotifications.Next = 0;
    end;

    local procedure InitializeExtensions()
    var
        NAVAppInstalledApp: Record "NAV App Installed App";
        NavExtensionInstallationMgmt: Codeunit "Extension Installation Impl";
    begin
        NAVAppInstalledApp.SetRange(Name,'Sales and Inventory Forecast');
        if not NAVAppInstalledApp.FindFirst then
          exit;

        NavExtensionInstallationMgmt.UninstallNavExtension(NAVAppInstalledApp."Package ID");
    end;

    local procedure InitializeNoSeries()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        if not IsNewCompany then
          exit; // Do not change no. series if we already have invoices documents

        SalesReceivablesSetup.Get;
        SalesReceivablesSetup.Validate("Invoice Nos.",O365SalesInitialSetup."Sales Invoice No. Series");
        SalesReceivablesSetup.Validate("Posted Invoice Nos.",O365SalesInitialSetup."Posted Sales Inv. No. Series");
        SalesReceivablesSetup.Modify(true);
    end;

    local procedure InitializeTax()
    var
        TaxGroup: Record "Tax Group";
        TaxArea: Record "Tax Area";
        TaxJurisdiction: Record "Tax Jurisdiction";
        TaxSetup: Record "Tax Setup";
        TaxAreaLine: Record "Tax Area Line";
        TaxDetail: Record "Tax Detail";
        Item: Record Item;
        Customer: Record Customer;
        ConfigTemplateManagement: Codeunit "Config. Template Management";
    begin
        if not TaxGroup.Get(TaxableCodeTxt) then begin
          TaxGroup.Init;
          TaxGroup.Validate(Code,TaxableCodeTxt);
          TaxGroup.Validate(Description,TaxableDescriptionTxt);
          TaxGroup.Insert;
        end;

        if not TaxArea.Get(TaxableCodeTxt) then begin
          TaxArea.Init;
          TaxArea.Validate(Code,TaxableCodeTxt);
          TaxArea.Validate(Description,TaxableCodeTxt);
          TaxArea.Insert;
        end;

        if not TaxJurisdiction.Get(TaxableCodeTxt) then begin
          TaxJurisdiction.Init;
          TaxJurisdiction.Validate(Code,TaxableCodeTxt);
          TaxJurisdiction.Insert;
        end;

        if TaxSetup.Get then;
        TaxJurisdiction.Validate(Description,TaxableDescriptionTxt);
        TaxJurisdiction.Validate("Tax Account (Sales)",TaxSetup."Tax Account (Sales)");
        TaxJurisdiction.Validate("Tax Account (Purchases)",TaxSetup."Tax Account (Purchases)");
        TaxJurisdiction.Modify;

        if not TaxAreaLine.Get(TaxArea.Code,TaxJurisdiction.Code) then begin
          TaxAreaLine.Init;
          TaxAreaLine.Validate("Tax Area",TaxArea.Code);
          TaxAreaLine.Validate("Tax Jurisdiction Code",TaxJurisdiction.Code);
          TaxAreaLine.Insert;
        end;

        if not TaxDetail.Get(TaxJurisdiction.Code,TaxGroup.Code,TaxDetail."tax type"::"Sales and Use Tax",WorkDate) then begin
          TaxDetail.Init;
          TaxDetail.Validate("Tax Jurisdiction Code",TaxJurisdiction.Code);
          TaxDetail.Validate("Tax Group Code",TaxGroup.Code);
          TaxDetail.Validate("Tax Type",TaxDetail."tax type"::"Sales and Use Tax");
          TaxDetail.Validate("Effective Date",WorkDate);
          TaxDetail.Insert(true);
        end;

        TaxDetail.Validate("Maximum Amount/Qty.",0);
        TaxDetail.Validate("Tax Below Maximum",0);
        TaxDetail.Modify;

        ConfigTemplateManagement.ReplaceDefaultValueForAllTemplates(
          Database::Item,Item.FieldNo("Tax Group Code"),TaxGroup.Code);

        ConfigTemplateManagement.ReplaceDefaultValueForAllTemplates(
          Database::Customer,Customer.FieldNo("Tax Area Code"),TaxArea.Code);
    end;

    local procedure InitializeAccountingPeriod()
    var
        AccountingPeriod: Record "Accounting Period";
        CreateFiscalYear: Report "Create Fiscal Year";
        DateFormulaVariable: DateFormula;
    begin
        if not AccountingPeriod.IsEmpty then
          exit;

        Evaluate(DateFormulaVariable,'<1M>');
        CreateFiscalYear.InitializeRequest(12,DateFormulaVariable,CalcDate('<-CY>',WorkDate));
        CreateFiscalYear.UseRequestPage(false);
        CreateFiscalYear.HideConfirmationDialog(true);
        CreateFiscalYear.RunModal;
    end;

    local procedure InitializeBankAccount()
    var
        CompanyInformation: Record "Company Information";
        BankAccount: Record "Bank Account";
        CompanyInformationMgt: Codeunit "Company Information Mgt.";
    begin
        CompanyInformation.Get;
        CompanyInformation.Validate("Bank Name",DefaultBankLbl);
        CompanyInformation.Validate("Bank Account No.",DefaultBankLbl);
        CompanyInformation.Validate("Bank Branch No.",DefaultBankLbl);
        CompanyInformation.Modify(true);

        CompanyInformationMgt.UpdateCompanyBankAccount(CompanyInformation,'',BankAccount);
    end;

    local procedure InitializeCompanySetup()
    var
        CompanyInformation: Record "Company Information";
    begin
        if not CompanyInformation.Get then
          CompanyInformation.Insert(true);

        if CompanyInformation.Name = '' then
          CompanyInformation.Validate(Name,COMPANYNAME);

        CompanyInformation.Modify(true);
    end;

    local procedure NotifySetupComplete()
    var
        AssistedSetup: Record "Assisted Setup";
        Notification: Notification;
    begin
        AssistedSetup.SetStatus(Page::"Assisted Company Setup Wizard",AssistedSetup.Status::Completed); // don't run the madeira assisted company setup

        Notification.Scope(Notificationscope::LocalScope);
        Notification.Message(SetupCompleteMsg);
        Notification.AddAction(CreateInvoiceMsg,Codeunit::"O365 Sales Initial Setup",'CreateInvoice');
        Notification.Send;
    end;


    procedure CreateInvoice(Notification: Notification)
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Init;
        SalesHeader.Validate("Document Type",SalesHeader."document type"::Invoice);
        SalesHeader.Insert(true);

        Page.Run(Page::"O365 Sales Invoice",SalesHeader);
    end;

    local procedure IsNewCompany(): Boolean
    var
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        // Simple logic to determine if this is a new company
        exit(SalesHeader.IsEmpty and SalesInvoiceHeader.IsEmpty);
    end;

    local procedure InsertIcon(Type: Integer)
    var
        SalesDocumentIcon: Record "Sales Document Icon";
        Convert: dotnet Convert;
        ByteArray: dotnet Array;
        MemoryStream: dotnet MemoryStream;
        IconData: Text;
    begin
        if SalesDocumentIcon.Get(Type) then
          SalesDocumentIcon.Delete(true);

        IconData := GetIconData(Type);
        if IconData = '' then
          exit;

        SalesDocumentIcon.Init;
        SalesDocumentIcon.Type := Type;

        ByteArray := Convert.FromBase64String(IconData);
        MemoryStream := MemoryStream.MemoryStream(ByteArray);

        SalesDocumentIcon.Picture.ImportStream(MemoryStream,Format(SalesDocumentIcon.Type));

        SalesDocumentIcon.Insert;
    end;

    local procedure GetIconData(Type: Integer): Text
    var
        SalesDocumentIcon: Record "Sales Document Icon";
    begin
        SalesDocumentIcon.Type := Type;

        case Type of
          SalesDocumentIcon.Type::"Canceled Invoice":
            exit(CanceledInvoiceIcon);
          SalesDocumentIcon.Type::"Overdue Invoice":
            exit(OverdueInvoiceIcon);
          SalesDocumentIcon.Type::"Paid Invoice":
            exit(PaidInvoiceIcon);
          SalesDocumentIcon.Type::Quote:
            exit(QuoteIcon);
          SalesDocumentIcon.Type::"Unpaid Invoice":
            exit(UnpaidInvoiceIcon);
          SalesDocumentIcon.Type::"Draft Invoice":
            exit(DraftInvoiceIcon);
        end;

        exit('');
    end;

    local procedure CanceledInvoiceIcon(): Text
    begin
        exit('');
    end;

    local procedure UnpaidInvoiceIcon(): Text
    var
        IconData: Text;
    begin
        IconData := 'iVBORw0KGgoAAAANSUhEUgAAAZAAAAGQCAYAAACAvzbMAAAACXBIWXMAACKaAAAimgG+3fsqAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJ';
        IconData += 'lYWR5ccllPAAAB8VJREFUeNrs3cFRGlEcwGHMeDc3juoMBaSD0AHpANKBHQQ7MBUIFUQqCCnBOwc8ctMKNu9NHhNnohnfgss+9vtm3uzkgvhn3V';
        IconData += '9YYDmpqqoHALk+GAEAAgKAgAAgIAAICAAICAACAoCAACAgAAgIAAgIAAICgIAAICAACAgACAgAAgKAgAAgIAAICAAICAACAoCAACAgAAgIAAgIA';
        IconData += 'AICgIAAICAACAgACAgAAgKAgAAgIAAICAAICAACAoCAACAgACAgAAgIAAICgIAAICAAICAACAgAAgKAgAAgIAAgIAAICAACAoCAACAgACAgAAgI';
        IconData += 'AAICgIAAICAAICAACAgAAgKAgAAgIAAgIAAICAACAoCAACAgACAgAAgIAAICgIAAICAAICAACAgAAgKAgACAgAAgIAAICAACAoCAAICAACAgAAg';
        IconData += 'IAAICgIAAgIAAICAACAgAAgKAgACAgAAgIAAICAACAoCAAICAACAgAAgIAAICgIAAgIAAICAACAgAAgKAgACAgAAgIAAICAACAgACAoCAACAgAA';
        IconData += 'gIAAICAAICgIAAICAACAgAAgIAAgKAgAAgIAAICAACAgACAoCAACAgAAgIAAICAAICgIAAICAACAgAAgIAAgKAgAAgIAAICAACAgAZTo2gXfqD0';
        IconData += 'dAU4GWb1WJpCgLC634aAbzqxAjawyksAAQEAAEBQEAAEBAAEBAABAQAAQFAQAAQEAAQEAD2wLWwum0e1swY2MEkrGFY50YhIHTLOP3xTzerhZDw';
        IconData += 'Zv3BKIZjKhzd5hQW8QBwGw4I63RQgP+GI+4rcZ8RDwQEIUE4qOWkqipTaNcfalsekIfen1MUd5vV4tEj091w9Fp0qirsi74PREAoICBbT2HdxCU';
        IconData += 'kwiEgCIiACAlFhUNA2slrIOW7Twf393YW1rew4msk07A+Gv1xhaPh1zie0r6LgHBAd2FdhHUtJBQSjuu0z955BASEwz+tfwxrKiSUEI64rzoNKi';
        IconData += 'AIiZAIh3AICEIiJMIhHAgIQoJwICAICcKBgCAkQiIcCAhCIiTCIRwIiJAIiXAIBwKCkAiHcCAgCAnCgYAgJEIiHAgIQiIkwgECgpAIh3Cwi1MjI';
        IconData += 'CckYRMP5vF7Qa7SOmsoJFfp5x7t95GkSDY11+fh8D0vCAhCIhzCgYAgJEcfEuFAQBASIREOBASERDjgrbwLi3cJybN3bX1v6Me29l1b8b7E+xTv';
        IconData += 'W7qPTcUjzt67qhAQig1J/N/2ZVjzroXkgOGIs76MsxcOBITSQ7IOa9KVkLQgHJM4c3seAoKQFBIS4UBAQEiEAwQEIXm/kAgHAgJCkhUS4QABQUi';
        IconData += 'yQiIcICAISVZIhANe5pPotDokYTNJB++4xg2GZPvJ9qjJT45vwzEVDQQEyg5Jk4SDojiFRVEhOcCprabC4VQVAgJCIhwICAiJcICAICTCAQICpY';
        IconData += 'VEOBAQEBLhAAFBSIQDBARaEhLhQEBASIQDBATeLyTCgYCAkGSFRDhAQCArJMIBAgJZIREOeIGr8cILIen9vfpvTzRAQKBOSIBXOIUFgIAAICAAC';
        IconData += 'AgAAgIAAgKAgAAgIAAICAACAgACAoCAACAgAAgIAAICAAICgIAAICAACAgAAgIAAgKAgAAgIEBh+oPRZI8392iiAgJ0Ix6zsLlN251tVoubsJmb';
        IconData += 'rIAAxx+PcfrneI8RmYiIgADdiEdPRBAQoG48RAQBAWrHQ0QQEKB2PEREQABqx0NEBASgdjxERECAjsdjuEM8RERAgK4KB+xl2Hzdw02JiIAAHYz';
        IconData += 'ITEQQEEBEEBBARFJEEBBARBAQQEREREAARAQBAUQEAQFEBAEBREREBAQQEREREAARQUAAEUFAABFBQAAREZHjclJVlSm0SPgDyn1AHsJam1xrzN';
        IconData += 'IBNecxXx7J7/4prLM93M7cda/KcGoExTtPi3aoE4PPxvbPMxEXTyyAU1hAWyMyMwYBARARAQEQEQQEEBEEBOhARK6MQUAAct2H5VmIgABkx2O4W';
        IconData += 'S0ejUJAAMRDQADEQ0AAxIMMLmXSPr+MoGjrDj/mF739XFZHPArhYorAzvqD0SRsbsWjW5zCAsQDAQHEAwEBxAMBAcRDPAQEEA/xQEAA8UBAAPFA';
        IconData += 'QADxQEAA8RAPAQHEQzwQEEA8EBBAPBAQQDwQEEA8xOP4uZw7sI3Hl7D5IR54BgLkWqaDv3ggIMDbpYP+cIeIiIeAACKSHRHxEBBARLIjIh4CApA';
        IconData += 'dEfEQEIDsiIiHgABkR0Q8EBAgOyLigYAA2RGZiwdbPokOgGcgAAgIAAICgIAAgIAAICAACAgAAgKAgACAgAAgIAAICAACAoCAAICAACAgAAgIAA';
        IconData += 'ICgIAAgIAAICAACAgAAgKAgACAgAAgIAAICAACAoCAAICAACAgAAgIAAICgIAAgIAAICAACAgAAgIAAgKAgAAgIAAICAACAgACAoCAACAgAAgIA';
        IconData += 'AICAAICgIAAICAACAgAAgIAAgKAgAAgIAAICAACAgACAoCAACAgAAgIAAICAAICgIAAICAACAgAAgIAAgKAgAAgIAAICAACYgQACAgAAgKAgAAg';
        IconData += 'IAAgIAAICAACAoCAACAgACAgAAgIAAICgIAAICAAICAACAgAAgKAgAAgIAAgIAAICAACAoCAACAgACAgAAgIAAICgIAAICAAICAACAgAAgLAsfg';
        IconData += 'twAAkUuXVWtoVEAAAAABJRU5ErkJggg==';
        exit(IconData);
    end;

    local procedure PaidInvoiceIcon(): Text
    var
        IconData: Text;
    begin
        IconData := 'iVBORw0KGgoAAAANSUhEUgAAAZAAAAGQCAYAAACAvzbMAAAACXBIWXMAACKaAAAimgG+3fsqAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJ';
        IconData += 'lYWR5ccllPAAACB5JREFUeNrs3cFN21AYwPGk4g4jkAnoLUfYoCPgbpBD7s0AHDICbNANao7cwgaMABO4n4WRqopWvMQvPNu/n/QUTiA+2+8vg5';
        IconData += 'zMm6aZAUCqL0YAgIAAICAACAgAAgIAAgKAgAAgIAAICAACAgACAoCAACAgAAgIAAICAAICgIAAICAACAgAAgIAAgKAgAAgIAAICAACAgACAoCAA';
        IconData += 'CAgAAgIAAICAAICgIAAICAACAgAAgIAAgKAgAAgIAAICAAICAACAoCAACAgAAgIAAgIAAICgIAAICAACAgACAgAAgKAgAAgIAAICAAICAACAoCA';
        IconData += 'ACAgAAgIAAgIAAICgIAAICAACAgACAgAAgKAgAAgIAAICAAICAACAoCAACAgAAgIAAgIAAICgIAAICAAICAACAgAAgKAgAAgIAAgIAAICAACAoC';
        IconData += 'AACAgACAgAAgIAAICgIAAICAAICAACAgAAgKAgAAgIAAgIAAICAACAoCAACAgACAgAAgIAAICgIAAICAAICAACAgAAgKAgACAgAAgIAAICAACAo';
        IconData += 'CAAICAACAgAAgIAAICgIAAgIAAICAAfJoTIyjLfL1sTAHe19w8zE3BHQgAAgKAgACAgAAgIAAICAACAoCAAICAACAgAAgIAKPivbCG7yVWHWtnF';
        IconData += 'BTuLFYV69QoBIQytBfjt+7i3DQ3D7WRUJL5etmemyvxEBDKdRnrV1ys90JCYeFYCYeAICQgHAiIkIBwICAICcKBgCAkCAcCgpAgHAgIQgLCgYAg';
        IconData += 'JAgHAoKQIBwICEKCcCAgCAnCgYCAkAgHCMho3XWv10LCgMJxrPOWjHweyPA9xWZexevij4vyGCGpY10Z/zDDEWvTnjuxfhw5Hu05uujO2SdHwx0';
        IconData += 'IBYgLsr0Yq25j2LgjocA7jk13niIgCImQCIdwCAhCIiTCIRwICEIiHMKBgCAkCAcCgpAIiXAgIAiJkAiHcCAgQiIkwiEcCAhCIhzCgYAgJAgHAo';
        IconData += 'KQCIlwICAIiZAIBwgIQiIcwoGAICTCIRwICEIymZAIBwKCkAiJcCAgICTCAQKCkAiHcCAgCMkQQyIcCAgIiXCAgCAkwgECgpAUEhLhQEBASIQDB';
        IconData += 'AQhyRcS4QABQUiSQiIcICAISVJIhAMEBCFJColwgIAgJPuE5DFez4UD/u2LETCUkMSq4stFt8nmdnHkeLS/06L9HcUDAYFxhEQ4QEAQEuEAAYHh';
        IconData += 'hkQ4EBAQEuFAQEBIhAMEBAoJiXAgICAkwgHv8SAhkwnJ7PWBxLcny/t8uvwl1rZd8XOeTRsBgXGGpN3gNxGSbQ8hEQ4EBIQkKSTCAQKCkCSFRDh';
        IconData += 'AQCApJMIBAgLJIZkJRzG+G4GAwGBCYhLlxCOOya0xlMVzIIB4ICCAeCAgAOIhIADiISAAA4nHfL08N0oBAcQjNR7t99jF61cjFRBAPFLicT17fR';
        IconData += 'C0FhEBAcQjJR5vRERAAPFIjoeICAggHnvHQ0QEBBih7ZHiISICAoxJH29QmRAPEREQgL3jISICAojH3vH4OyJnpikggHikWvmcFwEBxCOV99oSE';
        IconData += 'EA8xENAAMRDQADEQ0AAxAMBAcQDAQHEQzwEBEA8BARAPAQEQDwQEEA8EBBAPMRDQADxEA8BARAPAQEQDwQEEA8EBBAP8RAQQDzEQ0AAxENAAMQD';
        IconData += 'AQHEAwEBxEM8BAQQD/EQEADxEBAA8UBAAPHgSMe8aRpTKOsiTD0g97FqkyPRLjbpn+LBIU6MYPAuuwUf9RhrKx4cyp+wYHrxuIqN+lk8EBBAPBA';
        IconData += 'QQDwQEEA8xENAAPEQDwQExEM8EBBAPBAQQDwQEEA8xENAAPEQDwQExEM86Jc3UwTEA3cggHggIIB4ICCAeCAggHiIBwICiAcCAogHAgKIBwICiA';
        IconData += 'cCAoiHeCAgIB7igYAA4oGAAOLBoJwYASPfPM/ipY61i82vEg/xwB0IpMTjot1Eu81UPMQDAYEPx+PNZCIiHggI9BePyUREPBAQ6D8eo4+IeCAgk';
        IconData += 'C8eo42IeCAgkD8eo4uIeCAgcLx4jCYi4oGAwP72jcfgIyIeCAgcZtfD9xhcRMQDAYEDdU+Y300pIuKBgICIiAcCAiIiHggIiEiBEREPBARERDwQ';
        IconData += 'EBAR8UBAQEQKjIh4ICAgIuKBgICIiAcICCJSYETEAwEBEREPBAREJH9ExAMBARERDwQERCR/RMQDAQEREQ8EBEQkf0TEAwEBEUmOSI/xuBMPBAQ';
        IconData += 'mEpGe41E5eggITCAi4oGAgIgkR0Q8GJt50zSmABnvFGKtYtWxLsQDAQERSfES61Q8EBAQkc8gHhTH/0DgP3r8n4h4ICAgIuIBAgJlR0Q8EBAQEf';
        IconData += 'FAQEBE8kdEPBAQEBHxQECA/BERDwQEREQ8EBAgf0TEAwEBEREPBATIHxHxQECA5IiIBwICJEdEPBAQIDki4oGAAMkREQ8EBEiOiHgwOj5QCnJfZ';
        IconData += 'OtlFfG4NQkEBABm/oQFgIAAICAACAgAAgIAAgKAgAAgIAAICAACAgACAoCAACAgAAgIAAICAAICgIAAICAACAgAAgIAAgKAgAAgIAAICAACAgAC';
        IconData += 'AoCAACAgAAgIAAICAAICgIAAICAACAgAAgIAAgKAgAAgIAAICAAICAACAoCAACAgAAgIAAgIAAICgIAAICAACAgACAgAAgKAgAAgIAAICAAICAA';
        IconData += 'CAoCAACAgAAgIAAgIAAICgIAAICAACAgACAgAAgKAgAAgIAAICAAICAACAoCAACAgACAgAAgIAAICgIAAICAAICAACAgAAgKAgAAgIAAgIAAICA';
        IconData += 'ACAsCw/BZgAOEhXeb55fCDAAAAAElFTkSuQmCC';
        exit(IconData);
    end;

    local procedure DraftInvoiceIcon(): Text
    var
        IconData: Text;
    begin
        IconData := 'iVBORw0KGgoAAAANSUhEUgAAAZAAAAGQCAYAAACAvzbMAAAACXBIWXMAACKaAAAimgG+3fsqAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJ';
        IconData += 'lYWR5ccllPAAAB3pJREFUeNrs3T1yEmEcwGHI0JOSLt7AFPSSG+QGkhNoGurYUukJXG4Qb4A9M+INYkcpJ1j3Hd4Gv2aB/d7nmdnBWCT47n/fn8';
        IconData += 'swYZim6QAATnVlCQAQEAAEBAABAUBAAEBAABAQAAQEAAEBQEAAQEAAEBAABAQAAQFAQABAQAAQEAAEBAABAUBAAEBAABAQAAQEAAEBQEAAQEAAE';
        IconData += 'BAABAQAAQFAQABAQAAQEAAEBAABAUBAAEBAABAQAAQEAAEBAAEBQEAAEBAABAQAAQEAAQFAQAAQEAAEBAABAQABAUBAABAQAAQEAAEBAAEBQEAA';
        IconData += 'EBAABAQAAQEAAQFAQAAQEAAEBAABAQABAUBAABAQAAQEAAEBAAEBQEAAEBAABAQAAQEAAQFAQAAQEAAEBAAEBAABAUBAABAQAAQEAAQEAAEBQEA';
        IconData += 'AEBAABAQABAQAAQFAQAAQEAAEBAAEBAABAUBAABAQAAQEAAQEAAEBQEAAEBAABAQABAQAAQFAQAAQEAAEBAAEBAABAUBAAOiWkSWAP20Wk+vsYR';
        IconData += '6/TKbL3U+rAseGaZpaBTgOx/t4jONf77PjYziEBAQE8oTjd0ICAgInhUNIQEDgonAICQgIwnFROIQEBAThKJSQICAgHEICAoJwVBcOIUFAQDiEB';
        IconData += 'AQE4WgOIUFAQDiEBAQE4RASEBCEQ0hAQKAJ4fgRH2+EBAQE4cgbjqdsE0/ic5iHr4UEBAThyBWOvzwnIQEBQTiOfI+bdJLzOQoJCAg9D8fXeMex';
        IconData += 'PvM538fn+0ZIEBAQjnP+DbN4RyIkCAgIh5CAgCAcJYdDSBAQEA4hAQFBOOoLh5AgICAcQgICgnAIiZAgIAhHS8MhJAgICIeQgIBwwab3KkZjLhy';
        IconData += 'tDkkSQ/JiqhEQqghH2OTeVvhjOx2OBoQkWMU1FhIEBOEQEiFBQOhfOL4MDi+rrJ0BIUFAEA6blpAgIAiHTUpIQEAQjjafs9vB4Z1wzhkCgnDgHC';
        IconData += 'Ig2HRsOs4pAoJNxibjHDvHCIhNxabinDvnCAg2EcwAAoJNAzOBgGCTwIyYEQHBpmBTMDNmBgGxCdgEMEMICC56zBQCQgsu8vChQ88ucjMmJAiIi';
        IconData += '/qUcPjYUzMnJAiIi1g4EBIExEUrHAgJAoJwYEaFREAo6uKs6oQIB0WEZD44fCbJuIqfmc3q0MoLCPUFRDgoemavY0RKD4mACAj1BEQ4aH1IBERA';
        IconData += 'qDYgwkFnQiIgAkI1AREOOhcSAREQyg2IcNDZkAiIgFBeQD4NDm91FA6aGpKn7HgnIN1wZQk6ZWYJMKMICOd4nR3r+D89aNrdxzrOKAKCiIB4CAg';
        IconData += 'iAuKBgCAiiAcCgoggHggIIoJ4ICCICIgHAiIiIB4ICCKCeCAgiAjigYAgIogHAoKIgHggIIgI4oGAICKIBwLC6fYFReQl2xhuLScVxmNvRQWEeo';
        IconData += 'VPH1wV8H3G8U5ERKgiHqs4uwgIdZoud3MRoeR4hJnYFhWPOLMICCJCD+IR7jxuxAMBERER4dR4jMUDAREREUE8EBD+G5FHEaEh8XgUDwGhXREJ7';
        IconData += '3B5EBFqjsdDnEUEhJZFJBERao5HYlUFBBEREfEQDwREREQE8UBAEBHEAwFBRBAPBAQRQTwQEERERMRDPBAQRATxoDAjS9DviGSbSfjj5wIi8i1+';
        IconData += 'L/pDPNyB4E6kkDsRxAMBQURAPBAQRATxQEAQEcQDAaHpEbnLjr3VIAqzcCceCAh5IrLOHmYiQpyBWZwJEBByRWQrIuIR47G1FAgIIoJ4ICCICOK';
        IconData += 'BgCAiiAcCgoggHvSF34XFSRHZLCYhIvdWo5OexQMBoew7EZsM4CUsAAQEAAEBQEAAEBAAEBAABAQAAQFAQAAQEAAQEAAEBAABAUBAABAQABAQAA';
        IconData += 'QEAAEBQEAAEBAAEBAABAQAAQFAQAAQEAAQEAAEBAABAUBAABAQABAQAAQEAAEBQEAAEBAAEBAABAQAAQFAQABAQAAQEAAEBAABAUBAAEBAABAQA';
        IconData += 'AQEAAEBQEAAQEAAEBAABAQAAQFAQABAQAAQEAAEBAABAUBAAEBAABAQAJpjmKapVWiQzWLihMA/TJe7oVVwBwKAgAAgIAAgIAAICAACAoCAACAg';
        IconData += 'ACAgAAgIAAICQKeMLEHjfLAEQBv4ZYoAnMVLWAAICAACAoCAACAgACAgAAgIAAICgIAAICAAICAACAgAAgKAgAAgIAAgIAAICAACAoCAACAgACA';
        IconData += 'gAAgIAAICgIAAICAAICAACAgAAgKAgAAgIAAgIAAICAACAoCAACAgACAgAAgIAAICgIAAgIAAICAACAgAAgKAgACAgAAgIAAICAACAoCAAICAAC';
        IconData += 'AgAAgIAAICgIAAgIAAICAACAgAAgKAgACAgAAgIAAICAACAoCAAICAACAgAAgIAAICgIAAgIAAICAACAgAAgKAgFgCAAQEAAEBQEAAEBAAEBAAB';
        IconData += 'AQAAQFAQAAQEAAQEAAEBAABAUBAABAQABAQAAQEAAEBQEAAEBAAEBAABAQAAQFAQAAQEAAQEAAEBAABAUBAABAQABAQAAQEAAEBQEAAEBAAEBAA';
        IconData += 'BAQAAQGgY34JMAAzFlqmkppqzAAAAABJRU5ErkJggg==';
        exit(IconData);
    end;

    local procedure QuoteIcon(): Text
    begin
        exit('');
    end;

    local procedure OverdueInvoiceIcon(): Text
    var
        IconData: Text;
    begin
        IconData := 'iVBORw0KGgoAAAANSUhEUgAAAZAAAAGQCAYAAACAvzbMAAAACXBIWXMAACKaAAAimgG+3fsqAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJ';
        IconData += 'lYWR5ccllPAAADjVJREFUeNrs3UtyE9cewOH2rczNLCPKygqAMQOLFdh3BYgVQFaAWAH2CixWELOCyAPG1+zALkbM8Ap8zz86SoxjjNUv9eP7qr';
        IconData += 'rMIJalltI/nX6c3rm+vi4AYFP/sQoAEBAABAQAAQFAQABAQAAQEAAEBAABAUBAAEBAABAQAAQEAAEBQEAAQEAAEBAABAQAAQFAQABAQAAQEAAEB';
        IconData += 'AABAUBAAEBAABAQAAQEAAEBQEAAQEAAEBAABAQAAQFAQABAQAAQEAAEBAABAQABAUBAABAQAAQEAAEBAAEBQEAAEBAABAQAAQEAAQFAQAAQEAAE';
        IconData += 'BAABAQABAUBAABAQAAQEAAEBAAEBQEAAEBAABAQAAQEAAQFAQAAQEAAEBAABAQABAUBAABAQAAQEAAEBAAEBQEAAEBAABAQABAQAAQFAQAAQEAA';
        IconData += 'EBAAEBAABAUBAABAQAAQEAAQEAAEBQEAAEBAABAQABAQAAQFAQAAQEAAEBAAEBAABAUBAABAQAAQEAAQEAAEBQEAAEBAABAQABAQAAQFAQAAQEA';
        IconData += 'AQEAAEBAABAUBAABAQABAQAAQEAAEBQEAAEBAAEBAABASArfnFKuiWT78+vrYW4G7Pv37ZsRaMQAAQEAAEBAAEBAABAUBAABAQAAQEAAQEAAEBQ';
        IconData += 'EAAGBRzYQ3HWVqWVgM9MEvLntUgIHTHflomaZk///plYXXQNZ9+fRzhmIvHcNiFNSzxP+ZJ+h/1Iv/PCp0IR3wm47MpHgKCkIBwICBCAsKBgCAk';
        IconData += 'CAcCgpAgHAgIQoJwICAICQgHAoKQIBwICEKCcCAgCAnCgYAgJAgHAoKQCIlwgIAMznFa3qXlSkjoSTiu8mf22NoXELbr2/OvX+bFaiZeIaEP4Zj';
        IconData += 'kz+w374KA0AHpf0ghoRfhiM+qd0FAEBIhEQ7hEBCEREiEQzgQEIQE4UBAEBKEAwFBSIREOBAQhERIhEM4EBAhERLhEA4EBCERDuFAQBAShAMBQU';
        IconData += 'iERDgQEIRESIQDsl+sAh4akvQjQjLPG/V5Cxu1dUj++rvpOSzGEo6W1u/a5ZjWL0YgbDcmi7TEiORV3vgYkfRzxBHv3at4L8UDAUFIhEM4EBCEZ';
        IconData += 'OghEQ4EBIREOBAQEBLhAAFBSIRDOBAQhKSPIREOBASERDhAQBCS5kIiHAgICIlwgIAgJM2FRDgQEBCSjUIiHCAgCMlGIREOEBCEZKOQCAfczXTu';
        IconData += '9CIk6cdiS9PIF4Vp1cEIBCOSEiEx4mjOhU+1gMDQQyIczb2PO+mfL9Jy3PP3UkBASIRjC+/jMi1v8nv5TEwEBIREOMq8l+c3YvLftHy0VgQExhw';
        IconData += 'S4Sj3fp6m5TD987e0fLBGBATGFBLhqOf9vEjLLIcEAYFBh0Q4GgqJtSAgMNSQCAcCAkIiHCAg0FxIhAMBASHZKCTCAQICG4VEOOAGkynCjZAUd0';
        IconData += '/aOMpJDtN6iKhOHrjulj5BAgJC8n1IiqGHI73Op+nHzWVSbDiJZHqM9T/P0vItLedpiajEleXffKqGaef6+tpa6Nb/zJu+Ie/S/6Bza44NPmOP0';
        IconData += 'o+4wnuaf+42/Cc/p+U0lpiqxDtgBAL0MxqxHLT855/k5W16Hpc5JgsxERCg2+GIXVJvWhppPETsGnsdS3puMTI5yiMTu7l6yFlYMMxwTNOyTP/8';
        IconData += 'X1pediQed41M4jbBcQvheR4lISDAlsPxZ1r2e/K0I25vhURAgO2EY5KWRc/C8aOQnK/PgENAgGbjEcc44oD0y4G8pDhOchIjqXwtCgICNDDqWKZ';
        IconData += '/vi+6eYyjqv08Gnnj3RYQoL54HOZRx/7AX2qE8X16vaeOjQgIUD0ecerrHwMddfzIQR6NPPUJEBBg83A8yrusXo90FcSxkaUD7N3hQkLoSTyK1d';
        IconData += 'xST1r6k3HF+EX+m2s3/x3PZz0amOSljd1pMeqKA+yFGZEFBPh5PGJDfVpsOMHhhtbzVUUkHjoB4ukPnmss06LZq98jIk/T83SAXUCAe+KxbGhDH';
        IconData += 'NGIb/ExlchFHQ+Y57c6z4+7Pth/2FBMYjqUR+lvznxSBAT4Ph6PGorHh2I1meGy6deQ/sZfs/DemMxxXvNI6mV67BgxHfnEtM9BdBhPPCIcv8U3';
        IconData += '9rZvABW7xGq8F/1t7x1YFxDgH/HNva4D5nGTp2c5HBfbfmE3QvJ7Wq5qetg4JjL1sREQGPvoI3bH1HFGU2yc4x7u0y7eeyPvdoqQfKwruqY+ERA';
        IconData += 'YczxmRT3XecSo42nXT3XNu7bi2MirGkYju8UdZ4YhIDCGeMS35zoOBh/nUcdFX157Dt20WJ0ZVsWTPIJDQGBUFkX1g+av+nptRN7NNs2jpypeOx';
        IconData += '4iIDCm0Uds9Ksc94jdPy/6fnV23qUVG/8PVWNs8kUBgTHEY1Ksro+oEo9p26fmNhySWcWI7FVcpzyACwlh+2KffZVdV4d1n2WVozbZcKNfa8AiI';
        IconData += 'jHnVVH+RlmxK+uoT8eCBATYZEM9LVZTlZf1qqGRR4wA3m74OzsNPI/YtRfTuZS9JmZRrI6r0AC7sGC75hV+93joM9LmSR0jAGVP8d13QF1AYKij';
        IconData += 'j7IHzs/GMhNtjsjhliKNgMCgRh/xbXw2phWVd9O9MwoREDD6WE3TXnb0MR/jgeH0miO4ZS80dN8QAYHBKLtBOxv51OVl19uBebIEBIYw+ljfG8M';
        IconData += '36c1HIcui/PUhM58+AYG+K3t3vg9dnFV3C+YCIiAw5oC0ueEc2ijkouQoZC8fe0JAoH/y7qsyFw5+dEW1UYiAgNFHGaYo//co5GOL6x8Bga2blv';
        IconData += 'idyyFNlFijRYnf2XM2loDAmEYgRh93j0Li7oNXLb0HCAhsTz6AW+bsK7dprXfdOJAuINA7ZTZclw6e1x6QqdUmIDCGgBh93CPvxtrUnrsVCgiMI';
        IconData += 'SBLq+2nzlp6LxAQ2JpJid9x5Xkz62hitVXnjoT9N03D8bnV0LpFiWMTexv+91eOfwiIgNCk/aL8tOCUt0zLgzfuJa89MPp4mDKRFZAa2IUF7Siz';
        IconData += 'wTL6MAIREKC1b9ajk295i4AAICAA7TmzCgQEhsqFawgIAAgItMeB3mZNrAIBAShjzyoQEAAEBKhoahX8XL7PCgICw1TylrTO3GpuPS2tturMhdW';
        IconData += '9Dc2OtUD2ZIufw3n6MTdSwwgEumHji90+/frYxvHn3GdFQGDwypzKa/9+M+vIadUCAr1SZtZYI5D7R2gRj41P4X3+9Yup8gUEemVZ4ncO3L+79s';
        IconData += 'CaN0tAYBQjkHBo1f3QrKWQcwdnYUFL4r4VaTTxudj87KoIyKLN55qe52zTjXN6fdOWn+OkKHemmt1XAgK9dFpioxe7sSYt3x89Ns5dv1Xym5IhP';
        IconData += '/UxrIddWNB+QMqYWXW1rJOPVpuAQC/ls38u2/q2PVR5F9tuiwFHQKC3o5DdvNFkZd7yCBABgU5YlPy9I6f0/j36KDN9+8c4kcHHT0Cgt/JurM9l';
        IconData += 'RiHFyHdl5YAetRxuBAQ6pexG8G0+fXWs5kW5Yx+Xzr4SEBiK2Jhd+Sa90ehjmn68ts4EBEYt74svOwrZTxvT+cji8ahCBK4qrGsEBDrpqMIo5O3';
        IconData += 'I7sQX8Sh73/MjB88FBIxCvrccw1lZ6TXGiQMHRh/dYyoT2P4oZFby2/Vujsi0gW/YF0UHZq3Np+y+r/AQc6OP5uxcX19bC7D9jeRJhYeIU4KnQ9';
        IconData += 'tQ5oPmf1Z4iDjzauIT1hy7sGDL0kZuUfHb/pNiYLuzcjyqnnY78+kSEBiD2NhdVfj9wUQkj8hi5LFb4WGOU5iXPlYCAmMYhVwU5ed3uh2R3p6dl';
        IconData += 'Q+Yn1R8mMsa1iUP4BgIdGsDGrttDio+TIxkZn268vrGdR4HNTzcM/c8NwKBMZoV5aZ7vyl2/fyRNsqLPuzSysc7zmuKx+/iYQQCYx6FxC6oZVHt';
        IconData += 'GMBaxOhNF0cjOW7zovz0JLd9SK9z5hNkBAKjlb9B1zXr7l4ejSzzN/2uxCNe30WN8fhcuOmWEQjw90Y2vk2f1PywcUvXo22coZRHHId51LFX40M';
        IconData += 'P8joYAQGqbnSPavyWfnujG4992vSGN++Sm+Vlt+aHjxMGnuaz2BAQ4NYGeJF+vGzwT8So5LTOmNyIxmHNo43b8Zg6aC4gwP0b5Ni//76FPxUjk/';
        IconData += 'Mby7f7NtB5t1TEYv1zmn/utvA8D408BAR4WETiG/2JNeGYR1c4Cwt6Is+Z9aKoNuVJ330QDyMQoPxIZFKsjlk8GdlLj4sE3dtDQIAaQtLUGVpdE';
        IconData += 'xdDHjpY3j12YUFPpQ1qHFh/UVSf+qTLjovVabriYQQCNDASqXtKkK6MOmamZBcQoJ2QTIrVjLb7PX4ZcYLA3LEOAQG2E5JpHpH0KSQRjojGkTOs';
        IconData += 'BAToRkjiOMlBh5/mZR41CYeAAB0MyaT4Zy6qvY48rZg+ZdGnm14hIDD2mLQxR9V90ah1zi0EBNjeyCRCMi1W81fVHZSzYnVjrHMjDQEBhh2U9YS';
        IconData += 'Ik1vLQyxv/Pzmug0BAYAfciU6AAICgIAAICAACAgACAgAAgKAgAAgIAAICAAICAACAoCAACAgAAgIAAgIAAICgIAAICAACAgACAgAAgKAgAAgIA';
        IconData += 'AICAAICAACAoCAACAgAAgIAAgIAAICgIAAICAACAgACAgAAgKAgAAgIAAgIAAICAACAoCAACAgACAgAAgIAAICgIAAICAAICAACAgAAgKAgAAgI';
        IconData += 'AAgIAAICAACAoCAACAgACAgAAgIAAICgIAAICAAICAACAgAAgKAgAAgIAAgIAAICAACAoCAACAgVgEAAgKAgAAgIAAICAAICAACAoCAACAgAAgI';
        IconData += 'AAgIAAICgIAAICAACAgACAgAAgKAgAAgIAAICAAICAACAoCAACAgAAgIAAgIAAICgIAAICAACAgACAgAAgJAB/1fgAEAUMOtVgkW07QAAAAASUV';
        IconData += 'ORK5CYII=';

        exit(IconData);
    end;
}

