#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68106 "HRM-Leave Requisition"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = UnknownTable61125;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Editable = NoEditable;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                    Editable = DateEditable;
                }
                field("Employee No";"Employee No")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Name";"Employee Name")
                {
                    ApplicationArea = Basic;
                    Editable = EmpNameEditable;
                }
                field("Reliever No.";"Reliever No.")
                {
                    ApplicationArea = Basic;
                    Editable = RelNoEditable;
                }
                field("Reliever Name";"Reliever Name")
                {
                    ApplicationArea = Basic;
                    Editable = RelNameEditable;
                }
                field("Campus Code";"Campus Code")
                {
                    ApplicationArea = Basic;
                    Editable = CampusCodeEditable;
                }
                field("Department Code";"Department Code")
                {
                    ApplicationArea = Basic;
                    Editable = DepartmentCodeEditable;
                }
                field("Leave Type";"Leave Type")
                {
                    ApplicationArea = Basic;
                    Editable = LeaveTypeEditable;
                }
                field("Applied Days";"Applied Days")
                {
                    ApplicationArea = Basic;
                    Editable = AppliedDaysEditable;
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                    Editable = StartingDateEditable;
                }
                field("End Date";"End Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Return Date";"Return Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Purpose;Purpose)
                {
                    ApplicationArea = Basic;
                    Editable = PurposeEditable;
                }
                field("Availlable Days";"Availlable Days")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Responsibility Center";"Responsibility Center")
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
                separator(Action15)
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
                separator(Action24)
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
                          //IF Status<>Status::Posted THEN ERROR('The Document Approval is not Complete');

                          TestField("Employee No");
                          TestField("Applied Days");
                          TestField("Starting Date");
                          LeaveEntry.Reset;
                          LeaveEntry.SetRange("Employee No","Employee No");
                          LeaveEntry.SetRange("Document No", "No.");
                          if LeaveEntry.Find('-') then begin
                            Error('Already Posted');
                            CurrPage.Close;
                             end;

                          LeaveEntry.Init;
                          LeaveEntry."Document No":="No.";
                          LeaveEntry."Leave Period":=Date2dwy(Today,3);
                          LeaveEntry."Transaction Date":=Date;
                          LeaveEntry."Employee No":="Employee No";
                          LeaveEntry."Leave Type":="Leave Type";
                          LeaveEntry."No. of Days":=-"Applied Days";
                          LeaveEntry."Transaction Description":=Purpose;
                          LeaveEntry."Entry Type":=LeaveEntry."entry type"::Application;
                          LeaveEntry."Created By":=UserId;
                          LeaveEntry."Transaction Type":=LeaveEntry."transaction type"::Application;
                          LeaveEntry.Insert(true);

                        Posted:=true;
                        "Posted By":=UserId;
                        "Posting Date":=Today;
                        Modify;

                        if HREmp.Get("Employee No") then begin
                        HREmp."On Leave":=true;
                        HREmp."Current Leave No":="No.";
                        HREmp.Modify;
                        end;
                        Message('Leave Posted Successfully');
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
        /*PurposeEditable := TRUE;
        "Starting DateEditable" := TRUE;
        "Applied DaysEditable" := TRUE;
        "Department CodeEditable" := TRUE;
        "Campus CodeEditable" := TRUE;
        "Employee NoEditable" := TRUE;
        DateEditable := TRUE;
        "No.Editable" := TRUE;*/
        UpdateControls;

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
        NoEditable: Boolean;
        [InDataSet]
        DateEditable: Boolean;
        [InDataSet]
        EmployeeNoEditable: Boolean;
        [InDataSet]
        CampusCodeEditable: Boolean;
        [InDataSet]
        DepartmentCodeEditable: Boolean;
        [InDataSet]
        AppliedDaysEditable: Boolean;
        [InDataSet]
        StartingDateEditable: Boolean;
        [InDataSet]
        PurposeEditable: Boolean;
        ApprovalEntries: Page "Approval Entries";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application";
        HREmp: Record UnknownRecord61188;
        RelNoEditable: Boolean;
        RelNameEditable: Boolean;
        EmpNameEditable: Boolean;
        LeaveTypeEditable: Boolean;


    procedure UpdateControls()
    begin
          if Status<>Status::Open then begin
        NoEditable:=false;
        DateEditable:=false;
        //EmployeeNoEditable:=FALSE;
        CampusCodeEditable:=false;
        DepartmentCodeEditable:=false;
        AppliedDaysEditable:=false;
        StartingDateEditable:=false;
        PurposeEditable:=false;
        RelNoEditable:=false;
        RelNameEditable:=false;
        EmpNameEditable:=false;
        LeaveTypeEditable:=false;


        //  CurrForm."Process Leave Allowance".EDITABLE:=FALSE;
          end else begin
         NoEditable:=false;
        DateEditable:=true;
        //EmployeeNoEditable:=FALSE;
        CampusCodeEditable:=false;
        DepartmentCodeEditable:=true;
        AppliedDaysEditable:=true;
        StartingDateEditable:=true;
        PurposeEditable:=true;
        RelNoEditable:=true;
        RelNameEditable:=false;
        EmpNameEditable:=false;
        LeaveTypeEditable:=true;
         // CurrForm."Process Leave Allowance".EDITABLE:=TRUE;

          end;
    end;
}

