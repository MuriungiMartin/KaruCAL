#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1643 "Hyperlink Manifest"
{
    TableNo = "Office Add-in";

    trigger OnRun()
    var
        AddinURL: Text;
    begin
        AddInManifestManagement.UploadDefaultManifestText(Rec,ManifestText);
        AddInManifestManagement.SetCommonManifestItems(Rec);
        AddinURL := AddInManifestManagement.ConstructURL(OfficeHostType.OutlookHyperlink,'',Version);
        AddInManifestManagement.SetSourceLocationNodes(Rec,AddinURL,0);
        AddInManifestManagement.SetSourceLocationNodes(Rec,AddinURL,1);

        AddInManifestManagement.RemoveAddInTriggersFromManifest(Rec);
        SetHyperlinkAddinTriggers(Rec);
    end;

    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        PurchasePayablesSetup: Record "Purchases & Payables Setup";
        AddInManifestManagement: Codeunit "Add-in Manifest Management";
        OfficeHostType: dotnet OfficeHostType;
        AddinNameTxt: label 'Document Links';
        AddinDescriptionTxt: label 'Provides a link directly to business documents in %1', Comment='%1 - Application Name';
        ManifestVersionTxt: label '1.1.0.0', Locked=true;
        PurchaseOrderAcronymTxt: label 'PO', Comment='US acronym for Purchase Order';


    procedure SetHyperlinkAddinTriggers(var OfficeAddin: Record "Office Add-in")
    var
        RegExText: Text;
    begin
        // First add the number series rules
        RegExText := AddPrefixesToRegex(GetNoSeriesPrefixes(GetNoSeriesForPostedSalesInvoice),RegExText);
        RegExText := AddPrefixesToRegex(GetNoSeriesPrefixes(GetNoSeriesForPostedSalesCrMemo),RegExText);
        RegExText := AddPrefixesToRegex(GetNoSeriesPrefixes(GetNoSeriesForPostedPurchInvoice),RegExText);
        RegExText := AddPrefixesToRegex(GetNoSeriesPrefixes(GetNoSeriesForPostedPurchCrMemo),RegExText);
        RegExText := AddPrefixesToRegex(GetNoSeriesPrefixes(GetNoSeriesForPurchaseInvoice),RegExText);
        RegExText := AddPrefixesToRegex(GetNoSeriesPrefixes(GetNoSeriesForPurchaseOrder),RegExText);
        RegExText := AddPrefixesToRegex(GetNoSeriesPrefixes(GetNoSeriesForSalesCrMemo),RegExText);
        RegExText := AddPrefixesToRegex(GetNoSeriesPrefixes(GetNoSeriesForSalesInvoice),RegExText);
        RegExText := AddPrefixesToRegex(GetNoSeriesPrefixes(GetNoSeriesForSalesOrder),RegExText);
        RegExText := AddPrefixesToRegex(GetNoSeriesPrefixes(GetNoSeriesForSalesQuote),RegExText);
        RegExText := AddPrefixesToRegex(GetNoSeriesPrefixes(GetNoSeriesForPurchaseQuote),RegExText);
        RegExText := AddPrefixesToRegex(GetNoSeriesPrefixes(GetNoSeriesForPurchaseCrMemo),RegExText);

        // Wrap the prefixes in parenthesis to group them and fill out the rest of the RegEx:
        if RegExText <> '' then begin
          RegExText := StrSubstNo('(%1)([0-9]+)',RegExText);
          AddInManifestManagement.AddRegExRuleNode(OfficeAddin,'No.Series',RegExText);
        end;

        // Now add the text-based rules
        RegExText := 'invoice|order|quote|credit memo';
        RegExText := RegExText + '|' + GetNameForPurchaseInvoice;
        RegExText := RegExText + '|' + GetNameForPurchaseOrder;
        RegExText := RegExText + '|' + GetAcronymForPurchaseOrder;
        RegExText := RegExText + '|' + GetNameForSalesCrMemo;
        RegExText := RegExText + '|' + GetNameForSalesInvoice;
        RegExText := RegExText + '|' + GetNameForSalesOrder;
        RegExText := RegExText + '|' + GetNameForSalesQuote;
        RegExText := RegExText + '|' + GetNameForPurchaseQuote;
        RegExText := RegExText + '|' + GetNameForPurchaseCrMemo;

        RegExText :=
          StrSubstNo('(%1):? ?#?(%2)',RegExText,GetNumberSeriesRegex);
        AddInManifestManagement.AddRegExRuleNode(OfficeAddin,'DocumentTypes',RegExText);
    end;


    procedure GetNoSeriesForPurchaseCrMemo(): Code[20]
    begin
        PurchasePayablesSetup.Get;
        exit(PurchasePayablesSetup."Credit Memo Nos.");
    end;


    procedure GetNoSeriesForPurchaseQuote(): Code[20]
    begin
        PurchasePayablesSetup.Get;
        exit(PurchasePayablesSetup."Quote Nos.");
    end;


    procedure GetNoSeriesForPurchaseInvoice(): Code[20]
    begin
        PurchasePayablesSetup.Get;
        exit(PurchasePayablesSetup."Invoice Nos.");
    end;


    procedure GetNoSeriesForPurchaseOrder(): Code[20]
    begin
        PurchasePayablesSetup.Get;
        exit(PurchasePayablesSetup."Order Nos.");
    end;


    procedure GetNoSeriesForSalesCrMemo(): Code[20]
    begin
        SalesReceivablesSetup.Get;
        exit(SalesReceivablesSetup."Credit Memo Nos.");
    end;


    procedure GetNoSeriesForSalesInvoice(): Code[20]
    begin
        SalesReceivablesSetup.Get;
        exit(SalesReceivablesSetup."Invoice Nos.");
    end;


    procedure GetNoSeriesForSalesOrder(): Code[20]
    begin
        SalesReceivablesSetup.Get;
        exit(SalesReceivablesSetup."Order Nos.");
    end;


    procedure GetNoSeriesForSalesQuote(): Code[20]
    begin
        SalesReceivablesSetup.Get;
        exit(SalesReceivablesSetup."Quote Nos.");
    end;


    procedure GetNoSeriesForPostedSalesInvoice(): Code[20]
    begin
        SalesReceivablesSetup.Get;
        exit(SalesReceivablesSetup."Posted Invoice Nos.");
    end;


    procedure GetNoSeriesForPostedSalesCrMemo(): Code[20]
    begin
        SalesReceivablesSetup.Get;
        exit(SalesReceivablesSetup."Posted Credit Memo Nos.");
    end;


    procedure GetNoSeriesForPostedPurchInvoice(): Code[20]
    begin
        PurchasePayablesSetup.Get;
        exit(PurchasePayablesSetup."Posted Invoice Nos.");
    end;


    procedure GetNoSeriesForPostedPurchCrMemo(): Code[20]
    begin
        PurchasePayablesSetup.Get;
        exit(PurchasePayablesSetup."Posted Credit Memo Nos.");
    end;


    procedure GetPrefixForNoSeriesLine(var NoSeriesLine: Record "No. Series Line"): Code[20]
    var
        NumericRegEx: dotnet Regex;
        RegExMatches: dotnet MatchCollection;
        SeriesStartNo: Code[20];
        MatchText: Text;
        LowerMatchBound: Integer;
    begin
        SeriesStartNo := NoSeriesLine."Starting No.";

        // Ensure that we have a non-numeric 'prefix' before the numbers and that we capture the last number group.
        // This ensures that we can generate a specific RegEx and not match all number sequences.

        NumericRegEx := NumericRegEx.Regex('[\p{Lu}\p{Lt}\p{Lo}\p{Lm}\p{Pc}' + RegExEscape('\_/#*+|-') + ']([0-9]+)$');
        RegExMatches := NumericRegEx.Matches(SeriesStartNo);

        // If we don't have a match, then the code is unusable for a RegEx as a number series
        if RegExMatches.Count = 0 then
          exit('');

        MatchText := RegExMatches.Item(RegExMatches.Count - 1).Groups.Item(1).Value; // Get the number group from the match.
        LowerMatchBound := RegExMatches.Item(RegExMatches.Count - 1).Groups.Item(1).Index + 1 ; // Get the index of the group, adjust indexing for NAV.

        // Remove the number match - leaving only the prefix
        SeriesStartNo := DelStr(SeriesStartNo,LowerMatchBound,StrLen(MatchText));

        exit(SeriesStartNo);
    end;


    procedure GetNoSeriesPrefixes(NoSeriesCode: Code[20]): Text
    var
        NoSeriesLine: Record "No. Series Line";
        NewPrefix: Text;
        Prefixes: Text;
    begin
        // For the given series code - get the prefix for each line
        NoSeriesLine.SetRange("Series Code",NoSeriesCode);
        if NoSeriesLine.Find('-') then
          repeat
            NewPrefix := GetPrefixForNoSeriesLine(NoSeriesLine);
            if NewPrefix <> '' then
              if Prefixes = '' then
                Prefixes := RegExEscape(NewPrefix)
              else
                Prefixes := StrSubstNo('%1|%2',Prefixes,RegExEscape(NewPrefix));
          until NoSeriesLine.Next = 0;

        exit(Prefixes);
    end;

    local procedure AddPrefixesToRegex(Prefixes: Text;RegExText: Text): Text
    begin
        // Handles some logic around concatenating the prefixes together in a regex string
        if Prefixes <> '' then
          if RegExText = '' then
            RegExText := Prefixes
          else
            RegExText := StrSubstNo('%1|%2',RegExText,Prefixes);
        exit(RegExText);
    end;


    procedure GetNameForPurchaseCrMemo(): Text
    var
        PurchaseCreditMemo: Page "Purchase Credit Memo";
    begin
        exit(PurchaseCreditMemo.Caption);
    end;


    procedure GetNameForPurchaseInvoice(): Text
    var
        PurchaseInvoice: Page "Purchase Invoice";
    begin
        exit(PurchaseInvoice.Caption);
    end;


    procedure GetNameForPurchaseOrder(): Text
    var
        PurchaseOrder: Page "Purchase Order";
    begin
        exit(PurchaseOrder.Caption);
    end;


    procedure GetAcronymForPurchaseOrder(): Text
    begin
        exit(PurchaseOrderAcronymTxt);
    end;


    procedure GetNameForPurchaseQuote(): Text
    var
        PurchaseQuote: Page "Purchase Quote";
    begin
        exit(PurchaseQuote.Caption);
    end;


    procedure GetNameForSalesCrMemo(): Text
    var
        SalesCreditMemo: Page "Sales Credit Memo";
    begin
        exit(SalesCreditMemo.Caption);
    end;


    procedure GetNameForSalesInvoice(): Text
    var
        SalesInvoice: Page "Sales Invoice";
    begin
        exit(SalesInvoice.Caption);
    end;


    procedure GetNameForSalesOrder(): Text
    var
        SalesOrder: Page "Sales Order";
    begin
        exit(SalesOrder.Caption);
    end;


    procedure GetNameForSalesQuote(): Text
    var
        SalesQuote: Page "Sales Quote";
    begin
        exit(SalesQuote.Caption);
    end;


    procedure GetNameForPostedSalesInvoice(): Text
    var
        PostedSalesInvoices: Page "Posted Sales Invoices";
    begin
        exit(PostedSalesInvoices.Caption);
    end;


    procedure GetNameForPostedSalesCrMemo(): Text
    var
        PostedSalesCreditMemos: Page "Posted Sales Credit Memos";
    begin
        exit(PostedSalesCreditMemos.Caption);
    end;


    procedure GetNameForPostedPurchInvoice(): Text
    var
        PostedPurchaseInvoices: Page "Posted Purchase Invoices";
    begin
        exit(PostedPurchaseInvoices.Caption);
    end;


    procedure GetNameForPostedPurchCrMemo(): Text
    var
        PostedPurchaseCreditMemos: Page "Posted Purchase Credit Memos";
    begin
        exit(PostedPurchaseCreditMemos.Caption);
    end;

    local procedure RegExEscape(RegExText: Text): Text
    var
        RegEx: dotnet Regex;
    begin
        // Function to escape some special characters in a regular expression character class:
        exit(RegEx.Escape(RegExText));
    end;


    procedure GetNumberSeriesRegex(): Text
    begin
        exit(StrSubstNo('[\w%1]*[0-9]+',RegExEscape('_/#*+\|-')));
    end;


    procedure ManifestText() Value: Text
    begin
        Value :=
          '<?xml version="1.0" encoding="utf-8"?>' +
          '<!--Created:cbbc9d22-5cf7-4e4c-8ee9-42a772aae58a-->' +
          '<OfficeApp xsi:type="MailApp" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' +
          ' xmlns="http://schemas.microsoft.com/office/appforoffice/1.1">' +
          '  <Id>cf6f2e6a-5f76-4a17-b966-2ed9d0b3e88a</Id>' +
          '  <Version>' + ManifestVersionTxt + '</Version>' +
          '  <ProviderName>Microsoft</ProviderName>' +
          '  <DefaultLocale>en-US</DefaultLocale>' +
          '  <DisplayName DefaultValue="' + AddinNameTxt + '" />' +
          '  <Description DefaultValue="' +
          StrSubstNo(AddinDescriptionTxt,AddInManifestManagement.XMLEncode(ProductName.Short)) + '" />' +
          '  <IconUrl DefaultValue="WEBCLIENTLOCATION/Resources/Images/OfficeAddinLogo.png"/>' +
          '  <HighResolutionIconUrl DefaultValue="WEBCLIENTLOCATION/Resources/Images/OfficeAddinLogoHigh.png"/>' +
          '  <AppDomains>' +
          '    <AppDomain>WEBCLIENTLOCATION</AppDomain>' +
          '  </AppDomains>' +
          '  <Hosts>' +
          '    <Host Name="Mailbox" />' +
          '  </Hosts>' +
          '  <Requirements>' +
          '    <Sets>' +
          '      <Set Name="MailBox" MinVersion="1.1" />' +
          '    </Sets>' +
          '  </Requirements>' +
          '  <FormSettings>' +
          '    <Form xsi:type="ItemRead">' +
          '      <DesktopSettings>' +
          '        <SourceLocation DefaultValue="" />' +
          '        <RequestedHeight>300</RequestedHeight>' +
          '      </DesktopSettings>' +
          '      <TabletSettings>' +
          '        <SourceLocation DefaultValue="" />' +
          '        <RequestedHeight>300</RequestedHeight>' +
          '      </TabletSettings>' +
          '      <PhoneSettings>' +
          '        <SourceLocation DefaultValue="" />' +
          '      </PhoneSettings>' +
          '    </Form>' +
          '    <Form xsi:type="ItemEdit">' +
          '      <DesktopSettings>' +
          '        <SourceLocation DefaultValue="" />' +
          '      </DesktopSettings>' +
          '      <TabletSettings>' +
          '        <SourceLocation DefaultValue="" />' +
          '      </TabletSettings>' +
          '      <PhoneSettings>' +
          '        <SourceLocation DefaultValue="" />' +
          '      </PhoneSettings>' +
          '    </Form>' +
          '  </FormSettings>' +
          '  <Permissions>ReadWriteItem</Permissions>' +
          '  <Rule xsi:type="RuleCollection" Mode="And">' +
          '    <Rule xsi:type="RuleCollection" Mode="Or">' +
          '      <!-- To add more complex rules, add additional rule elements -->' +
          '      <!-- E.g. To activate when a message contains an address -->' +
          '      <!-- <Rule xsi:type="ItemHasKnownEntity" EntityType="Address" /> -->' +
          '    </Rule>' +
          '    <Rule xsi:type="RuleCollection" Mode="Or">' +
          '      <Rule xsi:type="ItemIs" FormType="Edit" ItemType="Message" />' +
          '      <Rule xsi:type="ItemIs" FormType="Read" ItemType="Message" />' +
          '    </Rule>' +
          '' +
          '  </Rule>' +
          '</OfficeApp>';
    end;
}

