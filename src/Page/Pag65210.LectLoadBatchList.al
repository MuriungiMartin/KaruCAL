#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 65210 "Lect Load Batch List"
{
    ApplicationArea = Basic;
    CardPageID = "Lect Load Batch Card";
    DeleteAllowed = false;
    InsertAllowed = true;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable65200;
    SourceTableView = where(Status=filter(Draft));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Semester Code";"Semester Code")
                {
                    ApplicationArea = Basic;
                }
                field("Created Date";"Created Date")
                {
                    ApplicationArea = Basic;
                }
                field("Created Time";"Created Time")
                {
                    ApplicationArea = Basic;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field("No of Lecturers";"No of Lecturers")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Created By";"Created By")
                {
                    ApplicationArea = Basic;
                }
                field("Appointment Later Ref. No.";"Appointment Later Ref. No.")
                {
                    ApplicationArea = Basic;
                }
                field("Appointment Later Ref.";"Appointment Later Ref.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Mark as Closed")
            {
                ApplicationArea = Basic;
                Caption = 'Mark as Closed';
                Image = AvailableToPromise;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                     if Rec.Status<>Rec.Status::Draft then Error('Already Closed!');


                    if Confirm('CONFIRM:\Mark as Final?',false)=false then exit;
                    if Confirm('******WARNING!!!!!!!:\You will not post into an already posted Batch. \Continue?',false)=false then exit;
                      Rec.Status:=Rec.Status::Final;
                      Rec.Modify;
                end;
            }
        }
    }

    var
        lineNo: Integer;
        DateFilter: Date;
        LectLoadBatches: Record UnknownRecord65200;
        NextOderNo: Code[20];
        SalesSetup: Record "Sales & Receivables Setup";
        GLSetup: Record "General Ledger Setup";
        GLAcc: Record "G/L Account";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        CustLedgEntry: Record "Cust. Ledger Entry";
        Cust: Record Customer;
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        CurrExchRate: Record "Currency Exchange Rate";
        SalesCommentLine: Record "Sales Comment Line";
        PostCode: Record "Post Code";
        BankAcc: Record "Bank Account";
        SalesShptHeader: Record "Sales Shipment Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ReturnRcptHeader: Record "Return Receipt Header";
        SalesInvHeaderPrepmt: Record "Sales Invoice Header";
        SalesCrMemoHeaderPrepmt: Record "Sales Cr.Memo Header";
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        RespCenter: Record "Responsibility Center";
        InvtSetup: Record "Inventory Setup";
        Location: Record Location;
        WhseRequest: Record "Warehouse Request";
        ReservEntry: Record "Reservation Entry";
        TempReservEntry: Record "Reservation Entry" temporary;
        CompanyInfo: Record "Company Information";
        UserSetupMgt: Codeunit "User Setup Management";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit";
        DimMgt: Codeunit DimensionManagement;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WhseSourceHeader: Codeunit "Whse. Validate Source Header";
        ArchiveManagement: Codeunit ArchiveManagement;
        SalesLineReserve: Codeunit "Sales Line-Reserve";
        CurrencyDate: Date;
        HideValidationDialog: Boolean;
        Confirmed: Boolean;
        SkipSellToContact: Boolean;
        SkipBillToContact: Boolean;
        InsertMode: Boolean;
        HideCreditCheckDialogue: Boolean;
        UpdateDocumentDate: Boolean;
        BilltoCustomerNoChanged: Boolean;
        FINCashOfficeUserTemplate: Record UnknownRecord61712;
        Customer: Record Customer;
        LectLoadCustProdSource: Record UnknownRecord65202;
        Item: Record Item;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesShipmentHeader: Record "Sales Shipment Header";
        DocPrint: Codeunit "Document-Print";
        Usage: Option "Load Confirmation","Work Load","Pick Instruction";
}

