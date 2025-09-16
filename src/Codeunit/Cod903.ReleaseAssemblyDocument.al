#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 903 "Release Assembly Document"
{
    Permissions = TableData "Assembly Header"=m,
                  TableData "Assembly Line"=r;
    TableNo = "Assembly Header";

    trigger OnRun()
    var
        AssemblyLine: Record "Assembly Line";
        InvtSetup: Record "Inventory Setup";
        WhseAssemblyRelease: Codeunit "Whse.-Assembly Release";
    begin
        if Status = Status::Released then
          exit;

        AssemblyLine.SetRange("Document Type","Document Type");
        AssemblyLine.SetRange("Document No.","No.");
        AssemblyLine.SetFilter(Type,'<>%1',AssemblyLine.Type::" ");
        AssemblyLine.SetFilter(Quantity,'<>0');
        if not AssemblyLine.Find('-') then
          Error(Text001,"Document Type","No.");
        InvtSetup.Get;
        if InvtSetup."Location Mandatory" then begin
          AssemblyLine.SetRange(Type,AssemblyLine.Type::Item);
          if AssemblyLine.FindSet then
            repeat
              AssemblyLine.TestField("Location Code");
            until AssemblyLine.Next = 0;
        end;

        Status := Status::Released;
        Modify;

        if "Document Type" = "document type"::Order then
          WhseAssemblyRelease.Release(Rec);
    end;

    var
        Text001: label 'There is nothing to release for %1 %2.', Comment='%1 = Document Type, %2 = No.';


    procedure Reopen(var AssemblyHeader: Record "Assembly Header")
    var
        WhseAssemblyRelease: Codeunit "Whse.-Assembly Release";
    begin
        with AssemblyHeader do begin
          if Status = Status::Open then
            exit;

          Status := Status::Open;
          Modify(true);

          if "Document Type" = "document type"::Order then
            WhseAssemblyRelease.Reopen(AssemblyHeader);
        end;
    end;
}

