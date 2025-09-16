#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 297 "Batch Post Sales Invoices"
{
    Caption = 'Batch Post Sales Invoices';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Header";"Sales Header")
        {
            DataItemTableView = sorting("Document Type","No.") where("Document Type"=const(Invoice));
            RequestFilterFields = "No.",Status;
            RequestFilterHeading = 'Sales Invoice';
            column(ReportForNavId_6640; 6640)
            {
            }

            trigger OnAfterGetRecord()
            var
                ApprovalsMgmt: Codeunit "Approvals Mgmt.";
            begin
                if ApprovalsMgmt.IsSalesApprovalsWorkflowEnabled("Sales Header") or (Status = Status::"Pending Approval") then
                  CurrReport.Skip;

                if CalcInvDisc then
                  CalculateInvoiceDiscount;

                Counter := Counter + 1;
                Window.Update(1,"No.");
                Window.Update(2,ROUND(Counter / CounterTotal * 10000,1));
                Clear(SalesPost);
                SalesPost.SetPostingDate(ReplacePostingDate,ReplaceDocumentDate,PostingDateReq);
                if SalesPost.Run("Sales Header") then begin
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
                    field(CalcInvDisc;CalcInvDisc)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Calc. Inv. Discount';

                        trigger OnValidate()
                        begin
                            SalesSetup.Get;
                            SalesSetup.TestField("Calc. Inv. Discount",false);
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
            SalesSetup.Get;
            CalcInvDisc := SalesSetup."Calc. Inv. Discount";
            ReplacePostingDate := false;
            ReplaceDocumentDate := false;
        end;
    }

    labels
    {
    }

    var
        Text000: label 'Enter the posting date.';
        Text001: label 'Posting invoices   #1########## @2@@@@@@@@@@@@@';
        Text002: label '%1 invoices out of a total of %2 have now been posted.';
        Text003: label 'The exchange rate associated with the new posting date on the sales header will not apply to the sales lines.';
        SalesLine: Record "Sales Line";
        SalesSetup: Record "Sales & Receivables Setup";
        SalesCalcDisc: Codeunit "Sales-Calc. Discount";
        SalesPost: Codeunit "Sales-Post";
        Window: Dialog;
        PostingDateReq: Date;
        CounterTotal: Integer;
        Counter: Integer;
        CounterOK: Integer;
        ReplacePostingDate: Boolean;
        ReplaceDocumentDate: Boolean;
        CalcInvDisc: Boolean;

    local procedure CalculateInvoiceDiscount()
    begin
        SalesLine.Reset;
        SalesLine.SetRange("Document Type","Sales Header"."Document Type");
        SalesLine.SetRange("Document No.","Sales Header"."No.");
        if SalesLine.FindFirst then
          if SalesCalcDisc.Run(SalesLine) then begin
            "Sales Header".Get("Sales Header"."Document Type","Sales Header"."No.");
            Commit;
          end;
    end;
}

