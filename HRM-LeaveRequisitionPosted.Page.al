#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68108 "HRM-Leave Requisition Posted"
{
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable61125;
    SourceTableView = where(Status=filter(Posted));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Editable = "No.Editable";
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                    Editable = DateEditable;
                }
                field("Employee No";"Employee No")
                {
                    ApplicationArea = Basic;
                    Editable = "Employee NoEditable";
                }
                field("Employee Name";"Employee Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Campus Code";"Campus Code")
                {
                    ApplicationArea = Basic;
                    Editable = "Campus CodeEditable";
                }
                field("Department Code";"Department Code")
                {
                    ApplicationArea = Basic;
                    Editable = "Department CodeEditable";
                }
                field("Applied Days";"Applied Days")
                {
                    ApplicationArea = Basic;
                    Editable = "Applied DaysEditable";
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                    Editable = "Starting DateEditable";
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
                field("Leave Type";"Leave Type")
                {
                    ApplicationArea = Basic;
                }
                field(Purpose;Purpose)
                {
                    ApplicationArea = Basic;
                    Editable = PurposeEditable;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Leave Balance";"Leave Balance")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Availlable Days";"Availlable Days")
                {
                    ApplicationArea = Basic;
                    Editable = false;
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
                action("Post Leave Application")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Leave Application';
                    Visible = false;

                    trigger OnAction()
                    begin
                         /* IF Status<>Status::Released THEN ERROR('The Document Approval is not Complete');
                        
                          TESTFIELD("Employee No");
                          TESTFIELD("Applied Days");
                          TESTFIELD("Starting Date");
                        
                          LeaveEntry.INIT;
                          LeaveEntry."Document No":="Employee No";
                          LeaveEntry."From Date":="No.";
                          LeaveEntry."To Date":="Leave Type";
                          LeaveEntry."Duration Units":="Starting Date";
                          LeaveEntry.Duration:=-"Applied Days";
                          LeaveEntry."Cost Of Training":=LeaveEntry."Cost Of Training"::"2";
                          LeaveEntry.INSERT(TRUE);
                        
                        Posted:=TRUE;
                        "Posted By":=USERID;
                        "Posting Date":=TODAY;
                        MODIFY;
                          MESSAGE('Leave Posted Successfully');  */

                    end;
                }
                separator(Action1102755034)
                {
                }
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;

                    trigger OnAction()
                    begin
                        DocumentType:=Documenttype::Requisition;
                        ApprovalEntries.Setfilters(Database::"PROC-Store Requistion Header",DocumentType,"No.");
                        ApprovalEntries.Run;
                    end;
                }
                action("Print/Preview")
                {
                    ApplicationArea = Basic;
                    Caption = 'Print/Preview';

                    trigger OnAction()
                    begin
                        Reset;
                        SetFilter("No.","No.");
                        Report.Run(51720,true,true,Rec);
                        Reset;
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        //ProcessLeaveAllowanceEditable := TRUE;
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
          if Status<>0 then begin
          "No.Editable" :=false;
          DateEditable :=false;
          "Employee NoEditable" :=false;
          "Campus CodeEditable" :=false;
          "Department CodeEditable" :=false;
          "Applied DaysEditable" :=false;
          "Starting DateEditable" :=false;
          PurposeEditable :=false;
        //  ProcessLeaveAllowanceEditable :=FALSE;
          end else begin
          "No.Editable" :=true;
          DateEditable :=true;
          "Employee NoEditable" :=true;
          "Campus CodeEditable" :=true;
          "Department CodeEditable" :=true;
          "Applied DaysEditable" :=true;
          "Starting DateEditable" :=true;
          PurposeEditable :=true;
          //ProcessLeaveAllowanceEditable :=TRUE;

          end;
    end;
}

