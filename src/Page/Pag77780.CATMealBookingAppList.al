#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77780 "CAT-Meal Booking App. List"
{
    ApplicationArea = Basic;
    CardPageID = "CAT-Meal Booking Approved";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61778;
    SourceTableView = where(Status=filter(Approved));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
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
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Requested By";"Requested By")
                {
                    ApplicationArea = Basic;
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Basic;
                }
                field("Total Cost";"Total Cost")
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
            action("Print Form")
            {
                ApplicationArea = Basic;
                Caption = 'Print Form';
                Image = PrintReport;
                Promoted = true;

                trigger OnAction()
                begin
                    if not (Status=Status::Approved) then Error('You can only print a fully approved Meals Requisition.');

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
        RespCenter: Code[10];
}

