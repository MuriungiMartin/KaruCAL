#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68107 "HRM-Leave Requisition List"
{
    ApplicationArea = Basic;
    CardPageID = "HRM-Leave Requisition";
    DeleteAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61125;
    SourceTableView = where(Posted=filter(No),
                            Status=filter(<>Posted));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';
                Editable = false;
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field("Employee No";"Employee No")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Name";"Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Applied Days";"Applied Days")
                {
                    ApplicationArea = Basic;
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                }
                field("End Date";"End Date")
                {
                    ApplicationArea = Basic;
                }
                field("Campus Code";"Campus Code")
                {
                    ApplicationArea = Basic;
                }
                field("Department Code";"Department Code")
                {
                    ApplicationArea = Basic;
                }
                field("Leave Type";"Leave Type")
                {
                    ApplicationArea = Basic;
                }
                field("Leave Balance";"Leave Balance")
                {
                    ApplicationArea = Basic;
                }
                field("Return Date";"Return Date")
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
            group("&Functions")
            {
                Caption = '&Functions';
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        DocumentType:=Documenttype::"Leave Application";
                        ApprovalEntries.Setfilters(Database::"HRM-Leave Requisition",DocumentType,"No.");
                        ApprovalEntries.Run;
                    end;
                }
                action(sendApproval)
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Export F/O Consolidation";
                        showmessage: Boolean;
                        ManualCancel: Boolean;
                        State: Option Open,"Pending Approval",Cancelled,Approved;
                        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Staff Advance","Staff Advance Accounting";
                        tableNo: Integer;
                    begin
                          TestField("Employee No");
                          TestField("Applied Days");
                          TestField("Starting Date");
                           TestField("Reliever No.");
                            TestField(Purpose);
                          if "Availlable Days"<1 then Error('Please note that you dont have enough leave balance');


                        //Release the Leave for Approval
                         State:=State::Open;
                         if Status<>Status::Open then State:=State::"Pending Approval";
                         DocType:=Doctype::"Leave Application";
                         Clear(tableNo);
                         tableNo:=61125;
                         if ApprovalMgt.SendApproval(tableNo,Rec."No.",DocType,State,"Responsibility Center",0) then;
                         //  IF ApprovalMgt.SendLeaveApprovalRequest(Rec) THEN;
                    end;
                }
                action(cancellsApproval)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Export F/O Consolidation";
                        showmessage: Boolean;
                        ManualCancel: Boolean;
                        State: Option Open,"Pending Approval",Cancelled,Approved;
                        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Staff Advance","Staff Advance Accounting";
                        tableNo: Integer;
                    begin
                         DocType:=Doctype::"Leave Application";
                         showmessage:=true;
                         ManualCancel:=true;
                         Clear(tableNo);
                         tableNo:=61125;
                          if ApprovalMgt.CancelApproval(tableNo,DocType,Rec."No.",showmessage,ManualCancel) then;

                        // IF ApprovalMgt.CancelLeaveApprovalRequest(Rec,TRUE,TRUE) THEN;
                    end;
                }
                separator(Action1000000003)
                {
                }
                action("Print/Preview")
                {
                    ApplicationArea = Basic;
                    Caption = 'Print/Preview';
                    Image = PrintReport;
                    Promoted = true;

                    trigger OnAction()
                    begin
                        Reset;
                        SetFilter("No.","No.");
                        Report.Run(51720,true,true,Rec);
                        Reset;
                    end;
                }
                separator(Action1000000001)
                {
                }
                action("Post Leave Application")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Leave Application';
                    Image = Post;
                    Promoted = true;

                    trigger OnAction()
                    begin
                          if Status<>Status::Posted then Error('The Document Approval is not Complete');
                    end;
                }
                action("Leave Summary Report")
                {
                    ApplicationArea = Basic;
                    Image = BulletList;
                    Promoted = true;

                    trigger OnAction()
                    begin
                        Report.Run(51870,true);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
          UpdateControls;
    end;

    trigger OnInit()
    begin
        PurposeEditable := true;
        "Starting DateEditable" := true;
        "Applied DaysEditable" := true;
        "Department CodeEditable" := true;
        "Campus CodeEditable" := true;
        "Employee NoEditable" := true;
        DateEditable := true;
        "No.Editable" := true;
    end;

    trigger OnOpenPage()
    begin
        /*
        IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center" ,UserMgt.GetPurchasesFilter());
          FILTERGROUP(0);
        END;
        */
        //SETFILTER("User ID",USERID);
        UpdateControls;

    end;

    var
        UserMgt: Codeunit "HMS Patient Treatment Mgt";
        ApprovalMgt: Codeunit "Export F/O Consolidation";
        ReqLine: Record UnknownRecord61400;
        InventorySetup: Record "Inventory Setup";
        GenJnline: Record "Item Journal Line";
        LineNo: Integer;
        Post: Boolean;
        JournlPosted: Codeunit PostCaferiaBatches;
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        FixedAsset: Record "Fixed Asset";
        MinorAssetsIssue: Record UnknownRecord61402;
        LeaveEntry: Record UnknownRecord61659;
        [InDataSet]
        "No.Editable": Boolean;
        [InDataSet]
        DateEditable: Boolean;
        [InDataSet]
        "Employee NoEditable": Boolean;
        [InDataSet]
        "Campus CodeEditable": Boolean;
        [InDataSet]
        "Department CodeEditable": Boolean;
        [InDataSet]
        "Applied DaysEditable": Boolean;
        [InDataSet]
        "Starting DateEditable": Boolean;
        [InDataSet]
        PurposeEditable: Boolean;
        ApprovalEntries: Page "Approval Entries";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application";
        HREmp: Record UnknownRecord61188;


    procedure UpdateControls()
    begin
          if Status<>Status::Open then begin
          "No.Editable" :=false;
          DateEditable :=false;
          "Employee NoEditable" :=false;
          "Campus CodeEditable" :=false;
          "Department CodeEditable" :=false;
          "Applied DaysEditable" :=false;
          "Starting DateEditable" :=false;
          PurposeEditable :=false;
        //  CurrForm."Process Leave Allowance".EDITABLE:=FALSE;
          end else begin
          "No.Editable" :=true;
          DateEditable :=true;
          "Employee NoEditable" :=true;
          "Campus CodeEditable" :=true;
          "Department CodeEditable" :=true;
          "Applied DaysEditable" :=true;
          "Starting DateEditable" :=true;
          PurposeEditable :=true;
         // CurrForm."Process Leave Allowance".EDITABLE:=TRUE;

          end;
    end;
}

