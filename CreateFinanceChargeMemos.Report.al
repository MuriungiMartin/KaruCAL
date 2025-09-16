#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 191 "Create Finance Charge Memos"
{
    Caption = 'Create Finance Charge Memos';
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
                Clear(MakeFinChrgMemo);
                MakeFinChrgMemo.Set(Customer,CustLedgEntry,FinChrgMemoHeaderReq);
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
                  Mark := not MakeFinChrgMemo.Code;
                end;
                Commit;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
                MarkedOnly := true;
                if Find('-') then
                  if Confirm(Text003,true) then
                    Page.RunModal(0,Customer);
            end;

            trigger OnPreDataItem()
            begin
                if FinChrgMemoHeaderReq."Document Date" = 0D then
                  Error(Text000,FinChrgMemoHeaderReq.FieldCaption("Document Date"));
                FilterGroup := 2;
                SetFilter("Fin. Charge Terms Code",'<>%1','');
                FilterGroup := 0;
                NoOfRecords := Count;
                if NoOfRecords = 1 then
                  Window.Open(Text001)
                else begin
                  Window.Open(Text002);
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
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field("FinChrgMemoHeaderReq.""Posting Date""";FinChrgMemoHeaderReq."Posting Date")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posting Date';
                    }
                    field(DocumentDate;FinChrgMemoHeaderReq."Document Date")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Document Date';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if FinChrgMemoHeaderReq."Document Date" = 0D then begin
              FinChrgMemoHeaderReq."Document Date" := WorkDate;
              FinChrgMemoHeaderReq."Posting Date" := WorkDate;
            end;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CustLedgEntry.Copy(CustLedgEntry2);
    end;

    var
        Text000: label '%1 must be specified.';
        Text001: label 'Making finance charge memos...';
        Text002: label 'Making finance charge memos @1@@@@@@@@@@@@@';
        Text003: label 'It was not possible to create finance charge memos for some of the selected customers.\Do you want to see these customers?';
        CustLedgEntry: Record "Cust. Ledger Entry";
        FinChrgMemoHeaderReq: Record "Finance Charge Memo Header";
        MakeFinChrgMemo: Codeunit "FinChrgMemo-Make";
        Window: Dialog;
        NoOfRecords: Integer;
        RecordNo: Integer;
        NewProgress: Integer;
        OldProgress: Integer;
        NewTime: Time;
        OldTime: Time;


    procedure InitializeRequest(PostingDate: Date;DocumentDate: Date)
    begin
        FinChrgMemoHeaderReq."Posting Date" := PostingDate;
        FinChrgMemoHeaderReq."Document Date" := DocumentDate;
    end;
}

