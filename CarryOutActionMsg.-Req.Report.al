#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 493 "Carry Out Action Msg. - Req."
{
    Caption = 'Carry Out Action Msg. - Req.';
    ProcessingOnly = true;

    dataset
    {
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
                    field(PrintOrders;PrintOrders)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Print Orders';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            PurchOrderHeader."Order Date" := WorkDate;
            PurchOrderHeader."Posting Date" := WorkDate;
            PurchOrderHeader."Expected Receipt Date" := WorkDate;
            if ReqWkshTmpl.Recurring then
              EndOrderDate := WorkDate
            else
              EndOrderDate := 0D;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        UseOneJnl(ReqLine);
    end;

    var
        Text000: label 'cannot be filtered when you create orders';
        Text001: label 'There is nothing to create.';
        Text003: label 'You are now in worksheet %1.';
        ReqWkshTmpl: Record "Req. Wksh. Template";
        ReqWkshName: Record "Requisition Wksh. Name";
        ReqLine: Record "Requisition Line";
        PurchOrderHeader: Record "Purchase Header";
        ReqWkshMakeOrders: Codeunit "Req. Wksh.-Make Order";
        EndOrderDate: Date;
        PrintOrders: Boolean;
        TempJnlBatchName: Code[10];
        HideDialog: Boolean;


    procedure SetReqWkshLine(var NewReqLine: Record "Requisition Line")
    begin
        ReqLine.Copy(NewReqLine);
        ReqWkshTmpl.Get(NewReqLine."Worksheet Template Name");
    end;


    procedure GetReqWkshLine(var NewReqLine: Record "Requisition Line")
    begin
        NewReqLine.Copy(ReqLine);
    end;


    procedure SetReqWkshName(var NewReqWkshName: Record "Requisition Wksh. Name")
    begin
        ReqWkshName.Copy(NewReqWkshName);
        ReqWkshTmpl.Get(NewReqWkshName."Worksheet Template Name");
    end;

    local procedure UseOneJnl(var ReqLine: Record "Requisition Line")
    begin
        with ReqLine do begin
          ReqWkshTmpl.Get("Worksheet Template Name");
          if ReqWkshTmpl.Recurring and (GetFilter("Order Date") <> '') then
            FieldError("Order Date",Text000);
          TempJnlBatchName := "Journal Batch Name";
          ReqWkshMakeOrders.Set(PurchOrderHeader,EndOrderDate,PrintOrders);
          ReqWkshMakeOrders.CarryOutBatchAction(ReqLine);

          if "Line No." = 0 then
            Message(Text001)
          else
            if not HideDialog then
              if TempJnlBatchName <> "Journal Batch Name" then
                Message(
                  Text003,
                  "Journal Batch Name");

          if not Find('=><') or (TempJnlBatchName <> "Journal Batch Name") then begin
            Reset;
            FilterGroup := 2;
            SetRange("Worksheet Template Name","Worksheet Template Name");
            SetRange("Journal Batch Name","Journal Batch Name");
            FilterGroup := 0;
            "Line No." := 1;
          end;
        end;
    end;


    procedure InitializeRequest(ExpirationDate: Date;OrderDate: Date;PostingDate: Date;ExpectedReceiptDate: Date;YourRef: Text[50])
    begin
        EndOrderDate := ExpirationDate;
        PurchOrderHeader."Order Date" := OrderDate;
        PurchOrderHeader."Posting Date" := PostingDate;
        PurchOrderHeader."Expected Receipt Date" := ExpectedReceiptDate;
        PurchOrderHeader."Your Reference" := YourRef;
    end;


    procedure SetHideDialog(NewHideDialog: Boolean)
    begin
        HideDialog := NewHideDialog;
    end;
}

