#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77715 "Venue Booking - Pending Alloc."
{
    ApplicationArea = Basic;
    CardPageID = "Venue Booking Allocate";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable77709;
    SourceTableView = where(Status=filter("Pending Approval"));
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
                field("Meeting Description";"Meeting Description")
                {
                    ApplicationArea = Basic;
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
                field("Venue Dscription";"Venue Dscription")
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
            action(sendApproval)
            {
                ApplicationArea = Basic;
                Caption = 'Mark as Allocated';
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
                    ApprovalsMgtNotification: Codeunit "IC Setup Diagnostics";
                    VenueSetup: Record UnknownRecord77706;
                    VenueBookingPermissions: Record UnknownRecord77710;
                begin
                    VenueBookingPermissions.Reset;
                    VenueBookingPermissions.SetRange("User Id",UserId);
                    if VenueBookingPermissions.Find('-') then begin
                      VenueBookingPermissions.TestField("Can Approve Booking");
                      end else Error('Access Denied!');

                      TestField(Department);
                      TestField("Request Date");
                      TestField("Booking Date");
                      TestField("Meeting Description");
                      TestField("Required Time");
                      TestField("Booking End Date");
                      TestField("Booking End Time");
                      TestField(Venue);
                      TestField("Contact Person");
                      TestField("Contact Number");
                      TestField(Pax);

                     if Confirm('Confirm Request',true)=false then Error('Cancelled by user!');
                     Status:=Status::Approved;
                     Modify;
                     //Update Room Statatus
                     Rec.CalcFields("Department Name","Venue Dscription");
                     VenueSetup.Reset;
                     VenueSetup.SetRange("Venue Code",Rec.Venue);
                     if VenueSetup.Find('-') then begin
                        VenueSetup."Book Id":=Rec."Booking Id";
                        VenueSetup."Booked From Date":=Rec."Request Date";
                        VenueSetup."Booked To Date":=Rec."Booking End Date";
                        VenueSetup."Booked From Time":=Rec."Required Time";
                        VenueSetup."Booked To Time":=Rec."Booking End Time";
                        VenueSetup."Booked Department":=Rec.Department;
                        VenueSetup."Booked Department Name":=Rec."Department Name";
                        VenueSetup."Booked By Name":=Rec."Contact Person";
                        VenueSetup.Status:=VenueSetup.Status::Occupied;
                        VenueSetup."Booked By Phone":=Rec."Contact Number";
                        VenueSetup.Modify;
                       end;
                     ApprovalsMgtNotification.SendVenueApprovedlMail(Rec."Booking Id",'VENUE BOOKING',Rec."Contact Mail",Rec."Contact Person");
                     CurrPage.Update;
                     Message('Approved!');
                end;
            }
            separator(Action1000000020)
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

                    Reset;
                    SetFilter("Booking Id","Booking Id");
                    Report.Run(77707,true,true,Rec);
                    Reset;
                end;
            }
            action("Allocation Schedule")
            {
                ApplicationArea = Basic;
                Caption = 'Allocation Schedule';
                Image = AmountByPeriod;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "Allocations Per Venue & Date";
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetFilter(Status,'%1',Status::"Pending Approval");
    end;

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

