#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 6653 "Combine Return Receipts"
{
    Caption = 'Combine Return Receipts';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(SalesOrderHeader;"Sales Header")
        {
            DataItemTableView = sorting("Document Type","Combine Shipments","Bill-to Customer No.") where("Document Type"=const("Return Order"),"Combine Shipments"=const(true));
            RequestFilterFields = "Sell-to Customer No.","Bill-to Customer No.";
            RequestFilterHeading = 'Sales Return Order';
            column(ReportForNavId_2495; 2495)
            {
            }
            dataitem("Return Receipt Header";"Return Receipt Header")
            {
                DataItemLink = "Return Order No."=field("No.");
                DataItemTableView = sorting("Return Order No.");
                RequestFilterFields = "Posting Date";
                RequestFilterHeading = 'Posted Return Receipts';
                column(ReportForNavId_9963; 9963)
                {
                }
                dataitem("Return Receipt Line";"Return Receipt Line")
                {
                    DataItemLink = "Document No."=field("No.");
                    DataItemTableView = sorting("Document No.","Line No.") where("Return Qty. Rcd. Not Invd."=filter(<>0));
                    column(ReportForNavId_5391; 5391)
                    {
                    }

                    trigger OnAfterGetRecord()
                    var
                        SalesGetReturnReceipts: Codeunit "Sales-Get Return Receipts";
                    begin
                        if "Return Qty. Rcd. Not Invd." <> 0 then begin
                          if "Bill-to Customer No." <> Cust."No." then
                            Cust.Get("Bill-to Customer No.");
                          if Cust.Blocked <> Cust.Blocked::All then begin
                            if (SalesOrderHeader."Bill-to Customer No." <> SalesHeader."Bill-to Customer No.") or
                               (SalesOrderHeader."Currency Code" <> SalesHeader."Currency Code") or
                               (SalesOrderHeader."Dimension Set ID" <> SalesHeader."Dimension Set ID")
                            then begin
                              if SalesHeader."No." <> '' then
                                FinalizeSalesInvHeader;
                              InsertSalesInvHeader;
                              SalesLine.SetRange("Document Type",SalesHeader."Document Type");
                              SalesLine.SetRange("Document No.",SalesHeader."No.");
                              SalesLine."Document Type" := SalesHeader."Document Type";
                              SalesLine."Document No." := SalesHeader."No.";
                            end;
                            ReturnRcptLine := "Return Receipt Line";
                            ReturnRcptLine.InsertInvLineFromRetRcptLine(SalesLine);
                            if Type = Type::"Charge (Item)" then
                              SalesGetReturnReceipts.GetItemChargeAssgnt("Return Receipt Line",SalesLine."Qty. to Invoice");
                          end else
                            NoOfSalesInvErrors := NoOfSalesInvErrors + 1;
                        end;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    Window.Update(3,"No.");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.Language := Language.GetLanguageID("Language Code");

                Window.Update(1,"Bill-to Customer No.");
                Window.Update(2,"No.");
            end;

            trigger OnPostDataItem()
            begin
                CurrReport.Language := GlobalLanguage;
                Window.Close;
                if SalesHeader."No." <> '' then begin // Not the first time
                  FinalizeSalesInvHeader;
                  if NoOfSalesInvErrors = 0 then
                    Message(Text010,NoOfSalesInv)
                  else
                    Message(Text007,NoOfSalesInvErrors)
                end else
                  Message(Text008);
            end;

            trigger OnPreDataItem()
            begin
                if PostingDateReq = 0D then
                  Error(Text000);
                if DocDateReq = 0D then
                  Error(Text001);

                Window.Open(
                  Text002 +
                  Text003 +
                  Text004 +
                  Text005);
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
                    field(PostingDateReq;PostingDateReq)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posting Date';
                    }
                    field(DocDateReq;DocDateReq)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Document Date';
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
                    field(PostInv;PostInv)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Post Credit Memos';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if PostingDateReq = 0D then
              PostingDateReq := WorkDate;
            if DocDateReq = 0D then
              DocDateReq := WorkDate;
            SalesSetup.Get;
            CalcInvDisc := SalesSetup."Calc. Inv. Discount";
        end;
    }

    labels
    {
    }

    var
        Text000: label 'Enter the posting date.';
        Text001: label 'Enter the document date.';
        Text002: label 'Combining return receipts...\\';
        Text003: label 'Customer No.        #1##########\';
        Text004: label 'Return Order No.    #2##########\';
        Text005: label 'Return Receipt No.  #3##########';
        Text007: label 'Not all the credit memos were posted. A total of %1 credit memos were not posted.';
        Text008: label 'There is nothing to combine.';
        Text010: label 'The return receipts are now combined and the number of credit memos created is %1.';
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        ReturnRcptLine: Record "Return Receipt Line";
        SalesSetup: Record "Sales & Receivables Setup";
        Cust: Record Customer;
        Language: Record Language;
        SalesCalcDisc: Codeunit "Sales-Calc. Discount";
        SalesPost: Codeunit "Sales-Post";
        Window: Dialog;
        PostingDateReq: Date;
        DocDateReq: Date;
        CalcInvDisc: Boolean;
        PostInv: Boolean;
        NoOfSalesInvErrors: Integer;
        NoOfSalesInv: Integer;

    local procedure FinalizeSalesInvHeader()
    begin
        with SalesHeader do begin
          if CalcInvDisc then
            SalesCalcDisc.Run(SalesLine);
          Find;
          Commit;
          Clear(SalesCalcDisc);
          Clear(SalesPost);
          NoOfSalesInv := NoOfSalesInv + 1;
          if PostInv then begin
            Clear(SalesPost);
            if not SalesPost.Run(SalesHeader) then
              NoOfSalesInvErrors := NoOfSalesInvErrors + 1;
          end;
        end;
    end;

    local procedure InsertSalesInvHeader()
    begin
        with SalesHeader do begin
          Init;
          "Document Type" := "document type"::"Credit Memo";
          "No." := '';
          Insert(true);
          Validate("Sell-to Customer No.",SalesOrderHeader."Bill-to Customer No.");
          if "Bill-to Customer No." <> "Sell-to Customer No." then
            Validate("Bill-to Customer No.",SalesOrderHeader."Bill-to Customer No.");
          Validate("Posting Date",PostingDateReq);
          Validate("Document Date",DocDateReq);
          Validate("Currency Code",SalesOrderHeader."Currency Code");
          "Shortcut Dimension 1 Code" := SalesOrderHeader."Shortcut Dimension 1 Code";
          "Shortcut Dimension 2 Code" := SalesOrderHeader."Shortcut Dimension 2 Code";
          "Dimension Set ID" := SalesOrderHeader."Dimension Set ID";
          Modify;
          Commit;
        end;
    end;


    procedure InitializeRequest(NewPostingDate: Date;NewDocumentDate: Date;NewCalcInvDisc: Boolean;NewPostCreditMemo: Boolean)
    begin
        PostingDateReq := NewPostingDate;
        DocDateReq := NewDocumentDate;
        CalcInvDisc := NewCalcInvDisc;
        PostInv := NewPostCreditMemo;
    end;
}

