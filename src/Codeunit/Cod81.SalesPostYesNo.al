#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 81 "Sales-Post (Yes/No)"
{
    EventSubscriberInstance = Manual;
    TableNo = "Sales Header";

    trigger OnRun()
    var
        SalesHeader: Record "Sales Header";
    begin
        if not Find then
          Error(NothingToPostErr);

        SalesHeader.Copy(Rec);
        Code(SalesHeader);
        Rec := SalesHeader;
    end;

    var
        Text000: label '&Ship,&Invoice,Ship &and Invoice';
        Text001: label 'Do you want to post the %1?';
        Text002: label '&Receive,&Invoice,Receive &and Invoice';
        Selection: Integer;
        NothingToPostErr: label 'There is nothing to post.';

    local procedure "Code"(var SalesHeader: Record "Sales Header")
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SalesPostViaJobQueue: Codeunit "Sales Post via Job Queue";
    begin
        with SalesHeader do begin
          case "Document Type" of
            "document type"::Order:
              begin
                if SalesHeader."Cash Sale Order" then begin
                 Ship := true;
                Invoice :=  true;
                  end else begin
                Selection := StrMenu(Text000,3);
                Ship := Selection in [1,3];
                Invoice := Selection in [2,3];
                if Selection = 0 then
                  exit;
                end;
              end;
            "document type"::"Return Order":
              begin
                Selection := StrMenu(Text002,3);
                if Selection = 0 then
                  exit;
                Receive := Selection in [1,3];
                Invoice := Selection in [2,3];
              end
            else
              if not Confirm(Text001,false,Lowercase(Format("Document Type"))) then
                exit;
          end;
          "Print Posted Documents" := false;

          SalesSetup.Get;
          if SalesSetup."Post with Job Queue" then
            SalesPostViaJobQueue.EnqueueSalesDoc(SalesHeader)
          else
            Codeunit.Run(Codeunit::"Sales-Post",SalesHeader);
        end;
    end;


    procedure Preview(var SalesHeader: Record "Sales Header")
    var
        SalesPostYesNo: Codeunit "Sales-Post (Yes/No)";
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
    begin
        BindSubscription(SalesPostYesNo);
        GenJnlPostPreview.Preview(SalesPostYesNo,SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Preview", 'OnRunPreview', '', false, false)]
    local procedure OnRunPreview(var Result: Boolean;Subscriber: Variant;RecVar: Variant)
    var
        SalesHeader: Record "Sales Header";
        SalesPost: Codeunit "Sales-Post";
    begin
        with SalesHeader do begin
          Copy(RecVar);
          Receive := "Document Type" = "document type"::"Return Order";
          Ship := "Document Type" = "document type"::Order;
          Invoice := true;
        end;
        SalesPost.SetPreviewMode(true);
        Result := SalesPost.Run(SalesHeader);
    end;
}

