#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 7323 "Whse.-Act.-Post (Yes/No)"
{
    TableNo = "Warehouse Activity Line";

    trigger OnRun()
    begin
        WhseActivLine.Copy(Rec);
        Code;
        Copy(WhseActivLine);
    end;

    var
        Text000: label '&Receive,Receive &and Invoice';
        WhseActivLine: Record "Warehouse Activity Line";
        WhseActivityPost: Codeunit "Whse.-Activity-Post";
        Selection: Integer;
        Text001: label '&Ship,Ship &and Invoice';
        Text002: label 'Do you want to post the %1 and %2?';
        PrintDoc: Boolean;

    local procedure "Code"()
    begin
        with WhseActivLine do begin
          if "Activity Type" = "activity type"::"Invt. Put-away" then begin
            if ("Source Document" = "source document"::"Prod. Output") or
               ("Source Document" = "source document"::"Inbound Transfer") or
               ("Source Document" = "source document"::"Prod. Consumption")
            then begin
              if not Confirm(Text002,false,"Activity Type","Source Document") then
                exit;
            end else begin
              Selection := StrMenu(Text000,2);
              if Selection = 0 then
                exit;
            end;
          end else
            if ("Source Document" = "source document"::"Prod. Consumption") or
               ("Source Document" = "source document"::"Outbound Transfer")
            then begin
              if not Confirm(Text002,false,"Activity Type","Source Document") then
                exit;
            end else begin
              Selection := StrMenu(Text001,2);
              if Selection = 0 then
                exit;
            end;

          WhseActivityPost.SetInvoiceSourceDoc(Selection = 2);
          WhseActivityPost.PrintDocument(PrintDoc);
          WhseActivityPost.Run(WhseActivLine);
          Clear(WhseActivityPost);
        end;
    end;


    procedure PrintDocument(SetPrint: Boolean)
    begin
        PrintDoc := SetPrint;
    end;
}

