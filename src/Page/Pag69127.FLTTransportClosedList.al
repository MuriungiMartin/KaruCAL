#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69127 "FLT-Transport - Closed List"
{
    CardPageID = "FLT-Approved transport Req";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61801;
    SourceTableView = where(Status=filter(Transport));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Transport Requisition No";"Transport Requisition No")
                {
                    ApplicationArea = Basic;
                }
                field(Commencement;Commencement)
                {
                    ApplicationArea = Basic;
                }
                field(Destination;Destination)
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field("Date of Trip";"Date of Trip")
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
                field("Finance Officer Comments";"Finance Officer Comments")
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
                field("P/NO";"P/NO")
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
                field("Purpose of Trip";"Purpose of Trip")
                {
                    ApplicationArea = Basic;
                }
                field(Comments;Comments)
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
                        DocumentType:=Documenttype::TransportRequest;
                        ApprovalEntries.Setfilters(Database::"FLT-Transport Requisition",DocumentType,"Transport Requisition No");
                        ApprovalEntries.Run;
                    end;
                }
                action(PrintPreview)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print/Preview';
                    Image = PrintReport;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        FLTTransportRequisition: Record UnknownRecord61801;
                    begin
                        FLTTransportRequisition.Reset;
                        FLTTransportRequisition.SetRange(FLTTransportRequisition."Transport Requisition No","Transport Requisition No");
                        Report.Run(51342,true,false,FLTTransportRequisition);
                    end;
                }
            }
        }
    }

    var
        Text0001: label 'You have no been setup as a Fleet Management User Contact your Systems Administrator';
        FltUserSetup: Record UnknownRecord61799;
        ViewPerDepartment: Boolean;
        ApprovalEntries: Page "Approval Entries";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest;
        UserSetup: Record "User Setup";
        VehicleAllocateddpt: Record UnknownRecord61817;
        WshpFA: Record UnknownRecord61816;
        Vehicleallocated: Record UnknownRecord61797;
        UserSetup2: Record "User Setup";
        hremp: Record UnknownRecord61188;
        UserSetup3: Record "User Setup";
}

