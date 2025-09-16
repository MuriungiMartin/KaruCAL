#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77718 "Venue Booking Allocated"
{
    Editable = false;
    PageType = Card;
    SourceTable = UnknownTable77709;

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
                field(Venue;Venue)
                {
                    ApplicationArea = Basic;
                }
                field("Venue Dscription";"Venue Dscription")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
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
                field("Meeting Description";"Meeting Description")
                {
                    ApplicationArea = Basic;
                    Caption = 'Description of Meeting';
                }
                field("Required Time";"Required Time")
                {
                    ApplicationArea = Basic;
                }
                field("Booking End Date";"Booking End Date")
                {
                    ApplicationArea = Basic;
                }
                field("Booking End Time";"Booking End Time")
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
        }
    }

    actions
    {
        area(creation)
        {
            action("Print Form")
            {
                ApplicationArea = Basic;
                Caption = 'Print Form';
                Image = PrintReport;
                Promoted = true;

                trigger OnAction()
                begin

                    Reset;
                    SetFilter("Booking Id","Booking Id");
                    Report.Run(77706,true,true,Rec);
                    Reset;
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
        GenVenueBooking: Record UnknownRecord77709;
}

