#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5339 "Integration Synch. Error List"
{
    ApplicationArea = Basic;
    Caption = 'Integration Synchronization Errors';
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Integration Synch. Job Errors";
    SourceTableView = sorting("Date/Time","Integration Synch. Job ID")
                      order(descending);
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the sequential number that is assigned to the synchronization job error.';
                }
                field("Date/Time";"Date/Time")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date and time that the error in the integration synchronization job occurred.';
                }
                field(Message;Message)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the error that occurred in the integration synchronization job.';
                    Width = 100;
                }
                field("Exception Detail";"Exception Detail")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the exception that occurred in the integration synchronization job.';
                }
                field(Source;OpenSourcePageTxt)
                {
                    ApplicationArea = Suite;
                    Caption = 'Source';
                    ToolTip = 'Specifies the record that supplied the data to destination record in integration synchronization job that failed.';

                    trigger OnDrillDown()
                    var
                        OpenRecordID: RecordID;
                    begin
                        OpenRecordID := "Source Record ID";
                        ShowPage(OpenRecordID);
                    end;
                }
                field(Destination;OpenDestinationPageTxt)
                {
                    ApplicationArea = Suite;
                    Caption = 'Destination';
                    ToolTip = 'Specifies the record that received the data from the source record in integration synchronization job that failed.';

                    trigger OnDrillDown()
                    var
                        OpenRecordID: RecordID;
                    begin
                        OpenRecordID := "Destination Record ID";
                        ShowPage(OpenRecordID);
                    end;
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
            group(ActionGroupCRM)
            {
                Caption = 'Dynamics CRM';
                action(CRMSynchronizeNow)
                {
                    ApplicationArea = Basic;
                    Caption = 'Synchronize Now';
                    Enabled = HasRecords;
                    Image = Refresh;
                    ToolTip = 'Send or get updated data to or from Microsoft Dynamics CRM.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                        LocalRecordID: RecordID;
                    begin
                        if IsEmpty then
                          exit;

                        GetRecordID(LocalRecordID);
                        CRMIntegrationManagement.UpdateOneNow(LocalRecordID);
                    end;
                }
                group(Coupling)
                {
                    Caption = 'Coupling', Comment='Coupling is a noun';
                    Image = LinkAccount;
                    ToolTip = 'Create, change, or delete a coupling between the Microsoft Dynamics NAV record and a Microsoft Dynamics CRM record.';
                    action(ManageCRMCoupling)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Set Up Coupling';
                        Enabled = HasRecords;
                        Image = LinkAccount;
                        ToolTip = 'Create or modify the coupling to a Microsoft Dynamics CRM entity.';

                        trigger OnAction()
                        var
                            CRMIntegrationManagement: Codeunit "CRM Integration Management";
                            LocalRecordID: RecordID;
                        begin
                            if IsEmpty then
                              exit;

                            GetRecordID(LocalRecordID);
                            CRMIntegrationManagement.DefineCoupling(LocalRecordID);
                        end;
                    }
                    action(DeleteCRMCoupling)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Delete Coupling';
                        Enabled = HasRecords;
                        Image = UnLinkAccount;
                        ToolTip = 'Delete the coupling to a Microsoft Dynamics CRM entity.';

                        trigger OnAction()
                        var
                            CRMCouplingManagement: Codeunit "CRM Coupling Management";
                            LocalRecordID: RecordID;
                        begin
                            if IsEmpty then
                              exit;

                            GetRecordID(LocalRecordID);
                            CRMCouplingManagement.RemoveCoupling(LocalRecordID);
                        end;
                    }
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        ReferenceRecordRef: RecordRef;
    begin
        if ReferenceRecordRef.Get("Source Record ID") then
          OpenSourcePageTxt := OpenPageTok
        else
          OpenSourcePageTxt := '';

        if ReferenceRecordRef.Get("Destination Record ID") then
          OpenDestinationPageTxt := OpenPageTok
        else
          OpenDestinationPageTxt := '';
        HasRecords := not IsEmpty;
    end;

    var
        UnableToFindPageForRecordErr: label 'Unable to find page for record %1.', Comment='%1 ID of the record';
        InvalidOrMissingSourceErr: label 'The source record was not found.';
        InvalidOrMissingDestinationErr: label 'The destination record was not found.';
        OpenSourcePageTxt: Text;
        OpenDestinationPageTxt: Text;
        OpenPageTok: label 'View';
        HasRecords: Boolean;

    local procedure ShowPage(RecordID: RecordID)
    var
        TableMetadata: Record "Table Metadata";
        PageManagement: Codeunit "Page Management";
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
        CrmId: Guid;
        CrmIdFormattet: Text;
    begin
        if RecordID.TableNo = 0 then
          exit;
        if not TableMetadata.Get(RecordID.TableNo) then
          exit;

        if not TableMetadata.DataIsExternal then begin
          PageManagement.PageRun(RecordID);
          exit;
        end;

        if TableMetadata.TableType = TableMetadata.Tabletype::CRM then begin
          CrmIdFormattet := Format(RecordID);
          CrmIdFormattet := CopyStr(CrmIdFormattet,StrPos(CrmIdFormattet,':') + 1);
          Evaluate(CrmId,CrmIdFormattet);
          Hyperlink(CRMIntegrationManagement.GetCRMEntityUrlFromCRMID(RecordID.TableNo,CrmId));
          exit;
        end;

        Error(StrSubstNo(UnableToFindPageForRecordErr,Format(RecordID,0,1)));
    end;

    local procedure GetRecordID(var LocalRecordID: RecordID)
    var
        TableMetadata: Record "Table Metadata";
    begin
        LocalRecordID := "Source Record ID";
        if LocalRecordID.TableNo = 0 then
          Error(InvalidOrMissingSourceErr);

        if not TableMetadata.Get(LocalRecordID.TableNo) then
          Error(InvalidOrMissingSourceErr);

        if TableMetadata.TableType <> TableMetadata.Tabletype::CRM then
          exit;

        LocalRecordID := "Destination Record ID";
        if LocalRecordID.TableNo = 0 then
          Error(InvalidOrMissingDestinationErr);
    end;
}

