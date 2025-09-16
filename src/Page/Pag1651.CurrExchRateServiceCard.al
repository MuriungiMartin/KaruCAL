#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1651 "Curr. Exch. Rate Service Card"
{
    Caption = 'Currency Exch. Rate Service';
    PromotedActionCategories = 'New,Process,Report,Setup';
    SourceTable = "Curr. Exch. Rate Update Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code";Code)
                {
                    ApplicationArea = Suite;
                    Editable = EditableByNotEnabled;
                    ToolTip = 'Specifies the setup of a service to update currency exchange rates.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Suite;
                    Editable = EditableByNotEnabled;
                    ToolTip = 'Specifies the setup of a service to update currency exchange rates.';
                }
                field(Enabled;Enabled)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies if the currency exchange rate service is enabled. Only one service can be enabled at a time.';

                    trigger OnValidate()
                    begin
                        EditableByNotEnabled := not Enabled;
                        CurrPage.Update;
                    end;
                }
                field(ShowEnableWarning;ShowEnableWarning)
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Enabled = not EditableByNotEnabled;

                    trigger OnDrillDown()
                    begin
                        DrilldownCode;
                    end;
                }
            }
            group(Service)
            {
                Caption = 'Service';
                field(ServiceURL;WebServiceURL)
                {
                    ApplicationArea = Suite;
                    Caption = 'Service URL';
                    Editable = EditableByNotEnabled;
                    MultiLine = true;
                    ToolTip = 'Specifies if the currency exchange rate service is enabled. Only one service can be enabled at a time.';

                    trigger OnValidate()
                    begin
                        SetWebServiceURL(WebServiceURL);
                        GenerateXMLStructure;
                    end;
                }
                field("Service Provider";"Service Provider")
                {
                    ApplicationArea = Suite;
                    Editable = EditableByNotEnabled;
                    ToolTip = 'Specifies the name of the service provider.';
                }
                field("Terms of Service";"Terms of Service")
                {
                    ApplicationArea = Suite;
                    Editable = EditableByNotEnabled;
                    ToolTip = 'Specifies the URL of the service provider''s terms of service.';
                }
                field("Log Web Requests";"Log Web Requests")
                {
                    ApplicationArea = Suite;
                    Editable = EditableByNotEnabled;
                    ToolTip = 'Specifies if web requests occurring in connection with the service are logged. The log is located in the server Temp folder.';
                }
            }
            part(SimpleDataExchSetup;"Data Exch. Setup Subform")
            {
                ApplicationArea = Suite;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Preview)
            {
                ApplicationArea = Suite;
                Caption = 'Preview';
                Image = ReviewWorksheet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Test the setup of the currency exchange rate service to make sure the service is working.';

                trigger OnAction()
                var
                    TempCurrencyExchangeRate: Record "Currency Exchange Rate" temporary;
                    UpdateCurrencyExchangeRates: Codeunit "Update Currency Exchange Rates";
                begin
                    TestField(Code);
                    VerifyServiceURL;
                    VerifyDataExchangeLineDefinition;
                    UpdateCurrencyExchangeRates.GenerateTempDataFromService(TempCurrencyExchangeRate,Rec);
                    Page.Run(Page::"Currency Exchange Rates",TempCurrencyExchangeRate);
                end;
            }
            action(JobQueueEntry)
            {
                ApplicationArea = Suite;
                Caption = 'Job Queue Entry';
                Enabled = Enabled;
                Image = JobListSetup;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'View or edit the job that updates the exchange rates from the service. For example, you can see the status or change how often rates are updated.';

                trigger OnAction()
                begin
                    ShowJobQueueEntry;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        GetWebServiceURL(WebServiceURL);
        if WebServiceURL <> '' then
          GenerateXMLStructure;

        UpdateSimpleMappingsPart;
        UpdateBasedOnEnable;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        TempField: Record "Field" temporary;
        MapCurrencyExchangeRate: Codeunit "Map Currency Exchange Rate";
    begin
        MapCurrencyExchangeRate.GetSuggestedFields(TempField);
        CurrPage.SimpleDataExchSetup.Page.SetSuggestedField(TempField);
        UpdateSimpleMappingsPart;
    end;

    trigger OnOpenPage()
    begin
        Codeunit.Run(Codeunit::"Check App. Area Only Basic");

        UpdateBasedOnEnable;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if not Enabled then
          if not Confirm(StrSubstNo(EnableServiceQst,CurrPage.Caption),true) then
            exit(false);
    end;

    var
        TempXMLBuffer: Record "XML Buffer" temporary;
        WebServiceURL: Text;
        EditableByNotEnabled: Boolean;
        EnabledWarningTok: label 'You must disable the service before you can make changes.';
        DisableEnableQst: label 'Do you want to disable currency exchange rate service?';
        ShowEnableWarning: Text;
        EnableServiceQst: label 'The %1 is not enabled. Are you sure you want to exit?', Comment='%1 = This Page Caption (Currency Exch. Rate Service)';
        XmlStructureIsNotSupportedErr: label ' The provided url does not contain a supported structure.';

    local procedure UpdateSimpleMappingsPart()
    begin
        CurrPage.SimpleDataExchSetup.Page.SetDataExchDefCode("Data Exch. Def Code");
        CurrPage.SimpleDataExchSetup.Page.UpdateData;
        CurrPage.SimpleDataExchSetup.Page.Update(false);
        CurrPage.SimpleDataExchSetup.Page.SetSourceToBeMandatory("Web Service URL".Hasvalue);
    end;

    local procedure GenerateXMLStructure()
    begin
        TempXMLBuffer.Reset;
        TempXMLBuffer.DeleteAll;
        if GetXMLStructure(TempXMLBuffer,WebServiceURL) then begin
          TempXMLBuffer.Reset;
          CurrPage.SimpleDataExchSetup.Page.SetXMLDefinition(TempXMLBuffer);
        end else
          Error(XmlStructureIsNotSupportedErr);
    end;

    local procedure UpdateBasedOnEnable()
    begin
        EditableByNotEnabled := not Enabled;
        ShowEnableWarning := '';
        if CurrPage.Editable and Enabled then
          ShowEnableWarning := EnabledWarningTok;
    end;

    local procedure DrilldownCode()
    begin
        if Confirm(DisableEnableQst,true) then begin
          Enabled := false;
          UpdateBasedOnEnable;
          CurrPage.Update;
        end;
    end;
}

