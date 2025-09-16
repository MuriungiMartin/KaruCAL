#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 91 "Purch.-Post (Yes/No)"
{
    EventSubscriberInstance = Manual;
    TableNo = "Purchase Header";

    trigger OnRun()
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        if not Find then
          Error(NothingToPostErr);

        PurchaseHeader.Copy(Rec);
        Code(PurchaseHeader);
        Rec := PurchaseHeader;
    end;

    var
        Text000: label '&Receive,&Invoice,Receive &and Invoice';
        Text001: label 'Do you want to post the %1?';
        Text002: label '&Ship,&Invoice,Ship &and Invoice';
        Selection: Integer;
        NothingToPostErr: label 'There is nothing to post.';

    local procedure "Code"(var PurchaseHeader: Record "Purchase Header")
    var
        PurchSetup: Record "Purchases & Payables Setup";
        PurchPostViaJobQueue: Codeunit "Purchase Post via Job Queue";
    begin
        with PurchaseHeader do begin
          case "Document Type" of
            "document type"::Order:
              begin
                Selection := StrMenu(Text000,3);
                if Selection = 0 then
                  exit;
                Receive := Selection in [1,3];
                Invoice := Selection in [2,3];
              end;
            "document type"::"Return Order":
              begin
                Selection := StrMenu(Text002,3);
                if Selection = 0 then
                  exit;
                Ship := Selection in [1,3];
                Invoice := Selection in [2,3];
              end
            else
              if not Confirm(Text001,false,Lowercase(Format("Document Type"))) then
                exit;
          end;
          "Print Posted Documents" := false;
        end;
        PurchSetup.Get;
        if PurchSetup."Post with Job Queue" then
          PurchPostViaJobQueue.EnqueuePurchDoc(PurchaseHeader)
        else
          Codeunit.Run(Codeunit::"Purch.-Post",PurchaseHeader)
    end;


    procedure Preview(var PurchaseHeader: Record "Purchase Header")
    var
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        PurchPostYesNo: Codeunit "Purch.-Post (Yes/No)";
    begin
        BindSubscription(PurchPostYesNo);
        GenJnlPostPreview.Preview(PurchPostYesNo,PurchaseHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Preview", 'OnRunPreview', '', false, false)]
    local procedure OnRunPreview(var Result: Boolean;Subscriber: Variant;RecVar: Variant)
    var
        PurchaseHeader: Record "Purchase Header";
        PurchPost: Codeunit "Purch.-Post";
    begin
        with PurchaseHeader do begin
          Copy(RecVar);
          Ship := "Document Type" = "document type"::"Return Order";
          Receive := "Document Type" = "document type"::Order;
          Invoice := true;
        end;
        PurchPost.SetPreviewMode(true);
        Result := PurchPost.Run(PurchaseHeader);
    end;
}

