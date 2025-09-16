#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1411 "Doc. Exch. Links"
{
    Permissions = TableData "Sales Invoice Header"=m,
                  TableData "Sales Cr.Memo Header"=m;

    trigger OnRun()
    begin
    end;

    var
        UnSupportedTableTypeErr: label 'The %1 table is not supported.', Comment='%1 is the table.';
        DocExchServiceMgt: Codeunit "Doc. Exch. Service Mgt.";


    procedure UpdateDocumentRecord(DocRecRef: RecordRef;DocIdentifier: Text;DocOrigIdentifier: Text)
    begin
        DocRecRef.Find;
        case DocRecRef.Number of
          Database::"Sales Invoice Header":
            SetInvoiceDocSent(DocRecRef,DocIdentifier,DocOrigIdentifier);
          Database::"Sales Cr.Memo Header":
            SetCrMemoDocSent(DocRecRef,DocIdentifier,DocOrigIdentifier);
          Database::"Service Invoice Header":
            SetServiceInvoiceDocSent(DocRecRef,DocIdentifier,DocOrigIdentifier);
          Database::"Service Cr.Memo Header":
            SetServiceCrMemoDocSent(DocRecRef,DocIdentifier,DocOrigIdentifier);
          else
            Error(UnSupportedTableTypeErr,DocRecRef.Number);
        end;
    end;


    procedure CheckAndUpdateDocExchCrMemoStatus(SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    var
        NewStatus: Option;
    begin
        with SalesCrMemoHeader do begin
          NewStatus := MapDocExchStatusToSalesCMStatus(
              DocExchServiceMgt.GetDocumentStatus(RecordId,"Document Exchange Identifier","Doc. Exch. Original Identifier"));
          if NewStatus <> "document exchange status"::"Sent to Document Exchange Service" then begin
            Validate("Document Exchange Status",NewStatus);
            Modify(true);
          end;
        end;
    end;


    procedure CheckAndUpdateDocExchInvoiceStatus(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        NewStatus: Option;
    begin
        with SalesInvoiceHeader do begin
          NewStatus := MapDocExchStatusToSalesInvStatus(
              DocExchServiceMgt.GetDocumentStatus(RecordId,"Document Exchange Identifier","Doc. Exch. Original Identifier"));
          if NewStatus <> "document exchange status"::"Sent to Document Exchange Service" then begin
            Validate("Document Exchange Status",NewStatus);
            Modify(true);
          end;
        end;
    end;


    procedure CheckAndUpdateDocExchServiceInvoiceStatus(ServiceInvoiceHeader: Record "Service Invoice Header")
    var
        NewStatus: Option;
    begin
        with ServiceInvoiceHeader do begin
          NewStatus := MapDocExchStatusToServiceInvStatus(
              DocExchServiceMgt.GetDocumentStatus(RecordId,"Document Exchange Identifier","Doc. Exch. Original Identifier"));
          if NewStatus <> "document exchange status"::"Sent to Document Exchange Service" then begin
            Validate("Document Exchange Status",NewStatus);
            Modify(true);
          end;
        end;
    end;


    procedure CheckAndUpdateDocExchServiceCrMemoStatus(ServiceCrMemoHeader: Record "Service Cr.Memo Header")
    var
        NewStatus: Option;
    begin
        with ServiceCrMemoHeader do begin
          NewStatus := MapDocExchStatusToServiceCMStatus(
              DocExchServiceMgt.GetDocumentStatus(RecordId,"Document Exchange Identifier","Doc. Exch. Original Identifier"));
          if NewStatus <> "document exchange status"::"Sent to Document Exchange Service" then begin
            Validate("Document Exchange Status",NewStatus);
            Modify(true);
          end;
        end;
    end;

    local procedure SetInvoiceDocSent(DocRecRef: RecordRef;DocIdentifier: Text;DocOriginalIdentifier: Text)
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        DocRecRef.SetTable(SalesInvoiceHeader);
        with SalesInvoiceHeader do begin
          Validate("Document Exchange Identifier",
            CopyStr(DocIdentifier,1,MaxStrLen("Document Exchange Identifier")));
          Validate("Doc. Exch. Original Identifier",
            CopyStr(DocOriginalIdentifier,1,MaxStrLen("Doc. Exch. Original Identifier")));
          Validate("Document Exchange Status","document exchange status"::"Sent to Document Exchange Service");
          Modify(true);
        end;
    end;

    local procedure SetCrMemoDocSent(DocRecRef: RecordRef;DocIdentifier: Text;DocOriginalIdentifier: Text)
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        DocRecRef.SetTable(SalesCrMemoHeader);
        with SalesCrMemoHeader do begin
          Validate("Document Exchange Identifier",
            CopyStr(DocIdentifier,1,MaxStrLen("Document Exchange Identifier")));
          Validate("Doc. Exch. Original Identifier",
            CopyStr(DocOriginalIdentifier,1,MaxStrLen("Doc. Exch. Original Identifier")));
          Validate("Document Exchange Status","document exchange status"::"Sent to Document Exchange Service");
          Modify(true);
        end;
    end;

    local procedure SetServiceInvoiceDocSent(DocRecRef: RecordRef;DocIdentifier: Text;DocOriginalIdentifier: Text)
    var
        ServiceInvoiceHeader: Record "Service Invoice Header";
    begin
        DocRecRef.SetTable(ServiceInvoiceHeader);
        with ServiceInvoiceHeader do begin
          Validate("Document Exchange Identifier",
            CopyStr(DocIdentifier,1,MaxStrLen("Document Exchange Identifier")));
          Validate("Doc. Exch. Original Identifier",
            CopyStr(DocOriginalIdentifier,1,MaxStrLen("Doc. Exch. Original Identifier")));
          Validate("Document Exchange Status","document exchange status"::"Sent to Document Exchange Service");
          Modify(true);
        end;
    end;

    local procedure SetServiceCrMemoDocSent(DocRecRef: RecordRef;DocIdentifier: Text;DocOriginalIdentifier: Text)
    var
        ServiceCrMemoHeader: Record "Service Cr.Memo Header";
    begin
        DocRecRef.SetTable(ServiceCrMemoHeader);
        with ServiceCrMemoHeader do begin
          Validate("Document Exchange Identifier",
            CopyStr(DocIdentifier,1,MaxStrLen("Document Exchange Identifier")));
          Validate("Doc. Exch. Original Identifier",
            CopyStr(DocOriginalIdentifier,1,MaxStrLen("Doc. Exch. Original Identifier")));
          Validate("Document Exchange Status","document exchange status"::"Sent to Document Exchange Service");
          Modify(true);
        end;
    end;

    local procedure MapDocExchStatusToSalesInvStatus(DocExchStatus: Text): Integer
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        case UpperCase(DocExchStatus) of
          'FAILED':
            exit(SalesInvoiceHeader."document exchange status"::"Delivery Failed");
          'SENT':
            exit(SalesInvoiceHeader."document exchange status"::"Delivered to Recipient");
          'PENDING_CONNECTION':
            exit(SalesInvoiceHeader."document exchange status"::"Pending Connection to Recipient");
          else
            exit(SalesInvoiceHeader."document exchange status"::"Sent to Document Exchange Service");
        end;
    end;

    local procedure MapDocExchStatusToSalesCMStatus(DocExchStatus: Text): Integer
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        case UpperCase(DocExchStatus) of
          'FAILED':
            exit(SalesCrMemoHeader."document exchange status"::"Delivery Failed");
          'SENT':
            exit(SalesCrMemoHeader."document exchange status"::"Delivered to Recipient");
          'PENDING_CONNECTION':
            exit(SalesCrMemoHeader."document exchange status"::"Pending Connection to Recipient");
          else
            exit(SalesCrMemoHeader."document exchange status"::"Sent to Document Exchange Service");
        end;
    end;

    local procedure MapDocExchStatusToServiceInvStatus(DocExchStatus: Text): Integer
    var
        ServiceInvoiceHeader: Record "Service Invoice Header";
    begin
        case UpperCase(DocExchStatus) of
          'FAILED':
            exit(ServiceInvoiceHeader."document exchange status"::"Delivery Failed");
          'SENT':
            exit(ServiceInvoiceHeader."document exchange status"::"Delivered to Recipient");
          'PENDING_CONNECTION':
            exit(ServiceInvoiceHeader."document exchange status"::"Pending Connection to Recipient");
          else
            exit(ServiceInvoiceHeader."document exchange status"::"Sent to Document Exchange Service");
        end;
    end;

    local procedure MapDocExchStatusToServiceCMStatus(DocExchStatus: Text): Integer
    var
        ServiceCrMemoHeader: Record "Service Cr.Memo Header";
    begin
        case UpperCase(DocExchStatus) of
          'FAILED':
            exit(ServiceCrMemoHeader."document exchange status"::"Delivery Failed");
          'SENT':
            exit(ServiceCrMemoHeader."document exchange status"::"Delivered to Recipient");
          'PENDING_CONNECTION':
            exit(ServiceCrMemoHeader."document exchange status"::"Pending Connection to Recipient");
          else
            exit(ServiceCrMemoHeader."document exchange status"::"Sent to Document Exchange Service");
        end;
    end;
}

