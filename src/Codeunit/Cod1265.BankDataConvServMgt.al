#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1265 "Bank Data Conv. Serv. Mgt."
{
    Permissions = TableData "Bank Data Conv. Service Setup"=r;

    trigger OnRun()
    begin
    end;

    var
        MissingCredentialsQst: label 'The %1 is missing the user name or password. Do you want to open the %1 page?';
        MissingCredentialsErr: label 'The user name and password must be filled in %1 page.';
        ResultPathTxt: label '/amc:%1/return/syslog[syslogtype[text()="error"]]', Locked=true;
        FinstaPathTxt: label '/amc:%1/return/finsta/transactions', Locked=true;
        HeaderErrPathTxt: label '/amc:%1/return/header/result[text()="error"]', Locked=true;
        ConvErrPathTxt: label '/amc:%1/return/pack/convertlog[syslogtype[text()="error"]]', Locked=true;
        DataPathTxt: label '/amc:%1/return/pack/data/text()', Locked=true;


    procedure InitDefaultURLs(var BankDataConvServiceSetup: Record "Bank Data Conv. Service Setup")
    begin
        BankDataConvServiceSetup."Sign-up URL" := 'http://www.amcbanking.dk/nav/register';
        BankDataConvServiceSetup."Service URL" := 'https://nav.amcbanking.com/nav02';
        BankDataConvServiceSetup."Support URL" := 'http://www.amcbanking.dk/nav/support';
    end;


    procedure SetURLsToDefault(var BankDataConvServiceSetup: Record "Bank Data Conv. Service Setup")
    begin
        InitDefaultURLs(BankDataConvServiceSetup);
        BankDataConvServiceSetup.Modify;
    end;


    procedure GetNamespace(): Text
    begin
        exit('http://nav02.soap.xml.link.amc.dk/');
    end;


    procedure GetSupportURL(XmlNode: dotnet XmlNode): Text
    var
        BankDataConvServiceSetup: Record "Bank Data Conv. Service Setup";
        XMLDOMMgt: Codeunit "XML DOM Management";
        SupportURL: Text;
    begin
        SupportURL := XMLDOMMgt.FindNodeText(XmlNode,'url');
        if SupportURL <> '' then
          exit(SupportURL);

        BankDataConvServiceSetup.Get;
        exit(BankDataConvServiceSetup."Support URL");
    end;


    procedure CheckCredentials()
    var
        BankDataConvServiceSetup: Record "Bank Data Conv. Service Setup";
        CompanyInformationMgt: Codeunit "Company Information Mgt.";
    begin
        if not BankDataConvServiceSetup.Get or (not BankDataConvServiceSetup.HasPassword) or (not BankDataConvServiceSetup.HasUserName)
        then begin
          if CompanyInformationMgt.IsDemoCompany then begin
            BankDataConvServiceSetup.DeleteAll(true);
            BankDataConvServiceSetup.Init;
            BankDataConvServiceSetup.Insert(true);
          end else
            if Confirm(StrSubstNo(MissingCredentialsQst,BankDataConvServiceSetup.TableCaption),true) then begin
              Commit;
              Page.RunModal(Page::"Bank Data Conv. Service Setup",BankDataConvServiceSetup);
            end;

          if not BankDataConvServiceSetup.Get or not BankDataConvServiceSetup.HasPassword then
            Error(MissingCredentialsErr,BankDataConvServiceSetup.TableCaption);
        end;
    end;


    procedure GetErrorXPath(ResponseNode: Text): Text
    begin
        exit(StrSubstNo(ResultPathTxt,ResponseNode));
    end;


    procedure GetFinstaXPath(ResponseNode: Text): Text
    begin
        exit(StrSubstNo(FinstaPathTxt,ResponseNode));
    end;


    procedure GetHeaderErrXPath(ResponseNode: Text): Text
    begin
        exit(StrSubstNo(HeaderErrPathTxt,ResponseNode));
    end;


    procedure GetConvErrXPath(ResponseNode: Text): Text
    begin
        exit(StrSubstNo(ConvErrPathTxt,ResponseNode));
    end;


    procedure GetDataXPath(ResponseNode: Text): Text
    begin
        exit(StrSubstNo(DataPathTxt,ResponseNode));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Service Connection", 'OnRegisterServiceConnection', '', false, false)]

    procedure HandleBankDataConvRegisterServiceConnection(var ServiceConnection: Record "Service Connection")
    var
        BankDataConvServiceSetup: Record "Bank Data Conv. Service Setup";
        RecRef: RecordRef;
    begin
        if not BankDataConvServiceSetup.Get then
          BankDataConvServiceSetup.Insert(true);
        RecRef.GetTable(BankDataConvServiceSetup);

        ServiceConnection.Status := ServiceConnection.Status::Enabled;
        with BankDataConvServiceSetup do begin
          if "Service URL" = '' then
            ServiceConnection.Status := ServiceConnection.Status::Disabled;

          ServiceConnection.InsertServiceConnection(
            ServiceConnection,RecRef.RecordId,TableName,"Service URL",Page::"Bank Data Conv. Service Setup");
        end;
    end;
}

