#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69119 "FLT-Transport Req. List"
{
    ApplicationArea = Basic;
    CardPageID = "FLT-Transport Req.";
    PageType = List;
    SourceTable = UnknownTable61801;
    SourceTableView = where(Status=filter(Open|"Pending Approval"),
                            Submitted=filter(No));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
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
                field("Club/Societies";"Club/Societies")
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
                field("Requested By";"Requested By")
                {
                    ApplicationArea = Basic;
                }
                field("Date of Request";"Date of Request")
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
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Closing Odometer Reading";"Closing Odometer Reading")
                {
                    ApplicationArea = Basic;
                }
                field("Work Ticket No";"Work Ticket No")
                {
                    ApplicationArea = Basic;
                }
                field("No of Days Requested";"No of Days Requested")
                {
                    ApplicationArea = Basic;
                }
                field("Time out";"Time out")
                {
                    ApplicationArea = Basic;
                }
                field("Time In";"Time In")
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
                action(sendApproval)
                {
                    ApplicationArea = Basic;
                    Caption = 'Submit to Transport';
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
                        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application";
                        tableNo: Integer;
                    begin
                        if Confirm('Send requisition to the Transport Officer?',true)=false then exit;
                        
                          TestField(Status,Status::Open);
                          TestField( Commencement);
                          TestField(Destination );
                          TestField("Date of Trip");
                          TestField("Purpose of Trip");
                        
                        "Date Requisition Received":=Today;
                        "Time Requisition Received":=Time;
                        Submitted:=true;
                        Modify;
                        Message('Requisition sent to the transport officer for Approval.');
                        
                         /*State:=State::Open;
                         IF Status<>Status::Open THEN State:=State::"Pending Approval";
                         DocType:=DocType::TR;
                         CLEAR(tableNo);
                         tableNo:=61801;
                         IF ApprovalMgt.SendApproval(tableNo,Rec."Transport Requisition No",DocType,State,Rec."Responsibility Center") THEN;*/

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
        UserMgt: Codeunit "HMS Patient Treatment Mgt";
        ApprovalMgt: Codeunit "Export F/O Consolidation";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application";
        ApprovalEntries: Page "Approval Entries";
        UserSetup2: Record "User Setup";
        hremp: Record UnknownRecord61188;
        UserSetup3: Record "User Setup";
}

