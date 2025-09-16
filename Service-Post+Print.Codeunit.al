#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5982 "Service-Post+Print"
{

    trigger OnRun()
    begin
    end;

    var
        Text000: label '&Ship,&Invoice,Ship &and Invoice,Ship and &Consume';
        Text001: label 'Do you want to post and print the %1?';
        ServiceHeader: Record "Service Header";
        ServShptHeader: Record "Service Shipment Header";
        ServInvHeader: Record "Service Invoice Header";
        ServCrMemoHeader: Record "Service Cr.Memo Header";
        ServicePost: Codeunit "Service-Post";
        Selection: Integer;
        Ship: Boolean;
        Consume: Boolean;
        Invoice: Boolean;


    procedure PostDocument(var Rec: Record "Service Header")
    var
        DummyServLine: Record "Service Line" temporary;
    begin
        ServiceHeader.Copy(Rec);
        Code(DummyServLine);
        Rec := ServiceHeader;
    end;

    local procedure "Code"(var PassedServLine: Record "Service Line")
    begin
        with ServiceHeader do begin
          case "Document Type" of
            "document type"::Order:
              begin
                Selection := StrMenu(Text000,3);
                if Selection = 0 then
                  exit;
                Ship := Selection in [1,3,4];
                Consume := Selection in [4];
                Invoice := Selection in [2,3];
              end
            else
              if not Confirm(Text001,false,"Document Type") then
                exit;
          end;
          ServicePost.PostWithLines(ServiceHeader,PassedServLine,Ship,Consume,Invoice);
          GetReport(ServiceHeader);
          Commit;
        end;
    end;

    local procedure GetReport(var ServiceHeader: Record "Service Header")
    begin
        with ServiceHeader do
          case "Document Type" of
            "document type"::Order:
              begin
                if Ship then begin
                  ServShptHeader."No." := "Last Shipping No.";
                  ServShptHeader.SetRecfilter;
                  ServShptHeader.PrintRecords(false);
                end;
                if Invoice then begin
                  ServInvHeader."No." := "Last Posting No.";
                  ServInvHeader.SetRecfilter;
                  ServInvHeader.PrintRecords(false);
                end;
              end;
            "document type"::Invoice:
              begin
                if "Last Posting No." = '' then
                  ServInvHeader."No." := "No."
                else
                  ServInvHeader."No." := "Last Posting No.";
                ServInvHeader.SetRecfilter;
                ServInvHeader.PrintRecords(false);
              end;
            "document type"::"Credit Memo":
              begin
                if "Last Posting No." = '' then
                  ServCrMemoHeader."No." := "No."
                else
                  ServCrMemoHeader."No." := "Last Posting No.";
                ServCrMemoHeader.SetRecfilter;
                ServCrMemoHeader.PrintRecords(false);
              end;
          end;
    end;
}

