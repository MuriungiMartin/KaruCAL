#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5338 "Integration Synch. Job List"
{
    ApplicationArea = Basic;
    Caption = 'Integration Synchronization Jobs';
    DeleteAllowed = true;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Integration Synch. Job";
    SourceTableView = sorting("Start Date/Time",ID)
                      order(descending);
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Start Date/Time";"Start Date/Time")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the data and time that the integration synchronization job started.';
                }
                field("Finish Date/Time";"Finish Date/Time")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date and time that the integration synchronization job completed.';
                }
                field(Duration;Duration)
                {
                    ApplicationArea = Suite;
                    Caption = 'Duration';
                    HideValue = DoHideDuration;
                    ToolTip = 'Specifies how long the data synchronization has taken.';
                }
                field("Integration Table Mapping Name";"Integration Table Mapping Name")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the name of the table mapping that was used for the integration synchronization job.';
                    Visible = false;
                }
                field(Inserted;Inserted)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of new records that were created in the destination database table (such as the Microsoft Dynamics CRM Account entity or Microsoft Dynamics NAV Customer table) by the integration synchronization job.';
                }
                field(Modified;Modified)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of records that were modified in the destination database table (such as the Microsoft Dynamics CRM Account entity or Microsoft Dynamics NAV Customer table) by the integration synchronization job.';
                }
                field(Unchanged;Unchanged)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of records that were not changed in the destination database table (such as the Microsoft Dynamics CRM Account entity or Microsoft Dynamics NAV Customer table) by the integration synchronization job.';
                }
                field(Failed;Failed)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of errors that occurred during the integration synchronization job.';

                    trigger OnDrillDown()
                    var
                        IntegrationSynchJobErrors: Record "Integration Synch. Job Errors";
                    begin
                        IntegrationSynchJobErrors.SetCurrentkey("Date/Time","Integration Synch. Job ID");
                        IntegrationSynchJobErrors.Ascending := false;

                        IntegrationSynchJobErrors.FilterGroup(2);
                        IntegrationSynchJobErrors.SetRange("Integration Synch. Job ID",ID);
                        IntegrationSynchJobErrors.FilterGroup(0);

                        IntegrationSynchJobErrors.FindFirst;
                        Page.Run(Page::"Integration Synch. Error List",IntegrationSynchJobErrors);
                    end;
                }
                field(Direction;SynchDirection)
                {
                    ApplicationArea = Suite;
                    Caption = 'Direction';
                    ToolTip = 'Specifies in which direction data is synchronized.';
                }
                field(Message;Message)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a message that occurred as a result of the integration synchronization job.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Delete7days)
            {
                ApplicationArea = Basic;
                Caption = 'Delete Entries Older Than 7 Days';
                Enabled = HasRecords;
                Image = ClearLog;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    DeleteEntries(7);
                end;
            }
            action(Delete0days)
            {
                ApplicationArea = Basic;
                Caption = 'Delete All Entries';
                Enabled = HasRecords;
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    DeleteEntries(0);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        TableMetadata: Record "Table Metadata";
    begin
        IntegrationTableMapping.Get("Integration Table Mapping Name");
        TableMetadata.Get(IntegrationTableMapping."Table ID");
        if "Synch. Direction" = "synch. direction"::ToIntegrationTable then
          SynchDirection := StrSubstNo(SynchDirectionTxt,TableMetadata.Caption,IntegrationTableMapping.GetExtendedIntegrationTableCaption)
        else
          SynchDirection :=
            StrSubstNo(SynchDirectionTxt,IntegrationTableMapping.GetExtendedIntegrationTableCaption,TableMetadata.Caption);

        DoHideDuration := "Finish Date/Time" < "Start Date/Time";
        if DoHideDuration then
          Clear(Duration)
        else
          Duration := "Finish Date/Time" - "Start Date/Time";

        HasRecords := not IsEmpty;
    end;

    var
        SynchDirectionTxt: label '%1 to %2.', Comment='%1 = Source table caption, %2 = Destination table caption';
        SynchDirection: Text;
        DoHideDuration: Boolean;
        Duration: Duration;
        HasRecords: Boolean;
}

