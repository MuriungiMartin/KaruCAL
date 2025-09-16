#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5550 "Fixed Asset Acquisition Wizard"
{

    trigger OnRun()
    begin
    end;

    var
        GenJournalBatchNameTxt: label 'AUTOMATIC', Comment='Translate normally and keep the upper case';
        SimpleJnlDescriptionTxt: label 'Fixed Asset Acquisition';
        FixedAssetNoTok: label 'FixedAssetNo', Locked=true;
        ReadyToAcquireMsg: label 'You are ready to acquire the fixed asset.';
        AcquireTxt: label 'Acquire';
        RunAcquisitionWizardTok: label 'RunAcquisitionWizardFromNotification', Locked=true;


    procedure RunAcquisitionWizard(FixedAssetNo: Code[20])
    var
        TempGenJournalLine: Record "Gen. Journal Line" temporary;
    begin
        TempGenJournalLine.SetRange("Account No.",FixedAssetNo);
        Page.RunModal(Page::"Fixed Asset Acquisition Wizard",TempGenJournalLine);
    end;


    procedure RunAcquisitionWizardFromNotification(FixedAssetAcquisitionNotification: Notification)
    var
        FixedAssetNo: Code[10];
    begin
        InitializeFromNotification(FixedAssetAcquisitionNotification,FixedAssetNo);
        RunAcquisitionWizard(FixedAssetNo);
    end;


    procedure PopulateDataOnNotification(var FixedAssetAcquisitionNotification: Notification;FixedAssetNo: Code[20])
    begin
        FixedAssetAcquisitionNotification.SetData(FixedAssetNoTok,FixedAssetNo);
    end;


    procedure InitializeFromNotification(FixedAssetAcquisitionNotification: Notification;var FixedAssetNo: Code[20])
    begin
        FixedAssetNo := FixedAssetAcquisitionNotification.GetData(FixedAssetNoTok);
    end;


    procedure GetAutogenJournalBatch(): Code[10]
    var
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        if not GenJournalBatch.Get(SelectFATemplate,GenJournalBatchNameTxt) then begin
          GenJournalBatch.Init;
          GenJournalBatch."Journal Template Name" := SelectFATemplate;
          GenJournalBatch.Name := GenJournalBatchNameTxt;
          GenJournalBatch.Description := SimpleJnlDescriptionTxt;
          GenJournalBatch.SetupNewBatch;
          GenJournalBatch.Insert;
        end;

        exit(GenJournalBatch.Name);
    end;


    procedure SelectFATemplate() ReturnValue: Code[10]
    var
        FAJournalLine: Record "FA Journal Line";
        FAJnlManagement: Codeunit FAJnlManagement;
        JnlSelected: Boolean;
    begin
        FAJnlManagement.TemplateSelection(Page::"Fixed Asset Journal",false,FAJournalLine,JnlSelected);

        if JnlSelected then begin
          FAJournalLine.FilterGroup := 2;
          ReturnValue := CopyStr(FAJournalLine.GetFilter("Journal Template Name"),1,MaxStrLen(FAJournalLine."Journal Template Name"));
          FAJournalLine.FilterGroup := 0;
        end;
    end;


    procedure ShowAcquireWizardNotification(var FAAcquireWizardNotificationId: Guid;FixedAssetNo: Code[20])
    var
        FixedAssetAcquisitionWizard: Codeunit "Fixed Asset Acquisition Wizard";
        FAAcquireWizardNotification: Notification;
    begin
        // Create a new ID
        FAAcquireWizardNotificationId := GetFAAcquireWizardNotificationId;
        FAAcquireWizardNotification.ID(FAAcquireWizardNotificationId);
        FAAcquireWizardNotification.Message(ReadyToAcquireMsg);
        FAAcquireWizardNotification.Scope(Notificationscope::LocalScope);
        FAAcquireWizardNotification.AddAction(AcquireTxt,Codeunit::"Fixed Asset Acquisition Wizard",RunAcquisitionWizardTok);
        FixedAssetAcquisitionWizard.PopulateDataOnNotification(FAAcquireWizardNotification,FixedAssetNo);
        FAAcquireWizardNotification.Send;
    end;

    local procedure GetFAAcquireWizardNotificationId(): Guid
    begin
        exit(CreateGuid);
    end;
}

