#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 65200 "Lect Load Batch Card"
{
    DataCaptionFields = "Semester Code",Status,"Created By";
    DeleteAllowed = true;
    PageType = Card;
    SourceTable = UnknownTable65200;

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Semester Code";"Semester Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("No of Lecturers";"No of Lecturers")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Approval Name";"Approval Name")
                {
                    ApplicationArea = Basic;
                }
                field("Approval Title";"Approval Title")
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
                field("Semester Range Descption";"Semester Range Descption")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1000000003;"Lect Load Batch Lines")
            {
                Caption = 'Loads List';
                SubPageLink = "Semester Code"=field("Semester Code");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(CourseLoad)
            {
                ApplicationArea = Basic;
                Caption = 'Course Loading Summary';
                Image = PrintAcknowledgement;
                Promoted = true;
                PromotedIsBig = true;
                ShortCutKey = 'F5';

                trigger OnAction()
                var
                    counted: Integer;
                    LectLoadBatchLines: Record UnknownRecord65201;
                begin
                    LectLoadBatchLines.Reset;
                    LectLoadBatchLines.SetRange("Semester Code",Rec."Semester Code");
                    if LectLoadBatchLines.Find('-') then begin
                        Report.Run(69270,true,false,LectLoadBatchLines);
                      end;
                end;
            }
            action(CourseLoadSum)
            {
                ApplicationArea = Basic;
                Caption = 'Course Loading Det,';
                Image = CalculateBinReplenishment;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "Lecturer Course Loading Det.";
            }
            action("Load Missing Lectures")
            {
                ApplicationArea = Basic;
                Caption = 'Load Missing Lecturers';
                Image = MoveToNextPeriod;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('This will load Missing Lecturers, Continue?',true)=false then Error('Cancelled by user:'+UserId);
                    HrEmployees.Reset;
                    HrEmployees.SetFilter(HrEmployees.Lecturer,'=%1',true);
                    if HrEmployees.Find('-') then begin
                        repeat
                          begin
                          LectLoadBatchLines.Reset;
                          LectLoadBatchLines.SetRange(LectLoadBatchLines."Semester Code","Semester Code");
                          LectLoadBatchLines.SetRange(LectLoadBatchLines."Lecturer Code",HrEmployees."No.");
                    if not (LectLoadBatchLines.Find('-')) then begin
                      LectLoadBatchLines.Init;
                      LectLoadBatchLines."Semester Code":="Semester Code";
                      LectLoadBatchLines."Lecturer Code":=HrEmployees."No.";
                      LectLoadBatchLines.Validate("Lecturer Code");
                      LectLoadBatchLines.Insert;
                      end;
                          end;
                          until HrEmployees.Next=0;
                      end;
                      CurrPage.Update;
                end;
            }
        }
    }

    var
        LectLoadBatchLines: Record UnknownRecord65201;
        LectLoadBatches1: Record UnknownRecord65200;
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
        HrEmployees: Record UnknownRecord61188;
}

