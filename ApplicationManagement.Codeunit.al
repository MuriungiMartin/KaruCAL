#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1 ApplicationManagement
{

    trigger OnRun()
    begin
    end;

    var
        DebuggerManagement: Codeunit "Sequence No. Mgt.";
        LogInManagement: Codeunit LogInManagement;
        TextManagement: Codeunit "Filter Tokens";
        CaptionManagement: Codeunit "Caption Class";
        LanguageManagement: Codeunit Language;
        AutoFormatManagement: Codeunit "Auto Format";
        NotSupportedErr: label 'The value is not supported.';


    procedure CompanyOpen()
    begin
        // This needs to be the very first thing to run before company open
        Codeunit.Run(Codeunit::"Azure AD User Management");
        OnBeforeCompanyOpen;
        LogInManagement.CompanyOpen;
        OnAfterCompanyOpen;
    end;


    procedure GetSystemIndicator(var Text: Text[250];var Style: Option Standard,Accent1,Accent2,Accent3,Accent4,Accent5,Accent6,Accent7,Accent8,Accent9)
    var
        CompanyInformation: Record "Company Information";
    begin
        if CompanyInformation.Get then
          CompanyInformation.GetSystemIndicator(Text,Style);
        OnAfterGetSystemIndicator(Text,Style);
    end;


    procedure CompanyClose()
    begin
        OnBeforeCompanyClose;
        LogInManagement.CompanyClose;
        OnAfterCompanyClose;
    end;


    procedure FindPrinter(ReportID: Integer): Text[250]
    var
        PrinterSelection: Record "Printer Selection";
        PrinterName: Text[250];
    begin
        Clear(PrinterSelection);

        if not PrinterSelection.Get(UserId,ReportID) then
          if not PrinterSelection.Get('',ReportID) then
            if not PrinterSelection.Get(UserId,0) then
              if PrinterSelection.Get('',0) then;
        PrinterName := PrinterSelection."Printer Name";
        OnAfterFindPrinter(ReportID,PrinterName);
        exit(PrinterName);
    end;


    procedure ApplicationVersion(): Text[80]
    var
        AppVersion: Text[80];
    begin
        AppVersion := CustomApplicationVersion('US Dynamics NAV 10.0');
        OnAfterGetApplicationVersion(AppVersion);
        exit(AppVersion);
    end;

    local procedure CustomApplicationVersion(BaseBuildVersion: Text[80]): Text[80]
    begin
        exit(BaseBuildVersion);
    end;


    procedure ApplicationBuild(): Text[80]
    begin
        exit(CustomApplicationBuild('13682'));
    end;

    local procedure CustomApplicationBuild(BaseBuildNumber: Text[80]): Text[80]
    begin
        exit(BaseBuildNumber);
    end;


    procedure ApplicationLanguage(): Integer
    begin
        exit(1033);
    end;


    procedure DefaultRoleCenter(): Integer
    var
        ConfPersMgt: Codeunit "Conf./Personalization Mgt.";
        DefaultRoleCenterID: Integer;
    begin
        DefaultRoleCenterID := ConfPersMgt.DefaultRoleCenterID;
        OnAfterGetDefaultRoleCenter(DefaultRoleCenterID);
        exit(DefaultRoleCenterID);
    end;


    procedure MakeDateTimeText(var DateTimeText: Text[250]): Integer
    begin
        exit(TextManagement.MakeDateTimeText(DateTimeText));
    end;


    procedure GetSeparateDateTime(DateTimeText: Text[250];var Date: Date;var Time: Time): Boolean
    begin
        exit(TextManagement.GetSeparateDateTime(DateTimeText,Date,Time));
    end;


    procedure MakeDateText(var DateText: Text[250]): Integer
    var
        Position: Integer;
    begin
        Position := TextManagement.MakeDateText(DateText);
        OnAfterMakeDateText(Position,DateText);
        exit(Position);
    end;


    procedure MakeTimeText(var TimeText: Text[250]): Integer
    var
        Position: Integer;
    begin
        Position := TextManagement.MakeTimeText(TimeText);
        OnAfterMakeTimeText(Position,TimeText);
        exit(Position);
    end;


    procedure MakeText(var Text: Text[250]): Integer
    var
        Position: Integer;
    begin
        Position := TextManagement.MakeText(Text);
        OnAfterMakeText(Position,Text);
        exit(Position);
    end;


    procedure MakeDateTimeFilter(var DateTimeFilterText: Text[250]): Integer
    var
        Position: Integer;
    begin
        Position := TextManagement.MakeDateTimeFilter(DateTimeFilterText);
        OnAfterMakeDateTimeFilter(Position,DateTimeFilterText);
        exit(Position);
    end;


    procedure MakeDateFilter(var DateFilterText: Text): Integer
    var
        Position: Integer;
    begin
        Position := TextManagement.MakeDateFilter(DateFilterText);
        OnAfterMakeDateFilter(Position,DateFilterText);
        exit(Position);
    end;


    procedure MakeTextFilter(var TextFilterText: Text): Integer
    var
        Position: Integer;
    begin
        Position := TextManagement.MakeTextFilter(TextFilterText);
        OnAfterMakeTextFilter(Position,TextFilterText);
        exit(Position);
    end;


    procedure MakeCodeFilter(var TextFilterText: Text): Integer
    var
        Position: Integer;
    begin
        Position := TextManagement.MakeTextFilter(TextFilterText);
        OnAfterMakeCodeFilter(Position,TextFilterText);
        exit(Position);
    end;


    procedure MakeTimeFilter(var TimeFilterText: Text[250]): Integer
    var
        Position: Integer;
    begin
        Position := TextManagement.MakeTimeFilter(TimeFilterText);
        OnAfterMakeTimeFilter(Position,TimeFilterText);
        exit(Position);
    end;


    procedure AutoFormatTranslate(AutoFormatType: Integer;AutoFormatExpr: Text[80]): Text[80]
    var
        AutoFormatTranslation: Text[80];
    begin
        AutoFormatTranslation := AutoFormatManagement.AutoFormatTranslate(AutoFormatType,AutoFormatExpr);
        OnAfterAutoFormatTranslate(AutoFormatType,AutoFormatExpr,AutoFormatTranslation);
        exit(AutoFormatTranslation);
    end;


    procedure ReadRounding(): Decimal
    begin
        exit(AutoFormatManagement.ReadRounding);
    end;


    procedure CaptionClassTranslate(Language: Integer;CaptionExpr: Text[1024]): Text[1024]
    var
        Caption: Text[1024];
    begin
        Caption := CaptionManagement.CaptionClassTranslate(Language,CaptionExpr);
        OnAfterCaptionClassTranslate(Language,CaptionExpr,Caption);
        exit(Caption);
    end;


    procedure GetCueStyle(TableId: Integer;FieldNo: Integer;CueValue: Decimal): Text
    var
        CueSetup: Codeunit "Cues And KPIs";
    begin
        exit(CueSetup.GetCustomizedCueStyle(TableId,FieldNo,CueValue));
    end;


    procedure SetGlobalLanguage()
    begin
        LanguageManagement.SetGlobalLanguage;
    end;


    procedure ValidateApplicationlLanguage(LanguageID: Integer)
    begin
        LanguageManagement.ValidateApplicationLanguage(LanguageID);
    end;


    procedure LookupApplicationlLanguage(var LanguageID: Integer)
    begin
        LanguageManagement.LookupApplicationLanguage(LanguageID);
    end;


    procedure GetGlobalTableTriggerMask(TableID: Integer): Integer
    var
        TableTriggerMask: Integer;
    begin
        // Replaced by GetDatabaseTableTriggerSetup
        OnAfterGetGlobalTableTriggerMask(TableID,TableTriggerMask);
        exit(TableTriggerMask);
    end;


    procedure OnGlobalInsert(RecRef: RecordRef)
    begin
        // Replaced by OnDataBaseInsert. This trigger is only called from pages.
        OnAfterOnGlobalInsert(RecRef);
    end;


    procedure OnGlobalModify(RecRef: RecordRef;xRecRef: RecordRef)
    begin
        // Replaced by OnDataBaseModify. This trigger is only called from pages.
        OnAfterOnGlobalModify(RecRef,xRecRef);
    end;


    procedure OnGlobalDelete(RecRef: RecordRef)
    begin
        // Replaced by OnDataBaseDelete. This trigger is only called from pages.
        OnAfterOnGlobalDelete(RecRef);
    end;


    procedure OnGlobalRename(RecRef: RecordRef;xRecRef: RecordRef)
    begin
        // Replaced by OnDataBaseRename. This trigger is only called from pages.
        OnAfterOnGlobalRename(RecRef,xRecRef);
    end;


    procedure GetDatabaseTableTriggerSetup(TableId: Integer;var OnDatabaseInsert: Boolean;var OnDatabaseModify: Boolean;var OnDatabaseDelete: Boolean;var OnDatabaseRename: Boolean)
    var
        IntegrationManagement: Codeunit "Integration Management";
        ChangeLogMgt: Codeunit "Change Log Management";
    begin
        ChangeLogMgt.GetDatabaseTableTriggerSetup(TableId,OnDatabaseInsert,OnDatabaseModify,OnDatabaseDelete,OnDatabaseRename);
        IntegrationManagement.GetDatabaseTableTriggerSetup(TableId,OnDatabaseInsert,OnDatabaseModify,OnDatabaseDelete,OnDatabaseRename);
        OnAfterGetDatabaseTableTriggerSetup(TableId,OnDatabaseInsert,OnDatabaseModify,OnDatabaseDelete,OnDatabaseRename);
    end;


    procedure OnDatabaseInsert(RecRef: RecordRef)
    var
        IntegrationManagement: Codeunit "Integration Management";
        ChangeLogMgt: Codeunit "Change Log Management";
    begin
        ChangeLogMgt.LogInsertion(RecRef);
        IntegrationManagement.OnDatabaseInsert(RecRef);
        OnAfterOnDatabaseInsert(RecRef);
    end;


    procedure OnDatabaseModify(RecRef: RecordRef)
    var
        IntegrationManagement: Codeunit "Integration Management";
        ChangeLogMgt: Codeunit "Change Log Management";
    begin
        ChangeLogMgt.LogModification(RecRef);
        IntegrationManagement.OnDatabaseModify(RecRef);
        OnAfterOnDatabaseModify(RecRef);
    end;


    procedure OnDatabaseDelete(RecRef: RecordRef)
    var
        IntegrationManagement: Codeunit "Integration Management";
        ChangeLogMgt: Codeunit "Change Log Management";
    begin
        ChangeLogMgt.LogDeletion(RecRef);
        IntegrationManagement.OnDatabaseDelete(RecRef);
        OnAfterOnDatabaseDelete(RecRef);
    end;


    procedure OnDatabaseRename(RecRef: RecordRef;xRecRef: RecordRef)
    var
        IntegrationManagement: Codeunit "Integration Management";
        ChangeLogMgt: Codeunit "Change Log Management";
    begin
        ChangeLogMgt.LogRename(RecRef,xRecRef);
        IntegrationManagement.OnDatabaseRename(RecRef,xRecRef);
        OnAfterOnDatabaseRename(RecRef,xRecRef);
    end;


    procedure OnDebuggerBreak(ErrorMessage: Text)
    begin
        DebuggerManagement.ProcessDebuggerBreak(ErrorMessage);
    end;


    procedure LaunchDebugger()
    begin
        Page.Run(Page::"Session List");
    end;


    procedure OpenSettings()
    begin
        Page.Run(Page::"My Settings");
    end;


    procedure OpenContactMSSales()
    begin
        Page.Run(Page::"Contact MS Sales");
    end;


    procedure OpenExtensionMarketplace()
    begin
        Page.Run(Page::"Extension Marketplace");
    end;


    procedure CustomizeChart(var TempChart: Record Chart temporary): Boolean
    var
        GenericChartMgt: Codeunit "Generic Chart Mgt";
    begin
        exit(GenericChartMgt.ChartCustomization(TempChart));
    end;


    procedure HasCustomLayout(ObjectType: Option "Report","Page";ObjectID: Integer): Integer
    var
        ReportLayoutSelection: Record "Report Layout Selection";
    begin
        // Return value:
        // 0: No custom layout
        // 1: RDLC layout
        // 2: Word layout
        if ObjectType <> Objecttype::Report then
          Error(NotSupportedErr);

        exit(ReportLayoutSelection.HasCustomLayout(ObjectID));
    end;


    procedure MergeDocument(ObjectType: Option "Report","Page";ObjectID: Integer;ReportAction: Option SaveAsPdf,SaveAsWord,SaveAsExcel,Preview,Print,SaveAsHtml;XmlData: InStream;FileName: Text)
    var
        DocumentReportMgt: Codeunit "Document Report Mgt.";
    begin
        if ObjectType <> Objecttype::Report then
          Error(NotSupportedErr);

        DocumentReportMgt.MergeWordLayout(ObjectID,ReportAction,XmlData,FileName);
    end;


    procedure ReportGetCustomRdlc(ReportId: Integer): Text
    var
        CustomReportLayout: Record "Custom Report Layout";
    begin
        exit(CustomReportLayout.GetCustomRdlc(ReportId));
    end;


    procedure ReportScheduler(ReportId: Integer;RequestPageXml: Text): Boolean
    var
        ScheduleAReport: Page "Schedule a Report";
    begin
        exit(ScheduleAReport.ScheduleAReport(ReportId,RequestPageXml));
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetApplicationVersion(var AppVersion: Text[80])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCompanyOpen()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCompanyOpen()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCompanyClose()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCompanyClose()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetSystemIndicator(var Text: Text[250];var Style: Option Standard,Accent1,Accent2,Accent3,Accent4,Accent5,Accent6,Accent7,Accent8,Accent9)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterFindPrinter(ReportID: Integer;var PrinterName: Text[250])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetDefaultRoleCenter(var DefaultRoleCenterID: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterMakeDateText(var Position: Integer;var DateText: Text[250])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterMakeTimeText(var Position: Integer;var TimeText: Text[250])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterMakeText(var Position: Integer;var Text: Text[250])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterMakeDateTimeFilter(var Position: Integer;var DateTimeFilterText: Text[250])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterMakeDateFilter(var Position: Integer;var DateFilterText: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterMakeTextFilter(var Position: Integer;var TextFilterText: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterMakeCodeFilter(var Position: Integer;var TextFilterText: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterMakeTimeFilter(var Position: Integer;var TimeFilterText: Text[250])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAutoFormatTranslate(AutoFormatType: Integer;AutoFormatExpression: Text[80];var AutoFormatTranslation: Text[80])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCaptionClassTranslate(Language: Integer;CaptionExpression: Text[1024];var Caption: Text[1024])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetGlobalTableTriggerMask(TableID: Integer;var TableTriggerMask: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnGlobalInsert(RecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnGlobalModify(RecRef: RecordRef;xRecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnGlobalDelete(RecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnGlobalRename(RecRef: RecordRef;xRecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetDatabaseTableTriggerSetup(TableId: Integer;var OnDatabaseInsert: Boolean;var OnDatabaseModify: Boolean;var OnDatabaseDelete: Boolean;var OnDatabaseRename: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnDatabaseInsert(RecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnDatabaseModify(RecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnDatabaseDelete(RecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnDatabaseRename(RecRef: RecordRef;xRecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnEditInExcel(ObjectId: Integer)
    begin
    end;
}

