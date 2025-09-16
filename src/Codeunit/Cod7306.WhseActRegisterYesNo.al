#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 7306 "Whse.-Act.-Register (Yes/No)"
{
    TableNo = "Warehouse Activity Line";

    trigger OnRun()
    begin
        WhseActivLine.Copy(Rec);
        Code;
        Copy(WhseActivLine);
    end;

    var
        Text001: label 'Do you want to register the %1 Document?';
        WhseActivLine: Record "Warehouse Activity Line";
        WhseActivityRegister: Codeunit "Whse.-Activity-Register";
        WMSMgt: Codeunit "WMS Management";
        Text002: label 'The document %1 is not supported.';

    local procedure "Code"()
    begin
        with WhseActivLine do begin
          if ("Activity Type" = "activity type"::"Invt. Movement") and
             not ("Source Document" in ["source document"::" ",
                                        "source document"::"Prod. Consumption",
                                        "source document"::"Assembly Consumption"])
          then
            Error(Text002,"Source Document");

          WMSMgt.CheckBalanceQtyToHandle(WhseActivLine);

          if not Confirm(Text001,false,"Activity Type") then
            exit;

          WhseActivityRegister.Run(WhseActivLine);
          Clear(WhseActivityRegister);
        end;
    end;
}

