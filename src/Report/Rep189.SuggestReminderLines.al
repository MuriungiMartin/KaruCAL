#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 189 "Suggest Reminder Lines"
{
    Caption = 'Suggest Reminder Lines';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Reminder Header";"Reminder Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Reminder';
            column(ReportForNavId_4775; 4775)
            {
            }

            trigger OnAfterGetRecord()
            begin
                RecordNo := RecordNo + 1;
                Clear(MakeReminder);
                MakeReminder.SuggestLines("Reminder Header",CustLedgEntry,OverdueEntriesOnly,IncludeEntriesOnHold,CustLedgEntryLineFeeOn);
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
                  Mark := not MakeReminder.Run;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Commit;
                Window.Close;
                MarkedOnly := true;
                if Find('-') then
                  if Confirm(Text002,true) then
                    Page.RunModal(0,"Reminder Header");
            end;

            trigger OnPreDataItem()
            begin
                NoOfRecords := Count;
                if NoOfRecords = 1 then
                  Window.Open(Text000)
                else begin
                  Window.Open(Text001);
                  OldTime := Time;
                end;
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

    trigger OnPreReport()
    begin
        CustLedgEntry.Copy(CustLedgEntry2)
    end;

    var
        Text000: label 'Suggesting lines...';
        Text001: label 'Suggesting lines @1@@@@@@@@@@@@@';
        Text002: label 'It was not possible to process some of the selected reminders.\Do you want to see these reminders?';
        CustLedgEntry: Record "Cust. Ledger Entry";
        MakeReminder: Codeunit "Reminder-Make";
        Window: Dialog;
        NoOfRecords: Integer;
        RecordNo: Integer;
        NewProgress: Integer;
        OldProgress: Integer;
        NewTime: Time;
        OldTime: Time;
        OverdueEntriesOnly: Boolean;
        IncludeEntriesOnHold: Boolean;
}

