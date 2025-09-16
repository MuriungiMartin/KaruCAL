#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1802 "Data Migration Notifier"
{

    trigger OnRun()
    begin
    end;

    var
        ListEmptyMsg: label 'It looks like the list is empty. Would you like to import some entries?';
        ButtonYesPleaseTxt: label 'Yes, please';
        DataTypeManagement: Codeunit "Data Type Management";

    [EventSubscriber(Objecttype::Page, 22, 'OnOpenPageEvent', '', false, false)]
    local procedure OnCustomerListOpen(var Rec: Record Customer)
    begin
        ShowListEmptyNotification(Rec);
    end;

    [EventSubscriber(Objecttype::Page, 27, 'OnOpenPageEvent', '', false, false)]
    local procedure OnVendorListOpen(var Rec: Record Vendor)
    begin
        ShowListEmptyNotification(Rec);
    end;

    [EventSubscriber(Objecttype::Page, 31, 'OnOpenPageEvent', '', false, false)]
    local procedure OnItemListOpen(var Rec: Record Item)
    begin
        ShowListEmptyNotification(Rec);
    end;

    local procedure ShowListEmptyNotification(RecordVariant: Variant)
    var
        ListEmptyNotification: Notification;
        RecRef: RecordRef;
    begin
        DataTypeManagement.GetRecordRef(RecordVariant,RecRef);

        if not RecRef.IsEmpty then
          exit;

        ListEmptyNotification.Message := ListEmptyMsg;
        ListEmptyNotification.Scope := Notificationscope::LocalScope;
        ListEmptyNotification.AddAction(ButtonYesPleaseTxt,Codeunit::"Data Migration Notifier",'OpenDataMigrationWizard');
        ListEmptyNotification.Send;
    end;


    procedure OpenDataMigrationWizard(ListEmptyNotification: Notification)
    begin
        Page.Run(Page::"Data Migration Wizard");
    end;
}

