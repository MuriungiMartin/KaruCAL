#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 496 "Batch Post Purchase Orders"
{
    Caption = 'Batch Post Purchase Orders';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Purchase Header";"Purchase Header")
        {
            DataItemTableView = sorting("Document Type","No.") where("Document Type"=const(Order));
            RequestFilterFields = "No.",Status;
            RequestFilterHeading = 'Purchase Order';
            column(ReportForNavId_4458; 4458)
            {
            }

            trigger OnAfterGetRecord()
            var
                ApprovalsMgmt: Codeunit "Approvals Mgmt.";
            begin
                if ApprovalsMgmt.IsPurchaseApprovalsWorkflowEnabled("Purchase Header") or (Status = Status::"Pending Approval") then
                  CurrReport.Skip;

                if CalcInvDisc then
                  CalculateInvoiceDiscount;

                Counter := Counter + 1;
                Window.Update(1,"No.");
                Window.Update(2,ROUND(Counter / CounterTotal * 10000,1));
                Receive := ReceiveReq;
                Invoice := InvReq;
                Clear(PurchPost);
                PurchPost.SetPostingDate(ReplacePostingDate,ReplaceDocumentDate,PostingDateReq);
                if IsApprovedForPostingBatch then
                  if PurchPost.Run("Purchase Header") then begin
                    CounterOK := CounterOK + 1;
                    if MarkedOnly then
                      Mark(false);
                  end;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
                Message(Text002,CounterOK,CounterTotal);
            end;

            trigger OnPreDataItem()
            begin
                if ReplacePostingDate and (PostingDateReq = 0D) then
                  Error(Text000);

                CounterTotal := Count;
                Window.Open(Text001);
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
                    field(Receive;ReceiveReq)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Receive';
                    }
                    field(Invoice;InvReq)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Invoice';
                    }
                    field(PostingDate;PostingDateReq)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posting Date';
                    }
                    field(ReplacePostingDate;ReplacePostingDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Replace Posting Date';

                        trigger OnValidate()
                        begin
                            if ReplacePostingDate then
                              Message(Text003);
                        end;
                    }
                    field(ReplaceDocumentDate;ReplaceDocumentDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Replace Document Date';
                    }
                    field(CalcInvDiscount;CalcInvDisc)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Calc. Inv. Discount';

                        trigger OnValidate()
                        begin
                            PurchSetup.Get;
                            PurchSetup.TestField("Calc. Inv. Discount",false);
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            InitValue;
        end;
    }

    labels
    {
    }

    var
        Text000: label 'Enter the posting date.';
        Text001: label 'Posting orders  #1########## @2@@@@@@@@@@@@@';
        Text002: label '%1 orders out of a total of %2 have now been posted.';
        PurchLine: Record "Purchase Line";
        PurchSetup: Record "Purchases & Payables Setup";
        PurchCalcDisc: Codeunit "Purch.-Calc.Discount";
        PurchPost: Codeunit "Purch.-Post";
        Window: Dialog;
        ReceiveReq: Boolean;
        InvReq: Boolean;
        PostingDateReq: Date;
        CounterTotal: Integer;
        Counter: Integer;
        CounterOK: Integer;
        ReplacePostingDate: Boolean;
        ReplaceDocumentDate: Boolean;
        CalcInvDisc: Boolean;
        Text003: label 'The exchange rate associated with the new posting date on the purchase header will not apply to the purchase lines.';

    local procedure CalculateInvoiceDiscount()
    begin
        PurchLine.Reset;
        PurchLine.SetRange("Document Type","Purchase Header"."Document Type");
        PurchLine.SetRange("Document No.","Purchase Header"."No.");
        if PurchLine.FindFirst then
          if PurchCalcDisc.Run(PurchLine) then begin
            "Purchase Header".Get("Purchase Header"."Document Type","Purchase Header"."No.");
            Commit;
          end;
    end;


    procedure InitializeRequest(NewReceiveReq: Boolean;NewInvReq: Boolean;NewPostingDateReq: Date;NewReplacePostingDate: Boolean;NewReplaceDocumentDate: Boolean;NewCalcInvDisc: Boolean)
    begin
        InitValue;
        ReceiveReq := NewReceiveReq;
        InvReq := NewInvReq;
        PostingDateReq := NewPostingDateReq;
        ReplacePostingDate := NewReplacePostingDate;
        ReplaceDocumentDate := NewReplaceDocumentDate;
        if NewCalcInvDisc then
          PurchSetup.TestField("Calc. Inv. Discount",false);
        CalcInvDisc := NewCalcInvDisc;
    end;

    local procedure InitValue()
    begin
        PurchSetup.Get;
        CalcInvDisc := PurchSetup."Calc. Inv. Discount";
    end;
}

