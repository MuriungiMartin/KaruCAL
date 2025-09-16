#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 65215 "Lect Load Approvals"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = UnknownTable65201;
    SourceTableView = where("Courses Count"=filter(>0),
                            Claimed=filter(No),
                            Invoiced=filter(No));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group("Filter")
            {
                Caption = 'Filters';
                field(DateFil;SemesterFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Semester Filter';
                    Enabled = false;

                    trigger OnValidate()
                    begin
                        Rec.SetFilter("Semester Code",'=%1',SemesterFilter);
                        CurrPage.Update;
                    end;
                }
            }
            repeater(Group)
            {
                field("Lecturer Code";"Lecturer Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Lecturer Name";"Lecturer Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(Approve;Approve)
                {
                    ApplicationArea = Basic;
                }
                field(Reject;Reject)
                {
                    ApplicationArea = Basic;
                }
                field("Courses Count";"Courses Count")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Admissible;Admissible)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Campus;Campus)
                {
                    ApplicationArea = Basic;
                }
                field("Department Code";"Department Code")
                {
                    ApplicationArea = Basic;
                }
                field("Claim No.";"Claim No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Created By";"Created By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Created Time";"Created Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Reject Reason";"Reject Reason")
                {
                    ApplicationArea = Basic;
                }
                field("Additional Comments";"Additional Comments")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(CloseBatch)
            {
                ApplicationArea = Basic;
                Caption = 'Close Batch';
                Image = AvailableToPromise;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    LectLoadBatches.Reset;
                    LectLoadBatches.SetRange(LectLoadBatches."Semester Code",SemesterFilter);
                    if LectLoadBatches.Find('-') then begin
                     if LectLoadBatches.Status<>LectLoadBatches.Status::Draft then Error('');
                      end;


                    if Confirm('Close Batch?',false)=false then exit;
                    LectLoadBatches.Reset;
                    LectLoadBatches.SetRange(LectLoadBatches."Semester Code",SemesterFilter);
                    if LectLoadBatches.Find('-') then begin
                      LectLoadBatches.Status:=LectLoadBatches.Status::Final;
                      LectLoadBatches.Modify;
                      end;
                end;
            }
            action(PrinAppointment)
            {
                ApplicationArea = Basic;
                Caption = 'Print Appointment Letter';
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
                    LectLoadBatchLines.SetRange("Lecturer Code",Rec."Lecturer Code");
                    if LectLoadBatchLines.Find('-') then begin
                      if Rec.Approve then
                        Report.Run(65201,true,false,LectLoadBatchLines);
                      end;
                end;
            }
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
                    //LectLoadBatchLines.SETRANGE("Lecturer Code",Rec."Lecturer Code");
                    if LectLoadBatchLines.Find('-') then begin
                        Report.Run(69270,true,false,LectLoadBatchLines);
                      end;
                end;
            }
            action(ClassList)
            {
                ApplicationArea = Basic;
                Caption = 'Class List';
                Image = List;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "Course Class List";
            }
            action(AttendanceList)
            {
                ApplicationArea = Basic;
                Caption = 'Attendance List';
                Image = ListPage;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ACALecturersUnits: Record UnknownRecord65202;
                begin
                    ACALecturersUnits.Reset;
                    ACALecturersUnits.SetRange(Semester,Rec."Semester Code");
                    ACALecturersUnits.SetRange(Lecturer,Rec."Lecturer Code");
                    if ACALecturersUnits.Find('-') then begin
                        Report.Run(65207,true,false,ACALecturersUnits);
                      end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.SetFilter("Semester Code",'=%1',SemesterFilter);
    end;

    trigger OnOpenPage()
    begin
        //Rec.SETFILTER("Batch Date",'=%1',DateFilter);
        ACASemesters.Reset;
        ACASemesters.SetRange("Current Semester",true);
        if ACASemesters.Find('-') then
        SemesterFilter:=ACASemesters.Code;
    end;

    var
        Customer1: Record Customer;
        lineNo: Integer;
        SemesterFilter: Code[20];
        ACASemesters: Record UnknownRecord61692;
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
        currPayments: Decimal;
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
}

