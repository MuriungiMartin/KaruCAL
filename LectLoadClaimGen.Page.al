#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 65216 "Lect Load Claim Gen."
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable65201;
    SourceTableView = where("Courses Count"=filter(>0));
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
                        //Rec.SETFILTER("Semester Code",'=%1',semesterfilter);
                        CurrPage.Update;
                    end;
                }
            }
            repeater(Group)
            {
                field("Semester Code";"Semester Code")
                {
                    ApplicationArea = Basic;
                }
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
                field(Amount;Amount)
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
                action(GenClaim)
                {
                    ApplicationArea = Basic;
                    Caption = 'Generate Claim';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedIsBig = true;
                    ShortCutKey = 'F2';

                    trigger OnAction()
                    var
                        counted: Integer;
                        PurchaseHeader: Record "Purchase Header";
                        PurchaseLine: Record "Purchase Line";
                    begin
                        if Rec."Claim No."<>'' then Error('Claim Already Created!');
                        LectLoadCentralSetup.Reset;
                        if LectLoadCentralSetup.Find('-') then begin
                          LectLoadCentralSetup.TestField("Part-Time Expenses Account");
                          LectLoadCentralSetup.TestField("Gen. Bus. Posting Group");
                          LectLoadCentralSetup.TestField("Vendor Posting Group");
                            end;
                        
                        CalcFields("Exists Part-Time","Pending Marks");
                        if not "Exists Part-Time" then Error("Lecturer Name"+' has no part-time units');
                        //IF NOT Approve THEN ERROR('Not Approved');
                        //IF "Pending Marks" THEN ERROR('Some Marks are not submitted by the Lecturer');
                        
                        if Confirm('Create Claim?',true)=false then Error('You cancelled the process');
                        Clear(NextOderNo);
                        if not Vendor.Get(Rec."Lecturer Code") then begin
                          Rec.CalcFields("Lecturer Name");
                          Vendor.Init;
                          Vendor."No.":=Rec."Lecturer Code";
                          Vendor.Name:=Rec."Lecturer Name";
                          Vendor."Search Name":=Rec."Lecturer Name";
                          Vendor."Gen. Bus. Posting Group":=LectLoadCentralSetup."Gen. Bus. Posting Group";
                          Vendor."Vendor Posting Group":=LectLoadCentralSetup."Vendor Posting Group";
                          Vendor.Insert;
                        
                        
                          end;
                          if  Vendor.Get(Rec."Lecturer Code") then begin
                        if PurchasesSetup.Get() then PurchasesSetup.TestField("Invoice Nos.");
                        NextOderNo:=NoSeriesMgt.GetNextNo(PurchasesSetup."Invoice Nos.",Today,true);
                        /////////////////////////////////////////88888888888888888888888888
                        PurchasesHeader.Init;
                        PurchasesHeader."Document Type":=PurchasesHeader."document type"::Invoice;
                        PurchasesHeader."No.":=NextOderNo;
                        PurchasesHeader."Buy-from Vendor No.":=Rec."Lecturer Code";
                        PurchasesHeader."Pay-to Vendor No.":=Rec."Lecturer Code";
                        PurchasesHeader."Document Date":=Today;
                        PurchasesHeader."Posting Date":=Today;
                        PurchasesHeader."Posting Description":=CopyStr('Part-Time Lecturer Invoice for: '+Rec."Lecturer Code",1,50);
                        PurchasesHeader."Order Date":=Today;
                        PurchasesHeader."Due Date":=Today;
                        PurchasesHeader."Vendor Invoice No.":=CopyStr(("Semester Code"+Format(Today)+Format(Time)),1,35);
                        PurchasesHeader.Insert(true);
                        lineNo:=0;
                        
                        //Create the Lines Here
                        LectLoadCustProdSource.Reset;
                        LectLoadCustProdSource.SetRange(Semester,Rec."Semester Code");
                        LectLoadCustProdSource.SetRange(Lecturer,Rec."Lecturer Code");
                        //LectLoadCustProdSource.SETFILTER("Marks Submitted",'%1',TRUE);
                        //LectLoadCustProdSource.SETFILTER(Approved,'%1',TRUE);
                        LectLoadCustProdSource.SetFilter("Unit Cost",'>%1',0);
                        if LectLoadCustProdSource.Find('-') then begin
                          repeat
                            begin
                            lineNo:=lineNo+100;
                            if GLAccount.Get(LectLoadCentralSetup."Part-Time Expenses Account") then begin
                              GLAccount.TestField("Gen. Prod. Posting Group");
                        PurchasesLine.Init;
                        PurchasesLine."Document Type":=PurchasesLine."document type"::Invoice;
                        PurchasesLine."Document No.":=NextOderNo;
                        PurchasesLine."Line No.":=lineNo;
                        PurchasesLine.Type:=PurchasesLine.Type::"G/L Account";
                        PurchasesLine."No.":=LectLoadCentralSetup."Part-Time Expenses Account";
                        PurchasesLine.Validate("No.");
                        PurchasesLine.Description:=CopyStr('Part-Time('+LectLoadCustProdSource.Unit+':'+LectLoadCustProdSource.Description+')',1,35);
                        PurchasesLine.Quantity:=1;
                        PurchasesLine.Validate(Quantity);
                        //PurchasesLine."Qty. to Ship":=1;
                        PurchasesLine."Qty. to Invoice":=1;
                        PurchasesLine."Expected Receipt Date":=Today;
                        PurchasesLine."Gen. Bus. Posting Group":=Vendor."Gen. Bus. Posting Group";
                        PurchasesLine."Gen. Prod. Posting Group":=GLAccount."Gen. Prod. Posting Group";
                        //PurchaseLine."VAT Bus. Posting Group":='STD';
                        PurchasesLine."Planned Receipt Date":=Today;
                        PurchasesLine."Direct Unit Cost":=LectLoadCustProdSource."Unit Cost";
                        PurchasesLine.Validate("Unit Cost");
                        //PurchasesLine."Line Amount":=LectLoadCustProdSource."Unit Cost";
                        //PurchasesLine.VALIDATE("Line Amount");
                        PurchasesLine.Insert(true);
                        
                        counted:=counted+1;
                        
                              end;
                        end;
                        until LectLoadCustProdSource.Next=0;
                        end;
                        //Set The Load Status as Posted and released then post
                        PurchasesHeader.Reset;
                        PurchasesHeader.SetRange(PurchasesHeader."Document Type",PurchasesHeader."document type"::Invoice);
                        PurchasesHeader.SetRange(PurchasesHeader."No.",NextOderNo);
                        if PurchasesHeader.Find('-') then begin
                          //Send Approval Request
                        PurchasesHeader.Validate(PurchasesHeader."Buy-from Vendor No.");
                        PurchasesHeader.Validate(PurchasesHeader."Pay-to Vendor No.");
                          PurchasesHeader.Modify;
                          PurchasesHeader.Status:=PurchasesHeader.Status::"Pending Approval";
                          PurchasesHeader.Modify;
                          end;
                        Rec."Claim No.":=NextOderNo;
                          Rec.Modify;
                        //Post the Load Here...
                        //CODEUNIT.RUN(81,PurchasesHeader);
                        // Get and populate The Invoice and the shipment Numbers Here...
                        // // // SalesInvoiceHeader.RESET;
                        // // // SalesInvoiceHeader.SETRANGE(SalesInvoiceHeader."Load No.",NextOderNo);
                        // // // IF SalesInvoiceHeader.FIND('-') THEN BEGIN
                        // // //  Rec."PV No.":=SalesInvoiceHeader."No.";
                        // // //  END;
                        /*
                        SalesShipmentHeader.RESET;
                        SalesShipmentHeader.SETRANGE(SalesShipmentHeader."Load No.",NextOderNo);
                        IF SalesShipmentHeader.FIND('-') THEN BEGIN
                          Rec."Claim No.":=SalesShipmentHeader."No.";
                          END;
                          Rec.MODIFY;*/
                        
                        Rec.Claimed:=true;
                          Rec.Modify
                          end;// ELSE ERROR('Part-timer not created as a service Provide!');
                        
                          Message('The Claim has been created but requires approval by the HOD');

                    end;
                }
                action(PrintDispInv)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print &Disp. and Invoice';
                    Image = PrintAcknowledgement;
                    Promoted = true;
                    PromotedIsBig = true;

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
    }

    trigger OnAfterGetRecord()
    begin
        //Rec.SETFILTER("Semester Code",'=%1',semesterfilter);
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

