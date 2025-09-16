#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77170 "FLT-Transport Req. Read"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Document;
    SourceTable = UnknownTable61801;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Transport Requisition No";"Transport Requisition No")
                {
                    ApplicationArea = Basic;
                }
                field("Emp No";"Emp No")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Name";"Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field(From;Commencement)
                {
                    ApplicationArea = Basic;
                }
                field("To";Destination)
                {
                    ApplicationArea = Basic;
                }
                field("Date of Trip";"Date of Trip")
                {
                    ApplicationArea = Basic;
                }
                field("Purpose of Trip";"Purpose of Trip")
                {
                    ApplicationArea = Basic;
                }
                field("Nature of Trip";"Nature of Trip")
                {
                    ApplicationArea = Basic;
                }
                field(Group;Group)
                {
                    ApplicationArea = Basic;
                }
                field("No Of Passangers";"No Of Passangers")
                {
                    ApplicationArea = Basic;
                }
                field("Authorized  By";"Authorized  By")
                {
                    ApplicationArea = Basic;
                }
                field(Position;Position)
                {
                    ApplicationArea = Basic;
                }
                field("Transport Officer Remarks";"Transport Officer Remarks")
                {
                    ApplicationArea = Basic;
                }
                field("HOD Recommendations";"HOD Recommendations")
                {
                    ApplicationArea = Basic;
                }
                field("No of Days Requested";"No of Days Requested")
                {
                    ApplicationArea = Basic;
                }
                field("Requested By";"Requested By")
                {
                    ApplicationArea = Basic;
                }
                field("Date Requisition Received";"Date Requisition Received")
                {
                    ApplicationArea = Basic;
                }
                field("Date of Request";"Date of Request")
                {
                    ApplicationArea = Basic;
                }
                field("Time Requisition Received";"Time Requisition Received")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Vehicle Allocated";"Vehicle Allocated")
                {
                    ApplicationArea = Basic;
                }
                field("Driver Allocated";"Driver Allocated")
                {
                    ApplicationArea = Basic;
                }
                field("Vehicle Allocated by";"Vehicle Allocated by")
                {
                    ApplicationArea = Basic;
                }
                field("Opening Odometer Reading";"Opening Odometer Reading")
                {
                    ApplicationArea = Basic;
                }
                field("Clossing ODO";"Clossing ODO")
                {
                    ApplicationArea = Basic;
                }
                field(Mileage;Mileage)
                {
                    ApplicationArea = Basic;
                }
                field(Comments;Comments)
                {
                    ApplicationArea = Basic;
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
                        DocumentType:=Documenttype::TR;
                        ApprovalEntries.Setfilters(Database::"FLT-Transport Requisition",DocumentType,"Transport Requisition No");
                        ApprovalEntries.Run;
                    end;
                }
                action("Print/Preview")
                {
                    ApplicationArea = Basic;
                    Caption = 'Print/Preview';
                    Image = PrintReport;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        transRe.Reset;
                        transRe.SetFilter(transRe."Transport Requisition No","Transport Requisition No");
                        if transRe.Find('-') then
                        Report.Run(51342,true,true,Rec);
                    end;
                }
            }
        }
    }

    var
        Text0001: label 'You have no been setup as a Fleet Management User Contact your Systems Administrator';
        UserMgt: Codeunit "HMS Patient Treatment Mgt";
        ApprovalMgt: Codeunit "Export F/O Consolidation";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application";
        ApprovalEntries: Page "Approval Entries";
        UserSetup2: Record "User Setup";
        hremp: Record UnknownRecord61188;
        UserSetup3: Record "User Setup";
        transRe: Record UnknownRecord61801;
}

