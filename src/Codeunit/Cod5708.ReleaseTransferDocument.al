#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5708 "Release Transfer Document"
{
    TableNo = "Transfer Header";

    trigger OnRun()
    var
        TransLine: Record "Transfer Line";
    begin
        if Status = Status::Released then
          exit;

        TestField("Transfer-from Code");
        TestField("Transfer-to Code");
        if "Transfer-from Code" = "Transfer-to Code" then
          Error(Text001,"No.",FieldCaption("Transfer-from Code"),FieldCaption("Transfer-to Code"));
        TestField("In-Transit Code");
        TestField(Status,Status::Open);

        TransLine.SetRange("Document No.","No.");
        TransLine.SetFilter(Quantity,'<>0');
        if TransLine.IsEmpty then
          Error(Text002,"No.");

        Validate(Status,Status::Released);
        Modify;

        WhseTransferRelease.SetCallFromTransferOrder(true);
        WhseTransferRelease.Release(Rec);
    end;

    var
        Text001: label 'The transfer order %1 cannot be released because %2 and %3 are the same.';
        Text002: label 'There is nothing to release for transfer order %1.';
        WhseTransferRelease: Codeunit "Whse.-Transfer Release";


    procedure Reopen(var TransHeader: Record "Transfer Header")
    begin
        with TransHeader do begin
          if Status = Status::Open then
            exit;
          WhseTransferRelease.Reopen(TransHeader);
          Validate(Status,Status::Open);
          Modify;
        end;
    end;
}

