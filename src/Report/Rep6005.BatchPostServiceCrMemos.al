#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 6005 "Batch Post Service Cr. Memos"
{
    Caption = 'Batch Post Service Cr. Memos';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Service Header";"Service Header")
        {
            DataItemTableView = sorting("Document Type","No.") where("Document Type"=const("Credit Memo"));
            RequestFilterFields = "No.";
            column(ReportForNavId_1634; 1634)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if CalcInvDisc then
                  CalculateInvoiceDiscount;

                Counter := Counter + 1;
                Window.Update(1,"No.");
                Window.Update(2,ROUND(Counter / CounterTotal * 10000,1));
                Clear(ServPost);
                ServPost.SetPostingDate(ReplacePostingDate,ReplaceDocumentDate,PostingDateReq);
                ServPost.SetPostingOptions(true,false,true); // ship, consume, invoice
                if ServPost.Run("Service Header") then begin
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
        Text001: label 'Posting credit memos  #1########## @2@@@@@@@@@@@@@';
        Text002: label '%1 credit memos out of a total of %2 have now been posted.';
        Text003: label 'The exchange rate associated with the new posting date on the service header will not apply to the service lines.';
        ServLine: Record "Service Line";
        SalesSetup: Record "Sales & Receivables Setup";
        ServCalcDisc: Codeunit "Service-Calc. Discount";
        ServPost: Codeunit "Service-Post";
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
        ServLine.Reset;
        ServLine.SetRange("Document Type","Service Header"."Document Type");
        ServLine.SetRange("Document No.","Service Header"."No.");
        if ServLine.FindFirst then
          if ServCalcDisc.Run(ServLine) then begin
            "Service Header".Get("Service Header"."Document Type","Service Header"."No.");
            Commit;
          end;
    end;


    procedure InitializeRequest(PostingDateReqFrom: Date;ReplacePostingDateFrom: Boolean;ReplaceDocumentDateFrom: Boolean;CalcInvDiscFrom: Boolean)
    begin
        PostingDateReq := PostingDateReqFrom;
        ReplacePostingDate := ReplacePostingDateFrom;
        ReplaceDocumentDate := ReplaceDocumentDateFrom;
        CalcInvDisc := CalcInvDiscFrom;
    end;
}

