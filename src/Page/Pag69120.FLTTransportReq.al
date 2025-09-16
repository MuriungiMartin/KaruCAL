#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69120 "FLT-Transport Req."
{
    PageType = Document;
    SourceTable = UnknownTable61801;
    SourceTableView = where(Status=filter(Open|"Pending Approval"));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Transport Requisition No";"Transport Requisition No")
                {
                    ApplicationArea = Basic;
                    Editable = editable;
                    Enabled = false;
                }
                field("Emp No";"Emp No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Patron No.';
                    Editable = editable;
                }
                field("Employee Name";"Employee Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Patron Name';
                    Editable = false;
                }
                field(Position;Position)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(From;Commencement)
                {
                    ApplicationArea = Basic;
                    Editable = editable;
                }
                field("To";Destination)
                {
                    ApplicationArea = Basic;
                    Editable = editable;
                }
                field("Date of Trip";"Date of Trip")
                {
                    ApplicationArea = Basic;
                    Editable = editable;
                }
                field("Purpose of Trip";"Purpose of Trip")
                {
                    ApplicationArea = Basic;
                    Editable = editable;
                    MultiLine = true;
                }
                field("Nature of Trip";"Nature of Trip")
                {
                    ApplicationArea = Basic;
                    Editable = editable;
                }
                field(Group;Group)
                {
                    ApplicationArea = Basic;
                    Editable = editable;
                }
                field("Club/Societies";"Club/Societies")
                {
                    ApplicationArea = Basic;
                    Editable = editable;
                }
                field("No Of Passangers";"No Of Passangers")
                {
                    ApplicationArea = Basic;
                    Editable = editable;
                }
                field("No of Days Requested";"No of Days Requested")
                {
                    ApplicationArea = Basic;
                    Editable = editable;
                }
                field("Requested By";"Requested By")
                {
                    ApplicationArea = Basic;
                    Editable = editable;
                }
                field(Comments;Comments)
                {
                    ApplicationArea = Basic;
                    Editable = editable;
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                    Editable = editable;
                }
            }
            group("TRANSPORT OFFICER")
            {
                Editable = false;
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Transport Available/Not Av.";"Transport Available/Not Av.")
                {
                    ApplicationArea = Basic;
                }
                field("Type of Vehicle";"Type of Vehicle")
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
                field("Opening Odometer Reading";"Opening Odometer Reading")
                {
                    ApplicationArea = Basic;
                }
                field("Approved Rate";"Approved Rate")
                {
                    ApplicationArea = Basic;
                    Visible = true;
                }
                field("Fuel Unit Cost";"Fuel Unit Cost")
                {
                    ApplicationArea = Basic;
                    Visible = true;
                }
                field("Estimated Mileage";"Estimated Mileage")
                {
                    ApplicationArea = Basic;
                    Visible = true;
                }
                field("Total Cost";"Total Cost")
                {
                    ApplicationArea = Basic;
                    Visible = true;
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

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "Responsibility Center":='KARU';
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Responsibility Center":='KARU';
    end;

    trigger OnOpenPage()
    begin
        editable:=true;
    end;

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
        editable: Boolean;
}

