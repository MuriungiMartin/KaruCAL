#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 55506 "FLT-Fuel Req. List (Approved)"
{
    ApplicationArea = Basic;
    CardPageID = "FLT-Fuel Req. Approve View";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable55500;
    SourceTableView = where(Status=filter(Approved));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Req. No.";"Req. No.")
                {
                    ApplicationArea = Basic;
                }
                field("Requested By";"Requested By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
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
                field(Purpose;Purpose)
                {
                    ApplicationArea = Basic;
                }
                field("Emp. No.";"Emp. No.")
                {
                    ApplicationArea = Basic;
                }
                field("Description/Notes";"Description/Notes")
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
                field("No of Vehicles";"No of Vehicles")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Requisition Value";"Requisition Value")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
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
                    FLTFuelReqHeader.Reset;
                    FLTFuelReqHeader.SetRange("Req. No.",Rec."Req. No.");
                    if FLTFuelReqHeader.Find('-') then begin
                      Report.Run(55500,true,false,FLTFuelReqHeader);
                      end;
                end;
            }
        }
    }

    var
        FLTFuelReqHeader: Record UnknownRecord55500;
        UserMgt: Codeunit "HMS Patient Treatment Mgt";
        ApprovalMgt: Codeunit "Export F/O Consolidation";
        ApprovalEntries: Page "Approval Entries";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application";
}

