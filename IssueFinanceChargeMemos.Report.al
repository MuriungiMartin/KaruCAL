#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 193 "Issue Finance Charge Memos"
{
    Caption = 'Issue Finance Charge Memos';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Finance Charge Memo Header";"Finance Charge Memo Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Finance Charge Memo';
            column(ReportForNavId_8733; 8733)
            {
            }

            trigger OnAfterGetRecord()
            begin
                RecordNo := RecordNo + 1;
                Clear(FinChrgMemoIssue);
                FinChrgMemoIssue.Set("Finance Charge Memo Header",ReplacePostingDate,PostingDateReq);
                if NoOfRecords = 1 then begin
                  FinChrgMemoIssue.Run;
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
                  Mark := not FinChrgMemoIssue.Run;
                end;

                if (PrintDoc <> Printdoc::" ") and not Mark then begin
                  FinChrgMemoIssue.GetIssuedFinChrgMemo(IssuedFinChrgMemoHeader);
                  TempIssuedFinChrgMemoHeader := IssuedFinChrgMemoHeader;
                  TempIssuedFinChrgMemoHeader.Insert;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
                Commit;
                if PrintDoc <> Printdoc::" " then
                  if TempIssuedFinChrgMemoHeader.FindSet then
                    repeat
                      IssuedFinChrgMemoHeader := TempIssuedFinChrgMemoHeader;
                      IssuedFinChrgMemoHeader.SetRecfilter;
                      IssuedFinChrgMemoHeader.PrintRecords(false,PrintDoc = Printdoc::Email,HideDialog);
                    until TempIssuedFinChrgMemoHeader.Next = 0;
                MarkedOnly := true;
                if Find('-') then
                  if Confirm(Text003,true) then
                    Page.RunModal(0,"Finance Charge Memo Header");
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

    var
        Text000: label 'Enter the posting date.';
        Text001: label 'Issuing finance charge memo...';
        Text002: label 'Issuing finance charge memos @1@@@@@@@@@@@@@';
        Text003: label 'It was not possible to issue some of the selected finance charge memos.\Do you want to see these finance charge memos?';
        IssuedFinChrgMemoHeader: Record "Issued Fin. Charge Memo Header";
        TempIssuedFinChrgMemoHeader: Record "Issued Fin. Charge Memo Header" temporary;
        FinChrgMemoIssue: Codeunit "FinChrgMemo-Issue";
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
}

