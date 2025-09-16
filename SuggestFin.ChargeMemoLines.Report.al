#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 192 "Suggest Fin. Charge Memo Lines"
{
    Caption = 'Suggest Fin. Charge Memo Lines';
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
                Clear(MakeFinChrgMemo);
                MakeFinChrgMemo.SuggestLines("Finance Charge Memo Header",CustLedgEntry);
                if NoOfRecords = 1 then begin
                  MakeFinChrgMemo.Code;
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
                  Mark := not MakeFinChrgMemo.Run;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Commit;
                Window.Close;
                MarkedOnly := true;
                if Find('-') then
                  if Confirm(Text002,true) then
                    Page.RunModal(0,"Finance Charge Memo Header");
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
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
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
        CustLedgEntry.Copy(CustLedgEntry2);
    end;

    var
        Text000: label 'Suggesting lines...';
        Text001: label 'Suggesting lines @1@@@@@@@@@@@@@';
        Text002: label 'It was not possible to process some of the selected finance charge memos.\Do you want to see these finance charge memos?';
        CustLedgEntry: Record "Cust. Ledger Entry";
        MakeFinChrgMemo: Codeunit "FinChrgMemo-Make";
        Window: Dialog;
        NoOfRecords: Integer;
        RecordNo: Integer;
        NewProgress: Integer;
        OldProgress: Integer;
        NewTime: Time;
        OldTime: Time;
}

