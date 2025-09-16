#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 65227 "Lecturer Load Approved"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable65201;
    SourceTableView = where(Approve=filter(Yes),
                            Claimed=filter(Yes),
                            Invoiced=filter(Yes));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group("Filter")
            {
                Caption = 'Filters';
                field(DateFil;semesterfilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Semester Filter';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        Rec.SetFilter("Semester Code",'=%1',semesterfilter);
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
                    Enabled = false;
                }
                field("Lecturer Name";"Lecturer Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(Phone;Phone)
                {
                    ApplicationArea = Basic;
                }
                field("Courses Count";"Courses Count")
                {
                    ApplicationArea = Basic;
                }
                field("Claim No.";"Claim No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Claim Status";"Claim Status")
                {
                    ApplicationArea = Basic;
                }
                field("PV No.";"PV No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("PV Status";"PV Status")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Pending Marks";"Pending Marks")
                {
                    ApplicationArea = Basic;
                }
                field("Department Name";"Department Name")
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
            group(Functions)
            {
                Caption = 'Functions';
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
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        Approvalentries: Page "Approval Entries";
                        DocType: Option Quote,Load,Invoice,"Credit Memo","Blanket Load","Return Load","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Staff Advance","Staff Advance Accounting";
                    begin
                        Approvalentries.Setfilters(Database::"FIN-Payments Header",Doctype::"Payment Voucher",Rec."PV No.");
                        Approvalentries.Run;
                    end;
                }
                action(PrintClaim)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print Claim';
                    Image = ConfirmAndPrint;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    Visible = true;

                    trigger OnAction()
                    var
                        LectLoadBatchLines: Record UnknownRecord65201;
                        FINPaymentsHeader: Record UnknownRecord61688;
                        PurchInvHeader: Record "Purch. Inv. Header";
                    begin
                        LectLoadBatchLines.Reset;
                        LectLoadBatchLines.SetRange("Semester Code",Rec."Semester Code");
                        LectLoadBatchLines.SetRange("Lecturer Code",Rec."Lecturer Code");
                        if LectLoadBatchLines.Find('-') then begin
                         PurchInvHeader.Reset;
                          PurchInvHeader.SetRange("No.",Rec."Claim No.");
                          if PurchInvHeader.Find('-') then
                        Report.Run(65211,true,false,PurchInvHeader)
                          else Error('The Claim is not yet generated');

                          end;
                    end;
                }
                action(Print)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print PV';
                    Image = ConfirmAndPrint;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    Visible = true;

                    trigger OnAction()
                    var
                        LectLoadBatchLines: Record UnknownRecord65201;
                        FINPaymentsHeader: Record UnknownRecord61688;
                    begin
                        LectLoadBatchLines.Reset;
                        LectLoadBatchLines.SetRange("Semester Code",Rec."Semester Code");
                        LectLoadBatchLines.SetRange("Lecturer Code",Rec."Lecturer Code");
                        if LectLoadBatchLines.Find('-') then begin
                         FINPaymentsHeader.Reset;
                          FINPaymentsHeader.SetRange("No.",LectLoadBatchLines."PV No.");
                          if FINPaymentsHeader.Find('-') then
                        Report.Run(51054,true,false,FINPaymentsHeader)
                          else Error('The PV is not yet generated');

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
    }

    trigger OnAfterGetRecord()
    begin
        Rec.SetFilter("Semester Code",'=%1',semesterfilter);
    end;

    trigger OnOpenPage()
    begin
        //Rec.SETFILTER("Batch Date",'=%1',DateFilter);
        ACASemesters.Reset;
        ACASemesters.SetRange("Current Semester",true);
        if ACASemesters.Find('-') then begin
          end;
          if ACASemesters.Code<>'' then
        semesterfilter:=ACASemesters.Code;
    end;

    var
        ACASemesters: Record UnknownRecord61692;
        lineNo: Integer;
        semesterfilter: Code[20];
        LectLoadBatches: Record UnknownRecord65200;
        NextOderNo: Code[20];
        PurchasesSetup: Record "Purchases & Payables Setup";
        GLSetup: Record "General Ledger Setup";
        GLAcc: Record "G/L Account";
        PurchasesHeader: Record "Purchase Header";
        PurchasesLine: Record "Purchase Line";
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
        Vendor: Record Vendor;
        LectLoadCustProdSource: Record UnknownRecord65202;
        Item: Record Item;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesShipmentHeader: Record "Sales Shipment Header";
        DocPrint: Codeunit "Document-Print";
        Usage: Option "Load Confirmation","Work Load","Pick Instruction";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        DocumentIsPosted: Boolean;
        ExternalDocNoMandatory: Boolean;
        FinanceAppVisible: Boolean;
        CopySalesDoc: Report "Copy Sales Document";
        MoveNegSalesLines: Report "Move Negative Sales Lines";
        ReportPrint: Codeunit "Test Report-Print";
        UserMgt: Codeunit "User Setup Management";
        SalesCalcDiscByType: Codeunit "Sales - Calc Discount By Type";
        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
        ChangeExchangeRate: Page "Change Exchange Rate";
        [InDataSet]
        JobQueueVisible: Boolean;
        HasIncomingDocument: Boolean;
        DocNoVisible: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CustomerSelected: Boolean;
        OpenPostedSalesCrMemoQst: label 'The credit memo has been posted and archived.\\Do you want to open the posted credit memo from the Posted Sales Credit Memos window?';
        LectLoadPermissions: Record UnknownRecord65207;
        LectLoadCentralSetup: Record UnknownRecord65204;
        GLAccount: Record "G/L Account";

    local procedure Post(PostingCodeunitID: Integer;DocNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        OfficeMgt: Codeunit "Office Management";
        InstructionMgt: Codeunit "Instruction Mgt.";
        PreAssignedNo: Code[20];
    begin
        /*CheckSalesCheckAllLinesHaveQuantityAssigned(DocNo);
        PreAssignedNo := DocNo;
        PurchasesHeader.RESET;
        PurchasesHeader.SETRANGE(PurchasesHeader."No.",DocNo);
        IF PurchasesHeader.FIND('-') THEN BEGIN
        
        PurchasesHeader.SendToPosting(PostingCodeunitID);
        DocumentIsPosted := NOT PurchasesHeader.GET(PurchasesHeader."Document Type"::"Credit Memo",DocNo);
        {
        IF "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting" THEN
          CurrPage.CLOSE;
        CurrPage.UPDATE(FALSE);
        }
        IF PostingCodeunitID <> CODEUNIT::"Sales-Post (Yes/No)" THEN
          EXIT;
          SalesCrMemoHeader.RESET;
          SalesCrMemoHeader.SETRANGE("Pre-Assigned No.",PreAssignedNo);
          IF SalesCrMemoHeader.FIND('-') THEN BEGIN
          "Credit Memo number":=SalesCrMemoHeader."No.";
          "Credit Memo by":=USERID;
          "Credit memo Created Date":=TODAY;
          "Credit Memo Time":=TIME;
          "Load No.":='';
          "PV No.":='';
          "Claim No.":='';
          MODIFY;
          END;
        
        IF OfficeMgt.IsAvailable THEN BEGIN
         SalesCrMemoHeader.RESET;
          SalesCrMemoHeader.SETRANGE("Pre-Assigned No.",PreAssignedNo);
          IF SalesCrMemoHeader.FINDFIRST THEN
            PAGE.RUN(PAGE::"Posted Sales Credit Memo",SalesCrMemoHeader);
        END ELSE
          IF InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode) THEN
            ShowPostedConfirmationMessage(PreAssignedNo);
          END;
          */

    end;

    local procedure ApproveCalcInvDisc()
    begin
        //CurrPage.PurchasesLines.PAGE.ApproveCalcInvDisc;
    end;

    local procedure SalespersonCodeOnAfterValidate()
    begin
        //CurrPage.PurchasesLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.Update;
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        CurrPage.Update;
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,Load,Invoice,"Credit Memo","Blanket Load","Return Load",Reminder,FinChMemo;
    begin
        //DocNoVisible := DocumentNoVisibility.SalesDocumentNoIsVisible(DocType::"Credit Memo","No.");
    end;

    local procedure SetExtDocNoMandatoryCondition()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        // SalesReceivablesSetup.GET;
        // ExternalDocNoMandatory := SalesReceivablesSetup."Ext. Doc. No. Mandatory"
    end;


    procedure ShowPreview(DocNo: Code[20])
    var
        SalesPostYesNo: Codeunit "Sales-Post (Yes/No)";
    begin
        /*PurchasesHeader.RESET;
        PurchasesHeader.SETRANGE("No.",DocNo);
        IF PurchasesHeader.FIND('-') THEN
          SalesPostYesNo.Preview(PurchasesHeader);
          */

    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        /*JobQueueVisible := "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting";
        HasIncomingDocument := "Incoming Document Entry No." <> 0;
        SetExtDocNoMandatoryCondition;
        
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);
        CustomerSelected := "Sell-to Customer No." <> '';
        */

    end;

    local procedure CheckSalesCheckAllLinesHaveQuantityAssigned(DocNo: Code[20])
    var
        ApplicationAreaSetup: Record "Application Area Setup";
    begin
        /*IF ApplicationAreaSetup.IsFoundationEnabled THEN BEGIN
          PurchasesHeader.RESET;
        PurchasesHeader.SETRANGE("No.",DocNo);
        IF PurchasesHeader.FIND('-') THEN BEGIN
          LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(PurchasesHeader);
          END;
          END;*/

    end;

    local procedure ShowPostedConfirmationMessage(PreAssignedNo: Code[20])
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        InstructionMgt: Codeunit "Instruction Mgt.";
    begin
        /*SalesCrMemoHeader.SETRANGE("Pre-Assigned No.",PreAssignedNo);
        IF SalesCrMemoHeader.FINDFIRST THEN
          IF InstructionMgt.ShowConfirm(OpenPostedSalesCrMemoQst,InstructionMgt.ShowPostedConfirmationMessageCode) THEN
            PAGE.RUN(PAGE::"Posted Sales Credit Memo",SalesCrMemoHeader);
          */

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeStatisticsAction(var SalesHeader: Record "Sales Header";var Handled: Boolean)
    begin
    end;
}

