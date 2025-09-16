#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 188 "Create Reminders"
{
    Caption = 'Create Reminders';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(ReportForNavId_6836; 6836)
            {
            }

            trigger OnAfterGetRecord()
            begin
                RecordNo := RecordNo + 1;
                Clear(MakeReminder);
                MakeReminder.Set(Customer,CustLedgEntry,ReminderHeaderReq,OverdueEntriesOnly,IncludeEntriesOnHold,CustLedgEntryLineFeeOn);
                if NoOfRecords = 1 then begin
                  MakeReminder.Code;
                  Mark := false;
                end else begin
                  NewTime := Time;
                  if (NewTime - OldTime > 100) or (NewTime < OldTime) then begin
                    NewProgress := ROUND(RecordNo / NoOfRecords * 100,1);
                    if NewProgress <> OldProgress then begin
                      Window.Update(1,NewProgress * 100);
                      OldProgress := NewProgress;
                    end;
                    OldTime := Time;
                  end;
                  Mark := not MakeReminder.Code;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
                MarkedOnly := true;
                Commit;
                if Find('-') then
                  if Confirm(Text003,true) then
                    Page.RunModal(0,Customer);
            end;

            trigger OnPreDataItem()
            var
                SalesSetup: Record "Sales & Receivables Setup";
            begin
                if ReminderHeaderReq."Document Date" = 0D then
                  Error(Text000,ReminderHeaderReq.FieldCaption("Document Date"));
                FilterGroup := 2;
                SetFilter("Reminder Terms Code",'<>%1','');
                FilterGroup := 0;
                NoOfRecords := Count;
                SalesSetup.Get;
                SalesSetup.TestField("Reminder Nos.");
                if NoOfRecords = 1 then
                  Window.Open(Text001)
                else begin
                  Window.Open(Text002);
                  OldTime := Time;
                end;
                ReminderHeaderReq."Use Header Level" := UseHeaderLevel;
            end;
        }
        dataitem(CustLedgEntry2;"Cust. Ledger Entry")
        {
            DataItemTableView = sorting("Customer No.");
            RequestFilterFields = "Document Type";
            column(ReportForNavId_9065; 9065)
            {
            }

            trigger OnPreDataItem()
            begin
                CurrReport.Break;
            end;
        }
        dataitem(CustLedgEntryLineFeeOn;"Cust. Ledger Entry")
        {
            DataItemTableView = sorting("Entry No.") order(ascending);
            RequestFilterFields = "Document Type";
            RequestFilterHeading = 'Apply Fee per Line On';
            column(ReportForNavId_1000; 1000)
            {
            }

            trigger OnPreDataItem()
            begin
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
                    field("ReminderHeaderReq.""Posting Date""";ReminderHeaderReq."Posting Date")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posting Date';
                    }
                    field(DocumentDate;ReminderHeaderReq."Document Date")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Document Date';
                    }
                    field(OverdueEntriesOnly;OverdueEntriesOnly)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Only Entries with Overdue Amounts';
                        MultiLine = true;
                    }
                    field(IncludeEntriesOnHold;IncludeEntriesOnHold)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Include Entries On Hold';
                    }
                    field(UseHeaderLevel;UseHeaderLevel)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Use Header Level';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if ReminderHeaderReq."Document Date" = 0D then begin
              ReminderHeaderReq."Document Date" := WorkDate;
              ReminderHeaderReq."Posting Date" := WorkDate;
            end;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        OverdueEntriesOnly := true;
    end;

    trigger OnPreReport()
    begin
        CustLedgEntry.Copy(CustLedgEntry2);
        if CustLedgEntryLineFeeOnFilters.GetFilters <> '' then
          CustLedgEntryLineFeeOn.CopyFilters(CustLedgEntryLineFeeOnFilters);
    end;

    var
        Text000: label '%1 must be specified.';
        Text001: label 'Making reminders...';
        Text002: label 'Making reminders @1@@@@@@@@@@@@@';
        Text003: label 'It was not possible to create reminders for some of the selected customers.\Do you want to see these customers?';
        CustLedgEntry: Record "Cust. Ledger Entry";
        ReminderHeaderReq: Record "Reminder Header";
        CustLedgEntryLineFeeOnFilters: Record "Cust. Ledger Entry";
        MakeReminder: Codeunit "Reminder-Make";
        Window: Dialog;
        NoOfRecords: Integer;
        RecordNo: Integer;
        NewProgress: Integer;
        OldProgress: Integer;
        NewTime: Time;
        OldTime: Time;
        OverdueEntriesOnly: Boolean;
        UseHeaderLevel: Boolean;
        IncludeEntriesOnHold: Boolean;


    procedure InitializeRequest(DocumentDate: Date;PostingDate: Date;OverdueEntries: Boolean;NewUseHeaderLevel: Boolean;IncludeEntries: Boolean)
    begin
        ReminderHeaderReq."Document Date" := DocumentDate;
        ReminderHeaderReq."Posting Date" := PostingDate;
        OverdueEntriesOnly := OverdueEntries;
        UseHeaderLevel := NewUseHeaderLevel;
        IncludeEntriesOnHold := IncludeEntries;
    end;


    procedure SetApplyLineFeeOnFilters(var CustLedgEntryLineFeeOn2: Record "Cust. Ledger Entry")
    begin
        CustLedgEntryLineFeeOnFilters.CopyFilters(CustLedgEntryLineFeeOn2);
    end;
}

