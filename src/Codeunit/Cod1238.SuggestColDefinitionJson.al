#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1238 "Suggest Col. Definition - Json"
{

    trigger OnRun()
    begin
    end;


    procedure GenerateDataExchColDef(URLPath: Text;DataExchLineDef: Record "Data Exch. Line Def")
    var
        DataExchColumnDef: Record "Data Exch. Column Def";
        TempXMLBuffer: Record "XML Buffer" temporary;
        GetJsonStructure: Codeunit "Get Json Structure";
        ColumnNo: Integer;
    begin
        GetJsonStructure.GenerateStructure(URLPath,TempXMLBuffer);

        with DataExchColumnDef do begin
          SetRange("Data Exch. Def Code",DataExchLineDef."Data Exch. Def Code");
          SetRange("Data Exch. Line Def Code",DataExchLineDef.Code);
          DeleteAll;
          ColumnNo := 0;

          TempXMLBuffer.Reset;
          if TempXMLBuffer.FindSet then
            repeat
              ColumnNo += 10000;

              Init;
              Validate("Data Exch. Def Code",DataExchLineDef."Data Exch. Def Code");
              Validate("Data Exch. Line Def Code",DataExchLineDef.Code);
              Validate("Column No.",ColumnNo);

              Validate(Name,TempXMLBuffer.Name);
              Validate(Path,TempXMLBuffer.Path);
              Insert(true);
            until TempXMLBuffer.Next = 0;
        end;
    end;
}

