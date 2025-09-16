#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 65023 "Cash Sale List-Student"
{
    ApplicationArea = Basic;
    Caption = 'Students Cash Sale';
    CardPageID = "Cash Sale Header-Student";
    DataCaptionFields = "Sell-to Customer No.";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Request Approval,Order';
    SourceTable = "Sales Header";
    SourceTableView = where("Document Type"=filter(Order),
                            "Cash Sale Order"=filter(true),
                            Status=filter(Open));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the sales document.';
                }
                field("Posting Description";"Posting Description")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date when the posting of the sales document will be recorded.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.';
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the name of the salesperson who is assigned to the customer.';
                    Visible = false;
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date on which you created the sales document.';
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the document is open, waiting to be approved, has been invoiced for prepayment, or has been released to the next stage of processing.';
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Amount Including VAT";"Amount Including VAT")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Payment Method";"Payment Method")
                {
                    ApplicationArea = Basic;
                }
                field("M-Pesa Transaction Number";"M-Pesa Transaction Number")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(Post)
                {
                    ApplicationArea = Basic;
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';
                    Visible = false;

                    trigger OnAction()
                    begin
                        CalcFields(Amount);
                        if Amount=0 then Error('Nothing to be paid for!');
                        Page.Run(65005,Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetControlVisibility;
        //CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
    end;

    trigger OnAfterGetRecord()
    begin
        //SETFILTER("Location Code",FINCashOfficeUserTemplate."Default Direct Sales Location");
        SetFilter("Created By",'%1',UserId);
        SetFilter("Document Date",'=%1',Today);
        SetFilter("Sales Location Category",'%1',"sales location category"::Students);
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        exit(Find(Which) and ShowHeader);
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    var
        NewStepCount: Integer;
    begin
        repeat
          NewStepCount := Next(Steps);
        until (NewStepCount = 0) or ShowHeader;

        exit(NewStepCount);
    end;

    trigger OnOpenPage()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
        OfficeMgt: Codeunit "Office Management";
    begin
        if UserMgt.GetSalesFilter <> '' then begin
          FilterGroup(2);
          SetRange("Responsibility Center",UserMgt.GetSalesFilter);
          FilterGroup(0);
        end;
        FINCashOfficeUserTemplate.Reset;
        FINCashOfficeUserTemplate.SetRange(FINCashOfficeUserTemplate.User_ID,UserId);
        if not FINCashOfficeUserTemplate.Find('-') then Error('Access denied');
        FINCashOfficeUserTemplate.TestField(FINCashOfficeUserTemplate."Default Direct Sales Location");
        //SETFILTER("Location Code",FINCashOfficeUserTemplate."Default Direct Sales Location");
        SetFilter("Created By",'%1',UserId);
        SetFilter("Document Date",'=%1',Today);
        SetFilter("Sales Location Category",'%1',"sales location category"::Students);
        SetRange("Date Filter",0D,WorkDate - 1);

        JobQueueActive := SalesSetup.JobQueueActive;
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
        IsOfficeAddin := OfficeMgt.IsAvailable;

        CopySellToCustomerFilter;
        //SETFILTER("Location Code",FINCashOfficeUserTemplate."Default Direct Sales Location");
    end;

    var
        ApplicationAreaSetup: Record "Application Area Setup";
        DocPrint: Codeunit "Document-Print";
        ReportPrint: Codeunit "Test Report-Print";
        UserMgt: Codeunit "User Setup Management";
        Usage: Option "Order Confirmation","Work Order","Pick Instruction";
        [InDataSet]
        JobQueueActive: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CRMIntegrationEnabled: Boolean;
        IsOfficeAddin: Boolean;
        CanCancelApprovalForRecord: Boolean;
        SkipLinesWithoutVAT: Boolean;
        FINCashOfficeUserTemplate: Record UnknownRecord61712;


    procedure ShowPreview()
    var
        SalesPostYesNo: Codeunit "Sales-Post (Yes/No)";
    begin
        SalesPostYesNo.Preview(Rec);
    end;

    local procedure SetControlVisibility()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);

        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RecordId);
    end;

    local procedure Post(PostingCodeunitID: Integer)
    var
        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
    begin
        if ApplicationAreaSetup.IsFoundationEnabled then
          LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(Rec);

        SendToPosting(PostingCodeunitID);

        CurrPage.Update(false);
    end;


    procedure SkipShowingLinesWithoutVAT()
    begin
        SkipLinesWithoutVAT := true;
    end;

    local procedure ShowHeader(): Boolean
    var
        CashFlowManagement: Codeunit "Cash Flow Management";
    begin
        if SkipLinesWithoutVAT and (CashFlowManagement.GetTaxAmountFromSalesOrder(Rec) = 0) then
          exit(false);

        exit(true);
    end;
}

