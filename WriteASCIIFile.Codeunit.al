#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 50136 "Write ASCII File"
{
    // This CodeUnit will open and close a file, as well as write the records


    trigger OnRun()
    begin
    end;

    var
        ASCIIFile: File;


    procedure FileOpen(FileName: Text[250])
    begin
        // Call from OnPreReport
        ASCIIFile.TextMode := true;
        ASCIIFile.WriteMode(true);
        ASCIIFile.QUERYREPLACE(true);
        ASCIIFile.Create(FileName);
    end;


    procedure FileClose()
    begin
        // Call from OnPostReport
        ASCIIFile.Close;
    end;


    procedure "1FieldWrite"(Field1: Text[250])
    begin
        ASCIIFile.Write(Field1);
    end;


    procedure "2FieldWrite"(Field1: Text[50];Field2: Text[50])
    begin
        // Can be used for Fewer, Just Pass Null Values for unused
        ASCIIFile.Write(StrSubstNo('"%1","%2" ',Field1,Field2));
    end;


    procedure "4FieldWrite"(Field1: Text[50];Field2: Text[50];Field3: Text[50];Field4: Text[50])
    begin
        // Can be used for Fewer, Just Pass Null Values for unused
        ASCIIFile.Write(StrSubstNo('"%1","%2","%3","%4" ',Field1,Field2,Field3,Field4));
    end;


    procedure "5FieldWrite"(Field1: Text[50];Field2: Text[50];Field3: Text[50];Field4: Text[50];Field5: Text[50])
    begin
        // Can be used for Fewer, Just Pass Null Values for unused
        ASCIIFile.Write(StrSubstNo('"%1","%2","%3","%4","%5" ',
                                   Field1,Field2,Field3,Field4,Field5));
    end;


    procedure "11FieldWrite"(Field1: Text[70];Field2: Text[70];Field3: Text[70];Field4: Text[70];Field5: Text[70];Field6: Text[70];Field7: Text[70];Field8: Text[70];Field9: Text[70];Field10: Text[70];Field11: Text[70])
    begin
        // Can be used for Fewer, Just Pass Null Values for unused
        ASCIIFile.Write(StrSubstNo('"%1","%2","%3","%4","%5","%6","%7","%8","%9","%10","%11" ',
                                   Field1,Field2,Field3,Field4,Field5,Field6,Field7,
                                   Field8,Field9,Field10,Field11));
    end;


    procedure "13FieldWrite"(Field1: Text[50];Field2: Text[50];Field3: Text[50];Field4: Text[50];Field5: Text[50];Field6: Text[50];Field7: Text[50];Field8: Text[50];Field9: Text[50];Field10: Text[50];Field11: Text[50];Field12: Text[50];Field13: Text[50])
    begin
        // Can be used for Fewer, Just Pass Null Values for unused
        ASCIIFile.Write(StrSubstNo('"%1","%2","%3","%4","%5","%6","%7","%8","%9","%10","%11","%12",'+
                                   '"%13","%14" ',Field1,Field2,Field3,Field4,Field5,Field6,Field7,
                                    Field8,Field9,Field10,Field11,Field12,Field13));
    end;


    procedure "14FieldWrite"(Field1: Text[50];Field2: Text[50];Field3: Text[50];Field4: Text[50];Field5: Text[50];Field6: Text[50];Field7: Text[50];Field8: Text[50];Field9: Text[50];Field10: Text[50];Field11: Text[50];Field12: Text[50];Field13: Text[50];Field14: Text[50])
    begin
        // Can be used for Fewer, Just Pass Null Values for unused
        ASCIIFile.Write(StrSubstNo('"%1","%2","%3","%4","%5","%6","%7","%8","%9","%10","%11","%12",'+
                                   '"%13","%14" ',Field1,Field2,Field3,Field4,Field5,Field6,Field7,
                                    Field8,Field9,Field10,Field11,Field12,Field13,Field14));
    end;


    procedure OpenDialogBox(DialogTitle: Text[250];DialogFilters: Text[250]) FileName: Text[250]
    var
        DialogBox: OCX ;
    begin
        if DialogFilters = '' then
          DialogBox.Filter := 'Document Files (*.doc)|*.doc|Text Files (*.txt)|*.txt|' +
                                'All Files (*.*)|*.*'
        else
          DialogBox.Filter := DialogFilters;

        if DialogTitle <> '' then
          DialogBox.DialogTitle := DialogTitle;
        DialogBox.FilterIndex := 1;
        DialogBox.ShowOpen();
        exit(DialogBox.FileName)
    end;
}

