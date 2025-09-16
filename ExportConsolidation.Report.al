#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 91 "Export Consolidation"
{
    Caption = 'Export Consolidation';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("G/L Account";"G/L Account")
        {
            DataItemTableView = sorting("No.") where("Account Type"=const(Posting));
            column(ReportForNavId_6710; 6710)
            {
            }
            dataitem("G/L Entry";"G/L Entry")
            {
                DataItemLink = "G/L Account No."=field("No.");
                DataItemTableView = sorting("G/L Account No.","Posting Date");
                column(ReportForNavId_7069; 7069)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2,"Posting Date");
                    SetRange("Posting Date","Posting Date");

                    if not TempSelectedDim.FindFirst then begin
                      CalcSums(
                        Amount,"Debit Amount","Credit Amount",
                        "Add.-Currency Debit Amount","Add.-Currency Credit Amount");
                      if (Amount <> 0) or ("Debit Amount" <> 0) or ("Credit Amount" <> 0) then begin
                        TempGLEntry.Reset;
                        TempGLEntry.DeleteAll;
                        TempDimBufOut.Reset;
                        TempDimBufOut.DeleteAll;
                        TempGLEntry := "G/L Entry";
                        TempGLEntry.Insert;
                        if FileFormat = Fileformat::"Version 4.00 or Later (.xml)" then
                          Consolidate.InsertGLEntry(TempGLEntry)
                        else begin
                          UpdateExportedInfo(TempGLEntry);
                          WriteFile(TempGLEntry,TempDimBufOut);
                        end;
                      end;
                      Find('+');
                    end else begin
                      TempGLEntry.Reset;
                      TempGLEntry.DeleteAll;
                      DimBufMgt.DeleteAllDimensions;
                      repeat
                        TempDimBufIn.Reset;
                        TempDimBufIn.DeleteAll;
                        DimSetEntry.Reset;
                        DimSetEntry.SetRange("Dimension Set ID","Dimension Set ID");
                        if DimSetEntry.FindSet then begin
                          repeat
                            if TempSelectedDim.Get(UserId,3,Report::"Export Consolidation",'',DimSetEntry."Dimension Code") then begin
                              TempDimBufIn.Init;
                              TempDimBufIn."Table ID" := Database::"G/L Entry";
                              TempDimBufIn."Entry No." := "Entry No.";
                              if TempDim.Get(DimSetEntry."Dimension Code") then
                                if TempDim."Consolidation Code" <> '' then
                                  TempDimBufIn."Dimension Code" := TempDim."Consolidation Code"
                                else
                                  TempDimBufIn."Dimension Code" := TempDim.Code
                              else
                                TempDimBufIn."Dimension Code" := DimSetEntry."Dimension Code";
                              if TempDimVal.Get(DimSetEntry."Dimension Code",DimSetEntry."Dimension Value Code") then
                                if TempDimVal."Consolidation Code" <> '' then
                                  TempDimBufIn."Dimension Value Code" := TempDimVal."Consolidation Code"
                                else
                                  TempDimBufIn."Dimension Value Code" := TempDimVal.Code
                              else
                                TempDimBufIn."Dimension Value Code" := DimSetEntry."Dimension Value Code";
                              TempDimBufIn.Insert;
                            end;
                          until DimSetEntry.Next = 0;
                        end;
                        UpdateTempGLEntry(TempDimBufIn);
                      until Next = 0;

                      TempGLEntry.Reset;
                      if TempGLEntry.FindSet then begin
                        repeat
                          TempDimBufOut.Reset;
                          TempDimBufOut.DeleteAll;
                          DimBufMgt.GetDimensions(TempGLEntry."Entry No.",TempDimBufOut);
                          TempDimBufOut.SetRange("Entry No.",TempGLEntry."Entry No.");
                          if FileFormat = Fileformat::"Version 4.00 or Later (.xml)" then begin
                            if (TempGLEntry."Debit Amount" <> 0) or (TempGLEntry."Credit Amount" <> 0) then
                              WriteFile(TempGLEntry,TempDimBufOut);
                          end else begin
                            UpdateExportedInfo(TempGLEntry);
                            if TempGLEntry.Amount <> 0 then
                              WriteFile(TempGLEntry,TempDimBufOut);
                          end;
                        until TempGLEntry.Next = 0;
                      end;
                    end;

                    SetRange("Posting Date",ConsolidStartDate,ConsolidEndDate);
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Posting Date",ConsolidStartDate,ConsolidEndDate);

                    TempDimBufIn.SetRange("Table ID",Database::"G/L Entry");
                    TempDimBufOut.SetRange("Table ID",Database::"G/L Entry");

                    if ConsolidStartDate = NormalDate(ConsolidStartDate) then
                      CheckClosingPostings("G/L Account"."No.",ConsolidStartDate,ConsolidEndDate);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(1,"No.");
                Window.Update(2,'');
                if FileFormat = Fileformat::"Version 4.00 or Later (.xml)" then
                  Consolidate.InsertGLAccount("G/L Account");
            end;

            trigger OnPostDataItem()
            begin
                if FileFormat = Fileformat::"Version 3.70 or Earlier (.txt)" then
                  GLEntryFile.Close;
            end;

            trigger OnPreDataItem()
            begin
                if ServerFileName = '' then
                  Error(Text000);
                if ConsolidStartDate = 0D then
                  Error(Text001);
                if ConsolidEndDate = 0D then
                  Error(Text002);

                CheckClosingDates(ConsolidStartDate,ConsolidEndDate,TransferPerDay);

                if NormalDate(ConsolidEndDate) - NormalDate(ConsolidStartDate) + 1 > 500 then
                  Error(Text003);

                if Dim.Find('-') then begin
                  repeat
                    TempDim.Init;
                    TempDim := Dim;
                    TempDim.Insert;
                  until Dim.Next = 0;
                end;
                if DimVal.Find('-') then begin
                  repeat
                    TempDimVal.Init;
                    TempDimVal := DimVal;
                    TempDimVal.Insert;
                  until DimVal.Next = 0;
                end;

                SelectedDim.SetRange("User ID",UserId);
                SelectedDim.SetRange("Object Type",3);
                SelectedDim.SetRange("Object ID",Report::"Export Consolidation");
                if SelectedDim.Find('-') then begin
                  repeat
                    TempSelectedDim.Init;
                    TempSelectedDim := SelectedDim;
                    TempDim.SetRange("Consolidation Code",SelectedDim."Dimension Code");
                    if TempDim.FindFirst then
                      TempSelectedDim."Dimension Code" := TempDim.Code;
                    TempSelectedDim.Insert;
                  until SelectedDim.Next = 0;
                end;
                TempDim.Reset;

                if FileFormat = Fileformat::"Version 3.70 or Earlier (.txt)" then begin
                  Clear(GLEntryFile);
                  GLEntryFile.TextMode := true;
                  GLEntryFile.WriteMode := true;
                  GLEntryFile.Create(ServerFileName);
                  GLEntryFile.Write(
                    StrSubstNo(
                      '<01>#1############################ #2####### #3####### #4#',
                      COMPANYNAME,ConsolidStartDate,ConsolidEndDate,Format(TransferPerDay,0,2)));
                end;

                Window.Open(
                  Text004 +
                  Text005 +
                  Text006);
            end;
        }
        dataitem("Currency Exchange Rate";"Currency Exchange Rate")
        {
            DataItemTableView = sorting("Currency Code","Starting Date");
            column(ReportForNavId_8685; 8685)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Consolidate.InsertExchRate("Currency Exchange Rate");
            end;

            trigger OnPostDataItem()
            begin
                if FileFormat = Fileformat::"Version 4.00 or Later (.xml)" then begin
                  Consolidate.SetGlobals(
                    ProductVersion,FormatVersion,COMPANYNAME,
                    GLSetup."LCY Code",GLSetup."Additional Reporting Currency",ParentCurrencyCode,
                    0,ConsolidStartDate,ConsolidEndDate);
                  Consolidate.SetGlobals(
                    ProductVersion,FormatVersion,COMPANYNAME,
                    GLSetup."LCY Code",GLSetup."Additional Reporting Currency",ParentCurrencyCode,
                    Consolidate.CalcCheckSum,ConsolidStartDate,ConsolidEndDate);
                  Consolidate.ExportToXML(ServerFileName);
                end;
            end;

            trigger OnPreDataItem()
            begin
                if FileFormat = Fileformat::"Version 3.70 or Earlier (.txt)" then
                  CurrReport.Break;
                GLSetup.Get;
                if GLSetup."Additional Reporting Currency" = '' then
                  SetRange("Currency Code",ParentCurrencyCode)
                else
                  SetFilter("Currency Code",'%1|%2',ParentCurrencyCode,GLSetup."Additional Reporting Currency");
                SetRange("Starting Date",0D,ConsolidEndDate);
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
                    field(ClientFileNameControl;ClientFileName)
                    {
                        ApplicationArea = Basic;
                        Caption = 'File Name';

                        trigger OnAssistEdit()
                        var
                            FileManagement: Codeunit "File Management";
                        begin
                            if FileFormat = Fileformat::"Version 4.00 or Later (.xml)" then
                              ClientFileName := FileManagement.SaveFileDialog(Text011,ClientFileName,FileManagement.GetToFilterText('','.xml'))
                            else
                              ClientFileName := FileManagement.SaveFileDialog(Text008,ClientFileName,FileManagement.GetToFilterText('','.txt'));
                        end;
                    }
                    group("Consolidation Period")
                    {
                        Caption = 'Consolidation Period';
                        field(StartDate;ConsolidStartDate)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Starting Date';
                            ClosingDates = true;
                        }
                        field(EndDate;ConsolidEndDate)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Ending Date';
                            ClosingDates = true;
                        }
                    }
                    group("Copy Field Contents")
                    {
                        Caption = 'Copy Field Contents';
                        field(ColumnDim;ColumnDim)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Copy Dimensions';
                            Editable = false;

                            trigger OnAssistEdit()
                            begin
                                DimSelectionBuf.SetDimSelectionMultiple(3,Report::"Export Consolidation",ColumnDim);
                            end;
                        }
                    }
                    field(ParentCurrencyCode;ParentCurrencyCode)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Parent Currency Code';
                        TableRelation = Currency;
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

    trigger OnInitReport()
    begin
        TransferPerDay := true;
    end;

    trigger OnPostReport()
    var
        FileManagement: Codeunit "File Management";
    begin
        FileManagement.DownloadToFile(ServerFileName,ClientFileName);
    end;

    trigger OnPreReport()
    var
        FileMgt: Codeunit "File Management";
    begin
        DimSelectionBuf.CompareDimText(3,Report::"Export Consolidation",'',ColumnDim,Text007);
        ServerFileName := FileMgt.ServerTempFileName('xml');
    end;

    var
        ProductVersion: label '4.00';
        FormatVersion: label '1.00';
        Text000: label 'Enter the file name.';
        Text001: label 'Enter the starting date for the consolidation period.';
        Text002: label 'Enter the ending date for the consolidation period.';
        Text003: label 'The export can include a maximum of 500 days.';
        Text004: label 'Processing the chart of accounts...\\';
        Text005: label 'No.             #1##########\';
        Text006: label 'Date            #2######';
        Text007: label 'Copy Dimensions';
        Text008: label 'Export to Text File';
        Text009: label 'A G/L Entry with posting date on a closing date (%1) was found while exporting nonclosing entries. G/L Account No. = %2.';
        Text010: label 'When using closing dates, the starting and ending dates must be the same.';
        TempGLEntry: Record "G/L Entry" temporary;
        DimSetEntry: Record "Dimension Set Entry";
        Dim: Record Dimension;
        DimVal: Record "Dimension Value";
        TempDim: Record Dimension temporary;
        TempDimVal: Record "Dimension Value" temporary;
        SelectedDim: Record "Selected Dimension";
        TempSelectedDim: Record "Selected Dimension" temporary;
        TempDimBufIn: Record "Dimension Buffer" temporary;
        TempDimBufOut: Record "Dimension Buffer" temporary;
        DimSelectionBuf: Record "Dimension Selection Buffer";
        GLSetup: Record "General Ledger Setup";
        DimBufMgt: Codeunit "Dimension Buffer Management";
        Consolidate: Codeunit Consolidate;
        Window: Dialog;
        GLEntryFile: File;
        ServerFileName: Text;
        FileFormat: Option "Version 4.00 or Later (.xml)","Version 3.70 or Earlier (.txt)";
        ConsolidStartDate: Date;
        ConsolidEndDate: Date;
        TransferPerDay: Boolean;
        TransferPerDayReq: Boolean;
        ColumnDim: Text[250];
        ParentCurrencyCode: Code[10];
        Text011: label 'Export to XML File';
        ClientFileName: Text;

    local procedure WriteFile(var GLEntry2: Record "G/L Entry";var DimBuf: Record "Dimension Buffer")
    var
        GLEntryNo: Integer;
    begin
        if FileFormat = Fileformat::"Version 4.00 or Later (.xml)" then
          GLEntryNo := Consolidate.InsertGLEntry(GLEntry2)
        else
          GLEntryFile.Write(
            StrSubstNo(
              '<02>#1################## #2####### #3####################',
              GLEntry2."G/L Account No.",
              GLEntry2."Posting Date",
              GLEntry2.Amount));

        if DimBuf.Find('-') then begin
          repeat
            if FileFormat = Fileformat::"Version 4.00 or Later (.xml)" then
              Consolidate.InsertEntryDim(DimBuf,GLEntryNo)
            else
              GLEntryFile.Write(
                StrSubstNo(
                  '<03>#1################## #2##################',
                  DimBuf."Dimension Code",
                  DimBuf."Dimension Value Code"));
          until DimBuf.Next = 0;
        end;
    end;

    local procedure UpdateTempGLEntry(var TempDimBuf: Record "Dimension Buffer" temporary)
    var
        DimEntryNo: Integer;
    begin
        DimEntryNo := DimBufMgt.FindDimensions(TempDimBuf);
        if (not TempDimBuf.IsEmpty) and (DimEntryNo = 0) then begin
          TempGLEntry := "G/L Entry";
          TempGLEntry."Entry No." := DimBufMgt.InsertDimensions(TempDimBuf);
          TempGLEntry.Insert;
        end else
          if TempGLEntry.Get(DimEntryNo) then begin
            TempGLEntry.Amount := TempGLEntry.Amount + "G/L Entry".Amount;
            TempGLEntry."Debit Amount" := TempGLEntry."Debit Amount" + "G/L Entry"."Debit Amount";
            TempGLEntry."Credit Amount" := TempGLEntry."Credit Amount" + "G/L Entry"."Credit Amount";
            TempGLEntry."Additional-Currency Amount" :=
              TempGLEntry."Additional-Currency Amount" + "G/L Entry"."Additional-Currency Amount";
            TempGLEntry."Add.-Currency Debit Amount" :=
              TempGLEntry."Add.-Currency Debit Amount" + "G/L Entry"."Add.-Currency Debit Amount";
            TempGLEntry."Add.-Currency Credit Amount" :=
              TempGLEntry."Add.-Currency Credit Amount" + "G/L Entry"."Add.-Currency Credit Amount";
            TempGLEntry.Modify;
          end else begin
            TempGLEntry := "G/L Entry";
            TempGLEntry."Entry No." := DimEntryNo;
            TempGLEntry.Insert;
          end;
    end;

    local procedure UpdateExportedInfo(var GLEntry3: Record "G/L Entry")
    begin
        with GLEntry3 do begin
          if Amount < 0 then begin
            "G/L Account".TestField("Consol. Credit Acc.");
            "G/L Account No." := "G/L Account"."Consol. Credit Acc.";
          end else begin
            "G/L Account".TestField("Consol. Debit Acc.");
            "G/L Account No." := "G/L Account"."Consol. Debit Acc.";
          end;
          Modify;
        end;
    end;

    local procedure CheckClosingPostings(GLAccNo: Code[20];StartDate: Date;EndDate: Date)
    var
        GLEntry: Record "G/L Entry";
        AccountingPeriod: Record "Accounting Period";
    begin
        AccountingPeriod.SetCurrentkey("New Fiscal Year","Date Locked");
        AccountingPeriod.SetRange("New Fiscal Year",true);
        AccountingPeriod.SetRange("Date Locked",true);
        AccountingPeriod.SetRange("Starting Date",StartDate + 1,EndDate);
        if AccountingPeriod.Find('-') then begin
          GLEntry.SetRange("G/L Account No.",GLAccNo);
          repeat
            GLEntry.SetRange("Posting Date",ClosingDate(AccountingPeriod."Starting Date" - 1));
            if not GLEntry.IsEmpty then
              Error(
                Text009,
                GLEntry.GetFilter("Posting Date"),
                GLAccNo);
          until AccountingPeriod.Next = 0;
        end;
    end;

    local procedure CheckClosingDates(StartDate: Date;EndDate: Date;var TransferPerDay: Boolean)
    begin
        if (StartDate = ClosingDate(StartDate)) or
           (EndDate = ClosingDate(EndDate))
        then begin
          if StartDate <> EndDate then
            Error(Text010);
          TransferPerDay := false;
        end else
          TransferPerDay := TransferPerDayReq;
    end;


    procedure InitializeRequest(NewFileFormat: Option;NewFileName: Text)
    begin
        FileFormat := NewFileFormat;
        ClientFileName := NewFileName;
    end;
}

