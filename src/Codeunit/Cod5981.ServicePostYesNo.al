#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5981 "Service-Post (Yes/No)"
{
    EventSubscriberInstance = Manual;
    TableNo = "Service Line";

    trigger OnRun()
    begin
        Code(Rec,ServiceHeaderPreviewContext);
    end;

    var
        Text000: label '&Ship,&Invoice,Ship &and Invoice,Ship and &Consume';
        Text001: label 'Do you want to post the %1?';
        ServiceHeaderPreviewContext: Record "Service Header";
        Selection: Integer;
        PreviewMode: Boolean;
        CancelErr: label 'The preview has been canceled.';
        NothingToPostErr: label 'There is nothing to post.';

    local procedure "Code"(var PassedServLine: Record "Service Line";var PassedServiceHeader: Record "Service Header")
    var
        ServicePost: Codeunit "Service-Post";
        Ship: Boolean;
        Consume: Boolean;
        Invoice: Boolean;
    begin
        if not PassedServiceHeader.Find then
          Error(NothingToPostErr);

        with PassedServiceHeader do begin
          case "Document Type" of
            "document type"::Order:
              begin
                Selection := StrMenu(Text000,3);
                if Selection = 0 then begin
                  if PreviewMode then
                    Error(CancelErr);
                  exit;
                end;
                Ship := Selection in [1,3,4];
                Consume := Selection in [4];
                Invoice := Selection in [2,3];
              end
            else
              if not PreviewMode then
                if not Confirm(Text001,false,"Document Type") then
                  exit;
          end;
          ServicePost.SetPreviewMode(PreviewMode);
          ServicePost.PostWithLines(PassedServiceHeader,PassedServLine,Ship,Consume,Invoice);

          if not PreviewMode then
            Commit;
        end;
    end;


    procedure PostDocument(var ServiceHeaderSource: Record "Service Header")
    var
        DummyServLine: Record "Service Line" temporary;
    begin
        PostDocumentWithLines(ServiceHeaderSource,DummyServLine);
    end;


    procedure PostDocumentWithLines(var ServiceHeaderSource: Record "Service Header";var PassedServLine: Record "Service Line")
    var
        ServiceHeader: Record "Service Header";
    begin
        ServiceHeader.Copy(ServiceHeaderSource);
        Code(PassedServLine,ServiceHeader);
        ServiceHeaderSource := ServiceHeader;
    end;


    procedure PreviewDocument(var ServHeader: Record "Service Header")
    var
        TempServLine: Record "Service Line" temporary;
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        ServicePostYesNo: Codeunit "Service-Post (Yes/No)";
    begin
        BindSubscription(ServicePostYesNo);
        ServicePostYesNo.SetPreviewContext(ServHeader);
        GenJnlPostPreview.Preview(ServicePostYesNo,TempServLine);
    end;


    procedure PreviewDocumentWithLines(var ServHeader: Record "Service Header";var PassedServLine: Record "Service Line")
    var
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        ServicePostYesNo: Codeunit "Service-Post (Yes/No)";
    begin
        BindSubscription(ServicePostYesNo);
        ServicePostYesNo.SetPreviewContext(ServHeader);
        GenJnlPostPreview.Preview(ServicePostYesNo,PassedServLine);
    end;


    procedure SetPreviewContext(var ServiceHeader: Record "Service Header")
    begin
        ServiceHeaderPreviewContext.Copy(ServiceHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Preview", 'OnRunPreview', '', false, false)]
    local procedure OnRunPreview(var Result: Boolean;Subscriber: Variant;RecVar: Variant)
    var
        ServicePostYesNo: Codeunit "Service-Post (Yes/No)";
    begin
        ServicePostYesNo := Subscriber;
        PreviewMode := true;
        Result := ServicePostYesNo.Run(RecVar);
    end;
}

