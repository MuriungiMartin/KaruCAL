#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 55518 "FLT-Maintenance List (Closed)"
{
    ApplicationArea = Basic;
    CardPageID = "FLT-Maintenance Card";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable55517;
    SourceTableView = where(Status=filter(Closed));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Req. No.";"Req. No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Maintenance Period";"Maintenance Period")
                {
                    ApplicationArea = Basic;
                }
                field("Req. Date";"Req. Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Req. Time";"Req. Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Maintenance Type";"Maintenance Type")
                {
                    ApplicationArea = Basic;
                }
                field("Emp. No.";"Emp. No.")
                {
                    ApplicationArea = Basic;
                }
                field("Requested By";"Requested By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Work Performed & Notes";"Work Performed & Notes")
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
                    Enabled = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Vehicle Registration";"Vehicle Registration")
                {
                    ApplicationArea = Basic;
                }
                field("Vehicle Details";"Vehicle Details")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Fuel Type";"Fuel Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("CC Rating";"CC Rating")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Vihicle Make";"Vihicle Make")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Vehicle Model";"Vehicle Model")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Service Done By (Employee)";"Service Done By (Employee)")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Date of Service";"Date of Service")
                {
                    ApplicationArea = Basic;
                }
                field("Milleage of Service";"Milleage of Service")
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
            action(PrintForm)
            {
                ApplicationArea = Basic;
                Caption = 'Print Form';
                Image = PrintReport;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FLTMaintenanceReqHeader.Reset;
                    FLTMaintenanceReqHeader.SetRange("Req. No.",Rec."Req. No.");
                    if FLTMaintenanceReqHeader.Find('-') then begin
                      Report.Run(55510,true,false,FLTMaintenanceReqHeader);
                      end;
                end;
            }
            action(Approvals)
            {
                ApplicationArea = Basic;
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    DocumentType:=Documenttype::Maintenance;
                    ApprovalEntries.Setfilters(Database::"FLT-Maintenance Req. Header",DocumentType,"Req. No.");
                    ApprovalEntries.Run;
                end;
            }
        }
    }

    var
        UserMgt: Codeunit "HMS Patient Treatment Mgt";
        ApprovalMgt: Codeunit "Export F/O Consolidation";
        ApprovalEntries: Page "Approval Entries";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application";
        FLTMaintenanceReqHeader: Record UnknownRecord55517;
}

