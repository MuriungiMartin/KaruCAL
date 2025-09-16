#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1495 "Delete Check Ledger Entries"
{
    Caption = 'Delete Check Ledger Entries';
    Permissions = TableData "Check Ledger Entry"=rimd,
                  TableData "G/L Register"=rimd,
                  TableData "Date Compr. Register"=rimd;
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Check Ledger Entry";"Check Ledger Entry")
        {
            DataItemTableView = sorting("Bank Account No.","Check Date") where("Entry Status"=filter(<>Printed));
            RequestFilterFields = "Bank Account No.","Bank Payment Type";
            column(ReportForNavId_5439; 5439)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CheckLedgEntry2 := "Check Ledger Entry";
                with CheckLedgEntry2 do begin
                  SetCurrentkey("Bank Account No.","Check Date");
                  CopyFilters("Check Ledger Entry");

                  Window.Update(1,"Bank Account No.");

                  repeat
                    Delete;
                    DateComprReg."No. Records Deleted" := DateComprReg."No. Records Deleted" + 1;
                    Window.Update(4,DateComprReg."No. Records Deleted");
                  until Next = 0;
                end;

                if DateComprReg."No. Records Deleted" >= NoOfDeleted + 10 then begin
                  NoOfDeleted := DateComprReg."No. Records Deleted";
                  InsertRegisters(DateComprReg);
                end;
            end;

            trigger OnPostDataItem()
            begin
                if DateComprReg."No. Records Deleted" > NoOfDeleted then
                  InsertRegisters(DateComprReg);
            end;

            trigger OnPreDataItem()
            begin
                if not Confirm(Text000,false) then
                  CurrReport.Break;

                if EntrdDateComprReg."Ending Date" = 0D then
                  Error(StrSubstNo(Text003,EntrdDateComprReg.FieldCaption("Ending Date")));

                Window.Open(Text004);

                SourceCodeSetup.Get;
                SourceCodeSetup.TestField("Compress Check Ledger");

                CheckLedgEntry2.LockTable;
                if CheckLedgEntry3.FindLast then;
                DateComprReg.LockTable;

                SetRange("Check Date",EntrdDateComprReg."Starting Date",EntrdDateComprReg."Ending Date");
                DateComprMgt.GetDateFilter(EntrdDateComprReg."Ending Date",EntrdDateComprReg,true);

                InitRegister;
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
                    field("EntrdDateComprReg.""Starting Date""";EntrdDateComprReg."Starting Date")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Starting Date';
                    }
                    field("EntrdDateComprReg.""Ending Date""";EntrdDateComprReg."Ending Date")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Ending Date';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if EntrdDateComprReg."Ending Date" = 0D then
              EntrdDateComprReg."Ending Date" := Today;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CheckLedgEntryFilter := CopyStr("Check Ledger Entry".GetFilters,1,MaxStrLen(DateComprReg.Filter));
    end;

    var
        Text000: label 'This batch job deletes entries. Therefore, it is important that you make a backup of the database before you run the batch job.\\Do you want to date compress the entries?';
        Text003: label '%1 must be specified.';
        Text004: label 'Date compressing check ledger entries...\\Bank Account No.       #1##########\No. of entries deleted #4######';
        Text007: label 'All records deleted';
        SourceCodeSetup: Record "Source Code Setup";
        DateComprReg: Record "Date Compr. Register";
        EntrdDateComprReg: Record "Date Compr. Register";
        CheckLedgEntry2: Record "Check Ledger Entry";
        CheckLedgEntry3: Record "Check Ledger Entry";
        DateComprMgt: Codeunit DateComprMgt;
        Window: Dialog;
        CheckLedgEntryFilter: Text[250];
        NoOfDeleted: Integer;
        RegExists: Boolean;

    local procedure InitRegister()
    var
        NextRegNo: Integer;
    begin
        if DateComprReg.FindLast then
          NextRegNo := DateComprReg."No." + 1;

        DateComprReg.InitRegister(
          Database::"Check Ledger Entry",NextRegNo,
          EntrdDateComprReg."Starting Date",EntrdDateComprReg."Ending Date",EntrdDateComprReg."Period Length",
          CheckLedgEntryFilter,0,SourceCodeSetup."Compress Check Ledger");

        DateComprReg."Retain Field Contents" := Text007;

        RegExists := false;
        NoOfDeleted := 0;
    end;

    local procedure InsertRegisters(DateComprReg: Record "Date Compr. Register")
    begin
        if RegExists then begin
          DateComprReg.Modify;
        end else begin
          DateComprReg.Insert;
          RegExists := true;
        end;
        Commit;

        CheckLedgEntry2.LockTable;
        if CheckLedgEntry3.FindLast then;
        DateComprReg.LockTable;

        InitRegister;
    end;


    procedure InitializeRequest(StartingDate: Date;EndingDate: Date)
    begin
        EntrdDateComprReg."Starting Date" := StartingDate;
        EntrdDateComprReg."Ending Date" := EndingDate;
    end;
}

