#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77781 "CAT-Meal Booking Posted"
{
    PageType = Card;
    SourceTable = UnknownTable61778;
    SourceTableView = where(Status=filter(Approved));

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
                    Editable = false;
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

                trigger OnAction()
                begin
                    if Confirm('Post meal requisition?',true) = false then Error('Cancelled by user!');
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
}

