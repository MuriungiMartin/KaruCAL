#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 190 "Issue Reminders"
{
    Caption = 'Issue Reminders';
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
                Clear(ReminderIssue);
                ReminderIssue.Set("Reminder Header",ReplacePostingDate,PostingDateReq);
                if NoOfRecords = 1 then begin
                  ReminderIssue.Run;
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
                  Commit;
                  Mark := not ReminderIssue.Run;
                end;

                if PrintDoc <> Printdoc::" " then begin
                  ReminderIssue.GetIssuedReminder(IssuedReminderHeader);
                  TempIssuedReminderHeader := IssuedReminderHeader;
                  TempIssuedReminderHeader.Insert;
                end;
            end;

            trigger OnPostDataItem()
            var
                IssuedReminderHeaderPrint: Record "Issued Reminder Header";
            begin
                Window.Close;
                Commit;
                if PrintDoc <> Printdoc::" " then
                  if TempIssuedReminderHeader.FindSet then
                    repeat
                      IssuedReminderHeaderPrint := TempIssuedReminderHeader;
                      IssuedReminderHeaderPrint.SetRecfilter;
                      IssuedReminderHeaderPrint.PrintRecords(false,PrintDoc = Printdoc::Email,HideDialog);
                    until TempIssuedReminderHeader.Next = 0;
                MarkedOnly := true;
                if Find('-') then
                  if Confirm(Text003,true) then
                    Page.RunModal(0,"Reminder Header");
            end;

            trigger OnPreDataItem()
            begin
                if ReplacePostingDate and (PostingDateReq = 0D) then
                  Error(Text000);
                NoOfRecords := Count;
                if NoOfRecords = 1 then
                  Window.Open(Text001)
                else begin
                  Window.Open(Text002);
                  OldTime := Time;
                end;
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
                    field(PrintDoc;PrintDoc)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Print';
                        Enabled = not IsOfficeAddin;
                    }
                    field(ReplacePostingDate;ReplacePostingDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Replace Posting Date';
                    }
                    field(PostingDateReq;PostingDateReq)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posting Date';
                    }
                    field(HideEmailDialog;HideDialog)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Hide Email Dialog';
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
    var
        OfficeMgt: Codeunit "Office Management";
    begin
        IsOfficeAddin := OfficeMgt.IsAvailable;
        if IsOfficeAddin then
          PrintDoc := 2;
    end;

    var
        Text000: label 'Enter the posting date.';
        Text001: label 'Issuing reminder...';
        Text002: label 'Issuing reminders @1@@@@@@@@@@@@@';
        Text003: label 'It was not possible to issue some of the selected reminders.\Do you want to see these reminders?';
        IssuedReminderHeader: Record "Issued Reminder Header";
        TempIssuedReminderHeader: Record "Issued Reminder Header" temporary;
        ReminderIssue: Codeunit "Reminder-Issue";
        Window: Dialog;
        NoOfRecords: Integer;
        RecordNo: Integer;
        NewProgress: Integer;
        OldProgress: Integer;
        NewTime: Time;
        OldTime: Time;
        PostingDateReq: Date;
        ReplacePostingDate: Boolean;
        PrintDoc: Option " ",Print,Email;
        HideDialog: Boolean;
        [InDataSet]
        IsOfficeAddin: Boolean;
}

