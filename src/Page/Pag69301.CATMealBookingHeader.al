#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69301 "CAT-Meal Booking Header"
{
    PageType = Card;
    SourceTable = UnknownTable61778;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Booking Id";"Booking Id")
                {
                    ApplicationArea = Basic;
                }
                field(Department;Department)
                {
                    ApplicationArea = Basic;
                }
                field("Department Name";"Department Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Request Date";"Request Date")
                {
                    ApplicationArea = Basic;
                }
                field("Booking Date";"Booking Date")
                {
                    ApplicationArea = Basic;
                }
                field("Booking Time";"Booking Time")
                {
                    ApplicationArea = Basic;
                }
                field("Meeting Name";"Meeting Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Description of Meeting';
                }
                field("Required Time";"Required Time")
                {
                    ApplicationArea = Basic;
                }
                field(Venue;Venue)
                {
                    ApplicationArea = Basic;
                }
                field("Contact Person";"Contact Person")
                {
                    ApplicationArea = Basic;
                }
                field("Contact Number";"Contact Number")
                {
                    ApplicationArea = Basic;
                }
                field("Contact Mail";"Contact Mail")
                {
                    ApplicationArea = Basic;
                }
                field(Pax;Pax)
                {
                    ApplicationArea = Basic;
                    Caption = 'Number of People';
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Requested By";"Requested By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Total Cost";"Total Cost")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Commited;Commited)
                {
                    ApplicationArea = Basic;
                }
                field("Budgeted Amount";"Budgeted Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Actual Expenditure";"Actual Expenditure")
                {
                    ApplicationArea = Basic;
                }
                field("Committed Amount";"Committed Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Budget Balance";"Budget Balance")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Details)
            {
                Caption = 'Details';
                part(Control1000000024;"ACA-Meal Booking Lines")
                {
                    SubPageLink = "Booking Id"=field("Booking Id");
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Approvals)
            {
                ApplicationArea = Basic;
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    DocumentType:=Documenttype::"Meals Bookings";
                    ApprovalEntries.Setfilters(Database::"CAT-Meal Booking Header",DocumentType,Rec."Booking Id");
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
                      TestField(Department);
                      TestField("Request Date");
                      TestField("Booking Date");
                      TestField("Meeting Name");
                      TestField("Required Time");
                      TestField(Venue);
                      TestField("Contact Person");
                      TestField("Contact Number");
                      TestField(Pax);

                     // IF "Availlable Days"<1 THEN ERROR('Please note that you dont have enough leave balance');

                    //Release the Bookingfor Approval
                     State:=State::Open;
                     if Status<>Status::New then State:=State::"Pending Approval";
                     DocType:=Doctype::"Meals Bookings";
                     Clear(tableNo);
                     tableNo:=61778;
                     Clear(respCenter);
                     if ApprovalMgt.SendApproval(tableNo,Rec."Booking Id",DocType,State,respCenter,0) then;
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
                     DocType:=Doctype::"Meals Bookings";
                     showmessage:=true;
                     ManualCancel:=true;
                     Clear(tableNo);
                     tableNo:=61778;
                      if ApprovalMgt.CancelApproval(tableNo,DocType,Rec."Booking Id",showmessage,ManualCancel) then;

                    // IF ApprovalMgt.CancelLeaveApprovalRequest(Rec,TRUE,TRUE) THEN;
                end;
            }
            separator(Action1000000026)
            {
            }
            action("Print Form")
            {
                ApplicationArea = Basic;
                Caption = 'Print Form';
                Image = PrintReport;
                Promoted = true;

                trigger OnAction()
                begin
                    //IF NOT (Status=Status::Approved) THEN ERROR('You can only print a fully approved Meals Requisition.');

                    Reset;
                    SetFilter("Booking Id","Booking Id");
                    Report.Run(69271,true,true,Rec);
                    Reset;
                end;
            }
            action("Post Meal Requisition")
            {
                ApplicationArea = Basic;
                Caption = 'Post Meal Requisition';
                Image = PostDocument;
                Promoted = true;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                    if Confirm('Post meal requisition?',true) = false then Error('Cancelled by user!');
                end;
            }
            action("Check Budget Availlabilty")
            {
                ApplicationArea = Basic;
                Caption = 'Check Budget Availlabilty';
                Image = Check;
                Promoted = true;

                trigger OnAction()
                begin
                    BCSetup.Get;
                    if not BCSetup.Mandatory then
                       exit;
                     //IF ("Issuing Store"<>'MAIN') AND ("Issuing Store"<>'GENERAL') THEN ERROR('This function is only applicable to Central Stores')
                    ;
                    //IF Status=Status::Released THEN
                    //  ERROR('This document has already been released. This functionality is available for open documents only');
                    //IF NOT SomeLinesCommitted THEN BEGIN
                    //   IF NOT CONFIRM( 'Some or All the Lines Are already Committed do you want to continue',TRUE, "Document Type") THEN
                    //        ERROR('Budget Availability Check and Commitment Aborted');
                      DeleteCommitment.Reset;
                      DeleteCommitment.SetRange(DeleteCommitment."Document Type",DeleteCommitment."document type"::Meal);
                      DeleteCommitment.SetRange(DeleteCommitment."Document No.","Booking Id");
                      DeleteCommitment.DeleteAll;
                    //END;

                    //IF "Requisition Type"="Requisition Type"::Stationery THEN

                       Commitment.CheckMeal(Rec);
                      // ELSE
                      // ERROR('Please note that only Stationery Items are voted');

                       Commited:=true;
                       Modify;
                       Message('Budget Availability Checking Complete');
                end;
            }
            separator(Action1000000020)
            {
            }
            action("Cancel Budget Commitments")
            {
                ApplicationArea = Basic;
                Caption = 'Cancel Budget Commitments';
                Image = CancelLine;
                Promoted = true;

                trigger OnAction()
                begin
                      TestField(Commited);
                       if not Confirm( 'Are you sure you want to Cancel All Commitments Done for this document',true) then
                            Error('Budget Availability Check and Commitment Aborted');

                      DeleteCommitment.Reset;
                      DeleteCommitment.SetRange(DeleteCommitment."Document Type",DeleteCommitment."document type"::Meal);
                      DeleteCommitment.SetRange(DeleteCommitment."Document No.","Booking Id");
                      DeleteCommitment.DeleteAll;
                      //Tag all the SRN entries as Uncommitted
                      Commited:=false;
                      Modify;
                    Message('Commitments Cancelled Successfully for Doc. No %1',"Booking Id");
                end;
            }
        }
    }

    var
        UserMgt: Codeunit "HMS Patient Treatment Mgt";
        ApprovalMgt: Codeunit "Export F/O Consolidation";
        InventorySetup: Record "Inventory Setup";
        GenJnline: Record "Item Journal Line";
        LineNo: Integer;
        Post: Boolean;
        JournlPosted: Codeunit PostCaferiaBatches;
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        FixedAsset: Record "Fixed Asset";
        ApprovalEntries: Page "Approval Entries";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application";
        RelNoEditable: Boolean;
        RelNameEditable: Boolean;
        EmpNameEditable: Boolean;
        LeaveTypeEditable: Boolean;
        respCenter: Code[10];
        ReqLine: Record UnknownRecord61779;
        MinorAssetsIssue: Record UnknownRecord61725;
        Commitment: Codeunit "Procurement Controls Handler";
        BCSetup: Record UnknownRecord61721;
        DeleteCommitment: Record UnknownRecord61722;
        Loc: Record Location;
}

