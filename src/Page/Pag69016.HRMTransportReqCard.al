#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69016 "HRM-Transport Req. Card"
{
    PageType = Card;
    SourceTable = UnknownTable61621;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Requisition Date";"Requisition Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Requisition Time";"Requisition Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Requester Code";"Requester Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Requester;Requester)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(From;From)
                {
                    ApplicationArea = Basic;
                }
                field("To";"To")
                {
                    ApplicationArea = Basic;
                }
                field("Purpose of Request";"Purpose of Request")
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Allocation Done";"Allocation Done")
                {
                    ApplicationArea = Basic;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1102755016;Outlook)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Show)
            {
                Caption = 'Show';
                action("Show Comments")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Functions)
            {
                Caption = 'Functions';
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin

                        DocumentType:=Documenttype::"Transport Requisition";
                        ApprovalEntries.Setfilters(Database::"HRM-Transport Request",DocumentType,HRTransportReq.Code);
                        ApprovalEntries.Run;
                    end;
                }
                action("Send Approval Request")
                {
                    ApplicationArea = Basic;

                    trigger OnAction()
                    begin
                        //TESTFIELDS;
                        if Confirm('Send this Application for Approval?',true)=false then exit;
                         // ApprovalMgt.SendTransportReqApprovalReq(Rec);
                    end;
                }
                action("Cancel approval Request")
                {
                    ApplicationArea = Basic;

                    trigger OnAction()
                    begin
                        //ApprovalMgt.CancelTransportAppRequest(Rec,TRUE,TRUE);;
                    end;
                }
            }
        }
    }

    var
        ApprovalMgt: Codeunit "Export F/O Consolidation";
        HRTransportReq: Record UnknownRecord61621;
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Store Requisition","Employee Requisition","Leave Application","Transport Requisition","Training Requisition","Job Approval","Induction Approval","Disciplinary Approvals","Activity Approval";
        ApprovalEntries: Page "Approval Entries";
        ApprovalComments: Page "Approval Comments";


    procedure UpdateControls()
    begin
        /*
        IF Status=Status::New THEN BEGIN
        Currpage.Code.EDITABLE:=TRUE;
        Currpage."Requisition Date".EDITABLE:=TRUE;
        Currpage.Requester.EDITABLE:=TRUE;
        Currpage."Global Dimension 2 Code".EDITABLE:=TRUE;
        Currpage.From.EDITABLE:=TRUE;
        Currpage."Purpose of Request".EDITABLE:=TRUE;
        Currpage."Requisition Time".EDITABLE:=TRUE;
        Currpage.Status.EDITABLE:=TRUE;
        Currpage."Responsibility Center".EDITABLE:=TRUE;
        Currpage."To".EDITABLE:=TRUE;
        Currpage."Requester Code".EDITABLE:=TRUE;
        END ELSE BEGIN
        Currpage.Code.EDITABLE:=FALSE;
        Currpage."Requisition Date".EDITABLE:=FALSE;
        Currpage.Requester.EDITABLE:=FALSE;
        Currpage."Global Dimension 2 Code".EDITABLE:=FALSE;
        Currpage.From.EDITABLE:=FALSE;
        Currpage."Purpose of Request".EDITABLE:=FALSE;
        Currpage."Requisition Time".EDITABLE:=FALSE;
        Currpage.Status.EDITABLE:=FALSE;
        Currpage."Responsibility Center".EDITABLE:=FALSE;
        Currpage."To".EDITABLE:=FALSE;
        Currpage."Requester Code".EDITABLE:=FALSE;
        END;
         */

    end;
}

