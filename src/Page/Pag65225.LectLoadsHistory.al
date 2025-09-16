#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 65225 "Lect Loads History"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable65201;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                FreezeColumn = "Courses Count";
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
                field("PV No.";"PV No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Claim No.";"Claim No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Courses Count";"Courses Count")
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
            action(PostLoad)
            {
                ApplicationArea = Basic;
                Caption = 'Post Load';
                Image = PostPrint;
                Promoted = true;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                    /*IF Rec."PV No."<>'' THEN ERROR('Load Already Created!');
                    IF CONFIRM('Post Load?',TRUE)=FALSE THEN EXIT;
                    CLEAR(NextOderNo);
                    IF Customer.GET(Rec."Lecturer Code") THEN BEGIN
                    IF SalesSetup.GET() THEN SalesSetup.TESTFIELD("Load Nos.");
                    NextOderNo:=NoSeriesMgt.GetNextNo(SalesSetup."Load Nos.",TODAY,TRUE);
                    SalesHeader.INIT;
                    SalesHeader."Document Type":=SalesHeader."Document Type"::Load;
                    SalesHeader."No.":=NextOderNo;
                    SalesHeader."Sell-to Customer No.":=Rec."Lecturer Code";
                    SalesHeader.VALIDATE(SalesHeader."Sell-to Customer No.");
                    SalesHeader."Bill-to Customer No.":=Rec."Lecturer Code";
                    SalesHeader.VALIDATE(SalesHeader."Bill-to Customer No.");
                    SalesHeader."Document Date":="Semester Code";
                    SalesHeader."Posting Date":="Semester Code";
                    SalesHeader."Posting Description":='Lect Sale-'+SalesHeader."Sell-to Customer Name";
                    SalesHeader."Load Date":="Semester Code";
                    SalesHeader."Due Date":="Semester Code";
                    SalesHeader."Salesperson Code":=Rec."Sales Person";
                    SalesHeader.Route:=Rec."Route Code";
                    SalesHeader."Location Code":='COLDROOM 2';
                    SalesHeader.VALIDATE("Location Code");
                    SalesHeader.INSERT(TRUE);
                    lineNo:=0;
                    //Create the Lines Here
                    LectLoadCustProdSource.RESET;
                    LectLoadCustProdSource.SETRANGE(Lecturer,Rec."Semester Code");
                    LectLoadCustProdSource.SETRANGE(Programme,Rec."Lecturer Code");
                    LectLoadCustProdSource.SETFILTER(Stage,'<>%1','');
                    LectLoadCustProdSource.SETFILTER("No. Of Hours Contracted",'>%1',0);
                    IF LectLoadCustProdSource.FIND('-') THEN BEGIN
                      REPEAT
                        BEGIN
                        lineNo:=lineNo+100;
                        IF Item.GET(LectLoadCustProdSource.Stage) THEN BEGIN
                    SalesLine.INIT;
                    SalesLine."Document Type":=SalesLine."Document Type"::Load;
                    SalesLine."Document No.":=NextOderNo;
                    SalesLine."Line No.":=lineNo;
                    SalesLine.Type:=SalesLine.Type::Item;
                    SalesLine."No.":=LectLoadCustProdSource.Stage;
                    SalesLine.VALIDATE("No.");
                    SalesLine."Unit of Measure":=LectLoadCustProdSource."Unit of Measure";
                    SalesLine."Location Code":='COLDROOM 2';
                    SalesLine.VALIDATE("Location Code");
                    SalesLine.Quantity:=LectLoadCustProdSource.Remarks;
                    SalesLine.VALIDATE(Quantity);
                    SalesLine."Qty. to Ship":=LectLoadCustProdSource.Remarks;
                    SalesLine."Qty. to Invoice":=LectLoadCustProdSource.Remarks;
                    SalesLine."Planned Delivery Date":=Rec."Semester Code";
                    SalesLine."Gen. Bus. Posting Group":=Customer."Gen. Bus. Posting Group";
                    SalesLine."Gen. Prod. Posting Group":=Item."Gen. Prod. Posting Group";
                    //SalesLine."VAT Bus. Posting Group":=Item.v
                    SalesLine."VAT Prod. Posting Group":=Item."VAT Prod. Posting Group";
                    SalesLine."Planned Shipment Date":=Rec."Semester Code";
                    SalesLine."Unit Price":=LectLoadCustProdSource."No. Of Hours";
                    //SalesLine.VALIDATE(Quantity);
                    //SalesLine.VALIDATE("No.");
                    //SalesLine.VALIDATE("Location Code");
                    
                    SalesLine.INSERT(TRUE);
                          END;
                    END;
                    UNTIL LectLoadCustProdSource.NEXT=0;
                    END;
                    //Set The Load Status as Posted and released then post
                    SalesHeader.RESET;
                    SalesHeader.SETRANGE(SalesHeader."Document Type",SalesHeader."Document Type"::Load);
                    SalesHeader.SETRANGE(SalesHeader."No.",NextOderNo);
                    IF SalesHeader.FIND('-') THEN BEGIN
                      SalesHeader.Status:=SalesHeader.Status::Released;
                      SalesHeader.MODIFY;
                      END;
                    Rec."Load No.":=NextOderNo;
                    //Post the Load Here...
                    CODEUNIT.RUN(81,SalesHeader);
                    // Get and populate The Invoice and the shipment Numbers Here...
                    SalesInvoiceHeader.RESET;
                    SalesInvoiceHeader.SETRANGE(SalesInvoiceHeader."Load No.",NextOderNo);
                    IF SalesInvoiceHeader.FIND('-') THEN BEGIN
                      Rec."PV No.":=SalesInvoiceHeader."No.";
                      END;
                    
                    SalesShipmentHeader.RESET;
                    SalesShipmentHeader.SETRANGE(SalesShipmentHeader."Load No.",NextOderNo);
                    IF SalesShipmentHeader.FIND('-') THEN BEGIN
                      Rec."Claim No.":=SalesShipmentHeader."No.";
                      END;
                      Rec.MODIFY;
                      END;
                      */

                end;
            }
            action(PrintDispInv)
            {
                ApplicationArea = Basic;
                Caption = 'Print Disp. and Invoice';
                Image = PrintAcknowledgement;
                Promoted = true;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                    /*IF Rec."Load No."='' THEN ERROR('Post the Load first!');
                    
                          // Just print since the Load already posted
                          // Get and populate The Invoice and the shipment Numbers Here...
                    SalesInvoiceHeader.RESET;
                    SalesInvoiceHeader.SETRANGE(SalesInvoiceHeader."Load No.",Rec."Load No.");
                    IF SalesInvoiceHeader.FIND('-') THEN BEGIN
                       REPORT.RUN(65211,FALSE,TRUE,SalesInvoiceHeader);
                    //  Rec."Invoice No":=SalesInvoiceHeader."No.";
                      END;
                    
                    SalesShipmentHeader.RESET;
                    SalesShipmentHeader.SETRANGE(SalesShipmentHeader."Load No.",Rec."Load No.");
                    IF SalesShipmentHeader.FIND('-') THEN BEGIN
                     // Rec."Shipment Number":=SalesShipmentHeader."No.";
                       REPORT.RUN(65210,FALSE,TRUE,SalesShipmentHeader);
                      END;
                      */

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
                Visible = statusVisible;

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
        //Rec.SETFILTER("Batch Date",'=%1',DateFilter);
        if Approve then statusVisible:=true else statusVisible:=false;
    end;

    trigger OnOpenPage()
    begin
        //Rec.SETFILTER("Batch Date",'=%1',DateFilter);
        //DateFilter:=TODAY;
    end;

    var
        statusVisible: Boolean;
        lineNo: Integer;
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
        SalesHeader.RESET;
        SalesHeader.SETRANGE(SalesHeader."No.",DocNo);
        IF SalesHeader.FIND('-') THEN BEGIN
        
        SalesHeader.SendToPosting(PostingCodeunitID);
        DocumentIsPosted := NOT SalesHeader.GET(SalesHeader."Document Type"::"Credit Memo",DocNo);
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
        //CurrPage.SalesLines.PAGE.ApproveCalcInvDisc;
    end;

    local procedure SalespersonCodeOnAfterValidate()
    begin
        //CurrPage.SalesLines.PAGE.UpdateForm(TRUE);
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
        SalesReceivablesSetup.Get;
        ExternalDocNoMandatory := SalesReceivablesSetup."Ext. Doc. No. Mandatory"
    end;


    procedure ShowPreview(DocNo: Code[20])
    var
        SalesPostYesNo: Codeunit "Sales-Post (Yes/No)";
    begin
        SalesHeader.Reset;
        SalesHeader.SetRange("No.",DocNo);
        if SalesHeader.Find('-') then
          SalesPostYesNo.Preview(SalesHeader);
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
        if ApplicationAreaSetup.IsFoundationEnabled then begin
          SalesHeader.Reset;
        SalesHeader.SetRange("No.",DocNo);
        if SalesHeader.Find('-') then begin
          LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(SalesHeader);
          end;
          end;
    end;

    local procedure ShowPostedConfirmationMessage(PreAssignedNo: Code[20])
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        InstructionMgt: Codeunit "Instruction Mgt.";
    begin
        SalesCrMemoHeader.SetRange("Pre-Assigned No.",PreAssignedNo);
        if SalesCrMemoHeader.FindFirst then
          if InstructionMgt.ShowConfirm(OpenPostedSalesCrMemoQst,InstructionMgt.ShowPostedConfirmationMessageCode) then
            Page.Run(Page::"Posted Sales Credit Memo",SalesCrMemoHeader);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeStatisticsAction(var SalesHeader: Record "Sales Header";var Handled: Boolean)
    begin
    end;
}

