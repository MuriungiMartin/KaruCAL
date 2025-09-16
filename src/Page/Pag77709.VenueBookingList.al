#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77709 "Venue Booking List"
{
    ApplicationArea = Basic;
    CardPageID = "Venue Booking Header";
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable77709;
    SourceTableView = where(Status=filter(New));
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
                Caption = 'Submit Request';
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
                      TestField("Meeting Description");
                      TestField("Required Time");
                      TestField(Venue);
                      TestField("Contact Person");
                      TestField("Contact Number");
                      TestField(Pax);

                     if Confirm('Submit request',true)=false then Error('Cancelled by user!');
                     Status:=Status::"Pending Approval";
                     Modify;
                     if ApprovalsMgtNotification.SendVenueApprovalMail(Rec."Booking Id",'VENUE BOOKING',Rec."Contact Mail",Rec."Contact Person") then;
                     CurrPage.Update;
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
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetFilter("Requested By",'=%1',UserId);
        SetFilter(Status,'=%1',Status::New);
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
        ApprovalsMgtNotification: Codeunit "IC Setup Diagnostics";
}

