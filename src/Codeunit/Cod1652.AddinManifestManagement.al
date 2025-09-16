#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1652 "Add-in Manifest Management"
{

    trigger OnRun()
    begin
    end;

    var
        RuleCollectionXPathTxt: label 'x:Rule[@xsi:type="RuleCollection" and @Mode="And"]/x:Rule[@xsi:type="RuleCollection" and @Mode="Or"]', Locked=true;
        MissingNodeErr: label 'Cannot find an XML node that matches %1.', Comment='%1=XML node name';
        UnsupportedNodeTypeErr: label 'You have specified a node of type %1. This type is not supported.', Comment='%1 = The type of XML node.';
        RuleXPathTxt: label 'x:Rule[@xsi:type="RuleCollection" and @Mode="Or"]/x:Rule[@xsi:type="RuleCollection" and @Mode="And"]/x:Rule[@xsi:type="ItemHasRegularExpressionMatch"]', Locked=true;
        WebClientHttpsErr: label 'Cannot set up the add-in because the %1 Server instance is not configured to use Secure Sockets Layer (SSL).', Comment='%1=product name';
        MicrosoftTxt: label 'Microsoft';
        PermissionManager: Codeunit "Permission Manager";
        NodeType: Option Version,ProviderName,DefaultLocale,DisplayName,Description,DesktopSourceLoc,TabletSourceLoc,PhoneSourceLoc,AppDomain,IconUrl,HighResolutionIconUrl;
        TestMode: Boolean;
        IntelligentInfoAddinNameTxt: label 'Contact Insights';
        IntelligentInfoDescriptionTxt: label 'Provides customer/vendor information in Outlook mail and enables creating and sending documents to the contact.';
        HyperlinkAddinNameTxt: label 'Document View';
        HyperlinkAddinDescriptionTxt: label 'Provides a link directly to a business document when the document number is included in the text of the email message.';
        BrandingFolderTxt: label 'ProjectMadeira/', Locked=true;


    procedure DownloadManifestToClient(var NewOfficeAddin: Record "Office Add-in";FileName: Text): Boolean
    var
        FileManagement: Codeunit "File Management";
        ServerLocation: Text;
    begin
        ServerLocation := SaveManifestToServer(NewOfficeAddin);

        if TestMode then begin
          FileManagement.CopyServerFile(ServerLocation,FileName,true);
          exit(true);
        end;

        exit(FileManagement.DownloadHandler(ServerLocation,'','','',FileName));
    end;


    procedure SaveManifestToServer(var NewOfficeAddin: Record "Office Add-in"): Text
    var
        TempBlob: Record TempBlob temporary;
        FileManagement: Codeunit "File Management";
        FileOutStream: OutStream;
        ManifestInStream: InStream;
        TempFileName: Text;
    begin
        GenerateManifest(NewOfficeAddin);
        NewOfficeAddin.CalcFields(Manifest);

        TempBlob.Blob.CreateOutstream(FileOutStream,Textencoding::UTF8);
        NewOfficeAddin.Manifest.CreateInstream(ManifestInStream,Textencoding::UTF8);
        CopyStream(FileOutStream,ManifestInStream);

        TempFileName := FileManagement.ServerTempFileName('xml');
        FileManagement.BLOBExportToServerFile(TempBlob,TempFileName);
        exit(TempFileName);
    end;


    procedure UploadDefaultManifest(var OfficeAddin: Record "Office Add-in";ManifestLocation: Text)
    var
        TempBlob: Record TempBlob temporary;
        FileManagement: Codeunit "File Management";
        TempInStream: InStream;
        ManifestText: Text;
    begin
        TempBlob.Init;
        FileManagement.BLOBImportFromServerFile(TempBlob,ManifestLocation);

        TempBlob.Blob.CreateInstream(TempInStream,Textencoding::UTF8);
        TempInStream.Read(ManifestText);
        UploadDefaultManifestText(OfficeAddin,ManifestText);
    end;


    procedure UploadDefaultManifestText(var OfficeAddin: Record "Office Add-in";ManifestText: Text)
    var
        ManifestOutStream: OutStream;
    begin
        with OfficeAddin do begin
          Clear("Default Manifest");
          "Default Manifest".CreateOutstream(ManifestOutStream,Textencoding::UTF8);
          ManifestOutStream.WriteText(ManifestText);

          // Set the AppID from the manifest
          "Application ID" := GetAppID(OfficeAddin);

          if IsNullGuid("Application ID") then
            "Application ID" := CreateGuid;

          Version := GetAppVersion(OfficeAddin);

          if not Modify then
            Insert;
        end;
    end;


    procedure CreateDefaultAddins()
    var
        IntelligentInfoManifest: Codeunit "Intelligent Info Manifest";
        HyperlinkManifest: Codeunit "Hyperlink Manifest";
    begin
        CreateAddin(IntelligentInfoManifest.ManifestText,IntelligentInfoAddinNameTxt,
          IntelligentInfoDescriptionTxt,Codeunit::"Intelligent Info Manifest");
        CreateAddin(HyperlinkManifest.ManifestText,HyperlinkAddinNameTxt,
          HyperlinkAddinDescriptionTxt,Codeunit::"Hyperlink Manifest");
    end;

    local procedure CreateAddin(ManifestText: Text;AddinName: Text[50];AddinDescription: Text[250];ManifestCodeunit: Integer)
    var
        OfficeAddin: Record "Office Add-in";
    begin
        OfficeAddin.Init;
        UploadDefaultManifestText(OfficeAddin,ManifestText);
        OfficeAddin."Manifest Codeunit" := ManifestCodeunit;
        OfficeAddin.Name := AddinName;
        OfficeAddin.Description := AddinDescription;
        OfficeAddin.Modify;
    end;


    procedure GenerateManifest(var OfficeAddin: Record "Office Add-in")
    begin
        // Uses the current value of Manifest and updates XML nodes to reflect the current values
        VerifyHttps;
        if OfficeAddin."Manifest Codeunit" <> 0 then
          Codeunit.Run(OfficeAddin."Manifest Codeunit",OfficeAddin)
        else
          SetCommonManifestItems(OfficeAddin);
    end;


    procedure SetCommonManifestItems(var OfficeAddin: Record "Office Add-in")
    var
        Thread: dotnet Thread;
    begin
        with OfficeAddin do begin
          CalcFields(Manifest,"Default Manifest");
          CopyDefaultManifestToManifest(OfficeAddin); // Reset the manifest by overwriting with the default

          // Set general metadata
          SetNodeValue(OfficeAddin,Thread.CurrentThread.CurrentCulture.Name,Nodetype::DefaultLocale,0);
          SetNodeValue(OfficeAddin,MicrosoftTxt,Nodetype::ProviderName,0);
          SetNodeValue(OfficeAddin,GetUrl(Clienttype::Web),Nodetype::AppDomain,0);
          SetNodeValue(OfficeAddin,GetAppName(OfficeAddin),Nodetype::DisplayName,0);
          SetNodeValue(OfficeAddin,XMLEncode(Description),Nodetype::Description,0);
          if PermissionManager.SoftwareAsAService then begin
            SetNodeValue(OfficeAddin,GetImageUrl(BrandingFolderTxt + 'Dyn365_64x.png'),Nodetype::IconUrl,0);
            SetNodeValue(OfficeAddin,GetImageUrl(BrandingFolderTxt + 'Dyn365_80x.png'),Nodetype::HighResolutionIconUrl,0);
          end else begin
            SetNodeValue(OfficeAddin,GetImageUrl('OfficeAddinLogo.png'),Nodetype::IconUrl,0);
            SetNodeValue(OfficeAddin,GetImageUrl('OfficeAddinLogoHigh.png'),Nodetype::HighResolutionIconUrl,0);
          end;

          Modify;
        end;
    end;

    local procedure GetManifestNamespaceManager(XMLRootNode: dotnet XmlNode;var XMLNamespaceManager: dotnet XmlNamespaceManager)
    var
        XMLDomManagement: Codeunit "XML DOM Management";
    begin
        XMLDomManagement.AddNamespaces(XMLNamespaceManager,XMLRootNode.OwnerDocument);

        // Need to explicitly add the default namespace to a namespace
        XMLNamespaceManager.AddNamespace('x',XMLNamespaceManager.DefaultNamespace);
        XMLNamespaceManager.AddNamespace('vOverrides','http://schemas.microsoft.com/office/mailappversionoverrides');
    end;


    procedure SetNodeValue(var OfficeAddIn: Record "Office Add-in";Value: Variant;Node: Option;FormType: Option ItemRead,ItemEdit)
    var
        XMLDomManagement: Codeunit "XML DOM Management";
        ManifestInStream: InStream;
        ManifestOutStream: OutStream;
        XMLRootNode: dotnet XmlNode;
        XMLFoundNodes: dotnet XmlNodeList;
        XMLNamespaceMgr: dotnet XmlNamespaceManager;
    begin
        with OfficeAddIn do begin
          CalcFields(Manifest);
          Manifest.CreateInstream(ManifestInStream,Textencoding::UTF8);

          XMLDomManagement.LoadXMLNodeFromInStream(ManifestInStream,XMLRootNode);
          GetManifestNamespaceManager(XMLRootNode,XMLNamespaceMgr);

          case Node of
            Nodetype::DefaultLocale:
              begin
                if not XMLDomManagement.FindNodesWithNamespaceManager(XMLRootNode,'x:DefaultLocale',XMLNamespaceMgr,XMLFoundNodes) then
                  Error(MissingNodeErr,Format(Node));
                XMLFoundNodes.Item(0).InnerText := Format(Value);
              end;
            Nodetype::Description:
              begin
                if not XMLDomManagement.FindNodesWithNamespaceManager(XMLRootNode,'x:Description',XMLNamespaceMgr,XMLFoundNodes) then
                  Error(MissingNodeErr,Format(Node));
                XMLFoundNodes.Item(0).Attributes.ItemOf('DefaultValue').Value := Format(Value);
              end;
            Nodetype::DisplayName:
              begin
                if not XMLDomManagement.FindNodesWithNamespaceManager(XMLRootNode,'x:DisplayName',XMLNamespaceMgr,XMLFoundNodes) then
                  Error(MissingNodeErr,Format(Node));
                XMLFoundNodes.Item(0).Attributes.ItemOf('DefaultValue').Value := Format(Value);
              end;
            Nodetype::IconUrl:
              begin
                if not XMLDomManagement.FindNodesWithNamespaceManager(XMLRootNode,'x:IconUrl',XMLNamespaceMgr,XMLFoundNodes) then
                  Error(MissingNodeErr,Format(Node));
                XMLFoundNodes.Item(0).Attributes.ItemOf('DefaultValue').Value := Format(Value);
              end;
            Nodetype::HighResolutionIconUrl:
              begin
                if not XMLDomManagement.FindNodesWithNamespaceManager(XMLRootNode,'x:HighResolutionIconUrl',XMLNamespaceMgr,XMLFoundNodes) then
                  Error(MissingNodeErr,Format(Node));
                XMLFoundNodes.Item(0).Attributes.ItemOf('DefaultValue').Value := Format(Value);
              end;
            Nodetype::ProviderName:
              begin
                if not XMLDomManagement.FindNodesWithNamespaceManager(XMLRootNode,'x:ProviderName',XMLNamespaceMgr,XMLFoundNodes) then
                  Error(MissingNodeErr,Format(Node));
                XMLFoundNodes.Item(0).InnerText := Format(Value);
              end;
            Nodetype::Version:
              begin
                if not XMLDomManagement.FindNodesWithNamespaceManager(XMLRootNode,'x:Version',XMLNamespaceMgr,XMLFoundNodes) then
                  Error(MissingNodeErr,Format(Node));
                XMLFoundNodes.Item(0).InnerText := Format(Value);
              end;
            Nodetype::DesktopSourceLoc:
              begin
                if not XMLDomManagement.FindNodesWithNamespaceManager(
                     XMLRootNode,StrSubstNo('x:FormSettings/x:Form[@xsi:type="%1"]/x:DesktopSettings/x:SourceLocation',FormType),
                     XMLNamespaceMgr,XMLFoundNodes)
                then
                  Error(MissingNodeErr,Format(Node));
                XMLFoundNodes.Item(0).Attributes.ItemOf('DefaultValue').Value := Format(Value);
              end;
            Nodetype::PhoneSourceLoc:
              begin
                if not XMLDomManagement.FindNodesWithNamespaceManager(
                     XMLRootNode,StrSubstNo('x:FormSettings/x:Form[@xsi:type="%1"]/x:PhoneSettings/x:SourceLocation',FormType),
                     XMLNamespaceMgr,XMLFoundNodes)
                then
                  Error(MissingNodeErr,Format(Node));
                XMLFoundNodes.Item(0).Attributes.ItemOf('DefaultValue').Value := StrSubstNo('%1&isphone=1',Format(Value));
              end;
            Nodetype::TabletSourceLoc:
              begin
                if not XMLDomManagement.FindNodesWithNamespaceManager(
                     XMLRootNode,StrSubstNo('x:FormSettings/x:Form[@xsi:type="%1"]/x:TabletSettings/x:SourceLocation',FormType),
                     XMLNamespaceMgr,XMLFoundNodes)
                then
                  Error(MissingNodeErr,Format(Node));
                XMLFoundNodes.Item(0).Attributes.ItemOf('DefaultValue').Value := Format(Value);
              end;
            Nodetype::AppDomain:
              begin
                if not XMLDomManagement.FindNodesWithNamespaceManager(
                     XMLRootNode,'x:AppDomains/x:AppDomain',XMLNamespaceMgr,XMLFoundNodes)
                then
                  Error(MissingNodeErr,Format(Node));
                XMLFoundNodes.Item(0).InnerText := Format(Value);
              end;
            else
              Error(StrSubstNo(UnsupportedNodeTypeErr,Node));
          end;

          // Need to clear the blob here, otherwise the OutStream may have extra data at the end.
          Clear(Manifest);
          Manifest.CreateOutstream(ManifestOutStream,Textencoding::UTF8);
          XMLDomManagement.SaveXMLDocumentToOutStream(ManifestOutStream,XMLRootNode);
          Modify;
        end;
    end;


    procedure SetNodeResource(var OfficeAddIn: Record "Office Add-in";Id: Text[32];Value: Text;Type: Option Image,Url,ShortString,LongString)
    var
        XMLDomManagement: Codeunit "XML DOM Management";
        ManifestInStream: InStream;
        ManifestOutStream: OutStream;
        XMLRootNode: dotnet XmlNode;
        XMLFoundNodes: dotnet XmlNodeList;
        XMLNamespaceMgr: dotnet XmlNamespaceManager;
        OfficeHostType: dotnet OfficeHostType;
        NodeLocation: Text;
    begin
        with OfficeAddIn do begin
          CalcFields(Manifest);
          Manifest.CreateInstream(ManifestInStream,Textencoding::UTF8);

          XMLDomManagement.LoadXMLNodeFromInStream(ManifestInStream,XMLRootNode);
          GetManifestNamespaceManager(XMLRootNode,XMLNamespaceMgr);
          NodeLocation := 'vOverrides:VersionOverrides/x:Resources/%1[@id="%2"]';
          case Type of
            Type::Image:
              begin
                NodeLocation := StrSubstNo(NodeLocation,'bt:Images/bt:Image',Id);
                Value := GetImageUrl(Value);
              end;
            Type::Url:
              begin
                NodeLocation := StrSubstNo(NodeLocation,'bt:Urls/bt:Url',Id);
                Value := ConstructURL(OfficeHostType.OutlookTaskPane,Value,Version);
              end;
            Type::ShortString:
              begin
                NodeLocation := StrSubstNo(NodeLocation,'bt:ShortStrings/bt:String',Id);
                Value := XMLEncode(Value);
              end;
            Type::LongString:
              begin
                NodeLocation := StrSubstNo(NodeLocation,'bt:LongStrings/bt:String',Id);
                Value := XMLEncode(Value);
              end;
            else
              Error(StrSubstNo(UnsupportedNodeTypeErr,Type));
          end;

          if not XMLDomManagement.FindNodesWithNamespaceManager(XMLRootNode,NodeLocation,XMLNamespaceMgr,XMLFoundNodes) then
            Error(MissingNodeErr,NodeLocation);

          XMLFoundNodes.Item(0).Attributes.ItemOf('DefaultValue').Value := Value;

          // Need to clear the blob here, otherwise the OutStream may have extra data at the end.
          Clear(Manifest);
          Manifest.CreateOutstream(ManifestOutStream,Textencoding::UTF8);
          XMLDomManagement.SaveXMLDocumentToOutStream(ManifestOutStream,XMLRootNode);
          Modify;
        end;
    end;


    procedure RemovePrefix(var OfficeAddin: Record "Office Add-in")
    var
        XMLDomManagement: Codeunit "XML DOM Management";
        ManifestInStream: InStream;
        ManifestOutStream: OutStream;
        XMLRootNode: dotnet XmlNode;
        InnerText: dotnet String;
        ManifestText: Text;
    begin
        with OfficeAddin do begin
          CalcFields(Manifest);
          Manifest.CreateInstream(ManifestInStream,Textencoding::UTF8);
          XMLDomManagement.LoadXMLNodeFromInStream(ManifestInStream,XMLRootNode);

          InnerText := XMLRootNode.OwnerDocument.InnerXml;
          InnerText := InnerText.Replace('vOverrides:','');
          InnerText := InnerText.Replace(':vOverrides','');
          ManifestText := InnerText;

          Clear(Manifest);
          Manifest.CreateOutstream(ManifestOutStream,Textencoding::UTF8);
          ManifestOutStream.WriteText(ManifestText);
          Modify;
        end;

        RestructureManifest(OfficeAddin);
    end;


    procedure RemoveAddInTriggersFromManifest(var OfficeAddin: Record "Office Add-in")
    var
        XMLDomManagement: Codeunit "XML DOM Management";
        ManifestInStream: InStream;
        ManifestOutStream: OutStream;
        XMLNode: dotnet XmlNode;
        XMLRootNode: dotnet XmlNode;
        XMLFoundNodes: dotnet XmlNodeList;
        XMLNamespaceMgr: dotnet XmlNamespaceManager;
    begin
        with OfficeAddin do begin
          CalcFields(Manifest);
          Manifest.CreateInstream(ManifestInStream,Textencoding::UTF8);

          XMLDomManagement.LoadXMLNodeFromInStream(ManifestInStream,XMLRootNode);
          GetManifestNamespaceManager(XMLRootNode,XMLNamespaceMgr);

          // Find the nodes that trigger the add-in and remove them all
          XMLDomManagement.FindNodesWithNamespaceManager(
            XMLRootNode,
            RuleXPathTxt,
            XMLNamespaceMgr,XMLFoundNodes);

          foreach XMLNode in XMLFoundNodes do
            XMLNode.ParentNode.RemoveChild(XMLNode);

          // Need to clear the blob here, otherwise the OutStream may have extra data at the end.
          Clear(Manifest);
          Manifest.CreateOutstream(ManifestOutStream,Textencoding::UTF8);
          XMLDomManagement.SaveXMLDocumentToOutStream(ManifestOutStream,XMLRootNode);
          Modify;
        end;
    end;

    local procedure CopyDefaultManifestToManifest(var OfficeAddIn: Record "Office Add-in")
    var
        DefaultManifestInStream: InStream;
        ManifestOutStream: OutStream;
    begin
        with OfficeAddIn do begin
          CalcFields(Manifest,"Default Manifest");
          "Default Manifest".CreateInstream(DefaultManifestInStream,Textencoding::UTF8);
          Clear(Manifest);
          Manifest.CreateOutstream(ManifestOutStream,Textencoding::UTF8);
          CopyStream(ManifestOutStream,DefaultManifestInStream);
          Modify;
        end;
    end;


    procedure SetSourceLocationNodes(var OfficeAddin: Record "Office Add-in";URL: Text;FormType: Option ItemRead,ItemEdit)
    begin
        SetNodeValue(OfficeAddin,URL,Nodetype::DesktopSourceLoc,FormType);
        SetNodeValue(OfficeAddin,URL,Nodetype::PhoneSourceLoc,FormType);
        SetNodeValue(OfficeAddin,URL,Nodetype::TabletSourceLoc,FormType);
    end;


    procedure ConstructURL(HostType: Text;Command: Text;Version: Text) BaseURL: Text
    var
        CompanyQueryPos: Integer;
    begin
        BaseURL := GetUrl(Clienttype::Web);

        CompanyQueryPos := StrPos(Lowercase(BaseURL),'?');
        if CompanyQueryPos > 0 then
          BaseURL := InsStr(BaseURL,'/OfficeAddin.aspx',CompanyQueryPos) + '&'
        else
          BaseURL := BaseURL + '/OfficeAddin.aspx?';

        BaseURL := BaseURL + 'OfficeContext=' + HostType;
        if Command <> '' then
          BaseURL := BaseURL + '&Command=' + Command;

        if Version <> '' then
          BaseURL := BaseURL + '&Version=' + Version;
    end;


    procedure AddRegExRuleNode(var OfficeAddin: Record "Office Add-in";RegExName: Text;RegExText: Text)
    var
        XMLDomManagement: Codeunit "XML DOM Management";
        ManifestInStream: InStream;
        ManifestOutStream: OutStream;
        XMLRootNode: dotnet XmlNode;
        XMLRuleNode: dotnet XmlNode;
        XMLFoundNodes: dotnet XmlNodeList;
        XMLNamespaceMgr: dotnet XmlNamespaceManager;
    begin
        OfficeAddin.CalcFields(Manifest);
        OfficeAddin.Manifest.CreateInstream(ManifestInStream,Textencoding::UTF8);

        XMLDomManagement.LoadXMLNodeFromInStream(ManifestInStream,XMLRootNode);
        GetManifestNamespaceManager(XMLRootNode,XMLNamespaceMgr);

        XMLDomManagement.FindNodesWithNamespaceManager(
          XMLRootNode,RuleCollectionXPathTxt,
          XMLNamespaceMgr,XMLFoundNodes);

        XMLRuleNode := XMLRootNode.OwnerDocument.CreateNode('element','Rule',
            'http://schemas.microsoft.com/office/appforoffice/1.1');
        XMLDomManagement.AddAttributeWithPrefix(
          XMLRuleNode,'type','xsi','http://www.w3.org/2001/XMLSchema-instance','ItemHasRegularExpressionMatch');
        XMLDomManagement.AddAttribute(XMLRuleNode,'RegExName',RegExName);
        XMLDomManagement.AddAttribute(XMLRuleNode,'RegExValue',RegExText);
        XMLDomManagement.AddAttribute(XMLRuleNode,'PropertyName','BodyAsPlaintext');
        XMLDomManagement.AddAttribute(XMLRuleNode,'IgnoreCase','true');
        XMLFoundNodes.Item(0).AppendChild(XMLRuleNode);

        // Need to clear the blob here, otherwise the OutStream may have extra data at the end.
        Clear(OfficeAddin.Manifest);
        OfficeAddin.Manifest.CreateOutstream(ManifestOutStream,Textencoding::UTF8);
        XMLDomManagement.SaveXMLDocumentToOutStream(ManifestOutStream,XMLRootNode);
        OfficeAddin.Modify;
    end;


    procedure GetImageUrl(ImageName: Text): Text
    var
        BaseUrl: Text;
    begin
        BaseUrl := GetUrl(Clienttype::Web);
        if StrPos(BaseUrl,'?') > 0 then
          BaseUrl := CopyStr(BaseUrl,1,StrPos(BaseUrl,'?') - 1);

        exit(StrSubstNo('%1/Resources/Images/%2',BaseUrl,ImageName));
    end;


    procedure GetAppID(OfficeAddIn: Record "Office Add-in"): Text
    var
        XMLFoundNodes: dotnet XmlNodeList;
    begin
        GetXmlNodes(OfficeAddIn,XMLFoundNodes,'x:Id');
        exit(XMLFoundNodes.Item(0).InnerText)
    end;


    procedure GetAppName(OfficeAddIn: Record "Office Add-in"): Text[50]
    var
        XMLFoundNodes: dotnet XmlNodeList;
    begin
        GetXmlNodes(OfficeAddIn,XMLFoundNodes,'x:DisplayName');
        exit(XMLFoundNodes.Item(0).Attributes.ItemOf('DefaultValue').Value)
    end;


    procedure GetAppDescription(OfficeAddIn: Record "Office Add-in"): Text[250]
    var
        XMLFoundNodes: dotnet XmlNodeList;
    begin
        GetXmlNodes(OfficeAddIn,XMLFoundNodes,'x:Description');
        exit(XMLFoundNodes.Item(0).Attributes.ItemOf('DefaultValue').Value)
    end;


    procedure GetAppVersion(OfficeAddIn: Record "Office Add-in"): Text[20]
    var
        XMLFoundNodes: dotnet XmlNodeList;
    begin
        GetXmlNodes(OfficeAddIn,XMLFoundNodes,'x:Version');
        exit(XMLFoundNodes.Item(0).InnerText)
    end;

    local procedure GetXmlNodes(OfficeAddin: Record "Office Add-in";var XMLFoundNodes: dotnet XmlNodeList;NodeName: Text)
    var
        XMLDomManagement: Codeunit "XML DOM Management";
        ManifestInStream: InStream;
        XMLRootNode: dotnet XmlNode;
        XMLNamespaceMgr: dotnet XmlNamespaceManager;
    begin
        with OfficeAddin do begin
          "Default Manifest".CreateInstream(ManifestInStream,Textencoding::UTF8);

          XMLDomManagement.LoadXMLNodeFromInStream(ManifestInStream,XMLRootNode);
          GetManifestNamespaceManager(XMLRootNode,XMLNamespaceMgr);

          if not XMLDomManagement.FindNodesWithNamespaceManager(XMLRootNode,NodeName,XMLNamespaceMgr,XMLFoundNodes) then
            Error(MissingNodeErr,NodeName);
        end;
    end;

    local procedure VerifyHttps()
    var
        WebClientUrl: Text;
    begin
        WebClientUrl := ConstructURL('','','');
        if (not TestMode) and (Lowercase(CopyStr(WebClientUrl,1,5)) <> 'https') then
          Error(StrSubstNo(WebClientHttpsErr,ProductName.Short));
    end;

    local procedure RestructureManifest(var OfficeAddin: Record "Office Add-in")
    var
        XMLDomManagement: Codeunit "XML DOM Management";
        XMLRootNode: dotnet XmlNode;
        ManifestInStream: InStream;
        ManifestOutStream: OutStream;
    begin
        OfficeAddin.CalcFields(Manifest);
        OfficeAddin.Manifest.CreateInstream(ManifestInStream,Textencoding::UTF8);
        OfficeAddin.Manifest.CreateOutstream(ManifestOutStream,Textencoding::UTF8);
        XMLDomManagement.LoadXMLNodeFromInStream(ManifestInStream,XMLRootNode);
        Clear(OfficeAddin.Manifest);
        XMLDomManagement.SaveXMLDocumentToOutStream(ManifestOutStream,XMLRootNode);
        OfficeAddin.Modify;
    end;


    procedure SetTestMode(NewTestMode: Boolean)
    begin
        TestMode := NewTestMode;
    end;


    procedure XMLEncode(Value: Text) Encoded: Text
    var
        SystemWebHttpUtility: dotnet HttpUtility;
    begin
        SystemWebHttpUtility := SystemWebHttpUtility.HttpUtility;
        Encoded := SystemWebHttpUtility.HtmlEncode(Value);
    end;
}

