#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5335 "Integration Table Mapping List"
{
    ApplicationArea = Basic;
    Caption = 'Integration Table Mappings';
    InsertAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Synchronization,Mapping';
    SourceTable = "Integration Table Mapping";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name;Name)
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the name of the integration table mapping entry.';
                }
                field(TableCaptionValue;TableCaptionValue)
                {
                    ApplicationArea = Suite;
                    Caption = 'Table';
                    Editable = false;
                    ToolTip = 'Specifies the name of the business data table in Microsoft Dynamics NAV to map to the integration table.';
                }
                field(TableFilterValue;TableFilter)
                {
                    ApplicationArea = Suite;
                    Caption = 'Table Filter';
                    ToolTip = 'Specifies a filter on the business data table in Microsoft Dynamics NAV to control which records can be synchronized with the corresponding records in the integration table that is specified by the Integration Table ID field.';

                    trigger OnAssistEdit()
                    var
                        FilterPageBuilder: FilterPageBuilder;
                    begin
                        FilterPageBuilder.AddTable(TableCaptionValue,"Table ID");
                        if TableFilter <> '' then
                          FilterPageBuilder.SetView(TableCaptionValue,TableFilter);
                        if FilterPageBuilder.RunModal then begin
                          TableFilter := FilterPageBuilder.GetView(TableCaptionValue,true);
                          SetTableFilter(TableFilter);
                        end;
                    end;
                }
                field(Direction;Direction)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the synchronization direction.';
                }
                field(IntegrationTableCaptionValue;IntegrationTableCaptionValue)
                {
                    ApplicationArea = Suite;
                    Caption = 'Integration Table';
                    Enabled = false;
                    ToolTip = 'Specifies the ID of the integration table to map to the business table.';
                }
                field(IntegrationFieldCaption;IntegrationFieldCaptionValue)
                {
                    ApplicationArea = Suite;
                    Caption = 'Integration Field';
                    Editable = false;
                    ToolTip = 'Specifies the ID of the field in the integration table to map to the business table.';

                    trigger OnDrillDown()
                    var
                        CRMOptionMapping: Record "CRM Option Mapping";
                        "Field": Record "Field";
                    begin
                        if "Int. Table UID Field Type" = Field.Type::Option then begin
                          CRMOptionMapping.FilterGroup(2);
                          CRMOptionMapping.SetRange("Table ID","Table ID");
                          CRMOptionMapping.FilterGroup(0);
                          Page.RunModal(Page::"CRM Option Mapping",CRMOptionMapping);
                        end;
                    end;
                }
                field(IntegrationFieldType;IntegrationFieldTypeValue)
                {
                    ApplicationArea = Suite;
                    Caption = 'Integration Field Type';
                    Editable = false;
                    ToolTip = 'Specifies the type of the field in the integration table to map to the business table.';
                }
                field(IntegrationTableFilter;IntegrationTableFilter)
                {
                    ApplicationArea = Suite;
                    Caption = 'Integration Table Filter';
                    ToolTip = 'Specifies a filter on the integration table to control which records can be synchronized with the corresponding records in the business data table that is specified by the Table field.';

                    trigger OnAssistEdit()
                    var
                        FilterPageBuilder: FilterPageBuilder;
                    begin
                        FilterPageBuilder.AddTable(IntegrationTableCaptionValue,"Integration Table ID");
                        if IntegrationTableFilter <> '' then
                          FilterPageBuilder.SetView(IntegrationTableCaptionValue,IntegrationTableFilter);
                        if FilterPageBuilder.RunModal then begin
                          IntegrationTableFilter := FilterPageBuilder.GetView(IntegrationTableCaptionValue,true);
                          SetIntegrationTableFilter(IntegrationTableFilter);
                        end;
                    end;
                }
                field("Table Config Template Code";"Table Config Template Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a configuration template to use when creating new records in the Microsoft Dynamics NAV business table (specified by the Table ID field) during synchronization.';
                }
                field("Int. Tbl. Config Template Code";"Int. Tbl. Config Template Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a configuration template to use for creating new records in the external database table, such as Microsoft Dynamics CRM.';
                }
                field("Synch. Only Coupled Records";"Synch. Only Coupled Records")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies how to handle uncoupled records in Microsoft Dynamics CRM entities and Microsoft Dynamics NAV tables when synchronization is performed by an integration synchronization job.';
                }
                field("Int. Tbl. Caption Prefix";"Int. Tbl. Caption Prefix")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies text that appears before the caption of the integration table wherever the caption is used.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(FieldMapping)
            {
                ApplicationArea = Basic;
                Caption = 'Fields';
                Enabled = HasRecords;
                Image = Relationship;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = Page "Integration Field Mapping List";
                RunPageLink = "Integration Table Mapping Name"=field(Name);
                RunPageMode = View;
                ToolTip = 'View fields in Dynamics CRM integration tables that are mapped to fields in Dynamics NAV.';
            }
            action("View Integration Synch. Job Log")
            {
                ApplicationArea = Basic;
                Caption = 'Integration Synch. Job Log';
                Enabled = HasRecords;
                Image = Log;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunPageMode = View;

                trigger OnAction()
                var
                    IntegrationSynchJob: Record "Integration Synch. Job";
                begin
                    if IsEmpty then
                      exit;

                    IntegrationSynchJob.SetCurrentkey("Start Date/Time",ID);
                    IntegrationSynchJob.Ascending := false;
                    IntegrationSynchJob.FilterGroup(2);
                    IntegrationSynchJob.SetRange("Integration Table Mapping Name",Name);
                    IntegrationSynchJob.FilterGroup(0);
                    IntegrationSynchJob.FindFirst;
                    Page.Run(Page::"Integration Synch. Job List",IntegrationSynchJob);
                end;
            }
            action(SynchronizeNow)
            {
                ApplicationArea = Basic;
                Caption = 'Synchronize Modified Records';
                Enabled = HasRecords and ("Parent Name" = '');
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Synchronize records that have been modified since the last time they were synchronized.';

                trigger OnAction()
                var
                    IntegrationSynchJobList: Page "Integration Synch. Job List";
                begin
                    if IsEmpty then
                      exit;

                    SynchronizeNow(false);
                    Message(SynchronizedModifiedCompletedMsg,IntegrationSynchJobList.Caption);
                end;
            }
            action(SynchronizeAll)
            {
                ApplicationArea = Basic;
                Caption = 'Run Full Synchronization';
                Enabled = HasRecords and ("Parent Name" = '');
                Image = RefreshLines;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Start all the default integration jobs for synchronizing Dynamics NAV record types and Dynamics CRM entities, as defined in the Integration Table Mappings window.';

                trigger OnAction()
                var
                    IntegrationSynchJobList: Page "Integration Synch. Job List";
                begin
                    if IsEmpty then
                      exit;

                    if not Confirm(StartFullSynchronizationQst) then
                      exit;
                    SynchronizeNow(true);
                    Message(FullSynchronizationCompletedMsg,IntegrationSynchJobList.Caption);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IntegrationTableCaptionValue := ObjectTranslation.TranslateObject(ObjectTranslation."object type"::Table,"Integration Table ID");
        TableCaptionValue := ObjectTranslation.TranslateObject(ObjectTranslation."object type"::Table,"Table ID");
        IntegrationFieldCaptionValue := GetFieldCaption;
        IntegrationFieldTypeValue := GetFieldType;

        TableFilter := GetTableFilter;
        IntegrationTableFilter := GetIntegrationTableFilter;

        HasRecords := not IsEmpty;
    end;

    var
        ObjectTranslation: Record "Object Translation";
        TableCaptionValue: Text[250];
        IntegrationFieldCaptionValue: Text;
        IntegrationFieldTypeValue: Text;
        IntegrationTableCaptionValue: Text[250];
        TableFilter: Text;
        IntegrationTableFilter: Text;
        StartFullSynchronizationQst: label 'You are about synchronize all data within the mapping. This process may take several minutes.\\Do you want to continue?';
        SynchronizedModifiedCompletedMsg: label 'Synchronized Modified Records completed.\See the %1 window for details.', Comment='%1 caption from page 5338';
        FullSynchronizationCompletedMsg: label 'Full Synchronization completed.\See the %1 window for details.', Comment='%1 caption from page 5338';
        HasRecords: Boolean;

    local procedure GetFieldCaption(): Text
    var
        "Field": Record "Field";
    begin
        if Field.Get("Integration Table ID","Integration Table UID Fld. No.") then
          exit(Field."Field Caption");
    end;

    local procedure GetFieldType(): Text
    var
        "Field": Record "Field";
    begin
        Field.Type := "Int. Table UID Field Type";
        exit(Format(Field.Type))
    end;
}

