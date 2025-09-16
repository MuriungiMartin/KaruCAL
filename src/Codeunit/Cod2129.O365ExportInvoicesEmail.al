#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 2129 "O365 Export Invoices + Email"
{

    trigger OnRun()
    begin
    end;

    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        NoInvoicesExportedErr: label 'There were no invoices to export.';
        InvoicesExportedMsg: label 'Your exported invoices have been sent.';
        AttachmentNameTxt: label 'Invoices.xlsx';
        ExportInvoicesEmailSubjectTxt: label 'Please find the invoices summary and item details from %1 date until %2 date in the attached Excel book.', Comment='%1 = Start Date, %2 =End Date';
        InvoiceNoFieldTxt: label 'Invoice No.';
        CustomerNameFieldTxt: label 'Customer Name';
        AddressFieldTxt: label 'Address';
        CityFieldTxt: label 'City';
        CountyFieldTxt: label 'County';
        CountryRegionCodeFieldTxt: label 'Country/Region Code';
        InvoiceDateFieldTxt: label 'Invoice Date';
        NetTotalFieldTxt: label 'Net Total';
        TotalIncludingTaxFieldTxt: label 'Total Including Tax';
        TaxPercentFieldTxt: label 'Tax %';
        InvoicesSummaryHeaderTxt: label 'Invoices Summary';
        ItemsHeaderTxt: label 'Items';
        InvoicesSheetNameTxt: label 'Invoices';
        CellBold: Boolean;
        RowNo: Integer;
        LineRowNo: Integer;


    procedure ExportInvoicesToExcelandEmail(StartDate: Date;EndDate: Date;Email: Text[80])
    var
        TempEmailItem: Record "Email Item" temporary;
        FileManagement: Codeunit "File Management";
        EmailSuccess: Boolean;
        ServerFileName: Text;
    begin
        TempExcelBuffer.Reset;
        SalesInvoiceHeader.SetRange("Document Date",StartDate,EndDate);

        InsertHeaderTextForSalesInvoices;
        InsertHeaderTextForSalesLines;

        InsertSalesInvoices;

        ServerFileName := FileManagement.ServerTempFileName('xlsx');
        TempExcelBuffer.CreateBook(ServerFileName,InvoicesSheetNameTxt);
        TempExcelBuffer.WriteSheet(InvoicesSheetNameTxt,COMPANYNAME,UserId);
        TempExcelBuffer.CloseBook;

        with TempEmailItem do begin
          Validate("Send to",Email);
          Validate(Subject,StrSubstNo(ExportInvoicesEmailSubjectTxt,StartDate,EndDate));
          "Attachment File Path" := CopyStr(ServerFileName,1,250);
          Validate("Attachment Name",AttachmentNameTxt);
          EmailSuccess := Send(true);
        end;

        if EmailSuccess then
          Message(InvoicesExportedMsg);
    end;

    local procedure EnterCell(RowNo: Integer;ColumnNo: Integer;CellValue: Variant)
    begin
        TempExcelBuffer.Init;
        TempExcelBuffer.Validate("Row No.",RowNo);
        TempExcelBuffer.Validate("Column No.",ColumnNo);

        if CellValue.IsDecimal or CellValue.Isinteger then
          TempExcelBuffer.Validate("Cell Type",TempExcelBuffer."cell type"::Number)
        else
          if CellValue.IsDate then
            TempExcelBuffer.Validate("Cell Type",TempExcelBuffer."cell type"::Date)
          else
            TempExcelBuffer.Validate("Cell Type",TempExcelBuffer."cell type"::Text);

        TempExcelBuffer."Cell Value as Text" := Format(CellValue);
        TempExcelBuffer.Bold := CellBold;
        TempExcelBuffer.Insert(true);
    end;

    local procedure InsertSalesInvoiceSummary()
    begin
        EnterCell(RowNo,1,SalesInvoiceHeader."No.");
        EnterCell(RowNo,2,SalesInvoiceHeader."Sell-to Customer Name");
        EnterCell(RowNo,3,SalesInvoiceHeader."Sell-to Address");
        EnterCell(RowNo,4,SalesInvoiceHeader."Sell-to City");
        EnterCell(RowNo,5,SalesInvoiceHeader."Sell-to County");
        EnterCell(RowNo,6,SalesInvoiceHeader."Sell-to Country/Region Code");
        EnterCell(RowNo,7,SalesInvoiceHeader."Document Date");
        EnterCell(RowNo,8,SalesInvoiceHeader."Due Date");
        EnterCell(RowNo,9,SalesInvoiceHeader."Tax Liable");
        EnterCell(RowNo,10,SalesInvoiceHeader."Work Description");
        EnterCell(RowNo,11,SalesInvoiceHeader.Amount);
        EnterCell(RowNo,12,SalesInvoiceHeader."Amount Including VAT");
    end;

    local procedure InsertSalesLineItem()
    begin
        EnterCell(LineRowNo,1,SalesInvoiceLine."Document No.");
        EnterCell(LineRowNo,2,SalesInvoiceHeader."Sell-to Customer Name");
        EnterCell(LineRowNo,3,SalesInvoiceLine.Description);
        EnterCell(LineRowNo,4,SalesInvoiceLine.Quantity);
        EnterCell(LineRowNo,5,SalesInvoiceLine."Unit of Measure");
        EnterCell(LineRowNo,6,SalesInvoiceLine."Unit Price");
        EnterCell(LineRowNo,7,SalesInvoiceLine."Tax Group Code");
        EnterCell(LineRowNo,8,SalesInvoiceLine."VAT %");
        EnterCell(LineRowNo,9,SalesInvoiceLine.Amount);
        EnterCell(LineRowNo,10,SalesInvoiceLine."Amount Including VAT");
    end;

    local procedure InsertHeaderTextForSalesInvoices()
    begin
        CellBold := true;
        RowNo := 1;
        EnterCell(RowNo,1,InvoicesSummaryHeaderTxt);

        RowNo := RowNo + 1;
        EnterCell(RowNo,1,InvoiceNoFieldTxt);
        EnterCell(RowNo,2,CustomerNameFieldTxt);
        EnterCell(RowNo,3,AddressFieldTxt);
        EnterCell(RowNo,4,CityFieldTxt);
        EnterCell(RowNo,5,CountyFieldTxt);
        EnterCell(RowNo,6,CountryRegionCodeFieldTxt);
        EnterCell(RowNo,7,InvoiceDateFieldTxt);
        EnterCell(RowNo,8,SalesInvoiceHeader.FieldCaption("Due Date"));
        EnterCell(RowNo,9,SalesInvoiceHeader.FieldCaption("Tax Liable"));
        EnterCell(RowNo,10,SalesInvoiceHeader.FieldCaption("Work Description"));
        EnterCell(RowNo,11,NetTotalFieldTxt);
        EnterCell(RowNo,12,TotalIncludingTaxFieldTxt);
        CellBold := false;
    end;

    local procedure InsertHeaderTextForSalesLines()
    var
        NumberOfEmptyLines: Integer;
    begin
        CellBold := true;
        NumberOfEmptyLines := 5;
        LineRowNo := SalesInvoiceHeader.Count + NumberOfEmptyLines;
        EnterCell(LineRowNo,1,ItemsHeaderTxt);

        LineRowNo := LineRowNo + 1;
        EnterCell(LineRowNo,1,InvoiceNoFieldTxt);
        EnterCell(LineRowNo,2,CustomerNameFieldTxt);
        EnterCell(LineRowNo,3,SalesInvoiceLine.FieldCaption(Description));
        EnterCell(LineRowNo,4,SalesInvoiceLine.FieldCaption(Quantity));
        EnterCell(LineRowNo,5,SalesInvoiceLine.FieldCaption("Unit of Measure"));
        EnterCell(LineRowNo,6,SalesInvoiceLine.FieldCaption("Unit Price"));
        EnterCell(LineRowNo,7,SalesInvoiceLine.FieldCaption("Tax Group Code"));
        EnterCell(LineRowNo,8,TaxPercentFieldTxt);
        EnterCell(LineRowNo,9,SalesInvoiceLine.FieldCaption(Amount));
        EnterCell(LineRowNo,10,SalesInvoiceLine.FieldCaption("Amount Including VAT"));
        CellBold := false;
    end;

    local procedure InsertSalesInvoices()
    begin
        if SalesInvoiceHeader.FindSet then begin
          repeat
            RowNo := RowNo + 1;
            SalesInvoiceHeader.CalcFields(Amount,"Amount Including VAT");
            InsertSalesInvoiceSummary;
            SalesInvoiceLine.SetRange("Document No.",SalesInvoiceHeader."No.");
            if SalesInvoiceLine.FindSet then begin
              repeat
                LineRowNo := LineRowNo + 1;
                InsertSalesLineItem;
              until SalesInvoiceLine.Next = 0;
            end;
          until SalesInvoiceHeader.Next = 0;
        end else
          Error(NoInvoicesExportedErr);
    end;
}

