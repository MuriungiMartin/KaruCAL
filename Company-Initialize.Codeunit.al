#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 2 "Company-Initialize"
{
    Permissions = TableData "Resources Setup"=i,
                  TableData "Jobs Setup"=i,
                  TableData "Cash Flow Setup"=i,
                  TableData "Social Listening Setup"=i,
                  TableData "Assembly Setup"=i,
                  TableData "Job WIP Method"=i,
                  TableData "Human Resources Setup"=i,
                  TableData "FA Setup"=i;

    trigger OnRun()
    var
        BankPmtApplRule: Record "Bank Pmt. Appl. Rule";
        TransformationRule: Record "Transformation Rule";
        IRS1099FormBox: Record UnknownRecord10010;
        ApplicationLaunchMgt: Codeunit "Application Launch Management";
        AddOnIntegrMgt: Codeunit AddOnIntegrManagement;
        WorkflowSetup: Codeunit "Workflow Setup";
        Window: Dialog;
    begin
        Window.Open(Text000);

        InitSetupTables;
        AddOnIntegrMgt.InitMfgSetup;
        InitSourceCodeSetup;
        InitStandardTexts;
        InitReportSelection;
        InitJobWIPMethods;
        InitBankExportImportSetup;
        InitBankDataConversionPmtType;
        InitBankClearingStandard;
        InitBankDataConvServiceSetup;
        InitDocExchServiceSetup;
        BankPmtApplRule.InsertDefaultMatchingRules;
        IRS1099FormBox.InitIRS1099FormBoxes;
        ApplicationLaunchMgt.InsertStyleSheets;
        InsertClientAddIns;
        InitVATRegNrValidationSetup;
        WorkflowSetup.InitWorkflow;
        TransformationRule.CreateDefaultTransformations;
        InitElectronicFormats;

        OnCompanyInitialize;

        Window.Close;

        Commit;
    end;

    var
        Text000: label 'Initializing company...';
        SEPACTCodeTxt: label 'SEPACT', Comment='No need to translate - but can be translated at will.';
        SEPACTNameTxt: label 'SEPA Credit Transfer';
        SEPADDCodeTxt: label 'SEPADD', Comment='No need to translate - but can be translated at will.';
        SEPADDNameTxt: label 'SEPA Direct Debit';
        Text001: label 'SALES';
        Text002: label 'Sales';
        Text003: label 'PURCHASES';
        Text004: label 'Purchases';
        Text005: label 'DELETE';
        Text006: label 'INVTPCOST';
        Text007: label 'EXCHRATADJ';
        Text010: label 'CLSINCOME';
        Text011: label 'CONSOLID';
        Text012: label 'Consolidation';
        Text013: label 'GENJNL';
        Text014: label 'SALESJNL';
        Text015: label 'PURCHJNL';
        Text016: label 'CASHRECJNL';
        Text017: label 'PAYMENTJNL';
        Text018: label 'ITEMJNL';
        Text020: label 'PHYSINVJNL';
        Text022: label 'RESJNL';
        Text023: label 'JOBJNL';
        Text024: label 'SALESAPPL';
        Text025: label 'Sales Entry Application';
        PaymentReconJnlTok: label 'PAYMTRECON', Comment='Payment Reconciliation Journal Code';
        Text026: label 'PURCHAPPL';
        Text027: label 'Purchase Entry Application';
        Text028: label 'TAXSTMT';
        Text029: label 'COMPRGL';
        Text030: label 'COMPRTAX';
        Text031: label 'COMPRCUST';
        Text032: label 'COMPRVEND';
        Text035: label 'COMPRRES';
        Text036: label 'COMPRJOB';
        Text037: label 'COMPRBANK';
        Text038: label 'COMPRCHECK';
        Text039: label 'FINVOIDCHK';
        Text040: label 'Financially Voided Check';
        Text041: label 'REMINDER';
        Text042: label 'Reminder';
        Text043: label 'FINCHRG';
        Text044: label 'Finance Charge Memo';
        Text045: label 'FAGLJNL';
        Text046: label 'FAJNL';
        Text047: label 'INSJNL';
        Text048: label 'COMPRFA';
        Text049: label 'COMPRMAINT';
        Text050: label 'COMPRINS';
        Text051: label 'ADJADDCURR';
        Text052: label 'MD';
        Text053: label 'Monthly Depreciation';
        Text054: label 'SC';
        Text055: label 'Shipping Charge';
        Text056: label 'SUC';
        Text057: label 'Sale under Contract';
        Text058: label 'TE';
        Text059: label 'Travel Expenses';
        Text063: label 'TRANSFER';
        Text064: label 'Transfer';
        Text065: label 'RECLASSJNL';
        Text066: label 'REVALJNL';
        Text067: label 'CONSUMPJNL';
        Text068: label 'INVTADJMT';
        Text069: label 'POINOUTJNL';
        Text070: label 'CAPACITJNL';
        Text071: label 'WHITEM';
        Text072: label 'WHPHYSINVT';
        Text073: label 'WHRCLSSJNL';
        Text074: label 'SERVICE';
        Text075: label 'Service Management';
        Text076: label 'BANKREC';
        Text077: label 'WHPUTAWAY';
        Text078: label 'WHPICK';
        Text079: label 'WHMOVEMENT';
        Text080: label 'Whse. Put-away';
        Text081: label 'Whse. Pick';
        Text082: label 'Whse. Movement';
        Text083: label 'COMPRWHSE';
        Text084: label 'INTERCOMP';
        Text085: label 'Intercompany';
        Text086: label 'UNAPPSALES';
        Text087: label 'Unapplied Sales Entry Application';
        Text088: label 'UNAPPPURCH';
        Text089: label 'Unapplied Purchase Entry Application';
        Text090: label 'REVERSAL';
        Text091: label 'Reversal Entry ';
        Text092: label 'PRODORDER';
        Text99000004: label 'FLUSHING';
        Text99000005: label 'Flushing';
        Text096: label 'JOBGLJNL';
        Text097: label 'JOBGLWIP';
        Text098: label 'WIP Entry';
        Text099: label 'Date Compress Job Ledge';
        Text100: label 'COMPRIBUDG', Comment='{Locked} ';
        Text101: label 'Completed Contract';
        Text102: label 'Cost of Sales';
        Text103: label 'Cost Value';
        Text104: label 'Sales Value';
        Text105: label 'Percentage of Completion';
        Text106: label 'POC';
        Text109: label 'CFWKSH', Comment='Uppercase of the translation of cash flow work sheet with a max of 10 char';
        Text110: label 'Cash Flow Worksheet';
        Text107: label 'ASSEMBLY', Comment='Uppercase of the translation of assembly with a max of 10 char';
        Text108: label 'Assembly';
        Text111: label 'GL';
        Text112: label 'G/L Entry to Cost Accounting';
        Text113: label 'CAJOUR', Comment='Uppercase of the translation of cost accounting journal with a max of 10 char';
        Text114: label 'Cost Journal';
        Text115: label 'ALLOC', Comment='Uppercase of the translation of allocation with a max of 10 char';
        Text116: label 'Cost Allocation';
        Text117: label 'TRABUD', Comment='Uppercase of the translation of Transfer Budget to Actual with a max of 10 char';
        Text118: label 'Transfer Budget to Actual';
        Text1020000: label 'BANKRECADJ';
        Text1020001: label 'Bank Rec. Adjustment';
        Text1020002: label 'BANKDEP';
        Text1020003: label 'Bank Deposit';
        BankClearingStandardCode1Tok: label 'AustrianBankleitzahl', Locked=true;
        BankClearingStandardDesc1Txt: label 'Austrian BLZ number';
        BankClearingStandardCode2Tok: label 'CanadianPaymentsARN', Locked=true;
        BankClearingStandardDesc2Txt: label 'Canadian ARN number';
        BankClearingStandardCode3Tok: label 'CHIPSParticipant', Locked=true;
        BankClearingStandardDesc3Txt: label 'American CHIPS number';
        BankClearingStandardCode4Tok: label 'CHIPSUniversal', Locked=true;
        BankClearingStandardDesc4Txt: label 'American CHIPS universal number';
        BankClearingStandardCode5Tok: label 'ExtensiveBranchNetwork', Locked=true;
        BankClearingStandardDesc5Txt: label 'Extensive branch network number';
        BankClearingStandardCode6Tok: label 'FedwireRoutingNumber', Locked=true;
        BankClearingStandardDesc6Txt: label 'American Fedwire/ABA routing number';
        BankClearingStandardCode7Tok: label 'GermanBankleitzahl', Locked=true;
        BankClearingStandardDesc7Txt: label 'German BLZ number';
        BankClearingStandardCode8Tok: label 'HongKongBank', Locked=true;
        BankClearingStandardDesc8Txt: label 'Hong Kong branch number';
        BankClearingStandardCode9Tok: label 'IrishNSC', Locked=true;
        BankClearingStandardDesc9Txt: label 'Irish NSC number';
        BankClearingStandardCode10Tok: label 'ItalianDomestic', Locked=true;
        BankClearingStandardDesc10Txt: label 'Italian domestic code';
        BankClearingStandardCode11Tok: label 'NewZealandNCC', Locked=true;
        BankClearingStandardDesc11Txt: label 'New Zealand NCC number';
        BankClearingStandardCode12Tok: label 'PortugueseNCC', Locked=true;
        BankClearingStandardDesc12Txt: label 'Portuguese NCC number';
        BankClearingStandardCode13Tok: label 'RussianCentralBankIdentificationCode', Locked=true;
        BankClearingStandardDesc13Txt: label 'Russian CBI code';
        BankClearingStandardCode14Tok: label 'SouthAfricanNCC', Locked=true;
        BankClearingStandardDesc14Txt: label 'South African NCC number';
        BankClearingStandardCode15Tok: label 'SpanishDomesticInterbanking', Locked=true;
        BankClearingStandardDesc15Txt: label 'Spanish domestic interbanking number';
        BankClearingStandardCode16Tok: label 'SwissBC', Locked=true;
        BankClearingStandardDesc16Txt: label 'Swiss BC number';
        BankClearingStandardCode17Tok: label 'SwissSIC', Locked=true;
        BankClearingStandardDesc17Txt: label 'Swiss SIC number';
        BankClearingStandardCode18Tok: label 'UKDomesticSortCode', Locked=true;
        BankClearingStandardDesc18Txt: label 'British sorting code';
        BankDataConvPmtTypeCode1Tok: label 'IntAcc2Acc', Locked=true;
        BankDataConvPmtTypeDesc1Txt: label 'International account to account transfer (standard)';
        BankDataConvPmtTypeCode2Tok: label 'IntAcc2AccExp', Locked=true;
        BankDataConvPmtTypeDesc2Txt: label 'International account to account transfer (express)';
        BankDataConvPmtTypeCode3Tok: label 'IntAcc2AccFoFa', Locked=true;
        BankDataConvPmtTypeDesc3Txt: label 'International account to account transfer';
        BankDataConvPmtTypeCode4Tok: label 'IntAcc2AccHighVal', Locked=true;
        BankDataConvPmtTypeDesc4Txt: label 'International account to account transfer (high value)';
        BankDataConvPmtTypeCode5Tok: label 'IntAcc2AccInterComp', Locked=true;
        BankDataConvPmtTypeDesc5Txt: label 'International account to account transfer (inter company)';
        BankDataConvPmtTypeCode6Tok: label 'DomAcc2Acc', Locked=true;
        BankDataConvPmtTypeDesc6Txt: label 'Domestic account to account transfer';
        BankDataConvPmtTypeCode7Tok: label 'DomAcc2AccHighVal', Locked=true;
        BankDataConvPmtTypeDesc7Txt: label 'Domestic account to account transfer (high value)';
        BankDataConvPmtTypeCode8Tok: label 'DomAcc2AccInterComp', Locked=true;
        BankDataConvPmtTypeDesc8Txt: label 'Domestic account to account transfer (inter company)';
        BankDataConvPmtTypeCode9Tok: label 'EurAcc2AccSepa', Locked=true;
        BankDataConvPmtTypeDesc9Txt: label 'SEPA credit transfer';
        PEPPOL21_ElectronicFormatTxt: label 'PEPPOL 2.1', Locked=true;
        PEPPOL21_ElectronicFormatDescriptionTxt: label 'PEPPOL 2.1 Format (Pan-European Public Procurement Online)';
        PEPPOL20_ElectronicFormatTxt: label 'PEPPOL 2.0', Locked=true;
        PEPPOL20_ElectronicFormatDescriptionTxt: label 'PEPPOL 2.0 Format (Pan-European Public Procurement Online)';

    local procedure InitSetupTables()
    var
        GLSetup: Record "General Ledger Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        InvtSetup: Record "Inventory Setup";
        ResourcesSetup: Record "Resources Setup";
        JobsSetup: Record "Jobs Setup";
        HumanResourcesSetup: Record "Human Resources Setup";
        MarketingSetup: Record "Marketing Setup";
        InteractionTemplateSetup: Record "Interaction Template Setup";
        ServiceMgtSetup: Record "Service Mgt. Setup";
        NonstockItemSetup: Record "Nonstock Item Setup";
        FASetup: Record "FA Setup";
        CashFlowSetup: Record "Cash Flow Setup";
        CostAccSetup: Record "Cost Accounting Setup";
        WhseSetup: Record "Warehouse Setup";
        AssemblySetup: Record "Assembly Setup";
        VATReportSetup: Record "VAT Report Setup";
        TaxSetup: Record "Tax Setup";
        ConfigSetup: Record "Config. Setup";
        DataMigrationSetup: Record "Data Migration Setup";
        IncomingDocumentsSetup: Record "Incoming Documents Setup";
        CompanyInfo: Record "Company Information";
        SocialListeningSetup: Record "Social Listening Setup";
    begin
        with GLSetup do
          if not FindFirst then begin
            Init;
            Insert;
          end;

        with SalesSetup do
          if not FindFirst then begin
            Init;
            Insert;
          end;

        with MarketingSetup do
          if not FindFirst then begin
            Init;
            Insert;
          end;

        with InteractionTemplateSetup do
          if not FindFirst then begin
            Init;
            Insert;
          end;

        with ServiceMgtSetup do
          if not FindFirst then begin
            Init;
            Insert;
          end;

        with SocialListeningSetup do
          if not FindFirst then begin
            Init;
            Insert(true);
          end;

        with PurchSetup do
          if not FindFirst then begin
            Init;
            Insert;
          end;

        with InvtSetup do
          if not FindFirst then begin
            Init;
            Insert;
          end;

        with ResourcesSetup do
          if not FindFirst then begin
            Init;
            Insert;
          end;

        with JobsSetup do
          if not FindFirst then begin
            Init;
            Insert;
          end;

        with FASetup do
          if not FindFirst then begin
            Init;
            Insert;
          end;

        with HumanResourcesSetup do
          if not FindFirst then begin
            Init;
            Insert;
          end;

        with WhseSetup do
          if not FindFirst then begin
            Init;
            Insert;
          end;

        with NonstockItemSetup do
          if not FindFirst then begin
            Init;
            Insert;
          end;

        with CashFlowSetup do
          if not FindFirst then begin
            Init;
            Insert;
          end;

        with CostAccSetup do
          if WritePermission then
            if not FindFirst then begin
              Init;
              Insert;
            end;

        with AssemblySetup do
          if not FindFirst then begin
            Init;
            Insert;
          end;

        with VATReportSetup do
          if not FindFirst then begin
            Init;
            Insert;
          end;

        with TaxSetup do
          if not FindFirst then begin
            Init;
            Insert;
          end;

        with ConfigSetup do
          if not FindFirst then begin
            Init;
            Insert;
          end;

        with DataMigrationSetup do
          if not FindFirst then begin
            Init;
            Insert;
          end;

        with IncomingDocumentsSetup do
          if not FindFirst then begin
            Init;
            Insert;
          end;

        with CompanyInfo do
          if not FindFirst then begin
            Init;
            "Created DateTime" := CurrentDatetime;
            Insert;
          end;
    end;

    local procedure InitSourceCodeSetup()
    var
        SourceCode: Record "Source Code";
        SourceCodeSetup: Record "Source Code Setup";
    begin
        if not (SourceCodeSetup.FindFirst or SourceCode.FindFirst) then
          with SourceCodeSetup do begin
            Init;
            InsertSourceCode(Sales,Text001,Text002);
            InsertSourceCode(Purchases,Text003,Text004);
            InsertSourceCode("Deleted Document",Text005,CopyStr(FieldCaption("Deleted Document"),1,30));
            InsertSourceCode("Inventory Post Cost",Text006,ReportName(Report::"Post Inventory Cost to G/L"));
            InsertSourceCode("Exchange Rate Adjmt.",Text007,ReportName(Report::"Adjust Exchange Rates"));
            InsertSourceCode("Close Income Statement",Text010,ReportName(Report::"Close Income Statement"));
            InsertSourceCode(Consolidation,Text011,Text012);
            InsertSourceCode("General Journal",Text013,PageName(Page::"General Journal"));
            InsertSourceCode("Sales Journal",Text014,PageName(Page::"Sales Journal"));
            InsertSourceCode("Purchase Journal",Text015,PageName(Page::"Purchase Journal"));
            InsertSourceCode("Cash Receipt Journal",Text016,PageName(Page::"Cash Receipt Journal"));
            InsertSourceCode("Payment Journal",Text017,PageName(Page::"Payment Journal"));
            InsertSourceCode("Payment Reconciliation Journal",PaymentReconJnlTok,PageName(Page::"Payment Reconciliation Journal"));
            InsertSourceCode("Item Journal",Text018,PageName(Page::"Item Journal"));
            InsertSourceCode(Transfer,Text063,Text064);
            InsertSourceCode("Item Reclass. Journal",Text065,PageName(Page::"Item Reclass. Journal"));
            InsertSourceCode("Phys. Inventory Journal",Text020,PageName(Page::"Phys. Inventory Journal"));
            InsertSourceCode("Revaluation Journal",Text066,PageName(Page::"Revaluation Journal"));
            InsertSourceCode("Consumption Journal",Text067,PageName(Page::"Consumption Journal"));
            InsertSourceCode("Output Journal",Text069,PageName(Page::"Output Journal"));
            InsertSourceCode("Production Journal",Text092,PageName(Page::"Production Journal"));
            InsertSourceCode("Capacity Journal",Text070,PageName(Page::"Capacity Journal"));
            InsertSourceCode("Resource Journal",Text022,PageName(Page::"Resource Journal"));
            InsertSourceCode("Job Journal",Text023,PageName(Page::"Job Journal"));
            InsertSourceCode("Job G/L Journal",Text096,PageName(Page::"Job G/L Journal"));
            InsertSourceCode("Job G/L WIP",Text097,Text098);
            InsertSourceCode("Sales Entry Application",Text024,Text025);
            InsertSourceCode("Unapplied Sales Entry Appln.",Text086,Text087);
            InsertSourceCode("Unapplied Purch. Entry Appln.",Text088,Text089);
            InsertSourceCode(Reversal,Text090,Text091);
            InsertSourceCode("Purchase Entry Application",Text026,Text027);
            InsertSourceCode("VAT Settlement",Text028,ReportName(Report::"Calc. and Post VAT Settlement"));
            InsertSourceCode("Compress G/L",Text029,ReportName(Report::"Date Compress General Ledger"));
            InsertSourceCode("Compress VAT Entries",Text030,ReportName(Report::"Date Compress VAT Entries"));
            InsertSourceCode("Compress Cust. Ledger",Text031,ReportName(Report::"Date Compress Customer Ledger"));
            InsertSourceCode("Compress Vend. Ledger",Text032,ReportName(Report::"Date Compress Vendor Ledger"));
            InsertSourceCode("Compress Res. Ledger",Text035,ReportName(Report::"Date Compress Resource Ledger"));
            InsertSourceCode("Compress Job Ledger",Text036,Text099);
            InsertSourceCode("Compress Bank Acc. Ledger",Text037,ReportName(Report::"Date Compress Bank Acc. Ledger"));
            InsertSourceCode("Compress Check Ledger",Text038,ReportName(Report::"Delete Check Ledger Entries"));
            InsertSourceCode("Financially Voided Check",Text039,Text040);
            InsertSourceCode(Reminder,Text041,Text042);
            InsertSourceCode("Finance Charge Memo",Text043,Text044);
            InsertSourceCode("Trans. Bank Rec. to Gen. Jnl.",Text076,ReportName(Report::"Trans. Bank Rec. to Gen. Jnl."));
            InsertSourceCode("Fixed Asset G/L Journal",Text045,PageName(Page::"Fixed Asset G/L Journal"));
            InsertSourceCode("Fixed Asset Journal",Text046,PageName(Page::"Fixed Asset Journal"));
            InsertSourceCode("Insurance Journal",Text047,PageName(Page::"Insurance Journal"));
            InsertSourceCode("Compress FA Ledger",Text048,ReportName(Report::"Date Compress FA Ledger"));
            InsertSourceCode("Compress Maintenance Ledger",Text049,ReportName(Report::"Date Compress Maint. Ledger"));
            InsertSourceCode("Compress Insurance Ledger",Text050,ReportName(Report::"Date Compress Insurance Ledger"));
            InsertSourceCode("Adjust Add. Reporting Currency",Text051,ReportName(Report::"Adjust Add. Reporting Currency"));
            InsertSourceCode(Flushing,Text99000004,Text99000005);
            InsertSourceCode("Adjust Cost",Text068,ReportName(Report::"Adjust Cost - Item Entries"));
            InsertSourceCode("Compress Item Budget",Text100,ReportName(Report::"Date Comp. Item Budget Entries"));
            InsertSourceCode("Whse. Item Journal",Text071,PageName(Page::"Whse. Item Journal"));
            InsertSourceCode("Whse. Phys. Invt. Journal",Text072,PageName(Page::"Whse. Phys. Invt. Journal"));
            InsertSourceCode("Whse. Reclassification Journal",Text073,PageName(Page::"Whse. Reclassification Journal"));
            InsertSourceCode("Compress Whse. Entries",Text083,ReportName(Report::"Date Compress Whse. Entries"));
            InsertSourceCode("Whse. Put-away",Text077,Text080);
            InsertSourceCode("Whse. Pick",Text078,Text081);
            InsertSourceCode("Whse. Movement",Text079,Text082);
            InsertSourceCode("Service Management",Text074,Text075);
            InsertSourceCode("IC General Journal",Text084,Text085);
            InsertSourceCode("Cash Flow Worksheet",Text109,Text110);
            InsertSourceCode(Assembly,Text107,Text108);
            InsertSourceCode("G/L Entry to CA",Text111,Text112);
            InsertSourceCode("Cost Journal",Text113,Text114);
            InsertSourceCode("Cost Allocation",Text115,Text116);
            InsertSourceCode("Transfer Budget to Actual",Text117,Text118);
            InsertSourceCode("Bank Rec. Adjustment",Text1020000,Text1020001);
            InsertSourceCode(Deposits,Text1020002,Text1020003);
            Insert;
          end;
    end;

    local procedure InitStandardTexts()
    var
        StandardText: Record "Standard Text";
    begin
        if not StandardText.FindFirst then begin
          InsertStandardText(Text052,Text053);
          InsertStandardText(Text054,Text055);
          InsertStandardText(Text056,Text057);
          InsertStandardText(Text058,Text059);
        end;
    end;

    local procedure InitReportSelection()
    var
        ReportSelections: Record "Report Selections";
    begin
        with ReportSelections do
          if not FindFirst then begin
            InsertRepSelection(Usage::"S.Invoice Draft",'1',Report::"Standard Sales - Draft Invoice");
            InsertRepSelection(Usage::"S.Quote",'1',Report::"Standard Sales - Quote");
            InsertRepSelection(Usage::"S.Blanket",'1',Report::"Sales Blanket Order");
            InsertRepSelection(Usage::"S.Order",'1',Report::"Standard Sales - Order Conf.");
            InsertRepSelection(Usage::"S.Work Order",'1',Report::"Work Order");
            InsertRepSelection(Usage::"S.Invoice",'1',Report::"Standard Sales - Invoice");
            InsertRepSelection(Usage::"S.Return",'1',Report::"Return Authorization");
            InsertRepSelection(Usage::"S.Cr.Memo",'1',Report::"Standard Sales - Credit Memo");
            InsertRepSelection(Usage::"S.Shipment",'1',Report::"Sales Shipment");
            InsertRepSelection(Usage::"S.Ret.Rcpt.",'1',Report::"Return Receipt");
            InsertRepSelection(Usage::"S.Test",'1',Report::"Sales Document - Test");
            InsertRepSelection(Usage::"P.Quote",'1',Report::"Purchase Quote");
            // InsertRepSelection(Usage::"P.Blanket",'1',REPORT::"Blanket Purchase Order");
            InsertRepSelection(Usage::"P.Blanket",'1',Report::"Purchase Blanket Order");
            InsertRepSelection(Usage::"P.Order",'1',Report::"Purchase Order");
            InsertRepSelection(Usage::"P.Invoice",'1',Report::"Purchase Invoice");
            InsertRepSelection(Usage::"P.Return",'1',Report::"Return Order");
            InsertRepSelection(Usage::"P.Cr.Memo",'1',Report::"Purchase Credit Memo");
            InsertRepSelection(Usage::"P.Receipt",'1',Report::"Purchase Receipt");
            InsertRepSelection(Usage::"P.Ret.Shpt.",'1',Report::"Return Shipment");
            InsertRepSelection(Usage::"P.Test",'1',Report::"Purchase Document - Test");
            InsertRepSelection(Usage::"B.Check",'1',Report::Check);
            InsertRepSelection(Usage::Reminder,'1',Report::Reminder);
            InsertRepSelection(Usage::"Fin.Charge",'1',Report::"Finance Charge Memo");
            InsertRepSelection(Usage::"Rem.Test",'1',Report::"Reminder - Test");
            InsertRepSelection(Usage::"F.C.Test",'1',Report::"Finance Charge Memo - Test");
            InsertRepSelection(Usage::Inv1,'1',Report::"Transfer Order");
            InsertRepSelection(Usage::Inv2,'1',Report::"Transfer Shipment");
            InsertRepSelection(Usage::Inv3,'1',Report::"Transfer Receipt");
            InsertRepSelection(Usage::"Invt. Period Test",'1',Report::"Close Inventory Period - Test");
            // InsertRepSelection(Usage::"B.Stmt",'1',REPORT::"Bank Reconciliation");
            InsertRepSelection(Usage::"B.Stmt",'1',Report::"Bank Account Statement");
            // InsertRepSelection(Usage::"B.Recon.Test",'1',REPORT::"Bank Rec. Test Report");
            InsertRepSelection(Usage::"B.Recon.Test",'1',Report::"Bank Acc. Recon. - Test");
            InsertRepSelection(Usage::"Prod. Order",'1',Report::"Prod. Order - Job Card");
            InsertRepSelection(Usage::M1,'1',Report::"Prod. Order - Job Card");
            InsertRepSelection(Usage::M2,'1',Report::"Prod. Order - Mat. Requisition");
            InsertRepSelection(Usage::M3,'1',Report::"Prod. Order - Shortage List");
            InsertRepSelection(Usage::"SM.Quote",'1',Report::"Service Quote");
            InsertRepSelection(Usage::"SM.Order",'1',Report::"Service Order");
            InsertRepSelection(Usage::"SM.Invoice",'1',Report::"Service Invoice-Sales Tax");
            InsertRepSelection(Usage::"SM.Credit Memo",'1',Report::"Service Credit Memo-Sales Tax");
            InsertRepSelection(Usage::"SM.Shipment",'1',Report::"Service - Shipment");
            InsertRepSelection(Usage::"SM.Contract Quote",'1',Report::"Service Contract Quote");
            InsertRepSelection(Usage::"SM.Contract",'1',Report::"Service Contract");
            InsertRepSelection(Usage::"SM.Test",'1',Report::"Service Document - Test");
            InsertRepSelection(Usage::"Asm. Order",'1',Report::"Assembly Order");
            InsertRepSelection(Usage::"P.Assembly Order",'1',Report::"Posted Assembly Order");
            InsertRepSelection(Usage::"S.Test Prepmt.",'1',Report::"Sales Prepmt. Document Test");
            InsertRepSelection(Usage::"P.Test Prepmt.",'1',Report::"Purchase Prepmt. Doc. - Test");
            InsertRepSelection(Usage::"S.Arch. Quote",'1',Report::"Archived Sales Quote");
            InsertRepSelection(Usage::"S.Arch. Order",'1',Report::"Archived Sales Order");
            InsertRepSelection(Usage::"P.Arch. Quote",'1',Report::"Archived Purchase Quote");
            InsertRepSelection(Usage::"P.Arch. Order",'1',Report::"Archived Purchase Order");
            InsertRepSelection(Usage::"P. Arch. Return Order",'1',Report::"Arch.Purch. Return Order");
            InsertRepSelection(Usage::"S. Arch. Return Order",'1',Report::"Arch. Sales Return Order");
            InsertRepSelection(Usage::"S.Order Pick Instruction",'1',Report::"Pick Instruction");
            InsertRepSelection(Usage::"C.Statement",'1',Report::"Standard Statement");
            InsertRepSelection(Usage::"V.Remittance",'1',Report::"Export Electronic Payments");
          end;
    end;

    local procedure InitJobWIPMethods()
    var
        JobWIPMethod: Record "Job WIP Method";
    begin
        if not JobWIPMethod.FindFirst then begin
          InsertJobWIPMethod(Text101,Text101,JobWIPMethod."recognized costs"::"At Completion",
            JobWIPMethod."recognized sales"::"At Completion",4);
          InsertJobWIPMethod(Text102,Text102,JobWIPMethod."recognized costs"::"Cost of Sales",
            JobWIPMethod."recognized sales"::"Contract (Invoiced Price)",2);
          InsertJobWIPMethod(Text103,Text103,JobWIPMethod."recognized costs"::"Cost Value",
            JobWIPMethod."recognized sales"::"Contract (Invoiced Price)",0);
          InsertJobWIPMethod(Text104,Text104,JobWIPMethod."recognized costs"::"Usage (Total Cost)",
            JobWIPMethod."recognized sales"::"Sales Value",1);
          InsertJobWIPMethod(Text106,Text105,JobWIPMethod."recognized costs"::"Usage (Total Cost)",
            JobWIPMethod."recognized sales"::"Percentage of Completion",3);
        end;
    end;

    local procedure InitBankExportImportSetup()
    var
        BankExportImportSetup: Record "Bank Export/Import Setup";
    begin
        if not BankExportImportSetup.FindFirst then begin
          InsertBankExportImportSetup(SEPACTCodeTxt,SEPACTNameTxt,BankExportImportSetup.Direction::Export,
            Codeunit::"SEPA CT-Export File",Xmlport::"SEPA CT pain.001.001.03",Codeunit::"SEPA CT-Check Line");
          InsertBankExportImportSetup(SEPADDCodeTxt,SEPADDNameTxt,BankExportImportSetup.Direction::Export,
            Codeunit::"SEPA DD-Export File",Xmlport::"SEPA DD pain.008.001.02",Codeunit::"SEPA DD-Check Line");
        end;
    end;

    local procedure InitBankClearingStandard()
    var
        BankClearingStandard: Record "Bank Clearing Standard";
    begin
        if not BankClearingStandard.FindFirst then begin
          InsertBankClearingStandard(BankClearingStandardCode1Tok,BankClearingStandardDesc1Txt);
          InsertBankClearingStandard(BankClearingStandardCode2Tok,BankClearingStandardDesc2Txt);
          InsertBankClearingStandard(BankClearingStandardCode3Tok,BankClearingStandardDesc3Txt);
          InsertBankClearingStandard(BankClearingStandardCode4Tok,BankClearingStandardDesc4Txt);
          InsertBankClearingStandard(BankClearingStandardCode5Tok,BankClearingStandardDesc5Txt);
          InsertBankClearingStandard(BankClearingStandardCode6Tok,BankClearingStandardDesc6Txt);
          InsertBankClearingStandard(BankClearingStandardCode7Tok,BankClearingStandardDesc7Txt);
          InsertBankClearingStandard(BankClearingStandardCode8Tok,BankClearingStandardDesc8Txt);
          InsertBankClearingStandard(BankClearingStandardCode9Tok,BankClearingStandardDesc9Txt);
          InsertBankClearingStandard(BankClearingStandardCode10Tok,BankClearingStandardDesc10Txt);
          InsertBankClearingStandard(BankClearingStandardCode11Tok,BankClearingStandardDesc11Txt);
          InsertBankClearingStandard(BankClearingStandardCode12Tok,BankClearingStandardDesc12Txt);
          InsertBankClearingStandard(BankClearingStandardCode13Tok,BankClearingStandardDesc13Txt);
          InsertBankClearingStandard(BankClearingStandardCode14Tok,BankClearingStandardDesc14Txt);
          InsertBankClearingStandard(BankClearingStandardCode15Tok,BankClearingStandardDesc15Txt);
          InsertBankClearingStandard(BankClearingStandardCode16Tok,BankClearingStandardDesc16Txt);
          InsertBankClearingStandard(BankClearingStandardCode17Tok,BankClearingStandardDesc17Txt);
          InsertBankClearingStandard(BankClearingStandardCode18Tok,BankClearingStandardDesc18Txt);
        end;
    end;

    local procedure InitBankDataConvServiceSetup()
    var
        BankDataConvServiceSetup: Record "Bank Data Conv. Service Setup";
    begin
        with BankDataConvServiceSetup do
          if not Get then begin
            Init;
            Insert(true);
          end;
    end;

    local procedure InitDocExchServiceSetup()
    var
        DocExchServiceSetup: Record "Doc. Exch. Service Setup";
    begin
        with DocExchServiceSetup do
          if not Get then begin
            Init;
            SetURLsToDefault;
            Insert;
          end;
    end;

    local procedure InitBankDataConversionPmtType()
    var
        BankDataConversionPmtType: Record "Bank Data Conversion Pmt. Type";
    begin
        if not BankDataConversionPmtType.FindFirst then begin
          InsertBankDataConversionPmtType(BankDataConvPmtTypeCode1Tok,BankDataConvPmtTypeDesc1Txt);
          InsertBankDataConversionPmtType(BankDataConvPmtTypeCode2Tok,BankDataConvPmtTypeDesc2Txt);
          InsertBankDataConversionPmtType(BankDataConvPmtTypeCode3Tok,BankDataConvPmtTypeDesc3Txt);
          InsertBankDataConversionPmtType(BankDataConvPmtTypeCode4Tok,BankDataConvPmtTypeDesc4Txt);
          InsertBankDataConversionPmtType(BankDataConvPmtTypeCode5Tok,BankDataConvPmtTypeDesc5Txt);
          InsertBankDataConversionPmtType(BankDataConvPmtTypeCode6Tok,BankDataConvPmtTypeDesc6Txt);
          InsertBankDataConversionPmtType(BankDataConvPmtTypeCode7Tok,BankDataConvPmtTypeDesc7Txt);
          InsertBankDataConversionPmtType(BankDataConvPmtTypeCode8Tok,BankDataConvPmtTypeDesc8Txt);
          InsertBankDataConversionPmtType(BankDataConvPmtTypeCode9Tok,BankDataConvPmtTypeDesc9Txt);
        end;
    end;

    local procedure InitVATRegNrValidationSetup()
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        VATLookupExtDataHndl: Codeunit "VAT Lookup Ext. Data Hndl";
    begin
        if GeneralLedgerSetup.Get then
          if GeneralLedgerSetup."VAT Reg. No. Validation URL" = '' then begin
            GeneralLedgerSetup."VAT Reg. No. Validation URL" := VATLookupExtDataHndl.GetVATRegNrValidationWebServiceURL;
            GeneralLedgerSetup.Modify;
          end;
    end;

    local procedure InitElectronicFormats()
    var
        ElectronicDocumentFormat: Record "Electronic Document Format";
    begin
        InsertElectronicFormat(
          PEPPOL21_ElectronicFormatTxt,PEPPOL21_ElectronicFormatDescriptionTxt,
          Codeunit::"Export Sales Inv. - PEPPOL 2.1",ElectronicDocumentFormat.Usage::"Sales Invoice");

        InsertElectronicFormat(
          PEPPOL21_ElectronicFormatTxt,PEPPOL21_ElectronicFormatDescriptionTxt,
          Codeunit::"Export Sales Cr.M. - PEPPOL2.1",ElectronicDocumentFormat.Usage::"Sales Credit Memo");

        InsertElectronicFormat(
          PEPPOL21_ElectronicFormatTxt,PEPPOL21_ElectronicFormatDescriptionTxt,
          Codeunit::"Export Serv. Inv. - PEPPOL 2.1",ElectronicDocumentFormat.Usage::"Service Invoice");

        InsertElectronicFormat(
          PEPPOL21_ElectronicFormatTxt,PEPPOL21_ElectronicFormatDescriptionTxt,
          Codeunit::"Exp. Service Cr.M. - PEPPOL2.1",ElectronicDocumentFormat.Usage::"Service Credit Memo");

        InsertElectronicFormat(
          PEPPOL21_ElectronicFormatTxt,PEPPOL21_ElectronicFormatDescriptionTxt,
          Codeunit::"PEPPOL Validation",ElectronicDocumentFormat.Usage::"Sales Validation");

        InsertElectronicFormat(
          PEPPOL21_ElectronicFormatTxt,PEPPOL21_ElectronicFormatDescriptionTxt,
          Codeunit::"PEPPOL Service Validation",ElectronicDocumentFormat.Usage::"Service Validation");

        InsertElectronicFormat(
          PEPPOL20_ElectronicFormatTxt,PEPPOL20_ElectronicFormatDescriptionTxt,
          Codeunit::"Export Sales Inv. - PEPPOL 2.0",ElectronicDocumentFormat.Usage::"Sales Invoice");

        InsertElectronicFormat(
          PEPPOL20_ElectronicFormatTxt,PEPPOL20_ElectronicFormatDescriptionTxt,
          Codeunit::"Export Sales Cr.M. - PEPPOL2.0",ElectronicDocumentFormat.Usage::"Sales Credit Memo");

        InsertElectronicFormat(
          PEPPOL20_ElectronicFormatTxt,PEPPOL20_ElectronicFormatDescriptionTxt,
          Codeunit::"Export Serv. Inv. - PEPPOL 2.0",ElectronicDocumentFormat.Usage::"Service Invoice");

        InsertElectronicFormat(
          PEPPOL20_ElectronicFormatTxt,PEPPOL20_ElectronicFormatDescriptionTxt,
          Codeunit::"Exp. Service Cr.M. - PEPPOL2.0",ElectronicDocumentFormat.Usage::"Service Credit Memo");

        InsertElectronicFormat(
          PEPPOL20_ElectronicFormatTxt,PEPPOL20_ElectronicFormatDescriptionTxt,
          Codeunit::"PEPPOL Validation",ElectronicDocumentFormat.Usage::"Sales Validation");

        InsertElectronicFormat(
          PEPPOL20_ElectronicFormatTxt,PEPPOL20_ElectronicFormatDescriptionTxt,
          Codeunit::"PEPPOL Service Validation",ElectronicDocumentFormat.Usage::"Service Validation");
    end;

    local procedure InsertSourceCode(var SourceCodeDefCode: Code[10];"Code": Code[10];Description: Text[50])
    var
        SourceCode: Record "Source Code";
    begin
        SourceCodeDefCode := Code;
        SourceCode.Init;
        SourceCode.Code := Code;
        SourceCode.Description := Description;
        SourceCode.Insert;
    end;

    local procedure InsertStandardText("Code": Code[20];Description: Text[50])
    var
        StandardText: Record "Standard Text";
    begin
        StandardText.Init;
        StandardText.Code := Code;
        StandardText.Description := Description;
        StandardText.Insert;
    end;

    local procedure InsertRepSelection(ReportUsage: Integer;Sequence: Code[10];ReportID: Integer)
    var
        ReportSelections: Record "Report Selections";
    begin
        ReportSelections.Init;
        ReportSelections.Usage := ReportUsage;
        ReportSelections.Sequence := Sequence;
        ReportSelections."Report ID" := ReportID;
        ReportSelections.Insert;
    end;

    local procedure PageName(PageID: Integer): Text[50]
    var
        ObjectTranslation: Record "Object Translation";
    begin
        exit(CopyStr(ObjectTranslation.TranslateObject(ObjectTranslation."object type"::Page,PageID),1,30));
    end;

    local procedure ReportName(ReportID: Integer): Text[50]
    var
        ObjectTranslation: Record "Object Translation";
    begin
        exit(CopyStr(ObjectTranslation.TranslateObject(ObjectTranslation."object type"::Report,ReportID),1,30));
    end;

    local procedure InsertClientAddIns()
    var
        ClientAddIn: Record "Add-in";
    begin
        InsertClientAddIn(
          'Microsoft.Dynamics.Nav.Client.DynamicsOnlineConnect','31bf3856ad364e35','',
          ClientAddIn.Category::"DotNet Control Add-in",
          'Microsoft Dynamics Online Connect control add-in','');
        InsertClientAddIn(
          'Microsoft.Dynamics.Nav.Client.BusinessChart','31bf3856ad364e35','',
          ClientAddIn.Category::"JavaScript Control Add-in",
          'Microsoft Dynamics BusinessChart control add-in',
          ApplicationPath + 'Add-ins\BusinessChart\Microsoft.Dynamics.Nav.Client.BusinessChart.zip');
        InsertClientAddIn(
          'Microsoft.Dynamics.Nav.Client.TimelineVisualization','31bf3856ad364e35','',
          ClientAddIn.Category::"DotNet Control Add-in",
          'Interactive visualizion for a timeline of events','');
        InsertClientAddIn(
          'Microsoft.Dynamics.Nav.Client.PingPong','31bf3856ad364e35','',
          ClientAddIn.Category::"DotNet Control Add-in",
          'Microsoft Dynamics PingPong control add-in','');
        InsertClientAddIn(
          'Microsoft.Dynamics.Nav.Client.VideoPlayer','31bf3856ad364e35','',
          ClientAddIn.Category::"JavaScript Control Add-in",
          'Microsoft Dynamics VideoPlayer control add-in',
          ApplicationPath + 'Add-ins\VideoPlayer\Microsoft.Dynamics.Nav.Client.VideoPlayer.zip');
        InsertClientAddIn(
          'Microsoft.Dynamics.Nav.Client.PageReady','31bf3856ad364e35','',
          ClientAddIn.Category::"JavaScript Control Add-in",
          'Microsoft Dynamics PageReady control add-in',
          ApplicationPath + 'Add-ins\PageReady\Microsoft.Dynamics.Nav.Client.PageReady.zip');
        InsertClientAddIn(
          'Microsoft.Dynamics.Nav.Client.SocialListening','31bf3856ad364e35','',
          ClientAddIn.Category::"JavaScript Control Add-in",
          'Microsoft Social Listening control add-in',
          ApplicationPath + 'Add-ins\SocialListening\Microsoft.Dynamics.Nav.Client.SocialListening.zip');
        InsertClientAddIn(
          'Microsoft.Dynamics.Nav.Client.WebPageViewer','31bf3856ad364e35','',
          ClientAddIn.Category::"JavaScript Control Add-in",
          'Microsoft Web Page Viewer control add-in',
          ApplicationPath + 'Add-ins\WebPageViewer\Microsoft.Dynamics.Nav.Client.WebPageViewer.zip');
        InsertClientAddIn(
          'Microsoft.Dynamics.Nav.Client.OAuthIntegration','31bf3856ad364e35','',
          ClientAddIn.Category::"JavaScript Control Add-in",
          'Microsoft OAuth Integration control add-in',
          ApplicationPath + 'Add-ins\OAuthIntegration\Microsoft.Dynamics.Nav.Client.OAuthIntegration.zip');
    end;

    local procedure InsertClientAddIn(ControlAddInName: Text[220];PublicKeyToken: Text[20];Version: Text[25];Category: Option;Description: Text[250];ResourceFilePath: Text[250])
    var
        ClientAddIn: Record "Add-in";
    begin
        if ClientAddIn.Get(ControlAddInName,PublicKeyToken,Version) then
          exit;

        ClientAddIn.Init;
        ClientAddIn."Add-in Name" := ControlAddInName;
        ClientAddIn."Public Key Token" := PublicKeyToken;
        ClientAddIn.Version := Version;
        ClientAddIn.Category := Category;
        ClientAddIn.Description := Description;
        if Exists(ResourceFilePath) then
          ClientAddIn.Resource.Import(ResourceFilePath);
        if ClientAddIn.Insert then;
    end;

    local procedure InsertJobWIPMethod("Code": Code[20];Description: Text[50];RecognizedCosts: Option;RecognizedSales: Option;SystemDefinedIndex: Integer)
    var
        JobWIPMethod: Record "Job WIP Method";
    begin
        JobWIPMethod.Init;
        JobWIPMethod.Code := Code;
        JobWIPMethod.Description := Description;
        JobWIPMethod."WIP Cost" := true;
        JobWIPMethod."WIP Sales" := true;
        JobWIPMethod."Recognized Costs" := RecognizedCosts;
        JobWIPMethod."Recognized Sales" := RecognizedSales;
        JobWIPMethod.Valid := true;
        JobWIPMethod."System Defined" := true;
        JobWIPMethod."System-Defined Index" := SystemDefinedIndex;
        JobWIPMethod.Insert;
    end;

    local procedure InsertBankExportImportSetup(CodeTxt: Text[20];NameTxt: Text[100];DirectionOpt: Option;CodeunitID: Integer;XMLPortID: Integer;CheckCodeunitID: Integer)
    var
        BankExportImportSetup: Record "Bank Export/Import Setup";
    begin
        with BankExportImportSetup do begin
          Init;
          Code := CodeTxt;
          Name := NameTxt;
          Direction := DirectionOpt;
          "Processing Codeunit ID" := CodeunitID;
          "Processing XMLport ID" := XMLPortID;
          "Check Export Codeunit" := CheckCodeunitID;
          "Preserve Non-Latin Characters" := false;
          Insert;
        end;
    end;

    local procedure InsertBankClearingStandard(CodeText: Text[50];DescriptionText: Text[80])
    var
        BankClearingStandard: Record "Bank Clearing Standard";
    begin
        with BankClearingStandard do begin
          Init;
          Code := CodeText;
          Description := DescriptionText;
          Insert;
        end;
    end;

    local procedure InsertBankDataConversionPmtType(CodeText: Text[50];DescriptionText: Text[80])
    var
        BankDataConversionPmtType: Record "Bank Data Conversion Pmt. Type";
    begin
        with BankDataConversionPmtType do begin
          Init;
          Code := CodeText;
          Description := DescriptionText;
          Insert;
        end;
    end;

    local procedure InsertElectronicFormat("Code": Code[20];Description: Text[250];CodeunitID: Integer;Usage: Option)
    var
        ElectronicDocumentFormat: Record "Electronic Document Format";
    begin
        if ElectronicDocumentFormat.Get(Code,Usage) then
          exit;

        ElectronicDocumentFormat.Init;
        ElectronicDocumentFormat.Code := Code;
        ElectronicDocumentFormat.Description := Description;
        ElectronicDocumentFormat."Codeunit ID" := CodeunitID;
        ElectronicDocumentFormat.Usage := Usage;
        ElectronicDocumentFormat.Insert;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCompanyInitialize()
    begin
    end;
}

