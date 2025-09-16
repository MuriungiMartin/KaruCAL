#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1305 "Sales-Quote to Invoice"
{
    TableNo = "Sales Header";

    trigger OnRun()
    var
        Cust: Record Customer;
        SalesInvoiceLine: Record "Sales Line";
        SalesSetup: Record "Sales & Receivables Setup";
        CustCheckCrLimit: Codeunit "Cust-Check Cr. Limit";
    begin
        TestField("Document Type","document type"::Quote);

        if "Sell-to Customer No." = '' then
          Error(SpecifyCustomerErr);

        if "Bill-to Customer No." = '' then
          Error(SpecifyBillToCustomerNoErr,FieldCaption("Bill-to Customer No."));

        Cust.Get("Sell-to Customer No.");
        Cust.CheckBlockedCustOnDocs(Cust,"document type"::Quote,true,false);
        CalcFields("Amount Including VAT","Invoice Discount Amount","Work Description");

        SalesInvoiceHeader := Rec;

        SalesInvoiceLine.LockTable;

        CreateSalesInvoiceHeader(SalesInvoiceHeader,Rec);
        CreateSalesInvoiceLines(SalesInvoiceHeader,Rec);

        SalesSetup.Get;
        if SalesSetup."Default Posting Date" = SalesSetup."default posting date"::"No Date" then begin
          SalesInvoiceHeader."Posting Date" := 0D;
          SalesInvoiceHeader.Modify;
        end;

        DeleteLinks;
        Delete;

        Commit;
        Clear(CustCheckCrLimit);
    end;

    var
        SalesInvoiceHeader: Record "Sales Header";
        SpecifyCustomerErr: label 'You must select a customer before you can convert a quote to an invoice.';
        SpecifyBillToCustomerNoErr: label 'You must specify the %1 before you can convert a quote to an invoice.', Comment='%1 is Bill-To Customer No.';


    procedure GetSalesInvoiceHeader(var SalesHeader2: Record "Sales Header")
    begin
        SalesHeader2 := SalesInvoiceHeader;
    end;

    local procedure CreateSalesInvoiceHeader(var SalesInvoiceHeader: Record "Sales Header";SalesQuoteHeader: Record "Sales Header")
    begin
        with SalesQuoteHeader do begin
          SalesInvoiceHeader."Document Type" := SalesInvoiceHeader."document type"::Invoice;

          SalesInvoiceHeader."No. Printed" := 0;
          SalesInvoiceHeader.Status := SalesInvoiceHeader.Status::Open;
          SalesInvoiceHeader."No." := '';

          SalesInvoiceHeader."Quote No." := "No.";
          SalesInvoiceHeader.Insert(true);

          if "Posting Date" <> 0D then
            SalesInvoiceHeader."Posting Date" := "Posting Date"
          else
            SalesInvoiceHeader."Posting Date" := WorkDate;
          SalesInvoiceHeader.InitFromSalesHeader(SalesQuoteHeader);
          SalesInvoiceHeader.Modify;
        end;
    end;

    local procedure CreateSalesInvoiceLines(SalesInvoiceHeader: Record "Sales Header";SalesQuoteHeader: Record "Sales Header")
    var
        SalesQuoteLine: Record "Sales Line";
        SalesInvoiceLine: Record "Sales Line";
    begin
        with SalesQuoteHeader do begin
          SalesQuoteLine.Reset;
          SalesQuoteLine.SetRange("Document Type","Document Type");
          SalesQuoteLine.SetRange("Document No.","No.");

          if SalesQuoteLine.FindSet then
            repeat
              SalesInvoiceLine := SalesQuoteLine;
              SalesInvoiceLine."Document Type" := SalesInvoiceHeader."Document Type";
              SalesInvoiceLine."Document No." := SalesInvoiceHeader."No.";
              if SalesInvoiceLine."No." <> '' then
                SalesInvoiceLine.DefaultDeferralCode;
              SalesInvoiceLine.Insert;
            until SalesQuoteLine.Next = 0;

          MoveLineCommentsToSalesInvoice(SalesInvoiceHeader,SalesQuoteHeader);

          SalesQuoteLine.DeleteAll;
        end;
    end;

    local procedure MoveLineCommentsToSalesInvoice(SalesInvoiceHeader: Record "Sales Header";SalesQuoteHeader: Record "Sales Header")
    var
        OldSalesCommentLine: Record "Sales Comment Line";
        SalesCommentLine: Record "Sales Comment Line";
        RecordLinkManagement: Codeunit "Record Link Management";
    begin
        with SalesQuoteHeader do begin
          SalesCommentLine.SetRange("Document Type","Document Type");
          SalesCommentLine.SetRange("No.","No.");
          if not SalesCommentLine.IsEmpty then begin
            SalesCommentLine.LockTable;
            if SalesCommentLine.FindSet then
              repeat
                OldSalesCommentLine := SalesCommentLine;
                SalesCommentLine.Delete;
                SalesCommentLine."Document Type" := SalesInvoiceHeader."Document Type";
                SalesCommentLine."No." := SalesInvoiceHeader."No.";
                SalesCommentLine.Insert;
                SalesCommentLine := OldSalesCommentLine;
              until SalesCommentLine.Next = 0;
          end;
          RecordLinkManagement.CopyLinks(SalesQuoteHeader,SalesInvoiceHeader);
        end;
    end;
}

