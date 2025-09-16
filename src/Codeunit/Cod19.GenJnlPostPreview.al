#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 19 "Gen. Jnl.-Post Preview"
{

    trigger OnRun()
    begin
    end;

    var
        NothingToPostMsg: label 'There is nothing to post.';
        PreviewModeErr: label 'Preview mode.';
        PostingPreviewEventHandler: Codeunit "Posting Preview Event Handler";
        SubscriberTypeErr: label 'Invalid Subscriber type. The type must be CODEUNIT.';
        RecVarTypeErr: label 'Invalid RecVar type. The type must be RECORD.';
        PreviewExitStateErr: label 'The posting preview has stopped because of a state that is not valid.';


    procedure Preview(Subscriber: Variant;RecVar: Variant)
    var
        RunResult: Boolean;
    begin
        if not Subscriber.IsCodeunit then
          Error(SubscriberTypeErr);
        if not RecVar.IsRecord then
          Error(RecVarTypeErr);

        BindSubscription(PostingPreviewEventHandler);

        RunResult := RunPreview(Subscriber,RecVar);

        UnbindSubscription(PostingPreviewEventHandler);

        // The OnRunPreview event expects subscriber following template: Result := <Codeunit>.RUN
        // So we assume RunPreview returns FALSE with the error.
        // To prevent return FALSE without thrown error we check error call stack.
        if RunResult or (GetLastErrorCallstack = '') then
          Error(PreviewExitStateErr);

        if GetLastErrorText <> PreviewModeErr then
          Error(GetLastErrorText);
        ShowAllEntries;
        Error('');
    end;


    procedure IsActive(): Boolean
    var
        EventSubscription: Record "Event Subscription";
        Result: Boolean;
    begin
        EventSubscription.SetRange("Subscriber Codeunit ID",Codeunit::"Posting Preview Event Handler");
        EventSubscription.SetFilter("Active Manual Instances",'<>%1',0);
        Result := not EventSubscription.IsEmpty;

        Clear(EventSubscription);
        EventSubscription.SetRange("Publisher Object ID",Codeunit::"Gen. Jnl.-Post Preview");
        EventSubscription.SetFilter("Active Manual Instances",'<>%1',0);
        exit(Result and (not EventSubscription.IsEmpty));
    end;

    local procedure RunPreview(Subscriber: Variant;RecVar: Variant): Boolean
    var
        Result: Boolean;
    begin
        OnRunPreview(Result,Subscriber,RecVar);
        exit(Result);
    end;

    local procedure ShowAllEntries()
    var
        TempDocumentEntry: Record "Document Entry" temporary;
        GLPostingPreview: Page "G/L Posting Preview";
    begin
        PostingPreviewEventHandler.FillDocumentEntry(TempDocumentEntry);
        if not TempDocumentEntry.IsEmpty then begin
          GLPostingPreview.Set(TempDocumentEntry,PostingPreviewEventHandler);
          GLPostingPreview.Run
        end else
          Message(NothingToPostMsg);
    end;


    procedure ShowDimensions(TableID: Integer;EntryNo: Integer;DimensionSetID: Integer)
    var
        DimMgt: Codeunit DimensionManagement;
        RecRef: RecordRef;
    begin
        RecRef.Open(TableID);
        DimMgt.ShowDimensionSet(DimensionSetID,StrSubstNo('%1 %2',RecRef.Caption,EntryNo));
    end;


    procedure ThrowError()
    begin
        Error(PreviewModeErr);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnRunPreview(var Result: Boolean;Subscriber: Variant;RecVar: Variant)
    begin
    end;
}

