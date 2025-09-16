#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1642 "Intelligent Info Manifest"
{
    TableNo = "Office Add-in";

    trigger OnRun()
    begin
        AddinManifestManagement.UploadDefaultManifestText(Rec,ManifestText);
        AddinManifestManagement.SetCommonManifestItems(Rec);
        SetupUrl(Rec);
        SetupResourceImages(Rec);
        SetupResourceUrls(Rec);
        SetupResourceStrings(Rec);
        AddinManifestManagement.RemovePrefix(Rec);
    end;

    var
        AddinManifestManagement: Codeunit "Add-in Manifest Management";
        OpenPaneButtonTxt: label 'Contact Insights', Comment='Shows more information about the contact';
        OpenPaneButtonTooltipTxt: label 'Opens a more detailed view of the contact in %1.', Comment='%1 = Application name';
        OpenPaneSuperTipTxt: label 'Open %1 in Outlook', Comment='%1 = Application name';
        OpenPaneSuperTipDescriptionTxt: label 'Opens a more detailed view of the customer or vendor in %1.', Comment='%1 = Application name';
        NewMenuButtonTxt: label 'New';
        NewMenuButtonTooltipTxt: label 'Creates a new document in %1.', Comment='%1 = Application name';
        NewMenuSuperTipTxt: label 'Create a new document in %1', Comment='%1 = Application name';
        NewMenuSuperTipDescriptionTxt: label 'Creates a new document for the selected customer or vendor in %1.', Comment='%1 = Application name';
        NewDocButtonTooltipTxt: label 'Creates a new %1 in %2.', Comment='%1 = document type (sales quote, purchase credit memo, etc.); %2 = Application name';
        NewDocSuperTipTxt: label 'Create new %1', Comment='%1 = document type (sales quote, purchase credit memo, etc.)';
        NewDocSuperTipDescTxt: label 'Creates a new %1 for this contact in %2.', Comment='%1 = document type (sales quote, purchase credit memo, etc.); %2 = Application name';
        AddinDescriptionTxt: label 'Provides customer/vendor information directly within Outlook messages.';
        ManifestVersionTxt: label '1.2.0.0', Locked=true;
        PermissionManager: Codeunit "Permission Manager";
        BrandingFolderTxt: label 'ProjectMadeira/', Locked=true;

    local procedure SetupUrl(var OfficeAddin: Record "Office Add-in")
    var
        OfficeHostType: dotnet OfficeHostType;
        AddinURL: Text;
    begin
        AddinURL := AddinManifestManagement.ConstructURL(OfficeHostType.OutlookItemRead,'',OfficeAddin.Version);
        AddinManifestManagement.SetSourceLocationNodes(OfficeAddin,AddinURL,0);

        AddinURL := AddinManifestManagement.ConstructURL(OfficeHostType.OutlookItemEdit,'',OfficeAddin.Version);
        AddinManifestManagement.SetSourceLocationNodes(OfficeAddin,AddinURL,1);
    end;

    local procedure SetupResourceImages(var OfficeAddin: Record "Office Add-in")
    begin
        with AddinManifestManagement do begin
          if PermissionManager.SoftwareAsAService then begin
            SetNodeResource(OfficeAddin,'nav-icon-16',BrandingFolderTxt + 'Dyn365_16xPos.png',0);
            SetNodeResource(OfficeAddin,'nav-icon-32',BrandingFolderTxt + 'Dyn365_32xPos.png',0);
            SetNodeResource(OfficeAddin,'nav-icon-80',BrandingFolderTxt + 'Dyn365_80x.png',0);
          end else begin
            SetNodeResource(OfficeAddin,'nav-icon-16','Dynamics-16x.png',0);
            SetNodeResource(OfficeAddin,'nav-icon-32','Dynamics-32x.png',0);
            SetNodeResource(OfficeAddin,'nav-icon-80','OfficeAddinLogoHigh.png',0);
          end;
          SetNodeResource(OfficeAddin,'new-document-16','NewDocument_16x16.png',0);
          SetNodeResource(OfficeAddin,'new-document-32','NewDocument_32x32.png',0);
          SetNodeResource(OfficeAddin,'new-document-80','NewDocument_80x80.png',0);

          SetNodeResource(OfficeAddin,'quote-16','Quote_16x16.png',0);
          SetNodeResource(OfficeAddin,'quote-32','Quote_32x32.png',0);
          SetNodeResource(OfficeAddin,'quote-80','Quote_80x80.png',0);

          SetNodeResource(OfficeAddin,'order-16','Order_16x16.png',0);
          SetNodeResource(OfficeAddin,'order-32','Order_32x32.png',0);
          SetNodeResource(OfficeAddin,'order-80','Order_80x80.png',0);

          SetNodeResource(OfficeAddin,'sales-invoice-16','SalesInvoice_16.png',0);
          SetNodeResource(OfficeAddin,'sales-invoice-32','SalesInvoice_32.png',0);
          SetNodeResource(OfficeAddin,'sales-invoice-80','SalesInvoice_80.png',0);

          SetNodeResource(OfficeAddin,'sales-credit-memo-16','SalesCreditMemo_16.png',0);
          SetNodeResource(OfficeAddin,'sales-credit-memo-32','SalesCreditMemo_32.png',0);
          SetNodeResource(OfficeAddin,'sales-credit-memo-80','SalesCreditMemo_80.png',0);

          SetNodeResource(OfficeAddin,'purchase-invoice-16','PurchaseInvoice_16.png',0);
          SetNodeResource(OfficeAddin,'purchase-invoice-32','PurchaseInvoice_32.png',0);
          SetNodeResource(OfficeAddin,'purchase-invoice-80','PurchaseInvoice_80.png',0);

          SetNodeResource(OfficeAddin,'purchase-credit-memo-16','PurchaseCreditMemo_16.png',0);
          SetNodeResource(OfficeAddin,'purchase-credit-memo-32','PurchaseCreditMemo_32.png',0);
          SetNodeResource(OfficeAddin,'purchase-credit-memo-80','PurchaseCreditMemo_80.png',0);
        end;
    end;

    local procedure SetupResourceUrls(var OfficeAddin: Record "Office Add-in")
    var
        Command: dotnet OutlookCommand;
    begin
        with AddinManifestManagement do begin
          SetNodeResource(OfficeAddin,'taskPaneUrl','',1);
          SetNodeResource(OfficeAddin,'newSalesQuoteUrl',Command.NewSalesQuote,1);
          SetNodeResource(OfficeAddin,'newSalesOrderUrl',Command.NewSalesOrder,1);
          SetNodeResource(OfficeAddin,'newSalesInvoiceUrl',Command.NewSalesInvoice,1);
          SetNodeResource(OfficeAddin,'newSalesCreditMemoUrl',Command.NewSalesCreditMemo,1);
          SetNodeResource(OfficeAddin,'newPurchaseInvoiceUrl',Command.NewPurchaseInvoice,1);
          SetNodeResource(OfficeAddin,'newPurchaseCrMemoUrl',Command.NewPurchaseCreditMemo,1);
          SetNodeResource(OfficeAddin,'newPurchaseOrderUrl',Command.NewPurchaseOrder,1);
        end;
    end;

    local procedure SetupResourceStrings(var OfficeAddin: Record "Office Add-in")
    var
        TypeIndex: Integer;
    begin
        with AddinManifestManagement do begin
          SetNodeResource(OfficeAddin,'groupLabel',ProductName.Short,2);
          SetNodeResource(OfficeAddin,'groupTooltip',ProductName.Short,3);
          SetNodeResource(OfficeAddin,'openPaneButtonLabel',OpenPaneButtonTxt,2);
          SetNodeResource(OfficeAddin,'openPaneSuperTipTitle',StrSubstNo(OpenPaneSuperTipTxt,ProductName.Short),2);
          SetNodeResource(OfficeAddin,'openPaneButtonTooltip',StrSubstNo(OpenPaneButtonTooltipTxt,ProductName.Short),3);
          SetNodeResource(OfficeAddin,'openPaneSuperTipDesc',StrSubstNo(OpenPaneSuperTipDescriptionTxt,ProductName.Short),3);

          SetNodeResource(OfficeAddin,'newMenuButtonLabel',NewMenuButtonTxt,2);
          SetNodeResource(OfficeAddin,'newMenuSuperTipTitle',StrSubstNo(NewMenuSuperTipTxt,ProductName.Short),2);
          SetNodeResource(OfficeAddin,'newMenuButtonTooltip',StrSubstNo(NewMenuButtonTooltipTxt,ProductName.Short),3);
          SetNodeResource(OfficeAddin,'newMenuSuperTipDesc',StrSubstNo(NewMenuSuperTipDescriptionTxt,ProductName.Short),3);

          for TypeIndex := 0 to 6 do begin
            SetNodeResource(OfficeAddin,ResourceId('new%1Label',TypeIndex),GetDocType(TypeIndex),2);
            SetNodeResource(OfficeAddin,ResourceId('new%1SuperTipTitle',TypeIndex),ResourceValue(NewDocSuperTipTxt,TypeIndex),2);
            SetNodeResource(OfficeAddin,ResourceId('new%1Tip',TypeIndex),ResourceValue(NewDocButtonTooltipTxt,TypeIndex),3);
            SetNodeResource(OfficeAddin,ResourceId('new%1SuperTipDesc',TypeIndex),ResourceValue(NewDocSuperTipDescTxt,TypeIndex),3);
          end;
        end;
    end;

    local procedure GetDocType(TypeIndex: Integer) DocType: Text
    var
        HyperlinkManifest: Codeunit "Hyperlink Manifest";
    begin
        case TypeIndex of
          0:
            DocType := HyperlinkManifest.GetNameForSalesQuote;
          1:
            DocType := HyperlinkManifest.GetNameForSalesOrder;
          2:
            DocType := HyperlinkManifest.GetNameForSalesInvoice;
          3:
            DocType := HyperlinkManifest.GetNameForSalesCrMemo;
          4:
            DocType := HyperlinkManifest.GetNameForPurchaseInvoice;
          5:
            DocType := HyperlinkManifest.GetNameForPurchaseCrMemo;
          6:
            DocType := HyperlinkManifest.GetNameForPurchaseOrder;
        end;
    end;

    local procedure ResourceId(BaseText: Text;TypeIndex: Integer) ResourceId: Text[32]
    var
        DocType: Text;
    begin
        case TypeIndex of
          0:
            DocType := 'SalesQuote';
          1:
            DocType := 'SalesOrder';
          2:
            DocType := 'SalesInvoice';
          3:
            DocType := 'SalesCreditMemo';
          4:
            DocType := 'PurchaseInvoice';
          5:
            DocType := 'PurchaseCrMemo';
          6:
            DocType := 'PurchaseOrder';
        end;

        ResourceId := CopyStr(StrSubstNo(BaseText,DocType),1,32);
    end;

    local procedure ResourceValue(BaseText: Text;TypeIndex: Integer) ResourceValue: Text
    var
        DocType: Text;
    begin
        DocType := GetDocType(TypeIndex);
        ResourceValue := StrSubstNo(BaseText,Lowercase(DocType),ProductName.Short);
    end;


    procedure ManifestText() Value: Text
    begin
        Value :=
          '<?xml version="1.0" encoding="utf-8"?>' +
          '<!--Created:cbbc9d22-5cf7-4e4c-8ee9-42a772aae58a-->' +
          '<OfficeApp' +
          '  xmlns="http://schemas.microsoft.com/office/appforoffice/1.1"' +
          '  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' +
          '  xmlns:bt="http://schemas.microsoft.com/office/officeappbasictypes/1.0"' +
          '  xmlns:mailappor="http://schemas.microsoft.com/office/mailappversionoverrides/1.0"' +
          '  xsi:type="MailApp">' +
          '  <Id>cfca30bd-9846-4819-a6fc-56c89c5aae96</Id>' +
          '  <Version>' + ManifestVersionTxt + '</Version>' +
          '  <ProviderName>Microsoft</ProviderName>' +
          '  <DefaultLocale>en-US</DefaultLocale>' +
          '  <DisplayName DefaultValue="' + AddinManifestManagement.XMLEncode(ProductName.Short) + '" />' +
          '  <Description DefaultValue="' + AddinDescriptionTxt + '" />' +
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
          '        <RequestedHeight>400</RequestedHeight>' +
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
          '  <Permissions>ReadWriteMailbox</Permissions>' +
          '  <Rule xsi:type="RuleCollection" Mode="Or">' +
          '    <Rule xsi:type="ItemIs" ItemType="Message" FormType="Edit" />' +
          '    <Rule xsi:type="ItemIs" ItemType="Message" FormType="Read" />' +
          '    <Rule xsi:type="ItemIs" ItemType="Appointment" FormType="Edit" />' +
          '    <Rule xsi:type="ItemIs" ItemType="Appointment" FormType="Read" />' +
          '  </Rule>' +
          '' +
          '  <vOverrides:VersionOverrides xmlns:vOverrides="http://schemas.microsoft.com/office/mailappversionoverrides"' +
          ' xsi:type="VersionOverridesV1_0">' +
          '    <Requirements>' +
          '      <bt:Sets DefaultMinVersion="1.3">' +
          '        <bt:Set Name="Mailbox" />' +
          '      </bt:Sets>' +
          '    </Requirements>' +
          '    <Hosts>' +
          '      <Host xsi:type="MailHost">' +
          '        <DesktopFormFactor>' +
          '          <!-- Custom pane, only applies to read form -->' +
          '          <ExtensionPoint xsi:type="CustomPane">' +
          '            <RequestedHeight>300</RequestedHeight>' +
          '            <SourceLocation resid="taskPaneUrl"/>' +
          '            <!-- Change this Mode to Or to enable the custom pane -->' +
          '            <Rule xsi:type="RuleCollection" Mode="And">' +
          '              <Rule xsi:type="ItemIs" ItemType="Message"/>' +
          '              <Rule xsi:type="ItemIs" ItemType="AppointmentAttendee"/>' +
          '            </Rule>' +
          '          </ExtensionPoint>' +
          '' +
          '          <!-- Message read form -->' +
          '          <ExtensionPoint xsi:type="MessageReadCommandSurface">' +
          '            <OfficeTab id="TabDefault">' +
          '              <Group id="msgReadGroup">' +
          '                <Label resid="groupLabel" />' +
          '                <Tooltip resid="groupTooltip" />' +
          '' +
          '                <!-- Task pane button -->' +
          '                <Control xsi:type="Button" id="msgReadOpenPaneButton">' +
          '                  <Label resid="openPaneButtonLabel" />' +
          '                  <Tooltip resid="openPaneButtonTooltip" />' +
          '                  <Supertip>' +
          '                    <Title resid="openPaneSuperTipTitle" />' +
          '                    <Description resid="openPaneSuperTipDesc" />' +
          '                  </Supertip>' +
          '                  <Icon>' +
          '                    <bt:Image size="16" resid="nav-icon-16" />' +
          '                    <bt:Image size="32" resid="nav-icon-32" />' +
          '                    <bt:Image size="80" resid="nav-icon-80" />' +
          '                  </Icon>' +
          '                  <Action xsi:type="ShowTaskpane">' +
          '                    <SourceLocation resid="taskPaneUrl" />' +
          '                  </Action>' +
          '                </Control>' +
          '' +
          '                <!-- Menu (dropdown) button -->' +
          '                <Control xsi:type="Menu" id="newMenuReadButton">' +
          '                  <Label resid="newMenuButtonLabel" />' +
          '                  <Tooltip resid="newMenuButtonTooltip" />' +
          '                  <Supertip>' +
          '                    <Title resid="newMenuSuperTipTitle" />' +
          '                    <Description resid="newMenuSuperTipDesc" />' +
          '                  </Supertip>' +
          '                  <Icon>' +
          '                    <bt:Image size="16" resid="new-document-16" />' +
          '                    <bt:Image size="32" resid="new-document-32" />' +
          '                    <bt:Image size="80" resid="new-document-80" />' +
          '                  </Icon>' +
          '                  <Items>' +
          '                    <Item id="newMenuReadItem1">' +
          '                      <Label resid="newSalesQuoteLabel" />' +
          '                      <Tooltip resid="newSalesQuoteTip" />' +
          '                      <Supertip>' +
          '                        <Title resid="newSalesQuoteSuperTipTitle" />' +
          '                        <Description resid="newSalesQuoteSuperTipDesc" />' +
          '                      </Supertip>' +
          '                      <Icon>' +
          '                        <bt:Image size="16" resid="quote-16" />' +
          '                        <bt:Image size="32" resid="quote-32" />' +
          '                        <bt:Image size="80" resid="quote-80" />' +
          '                      </Icon>' +
          '                      <Action xsi:type="ShowTaskpane">' +
          '                        <SourceLocation resid="newSalesQuoteUrl" />' +
          '                      </Action>' +
          '                    </Item>' +
          '                    <Item id="newMenuReadItem2">' +
          '                      <Label resid="newSalesInvoiceLabel" />' +
          '                      <Tooltip resid="newSalesInvoiceTip" />' +
          '                      <Supertip>' +
          '                        <Title resid="newSalesInvoiceSuperTipTitle" />' +
          '                        <Description resid="newSalesInvoiceSuperTipDesc" />' +
          '                      </Supertip>' +
          '                      <Icon>' +
          '                        <bt:Image size="16" resid="sales-invoice-16" />' +
          '                        <bt:Image size="32" resid="sales-invoice-32" />' +
          '                        <bt:Image size="80" resid="sales-invoice-80" />' +
          '                      </Icon>' +
          '                      <Action xsi:type="ShowTaskpane">' +
          '                        <SourceLocation resid="newSalesInvoiceUrl" />' +
          '                      </Action>' +
          '                    </Item>' +
          '                    <Item id="newMenuReadItem3">' +
          '                      <Label resid="newSalesOrderLabel" />' +
          '                      <Tooltip resid="newSalesOrderTip" />' +
          '                      <Supertip>' +
          '                        <Title resid="newSalesOrderSuperTipTitle" />' +
          '                        <Description resid="newSalesOrderSuperTipDesc" />' +
          '                      </Supertip>' +
          '                      <Icon>' +
          '                        <bt:Image size="16" resid="order-16" />' +
          '                        <bt:Image size="32" resid="order-32" />' +
          '                        <bt:Image size="80" resid="order-80" />' +
          '                      </Icon>' +
          '                      <Action xsi:type="ShowTaskpane">' +
          '                        <SourceLocation resid="newSalesOrderUrl" />' +
          '                      </Action>' +
          '                    </Item>' +
          '                    <Item id="newMenuReadItem4">' +
          '                      <Label resid="newSalesCreditMemoLabel" />' +
          '                      <Tooltip resid="newSalesCreditMemoTip" />' +
          '                      <Supertip>' +
          '                        <Title resid="newSalesCreditMemoSuperTipTitle" />' +
          '                        <Description resid="newSalesCreditMemoSuperTipDesc" />' +
          '                      </Supertip>' +
          '                      <Icon>' +
          '                        <bt:Image size="16" resid="sales-credit-memo-16" />' +
          '                        <bt:Image size="32" resid="sales-credit-memo-32" />' +
          '                        <bt:Image size="80" resid="sales-credit-memo-80" />' +
          '                      </Icon>' +
          '                      <Action xsi:type="ShowTaskpane">' +
          '                        <SourceLocation resid="newSalesCreditMemoUrl" />' +
          '                      </Action>' +
          '                    </Item>' +
          '                    <Item id="newMenuReadItem5">' +
          '                      <Label resid="newPurchaseInvoiceLabel" />' +
          '                      <Tooltip resid="newPurchaseInvoiceTip" />' +
          '                      <Supertip>' +
          '                        <Title resid="newPurchaseInvoiceSuperTipTitle" />' +
          '                        <Description resid="newPurchaseInvoiceSuperTipDesc" />' +
          '                      </Supertip>' +
          '                      <Icon>' +
          '                        <bt:Image size="16" resid="purchase-invoice-16" />' +
          '                        <bt:Image size="32" resid="purchase-invoice-32" />' +
          '                        <bt:Image size="80" resid="purchase-invoice-80" />' +
          '                      </Icon>' +
          '                      <Action xsi:type="ShowTaskpane">' +
          '                        <SourceLocation resid="newPurchaseInvoiceUrl" />' +
          '                      </Action>' +
          '                    </Item>' +
          '                    <Item id="newMenuReadItem6">' +
          '                      <Label resid="newPurchaseCrMemoLabel" />' +
          '                      <Tooltip resid="newPurchaseCrMemoTip" />' +
          '                      <Supertip>' +
          '                        <Title resid="newPurchaseCrMemoSuperTipTitle" />' +
          '                        <Description resid="newPurchaseCrMemoSuperTipDesc" />' +
          '                      </Supertip>' +
          '                      <Icon>' +
          '                        <bt:Image size="16" resid="purchase-credit-memo-16" />' +
          '                        <bt:Image size="32" resid="purchase-credit-memo-32" />' +
          '                        <bt:Image size="80" resid="purchase-credit-memo-80" />' +
          '                      </Icon>' +
          '                      <Action xsi:type="ShowTaskpane">' +
          '                        <SourceLocation resid="newPurchaseCrMemoUrl" />' +
          '                      </Action>' +
          '                    </Item>' +
          '                    <Item id="newMenuReadItem7">' +
          '                      <Label resid="newPurchaseOrderLabel" />' +
          '                      <Tooltip resid="newPurchaseOrderTip" />' +
          '                      <Supertip>' +
          '                        <Title resid="newPurchaseOrderSuperTipTitle" />' +
          '                        <Description resid="newPurchaseOrderSuperTipDesc" />' +
          '                      </Supertip>' +
          '                      <Icon>' +
          '                        <bt:Image size="16" resid="order-16" />' +
          '                        <bt:Image size="32" resid="order-32" />' +
          '                        <bt:Image size="80" resid="order-80" />' +
          '                      </Icon>' +
          '                      <Action xsi:type="ShowTaskpane">' +
          '                        <SourceLocation resid="newPurchaseOrderUrl" />' +
          '                      </Action>' +
          '                    </Item>' +
          '                  </Items>' +
          '                </Control>' +
          '              </Group>' +
          '            </OfficeTab>' +
          '          </ExtensionPoint>' +
          '' +
          '          <!-- Message compose form -->' +
          '          <ExtensionPoint xsi:type="MessageComposeCommandSurface">' +
          '            <OfficeTab id="TabDefault">' +
          '              <Group id="msgComposeGroup">' +
          '                <Label resid="groupLabel" />' +
          '                <Tooltip resid="groupTooltip" />' +
          '' +
          '                <!-- Task pane button -->' +
          '                <Control xsi:type="Button" id="msgComposeOpenPaneButton">' +
          '                  <Label resid="openPaneButtonLabel" />' +
          '                  <Tooltip resid="openPaneButtonTooltip" />' +
          '                  <Supertip>' +
          '                    <Title resid="openPaneSuperTipTitle" />' +
          '                    <Description resid="openPaneSuperTipDesc" />' +
          '                  </Supertip>' +
          '                  <Icon>' +
          '                    <bt:Image size="16" resid="nav-icon-16" />' +
          '                    <bt:Image size="32" resid="nav-icon-32" />' +
          '                    <bt:Image size="80" resid="nav-icon-80" />' +
          '                  </Icon>' +
          '                  <Action xsi:type="ShowTaskpane">' +
          '                    <SourceLocation resid="taskPaneUrl" />' +
          '                  </Action>' +
          '                </Control>' +
          '' +
          '                <!-- Menu (dropdown) button -->' +
          '                <Control xsi:type="Menu" id="newMenuComposeButton">' +
          '                  <Label resid="newMenuButtonLabel" />' +
          '                  <Tooltip resid="newMenuButtonTooltip" />' +
          '                  <Supertip>' +
          '                    <Title resid="newMenuSuperTipTitle" />' +
          '                    <Description resid="newMenuSuperTipDesc" />' +
          '                  </Supertip>' +
          '                  <Icon>' +
          '                    <bt:Image size="16" resid="new-document-16" />' +
          '                    <bt:Image size="32" resid="new-document-32" />' +
          '                    <bt:Image size="80" resid="new-document-80" />' +
          '                  </Icon>' +
          '                  <Items>' +
          '                    <Item id="newMenuComposeItem1">' +
          '                      <Label resid="newSalesQuoteLabel" />' +
          '                      <Tooltip resid="newSalesQuoteTip" />' +
          '                      <Supertip>' +
          '                        <Title resid="newSalesQuoteSuperTipTitle" />' +
          '                        <Description resid="newSalesQuoteSuperTipDesc" />' +
          '                      </Supertip>' +
          '                      <Icon>' +
          '                        <bt:Image size="16" resid="quote-16" />' +
          '                        <bt:Image size="32" resid="quote-32" />' +
          '                        <bt:Image size="80" resid="quote-80" />' +
          '                      </Icon>' +
          '                      <Action xsi:type="ShowTaskpane">' +
          '                        <SourceLocation resid="newSalesQuoteUrl" />' +
          '                      </Action>' +
          '                    </Item>' +
          '                    <Item id="newMenuComposeItem2">' +
          '                      <Label resid="newSalesInvoiceLabel" />' +
          '                      <Tooltip resid="newSalesInvoiceTip" />' +
          '                      <Supertip>' +
          '                        <Title resid="newSalesInvoiceSuperTipTitle" />' +
          '                        <Description resid="newSalesInvoiceSuperTipDesc" />' +
          '                      </Supertip>' +
          '                      <Icon>' +
          '                        <bt:Image size="16" resid="sales-invoice-16" />' +
          '                        <bt:Image size="32" resid="sales-invoice-32" />' +
          '                        <bt:Image size="80" resid="sales-invoice-80" />' +
          '                      </Icon>' +
          '                      <Action xsi:type="ShowTaskpane">' +
          '                        <SourceLocation resid="newSalesInvoiceUrl" />' +
          '                      </Action>' +
          '                    </Item>' +
          '                    <Item id="newMenuComposeItem3">' +
          '                      <Label resid="newSalesOrderLabel" />' +
          '                      <Tooltip resid="newSalesOrderTip" />' +
          '                      <Supertip>' +
          '                        <Title resid="newSalesOrderSuperTipTitle" />' +
          '                        <Description resid="newSalesOrderSuperTipDesc" />' +
          '                      </Supertip>' +
          '                      <Icon>' +
          '                        <bt:Image size="16" resid="order-16" />' +
          '                        <bt:Image size="32" resid="order-32" />' +
          '                        <bt:Image size="80" resid="order-80" />' +
          '                      </Icon>' +
          '                      <Action xsi:type="ShowTaskpane">' +
          '                        <SourceLocation resid="newSalesOrderUrl" />' +
          '                      </Action>' +
          '                    </Item>' +
          '                    <Item id="newMenuComposeItem4">' +
          '                      <Label resid="newSalesCreditMemoLabel" />' +
          '                      <Tooltip resid="newSalesCreditMemoTip" />' +
          '                      <Supertip>' +
          '                        <Title resid="newSalesCreditMemoSuperTipTitle" />' +
          '                        <Description resid="newSalesCreditMemoSuperTipDesc" />' +
          '                      </Supertip>' +
          '                      <Icon>' +
          '                        <bt:Image size="16" resid="sales-credit-memo-16" />' +
          '                        <bt:Image size="32" resid="sales-credit-memo-32" />' +
          '                        <bt:Image size="80" resid="sales-credit-memo-80" />' +
          '                      </Icon>' +
          '                      <Action xsi:type="ShowTaskpane">' +
          '                        <SourceLocation resid="newSalesCreditMemoUrl" />' +
          '                      </Action>' +
          '                    </Item>' +
          '                    <Item id="newMenuComposeItem5">' +
          '                      <Label resid="newPurchaseInvoiceLabel" />' +
          '                      <Tooltip resid="newPurchaseInvoiceTip" />' +
          '                      <Supertip>' +
          '                        <Title resid="newPurchaseInvoiceSuperTipTitle" />' +
          '                        <Description resid="newPurchaseInvoiceSuperTipDesc" />' +
          '                      </Supertip>' +
          '                      <Icon>' +
          '                        <bt:Image size="16" resid="purchase-invoice-16" />' +
          '                        <bt:Image size="32" resid="purchase-invoice-32" />' +
          '                        <bt:Image size="80" resid="purchase-invoice-80" />' +
          '                      </Icon>' +
          '                      <Action xsi:type="ShowTaskpane">' +
          '                        <SourceLocation resid="newPurchaseInvoiceUrl" />' +
          '                      </Action>' +
          '                    </Item>' +
          '                    <Item id="newMenuComposeItem6">' +
          '                      <Label resid="newPurchaseCrMemoLabel" />' +
          '                      <Tooltip resid="newPurchaseCrMemoTip" />' +
          '                      <Supertip>' +
          '                        <Title resid="newPurchaseCrMemoSuperTipTitle" />' +
          '                        <Description resid="newPurchaseCrMemoSuperTipDesc" />' +
          '                      </Supertip>' +
          '                      <Icon>' +
          '                        <bt:Image size="16" resid="purchase-credit-memo-16" />' +
          '                        <bt:Image size="32" resid="purchase-credit-memo-32" />' +
          '                        <bt:Image size="80" resid="purchase-credit-memo-80" />' +
          '                      </Icon>' +
          '                      <Action xsi:type="ShowTaskpane">' +
          '                        <SourceLocation resid="newPurchaseCrMemoUrl" />' +
          '                      </Action>' +
          '                    </Item>' +
          '                    <Item id="newMenuComposeItem7">' +
          '                      <Label resid="newPurchaseOrderLabel" />' +
          '                      <Tooltip resid="newPurchaseOrderTip" />' +
          '                      <Supertip>' +
          '                        <Title resid="newPurchaseOrderSuperTipTitle" />' +
          '                        <Description resid="newPurchaseOrderSuperTipDesc" />' +
          '                      </Supertip>' +
          '                      <Icon>' +
          '                        <bt:Image size="16" resid="order-16" />' +
          '                        <bt:Image size="32" resid="order-32" />' +
          '                        <bt:Image size="80" resid="order-80" />' +
          '                      </Icon>' +
          '                      <Action xsi:type="ShowTaskpane">' +
          '                        <SourceLocation resid="newPurchaseOrderUrl" />' +
          '                      </Action>' +
          '                    </Item>' +
          '                  </Items>' +
          '                </Control>' +
          '              </Group>' +
          '            </OfficeTab>' +
          '          </ExtensionPoint>' +
          '' +
          '          <!-- Appointment organizer form -->' +
          '          <ExtensionPoint xsi:type="AppointmentOrganizerCommandSurface">' +
          '            <OfficeTab id="TabDefault">' +
          '              <Group id="apptOrganizerGroup">' +
          '                <Label resid="groupLabel" />' +
          '                <Tooltip resid="groupTooltip" />' +
          '                <!-- Task pane button -->' +
          '                <Control xsi:type="Button" id="apptOrganizerOpenPaneButton">' +
          '                  <Label resid="openPaneButtonLabel" />' +
          '                  <Tooltip resid="openPaneButtonTooltip" />' +
          '                  <Supertip>' +
          '                    <Title resid="openPaneSuperTipTitle" />' +
          '                    <Description resid="openPaneSuperTipDesc" />' +
          '                  </Supertip>' +
          '                  <Icon>' +
          '                    <bt:Image size="16" resid="nav-icon-16" />' +
          '                    <bt:Image size="32" resid="nav-icon-32" />' +
          '                    <bt:Image size="80" resid="nav-icon-80" />' +
          '                  </Icon>' +
          '                  <Action xsi:type="ShowTaskpane">' +
          '                    <SourceLocation resid="taskPaneUrl" />' +
          '                  </Action>' +
          '                </Control>' +
          '                <!-- Invoice (dropdown) button -->' +
          '                <Control xsi:type="Menu" id="newMenuOrganizerButton">' +
          '                  <Label resid="newMenuButtonLabel" />' +
          '                  <Tooltip resid="newMenuButtonTooltip" />' +
          '                  <Supertip>' +
          '                    <Title resid="newMenuSuperTipTitle" />' +
          '                    <Description resid="newMenuSuperTipDesc" />' +
          '                  </Supertip>' +
          '                  <Icon>' +
          '                    <bt:Image size="16" resid="new-document-16" />' +
          '                    <bt:Image size="32" resid="new-document-32" />' +
          '                    <bt:Image size="80" resid="new-document-80" />' +
          '                  </Icon>' +
          '                  <Items>' +
          '                    <Item id="newMenuOrganizerItem1">' +
          '                      <Label resid="newSalesQuoteLabel" />' +
          '                      <Tooltip resid="newSalesQuoteTip" />' +
          '                      <Supertip>' +
          '                        <Title resid="newSalesQuoteSuperTipTitle" />' +
          '                        <Description resid="newSalesQuoteSuperTipDesc" />' +
          '                      </Supertip>' +
          '                      <Icon>' +
          '                        <bt:Image size="16" resid="quote-16" />' +
          '                        <bt:Image size="32" resid="quote-32" />' +
          '                        <bt:Image size="80" resid="quote-80" />' +
          '                      </Icon>' +
          '                      <Action xsi:type="ShowTaskpane">' +
          '                        <SourceLocation resid="newSalesQuoteUrl" />' +
          '                      </Action>' +
          '                    </Item>' +
          '                    <Item id="newMenuOrganizerItem2">' +
          '                      <Label resid="newSalesInvoiceLabel" />' +
          '                      <Tooltip resid="newSalesInvoiceTip" />' +
          '                      <Supertip>' +
          '                        <Title resid="newSalesInvoiceSuperTipTitle" />' +
          '                        <Description resid="newSalesInvoiceSuperTipDesc" />' +
          '                      </Supertip>' +
          '                      <Icon>' +
          '                        <bt:Image size="16" resid="sales-invoice-16" />' +
          '                        <bt:Image size="32" resid="sales-invoice-32" />' +
          '                        <bt:Image size="80" resid="sales-invoice-80" />' +
          '                      </Icon>' +
          '                      <Action xsi:type="ShowTaskpane">' +
          '                        <SourceLocation resid="newSalesInvoiceUrl" />' +
          '                      </Action>' +
          '                    </Item>' +
          '                    <Item id="newMenuOrganizerItem3">' +
          '                      <Label resid="newSalesOrderLabel" />' +
          '                      <Tooltip resid="newSalesOrderTip" />' +
          '                      <Supertip>' +
          '                        <Title resid="newSalesOrderSuperTipTitle" />' +
          '                        <Description resid="newSalesOrderSuperTipDesc" />' +
          '                      </Supertip>' +
          '                      <Icon>' +
          '                        <bt:Image size="16" resid="order-16" />' +
          '                        <bt:Image size="32" resid="order-32" />' +
          '                        <bt:Image size="80" resid="order-80" />' +
          '                      </Icon>' +
          '                      <Action xsi:type="ShowTaskpane">' +
          '                        <SourceLocation resid="newSalesOrderUrl" />' +
          '                      </Action>' +
          '                    </Item>' +
          '                    <Item id="newMenuOrganizerItem4">' +
          '                      <Label resid="newSalesCreditMemoLabel" />' +
          '                      <Tooltip resid="newSalesCreditMemoTip" />' +
          '                      <Supertip>' +
          '                        <Title resid="newSalesCreditMemoSuperTipTitle" />' +
          '                        <Description resid="newSalesCreditMemoSuperTipDesc" />' +
          '                      </Supertip>' +
          '                      <Icon>' +
          '                        <bt:Image size="16" resid="sales-credit-memo-16" />' +
          '                        <bt:Image size="32" resid="sales-credit-memo-32" />' +
          '                        <bt:Image size="80" resid="sales-credit-memo-80" />' +
          '                      </Icon>' +
          '                      <Action xsi:type="ShowTaskpane">' +
          '                        <SourceLocation resid="newSalesCreditMemoUrl" />' +
          '                      </Action>' +
          '                    </Item>' +
          '                  </Items>' +
          '                </Control>' +
          '              </Group>' +
          '            </OfficeTab>' +
          '          </ExtensionPoint>' +
          '' +
          '          <!-- Appointment attendee form -->' +
          '          <ExtensionPoint xsi:type="AppointmentAttendeeCommandSurface">' +
          '            <OfficeTab id="TabDefault">' +
          '              <Group id="apptAttendeeGroup">' +
          '                <Label resid="groupLabel" />' +
          '                <Tooltip resid="groupTooltip" />' +
          '                <!-- Task pane button -->' +
          '                <Control xsi:type="Button" id="apptAttendeeOpenPaneButton">' +
          '                  <Label resid="openPaneButtonLabel" />' +
          '                  <Tooltip resid="openPaneButtonTooltip" />' +
          '                  <Supertip>' +
          '                    <Title resid="openPaneSuperTipTitle" />' +
          '                    <Description resid="openPaneSuperTipDesc" />' +
          '                  </Supertip>' +
          '                  <Icon>' +
          '                    <bt:Image size="16" resid="nav-icon-16" />' +
          '                    <bt:Image size="32" resid="nav-icon-32" />' +
          '                    <bt:Image size="80" resid="nav-icon-80" />' +
          '                  </Icon>' +
          '                  <Action xsi:type="ShowTaskpane">' +
          '                    <SourceLocation resid="taskPaneUrl" />' +
          '                  </Action>' +
          '                </Control>' +
          '                <!-- Invoice (dropdown) button -->' +
          '                <Control xsi:type="Menu" id="newMenuAttendeeButton">' +
          '                  <Label resid="newMenuButtonLabel" />' +
          '                  <Tooltip resid="newMenuButtonTooltip" />' +
          '                  <Supertip>' +
          '                    <Title resid="newMenuSuperTipTitle" />' +
          '                    <Description resid="newMenuSuperTipDesc" />' +
          '                  </Supertip>' +
          '                  <Icon>' +
          '                    <bt:Image size="16" resid="new-document-16" />' +
          '                    <bt:Image size="32" resid="new-document-32" />' +
          '                    <bt:Image size="80" resid="new-document-80" />' +
          '                  </Icon>' +
          '                  <Items>' +
          '                    <Item id="newMenuAttendeeItem1">' +
          '                      <Label resid="newSalesQuoteLabel" />' +
          '                      <Tooltip resid="newSalesQuoteTip" />' +
          '                      <Supertip>' +
          '                        <Title resid="newSalesQuoteSuperTipTitle" />' +
          '                        <Description resid="newSalesQuoteSuperTipDesc" />' +
          '                      </Supertip>' +
          '                      <Icon>' +
          '                        <bt:Image size="16" resid="quote-16" />' +
          '                        <bt:Image size="32" resid="quote-32" />' +
          '                        <bt:Image size="80" resid="quote-80" />' +
          '                      </Icon>' +
          '                      <Action xsi:type="ShowTaskpane">' +
          '                        <SourceLocation resid="newSalesQuoteUrl" />' +
          '                      </Action>' +
          '                    </Item>' +
          '                    <Item id="newMenuAttendeeItem2">' +
          '                      <Label resid="newSalesInvoiceLabel" />' +
          '                      <Tooltip resid="newSalesInvoiceTip" />' +
          '                      <Supertip>' +
          '                        <Title resid="newSalesInvoiceSuperTipTitle" />' +
          '                        <Description resid="newSalesInvoiceSuperTipDesc" />' +
          '                      </Supertip>' +
          '                      <Icon>' +
          '                        <bt:Image size="16" resid="sales-invoice-16" />' +
          '                        <bt:Image size="32" resid="sales-invoice-32" />' +
          '                        <bt:Image size="80" resid="sales-invoice-80" />' +
          '                      </Icon>' +
          '                      <Action xsi:type="ShowTaskpane">' +
          '                        <SourceLocation resid="newSalesInvoiceUrl" />' +
          '                      </Action>' +
          '                    </Item>' +
          '                    <Item id="newMenuAttendeeItem3">' +
          '                      <Label resid="newSalesOrderLabel" />' +
          '                      <Tooltip resid="newSalesOrderTip" />' +
          '                      <Supertip>' +
          '                        <Title resid="newSalesOrderSuperTipTitle" />' +
          '                        <Description resid="newSalesOrderSuperTipDesc" />' +
          '                      </Supertip>' +
          '                      <Icon>' +
          '                        <bt:Image size="16" resid="order-16" />' +
          '                        <bt:Image size="32" resid="order-32" />' +
          '                        <bt:Image size="80" resid="order-80" />' +
          '                      </Icon>' +
          '                      <Action xsi:type="ShowTaskpane">' +
          '                        <SourceLocation resid="newSalesOrderUrl" />' +
          '                      </Action>' +
          '                    </Item>' +
          '                    <Item id="newMenuAttendeeItem4">' +
          '                      <Label resid="newSalesCreditMemoLabel" />' +
          '                      <Tooltip resid="newSalesCreditMemoTip" />' +
          '                      <Supertip>' +
          '                        <Title resid="newSalesCreditMemoSuperTipTitle" />' +
          '                        <Description resid="newSalesCreditMemoSuperTipDesc" />' +
          '                      </Supertip>' +
          '                      <Icon>' +
          '                        <bt:Image size="16" resid="sales-credit-memo-16" />' +
          '                        <bt:Image size="32" resid="sales-credit-memo-32" />' +
          '                        <bt:Image size="80" resid="sales-credit-memo-80" />' +
          '                      </Icon>' +
          '                      <Action xsi:type="ShowTaskpane">' +
          '                        <SourceLocation resid="newSalesCreditMemoUrl" />' +
          '                      </Action>' +
          '                    </Item>' +
          '                  </Items>' +
          '                </Control>' +
          '              </Group>' +
          '            </OfficeTab>' +
          '          </ExtensionPoint>' +
          '        </DesktopFormFactor>' +
          '      </Host>' +
          '    </Hosts>' +
          '    <Resources>' +
          '      <bt:Images>' +
          '        <!-- NAV icon -->' +
          '        <bt:Image id="nav-icon-16" DefaultValue="WEBCLIENTLOCATION/Resources/Images/Dynamics-16x.png"/>' +
          '        <bt:Image id="nav-icon-32" DefaultValue="WEBCLIENTLOCATION/Resources/Images/Dynamics-32x.png"/>' +
          '        <bt:Image id="nav-icon-80" DefaultValue="WEBCLIENTLOCATION/Resources/Images/OfficeAddinLogo.png"/>' +
          '' +
          '        <!-- New document icon -->' +
          '        <bt:Image id="new-document-16" DefaultValue="WEBCLIENTLOCATION/Resources/Images/NewDocument_16x16.png"/>' +
          '        <bt:Image id="new-document-32" DefaultValue="WEBCLIENTLOCATION/Resources/Images/NewDocument_32x32.png"/>' +
          '        <bt:Image id="new-document-80" DefaultValue="WEBCLIENTLOCATION/Resources/Images/NewDocument_80x80.png"/>' +
          '' +
          '        <!-- Quote icon -->' +
          '        <bt:Image id="quote-16" DefaultValue="WEBCLIENTLOCATION/Resources/Images/Quote_16x16.png"/>' +
          '        <bt:Image id="quote-32" DefaultValue="WEBCLIENTLOCATION/Resources/Images/Quote_32x32.png"/>' +
          '        <bt:Image id="quote-80" DefaultValue="WEBCLIENTLOCATION/Resources/Images/Quote_80x80.png"/>' +
          '' +
          '        <!-- Order icon -->' +
          '        <bt:Image id="order-16" DefaultValue="WEBCLIENTLOCATION/Resources/Images/Order_16x16.png"/>' +
          '        <bt:Image id="order-32" DefaultValue="WEBCLIENTLOCATION/Resources/Images/Order_32x32.png"/>' +
          '        <bt:Image id="order-80" DefaultValue="WEBCLIENTLOCATION/Resources/Images/Order_80x80.png"/>' +
          '' +
          '        <!-- Sales Invoice icon -->' +
          '        <bt:Image id="sales-invoice-16" DefaultValue="WEBCLIENTLOCATION/Resources/Images/SalesInvoice_16.png"/>' +
          '        <bt:Image id="sales-invoice-32" DefaultValue="WEBCLIENTLOCATION/Resources/Images/SalesInvoice_32.png"/>' +
          '        <bt:Image id="sales-invoice-80" DefaultValue="WEBCLIENTLOCATION/Resources/Images/SalesInvoice_80.png"/>' +
          '' +
          '        <!-- Purchase Invoice icon -->' +
          '        <bt:Image id="purchase-invoice-16" DefaultValue="WEBCLIENTLOCATION/Resources/Images/PurchaseInvoice_16.png"/>' +
          '        <bt:Image id="purchase-invoice-32" DefaultValue="WEBCLIENTLOCATION/Resources/Images/PurchaseInvoice_32.png"/>' +
          '        <bt:Image id="purchase-invoice-80" DefaultValue="WEBCLIENTLOCATION/Resources/Images/PurchaseInvoice_80.png"/>' +
          '' +
          '        <!-- Credit memo icon -->' +
          '        <bt:Image id="sales-credit-memo-16" DefaultValue="WEBCLIENTLOCATION/Resources/Images/SalesCreditMemo_16.png"/>' +
          '        <bt:Image id="sales-credit-memo-32" DefaultValue="WEBCLIENTLOCATION/Resources/Images/SalesCreditMemo_32.png"/>' +
          '        <bt:Image id="sales-credit-memo-80" DefaultValue="WEBCLIENTLOCATION/Resources/Images/SalesCreditMemo_80.png"/>' +
          '      ' +
          '        <!-- Credit memo icon -->' +
          '        <bt:Image id="purchase-credit-memo-16" DefaultValue="/Resources/Images/PurchaseCreditMemo_16.png"/>' +
          '        <bt:Image id="purchase-credit-memo-32" DefaultValue="/Resources/Images/PurchaseCreditMemo_32.png"/>' +
          '        <bt:Image id="purchase-credit-memo-80" DefaultValue="/Resources/Images/PurchaseCreditMemo_80.png"/>' +
          '      </bt:Images>' +
          '      <bt:Urls>' +
          '        <bt:Url id="taskPaneUrl" DefaultValue=""/>' +
          '        <bt:Url id="newSalesQuoteUrl" DefaultValue=""/>' +
          '        <bt:Url id="newSalesOrderUrl" DefaultValue=""/>' +
          '        <bt:Url id="newSalesInvoiceUrl" DefaultValue=""/>' +
          '        <bt:Url id="newSalesCreditMemoUrl" DefaultValue=""/>' +
          '        <bt:Url id="newPurchaseInvoiceUrl" DefaultValue=""/>' +
          '        <bt:Url id="newPurchaseCrMemoUrl" DefaultValue=""/>' +
          '        <bt:Url id="newPurchaseOrderUrl" DefaultValue=""/>' +
          '      </bt:Urls>' +
          '      <bt:ShortStrings>' +
          '        <!-- Both modes -->' +
          '        <bt:String id="groupLabel" DefaultValue="' + AddinManifestManagement.XMLEncode(ProductName.Short) + '"/>' +
          '' +
          '        <bt:String id="openPaneButtonLabel" DefaultValue="Contact Insights"/>' +
          '        <bt:String id="openPaneSuperTipTitle" DefaultValue="Open ' +
          AddinManifestManagement.XMLEncode(ProductName.Short) + ' in Outlook"/>' +
          '' +
          '        <bt:String id="newMenuButtonLabel" DefaultValue="New"/>' +
          '        <bt:String id="newMenuSuperTipTitle" DefaultValue="Create a new document in ' +
          AddinManifestManagement.XMLEncode(ProductName.Short) + '"/>' +
          '' +
          '        <bt:String id="newSalesQuoteLabel" DefaultValue="Sales Quote"/>' +
          '        <bt:String id="newSalesQuoteSuperTipTitle" DefaultValue="Create new sales quote"/>' +
          '' +
          '        <bt:String id="newSalesOrderLabel" DefaultValue="Sales Order"/>' +
          '        <bt:String id="newSalesOrderSuperTipTitle" DefaultValue="Create new sales order"/>' +
          '' +
          '        <bt:String id="newSalesInvoiceLabel" DefaultValue="Sales Invoice"/>' +
          '        <bt:String id="newSalesInvoiceSuperTipTitle" DefaultValue="Create new sales invoice"/>' +
          '' +
          '        <bt:String id="newSalesCreditMemoLabel" DefaultValue="Sales Credit Memo"/>' +
          '        <bt:String id="newSalesCreditMemoSuperTipTitle" DefaultValue="Create new sales credit memo"/>' +
          '' +
          '        <bt:String id="newPurchaseInvoiceLabel" DefaultValue="Purchase Invoice"/>' +
          '        <bt:String id="newPurchaseInvoiceSuperTipTitle" DefaultValue="Create new purchase invoice"/>' +
          '' +
          '        <bt:String id="newPurchaseCrMemoLabel" DefaultValue="Purchase Credit Memo"/>' +
          '        <bt:String id="newPurchaseCrMemoSuperTipTitle" DefaultValue="Create new purchase credit memo"/>' +
          '' +
          '        <bt:String id="newPurchaseOrderLabel" DefaultValue="Purchase Order"/>' +
          '        <bt:String id="newPurchaseOrderSuperTipTitle" DefaultValue="Create new purchase order"/>' +
          '      </bt:ShortStrings>' +
          '      <bt:LongStrings>' +
          '        <bt:String id="groupTooltip" DefaultValue="' + AddinManifestManagement.XMLEncode(ProductName.Short) + ' Add-in"/>' +
          '' +
          '        <bt:String id="openPaneButtonTooltip" DefaultValue="Opens the contact in an embedded view"/>' +
          '        <bt:String id="openPaneSuperTipDesc" DefaultValue="Opens a pane to interact with the customer or vendor"/>' +
          '' +
          '        <bt:String id="newMenuButtonTooltip" DefaultValue="Creates a new document in ' +
          AddinManifestManagement.XMLEncode(ProductName.Short) + '"/>' +
          '        <bt:String id="newMenuSuperTipDesc" DefaultValue="Creates a new document for the selected customer or vendor"/>' +
          '' +
          '        <bt:String id="newSalesQuoteTip" DefaultValue="Creates a new sales quote in ' +
          AddinManifestManagement.XMLEncode(ProductName.Short) + '" />' +
          '        <bt:String id="newSalesQuoteSuperTipDesc" DefaultValue="Creates a new sales quote for the selected customer." />' +
          '' +
          '        <bt:String id="newSalesOrderTip" DefaultValue="Creates a new sales order in ' +
          AddinManifestManagement.XMLEncode(ProductName.Short) + '" />' +
          '        <bt:String id="newSalesOrderSuperTipDesc" DefaultValue="Creates a new sales order for the selected customer." />' +
          '' +
          '        <bt:String id="newSalesInvoiceTip" DefaultValue="Creates a new sales invoice" />' +
          '        <bt:String id="newSalesInvoiceSuperTipDesc" DefaultValue="Creates a new sales invoice for the customer" />' +
          '' +
          '        <bt:String id="newSalesCreditMemoTip" DefaultValue="Creates a new sales credit memo" />' +
          '        <bt:String id="newSalesCreditMemoSuperTipDesc" DefaultValue="Creates a new sales credit memo" />' +
          '' +
          '        <bt:String id="newPurchaseInvoiceTip" DefaultValue="Creates a new purchase invoice" />' +
          '        <bt:String id="newPurchaseInvoiceSuperTipDesc" DefaultValue="Creates a new purchase invoice" />' +
          '' +
          '        <bt:String id="newPurchaseCrMemoTip" DefaultValue="Creates a new purchase credit memo" />' +
          '        <bt:String id="newPurchaseCrMemoSuperTipDesc" DefaultValue="Creates a new purchase credit memo" />' +
          '' +
          '        <bt:String id="newPurchaseOrderTip" DefaultValue="Creates a new purchase order" />' +
          '        <bt:String id="newPurchaseOrderSuperTipDesc" DefaultValue="Creates a new purchase order" />' +
          '      </bt:LongStrings>' +
          '    </Resources>' +
          '  </vOverrides:VersionOverrides>' +
          '</OfficeApp>';
    end;
}

