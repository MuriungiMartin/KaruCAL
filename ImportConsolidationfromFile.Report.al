#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 92 "Import Consolidation from File"
{
    Caption = 'Import Consolidation from File';
    ProcessingOnly = true;

    dataset
    {
        dataitem("G/L Account";"G/L Account")
        {
            DataItemTableView = sorting("No.") where("Account Type"=const(Posting));
            column(ReportForNavId_6710; 6710)
            {
            }

            trigger OnAfterGetRecord()
            begin
                "Consol. Debit Acc." := "No.";
                "Consol. Credit Acc." := "No.";
                "Consol. Translation Method" := "consol. translation method"::"Average Rate (Manual)";
                Consolidate.InsertGLAccount("G/L Account");
            end;

            trigger OnPostDataItem()
            var
                TempGLEntry: Record "G/L Entry" temporary;
                TempDimBuf: Record "Dimension Buffer" temporary;
            begin
                if FileFormat = Fileformat::"Version 4.00 or Later (.xml)" then
                  CurrReport.Break;

                // Import G/L entries
                while GLEntryFile.POS <> GLEntryFile.LEN do begin
                  GLEntryFile.Read(TextLine);
                  case CopyStr(TextLine,1,4) of
                    '<02>':
                      begin
                        TempGLEntry.Init;
                        Evaluate(TempGLEntry."G/L Account No.",CopyStr(TextLine,5,20));
                        Evaluate(TempGLEntry."Posting Date",CopyStr(TextLine,26,9));
                        Evaluate(TempGLEntry.Amount,CopyStr(TextLine,36,22));
                        if TempGLEntry.Amount > 0 then
                          TempGLEntry."Debit Amount" := TempGLEntry.Amount
                        else
                          TempGLEntry."Credit Amount" := -TempGLEntry.Amount;
                        TempGLEntry."Entry No." := Consolidate.InsertGLEntry(TempGLEntry);
                      end;
                    '<03>':
                      begin
                        TempDimBuf.Init;
                        TempDimBuf."Table ID" := Database::"G/L Entry";
                        TempDimBuf."Entry No." := TempGLEntry."Entry No.";
                        TempDimBuf."Dimension Code" := CopyStr(TextLine,5,20);
                        TempDimBuf."Dimension Value Code" := CopyStr(TextLine,26,20);
                        Consolidate.InsertEntryDim(TempDimBuf,TempDimBuf."Entry No.");
                      end;
                  end;
                end;

                Consolidate.SelectAllImportedDimensions;
            end;

            trigger OnPreDataItem()
            begin
                if FileFormat = Fileformat::"Version 4.00 or Later (.xml)" then
                  CurrReport.Break;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(FileFormat;FileFormat)
                    {
                        ApplicationArea = Basic;
                        Caption = 'File Format';
                        OptionCaption = 'Version 4.00 or Later (.xml),Version 3.70 or Earlier (.txt)';
                    }
                    field(FileNameControl;FileName)
                    {
                        ApplicationArea = Basic;
                        Caption = 'File Name';

                        trigger OnAssistEdit()
                        var
                            FileManagement: Codeunit "File Management";
                        begin
                            if FileFormat = Fileformat::"Version 4.00 or Later (.xml)" then
                              FileName := FileManagement.OpenFileDialog(Text034,FileName,FileManagement.GetToFilterText('','.xml'))
                            else
                              FileName := FileManagement.OpenFileDialog(Text031,FileName,FileManagement.GetToFilterText('','.txt'));
                        end;
                    }
                    field(GLDocNo;GLDocNo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Document No.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        if FileFormat = Fileformat::"Version 3.70 or Earlier (.txt)" then
          Consolidate.SetGlobals(
            '','',BusUnit."Company Name",
            SubsidCurrencyCode,AdditionalCurrencyCode,ParentCurrencyCode,
            0,ConsolidStartDate,ConsolidEndDate);
        Consolidate.UpdateGLEntryDimSetID;
        Consolidate.SetDocNo(GLDocNo);
        Consolidate.Run(BusUnit);
    end;

    trigger OnPreReport()
    var
        BusUnit2: Record "Business Unit";
        GLSetup: Record "General Ledger Setup";
        FileManagement: Codeunit "File Management";
    begin
        if FileName = '' then
          Error(Text000);
        ServerFileName := FileManagement.UploadFileSilent(FileName);

        if GLDocNo = '' then
          Error(Text015);

        if FileFormat = Fileformat::"Version 4.00 or Later (.xml)" then begin
          Consolidate.ImportFromXML(ServerFileName);
          Consolidate.GetGlobals(
            ProductVersion,FormatVersion,BusUnit."Company Name",
            SubsidCurrencyCode,AdditionalCurrencyCode,ParentCurrencyCode,
            CheckSum,ConsolidStartDate,ConsolidEndDate);
          CalculatedCheckSum := Consolidate.CalcCheckSum;
          if CheckSum <> CalculatedCheckSum then
            Error(Text036,CheckSum,CalculatedCheckSum);
          TransferPerDay := true;
        end else begin
          Clear(GLEntryFile);
          GLEntryFile.TextMode := true;
          GLEntryFile.Open(ServerFileName);
          GLEntryFile.Read(TextLine);
          if CopyStr(TextLine,1,4) = '<01>' then begin
            BusUnit."Company Name" := DelChr(CopyStr(TextLine,5,30),'>');
            Evaluate(ConsolidStartDate,CopyStr(TextLine,36,9));
            Evaluate(ConsolidEndDate,CopyStr(TextLine,46,9));
            Evaluate(TransferPerDay,CopyStr(TextLine,56,3));
          end;
        end;

        if (BusUnit."Company Name" = '') or (ConsolidStartDate = 0D) or (ConsolidEndDate = 0D) then
          Error(Text001);

        if not
           Confirm(
             Text023,
             false,ConsolidStartDate,ConsolidEndDate)
        then
          CurrReport.Quit;

        BusUnit.SetCurrentkey("Company Name");
        BusUnit.SetRange("Company Name",BusUnit."Company Name");
        BusUnit.Find('-');
        if BusUnit.Next <> 0 then
          Error(
            Text005 +
            Text006,
            BusUnit.FieldCaption("Company Name"),BusUnit."Company Name");
        BusUnit.TestField(Consolidate,true);

        BusUnit2."File Format" := FileFormat;
        if BusUnit."File Format" <> FileFormat then
          if not Confirm(
               Text037 + Text038,false,
               BusUnit.FieldCaption("File Format"),BusUnit2."File Format",BusUnit.TableCaption,BusUnit."File Format")
          then
            CurrReport.Quit;

        if FileFormat = Fileformat::"Version 4.00 or Later (.xml)" then begin
          if SubsidCurrencyCode = '' then
            SubsidCurrencyCode := BusUnit."Currency Code";
          GLSetup.Get;
          if (SubsidCurrencyCode <> BusUnit."Currency Code") and
             (SubsidCurrencyCode <> GLSetup."LCY Code") and
             not ((BusUnit."Currency Code" = '') and (GLSetup."LCY Code" = ''))
          then
            Error(
              Text002,
              BusUnit.FieldCaption("Currency Code"),SubsidCurrencyCode,
              BusUnit.TableCaption,BusUnit."Currency Code");
        end else begin
          SubsidCurrencyCode := BusUnit."Currency Code";
          Window.Open(
            '#1###############################\\' +
            Text024 +
            Text025 +
            Text026);
          Window.Update(1,Text027);
          Window.Update(2,BusUnit.Code);
          Window.Update(3,'');
        end;
    end;

    var
        Text000: label 'Enter the file name.';
        Text001: label 'The file to be imported has an unknown format.';
        Text002: label 'The %1 in the file to be imported (%2) does not match the %1 in the %3 (%4).';
        Text005: label 'The business unit %1 %2 is not unique.\\';
        Text006: label 'Delete %1 in the extra records.';
        Text015: label 'Enter a document number.';
        Text023: label 'Do you want to consolidate in the period from %1 to %2?';
        Text024: label 'Business Unit Code   #2##########\';
        Text025: label 'G/L Account No.      #3##########\';
        Text026: label 'Date                 #4######';
        Text027: label 'Reading File...';
        Text031: label 'Import from Text File';
        BusUnit: Record "Business Unit";
        Consolidate: Codeunit Consolidate;
        Window: Dialog;
        GLEntryFile: File;
        FileName: Text;
        FileFormat: Option "Version 4.00 or Later (.xml)","Version 3.70 or Earlier (.txt)";
        TextLine: Text[250];
        GLDocNo: Code[20];
        ConsolidStartDate: Date;
        ConsolidEndDate: Date;
        TransferPerDay: Boolean;
        CheckSum: Decimal;
        CalculatedCheckSum: Decimal;
        Text034: label 'Import from XML File';
        ParentCurrencyCode: Code[10];
        SubsidCurrencyCode: Code[10];
        AdditionalCurrencyCode: Code[10];
        ProductVersion: Code[10];
        FormatVersion: Code[10];
        Text036: label 'Imported checksum (%1) does not equal the calculated checksum (%2). The file may be corrupt.';
        Text037: label 'The entered %1, %2, does not equal the %1 on this %3, %4.';
        Text038: label '\Do you want to continue?';
        ServerFileName: Text;


    procedure InitializeRequest(NewFileFormat: Option;NewFileName: Text;NewGLDocNo: Code[20])
    begin
        FileFormat := NewFileFormat;
        FileName := NewFileName;
        GLDocNo := NewGLDocNo;
    end;
}

