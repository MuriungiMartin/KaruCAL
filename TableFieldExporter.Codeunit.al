#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 50141 TableFieldExporter
{

    trigger OnRun()
    begin
        ExportTableFieldsInfo(66644);
    end;

    var
        FileManagement: Codeunit "File Management";
        Window: Dialog;


    procedure ExportTableFieldsInfo(TableID: Integer)
    var
        "Field": Record "Field";
        FieldRec: Record "Field";
        OutputFile: File;
        OutputFileStream: OutStream;
        FileName: Text[250];
        FilePath: Text[250];
        TypeText: Text[30];
        FormulaText: Text[250];
        OptionString: Text[250];
    begin
        Window.Open('Exporting Table Fields Information...\Table ID: #1########');
        Window.Update(1,TableID);
        Field.Reset;
        Field.SetRange(TableNo,TableID);
        Field.SetRange(Enabled,true);
        if not Field.FindFirst then begin
          Window.Close;
          Error('No fields found for table ID %1',TableID);
        end;
        FilePath := FileManagement.ClientTempFileName('.txt');
        Message(FilePath);
        FileName := StrSubstNo('TableFields_%1_%2.txt',TableID,Field.TableName);
        OutputFile.Create(FilePath);
        OutputFile.CreateOutstream(OutputFileStream);
        // Write header
        OutputFileStream.WriteText('Table ID: ' + Format(TableID));
        OutputFileStream.WriteText;
        OutputFileStream.WriteText('Table Name: ' + Field.TableName);
        OutputFileStream.WriteText;
        OutputFileStream.WriteText('Fields Information:');
        OutputFileStream.WriteText('-------------------');
        OutputFileStream.WriteText;
        OutputFileStream.WriteText('No.,Name,Type,Length,OptionString,FlowField Formula');
        OutputFileStream.WriteText;
        // Write field data
        repeat
          // Get field type
          case Field.Type of
            Field.Type::BigInteger:
              TypeText := 'BigInteger';
            Field.Type::Blob:
              TypeText := 'Blob';
            Field.Type::Boolean:
              TypeText := 'Boolean';
            Field.Type::Code:
              TypeText := 'Code';
            Field.Type::Date:
              TypeText := 'Date';
            Field.Type::DateFormula:
              TypeText := 'DateFormula';
            Field.Type::Decimal:
              TypeText := 'Decimal';
            Field.Type::Duration:
              TypeText := 'Duration';
            Field.Type::Integer:
              TypeText := 'Integer';
            Field.Type::Option:
              TypeText := 'Option';
            Field.Type::Text:
              TypeText := 'Text';
            Field.Type::Time:
              TypeText := 'Time';
            Field.Type::DateTime:
              TypeText := 'DateTime';
            Field.Type::Guid:
              TypeText := 'GUID';
            Field.Type::RecordID:
              TypeText := 'RecordID';
            Field.Type::TableFilter:
              TypeText := 'TableFilter';
            else
              TypeText := Format(Field.Type);
          end;
          // Get Option String for Option fields
          OptionString := '';
          if Field.Type = Field.Type::Option then
            OptionString := Field.OptionString;
          // Get CalcFormula for FlowFields
          FormulaText := '';
          if Field.Class = Field.Class::FlowField then begin
            FieldRec.Get(Field.TableNo,Field."No.");
            FormulaText := Format(FieldRec.Class);
          end;
          // Write field details
          OutputFileStream.WriteText(
            Format(Field."No.") + ',' +
            Field.FieldName + ',' +
            TypeText + ',' +
            Format(Field.Len) + ',' +
            OptionString + ',' +
            FormulaText);
        until Field.Next = 0;
        OutputFile.Close;
        Window.Close;
        FileManagement.DownloadToFile(FilePath,FileName);
        Message('Table field information has been exported to file %1',FileName);
    end;


    procedure GetFieldTypeAsText(FieldNo: Integer;TableNo: Integer) TypeText: Text[30]
    var
        "Field": Record "Field";
    begin
        Field.Get(TableNo,FieldNo);
        case Field.Type of
          Field.Type::BigInteger:
            TypeText := 'BigInteger';
          Field.Type::Blob:
            TypeText := 'Blob';
          Field.Type::Boolean:
            TypeText := 'Boolean';
          Field.Type::Code:
            TypeText := 'Code';
          Field.Type::Date:
            TypeText := 'Date';
          Field.Type::DateFormula:
            TypeText := 'DateFormula';
          Field.Type::Decimal:
            TypeText := 'Decimal';
          Field.Type::Duration:
            TypeText := 'Duration';
          Field.Type::Integer:
            TypeText := 'Integer';
          Field.Type::Option:
            TypeText := 'Option';
          Field.Type::Text:
            TypeText := 'Text';
          Field.Type::Time:
            TypeText := 'Time';
          Field.Type::DateTime:
            TypeText := 'DateTime';
          Field.Type::Guid:
            TypeText := 'GUID';
          Field.Type::RecordID:
            TypeText := 'RecordID';
          Field.Type::TableFilter:
            TypeText := 'TableFilter';
          else
            TypeText := Format(Field.Type);
        end;
    end;


    procedure GetFlowFormula(FieldNo: Integer;TableNo: Integer) FormulaText: Text[250]
    var
        "Field": Record "Field";
    begin
        Field.Get(TableNo,FieldNo);
        if Field.Class = Field.Class::FlowField then
          FormulaText := Format(Field.Class)
        else
          FormulaText := '';
    end;


    procedure SaveFieldInfoText(TableID: Integer;var ResultText: Text)
    var
        "Field": Record "Field";
        TypeText: Text[30];
        FormulaText: Text[250];
        OptionString: Text[250];
    begin
        Field.Reset;
        Field.SetRange(TableNo,TableID);
        Field.SetRange(Enabled,true);
        if not Field.FindFirst then
          exit;
        ResultText := 'Table ID: ' + Format(TableID) + '\';
        ResultText += 'Table Name: ' + Field.TableName + '\';
        ResultText += '\';
        ResultText += 'Fields Information:\';
        ResultText += '-------------------\';
        ResultText += '\';
        ResultText += 'No.,Name,Type,Length,OptionString,FlowField Formula\';
        repeat
          TypeText := GetFieldTypeAsText(Field."No.",TableID);
          // Get Option String for Option fields
          OptionString := '';
          if Field.Type = Field.Type::Option then
            OptionString := Field.OptionString;
          FormulaText := GetFlowFormula(Field."No.",TableID);
          // Add field info to result text
          ResultText += Format(Field."No.") + ',' +
                       Field.FieldName + ',' +
                       TypeText + ',' +
                       Format(Field.Len) + ',' +
                       OptionString + ',' +
                       FormulaText + '\';
        until Field.Next = 0;
    end;
}

