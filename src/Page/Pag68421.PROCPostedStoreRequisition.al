#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68421 "PROC-Posted Store Requisition"
{
    ApplicationArea = Basic;
    CardPageID = "PROC-Posted Store Reqs";
    PageType = List;
    SourceTable = UnknownTable61399;
    SourceTableView = where(Status=filter(Posted));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field("Request date";"Request date")
                {
                    ApplicationArea = Basic;
                }
                field("Required Date";"Required Date")
                {
                    ApplicationArea = Basic;
                }
                field("Requester ID";"Requester ID")
                {
                    ApplicationArea = Basic;
                }
                field("Request Description";"Request Description")
                {
                    ApplicationArea = Basic;
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field(Supplier;Supplier)
                {
                    ApplicationArea = Basic;
                }
                field("Action Type";"Action Type")
                {
                    ApplicationArea = Basic;
                }
                field(Justification;Justification)
                {
                    ApplicationArea = Basic;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Function Name";"Function Name")
                {
                    ApplicationArea = Basic;
                }
                field("Budget Center Name";"Budget Center Name")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 3 Code";"Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 4 Code";"Shortcut Dimension 4 Code")
                {
                    ApplicationArea = Basic;
                }
                field(Dim3;Dim3)
                {
                    ApplicationArea = Basic;
                }
                field(Dim4;Dim4)
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field(TotalAmount;TotalAmount)
                {
                    ApplicationArea = Basic;
                }
                field("Issuing Store";"Issuing Store")
                {
                    ApplicationArea = Basic;
                }
                field("Store Requisition Type";"Store Requisition Type")
                {
                    ApplicationArea = Basic;
                }
                field("Issue Date";"Issue Date")
                {
                    ApplicationArea = Basic;
                }
                field(Committed;Committed)
                {
                    ApplicationArea = Basic;
                }
                field("SRN.No";"SRN.No")
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
                action("Post Store Requisition")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Store Requisition';
                    Image = Post;
                    Promoted = true;

                    trigger OnAction()
                    begin

                        if not LinesExists then
                           Error('There are no Lines created for this Document');

                           if Status=Status::Posted then
                              Error('The Document Has Already been Posted');

                           if Status<>Status::Released    then
                              Error('The Document Has not yet been Approved');



                            TestField("Issuing Store");
                            ReqLine.Reset;
                            ReqLine.SetRange(ReqLine."Requistion No","No.");
                            ReqLine.SetFilter(ReqLine."Quantity To Issue",'>%1',0);
                            TestField("Issuing Store");
                            if ReqLine.Find('-') then begin
                              if InventorySetup.Get then begin
                            //  ERROR('1');
                                     InventorySetup.TestField(InventorySetup."Item Issue Template");
                                     InventorySetup.TestField(InventorySetup."Item Issue Batch");
                                     GenJnline.Reset;
                                     GenJnline.SetRange(GenJnline."Journal Template Name",InventorySetup."Item Issue Template");
                                     GenJnline.SetRange(GenJnline."Journal Batch Name",InventorySetup."Item Issue Batch");
                                     if GenJnline.Find('-') then GenJnline.DeleteAll;
                                     end;
                            repeat
                            begin
                            //Issue
                                     LineNo:=LineNo+1000;

                                     GenJnline.Init;
                                     GenJnline."Journal Template Name":=InventorySetup."Item Issue Template";
                                     GenJnline."Journal Batch Name":=InventorySetup."Item Issue Batch";
                                     GenJnline."Line No.":=LineNo;
                                     GenJnline."Entry Type":=GenJnline."entry type"::"Negative Adjmt.";
                                     GenJnline."Document No.":="No.";
                                     GenJnline."Item No.":=ReqLine."No.";
                                     GenJnline.Validate("Item No.");
                                     GenJnline."Location Code":="Issuing Store";
                                     GenJnline.Validate("Location Code");
                                     GenJnline."Posting Date":="Request date";
                                     GenJnline.Description:=ReqLine.Description;
                                     //GenJnline.Quantity:=ReqLine.Quantity;
                                     GenJnline.Quantity:=ReqLine."Quantity To Issue";
                                     GenJnline."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
                                     GenJnline.Validate("Shortcut Dimension 1 Code");
                                     GenJnline."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
                                     GenJnline.Validate("Shortcut Dimension 2 Code");
                                     GenJnline.ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
                                     GenJnline.ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
                                     GenJnline.Validate(Quantity);
                                     GenJnline.Validate("Unit Amount");
                                     GenJnline."Reason Code":='221';
                                     GenJnline.Validate("Reason Code");
                                     GenJnline.Insert(true);

                        ReqLine."Quantity Issued":=ReqLine."Quantity Issued"+ReqLine."Quantity To Issue";
                        ReqLine."Quantity To Issue":=0;

                        if ReqLine."Quantity Issued"=ReqLine."Quantity Requested" then
                                     ReqLine."Request Status":=ReqLine."request status"::Closed;
                            ReqLine.Modify;
                                  end;
                           until ReqLine. Next=0;
                                    //Post Entries
                                    GenJnline.Reset;
                                    GenJnline.SetRange(GenJnline."Journal Template Name",InventorySetup."Item Issue Template");
                                 //
                                    GenJnline.SetRange(GenJnline."Journal Batch Name",InventorySetup."Item Issue Batch");
                                    Codeunit.Run(Codeunit::"Item Jnl.-Post",GenJnline);
                                    //End Post entries

                                  //Modify All

                                  Post:=JournlPosted.PostedSuccessfully();
                                  if Post then
                                        ReqLine.ModifyAll(ReqLine."Request Status",ReqLine."request status"::Closed);

                           end;

                            Post:=true;
                            ReqLine.Reset;
                            ReqLine.SetRange(ReqLine."Requistion No","No.");
                            if ReqLine.Find('-') then begin
                            repeat
                            begin
                              if ReqLine."Quantity Issued"<>ReqLine."Quantity Requested" then
                              if (Post = true) then
                                Post:=false;
                            end;
                            until ReqLine.Next=0;
                            end;
                           if Post=true then  begin
                           Status:=Status::Posted;
                           Modify;
                           end;
                           CurrPage.Update;
                    end;
                }
                separator(Action11)
                {
                }
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;

                    trigger OnAction()
                    begin
                        DocumentType:=Documenttype::Requisition;
                        ApprovalEntries.Setfilters(Database::"PROC-Store Requistion Header",DocumentType,"No.");
                        ApprovalEntries.Run;
                    end;
                }
                action(sendApproval)
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
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
                        if not LinesExists then
                           Error('There are no Lines created for this Document');

                          State:=State::Open;
                         if Status<>Status::"Pending Approval" then State:=State::"Pending Approval";
                         DocType:=Doctype::Requisition;
                         Clear(tableNo);
                         tableNo:=Database::"PROC-Store Requistion Header";
                         if ApprovalMgt.SendApproval(tableNo,Rec."No.",DocType,State,'',0) then;
                    end;
                }
                action(cancellsApproval)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;
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
                         DocType:=Doctype::Requisition;
                         showmessage:=true;
                         ManualCancel:=true;
                         Clear(tableNo);
                         tableNo:=Database::"PROC-Store Requistion Header";
                          if ApprovalMgt.CancelApproval(tableNo,DocType,Rec."No.",showmessage,ManualCancel) then;
                    end;
                }
                separator(Action7)
                {
                }
                action("Check Budget Availlabilty")
                {
                    ApplicationArea = Basic;
                    Caption = 'Check Budget Availlabilty';
                    Image = Check;
                    Promoted = true;

                    trigger OnAction()
                    begin
                        BCSetup.Get;
                        if not BCSetup.Mandatory then
                           exit;
                         if ("Issuing Store"<>'CENTRAL') and ("Issuing Store"<>'GENERAL') then Error('This function is only applicable to Central Stores')
                        ;
                        //IF Status=Status::Released THEN
                        //  ERROR('This document has already been released. This functionality is available for open documents only');
                        //IF NOT SomeLinesCommitted THEN BEGIN
                        //   IF NOT CONFIRM( 'Some or All the Lines Are already Committed do you want to continue',TRUE, "Document Type") THEN
                        //        ERROR('Budget Availability Check and Commitment Aborted');
                          DeleteCommitment.Reset;
                          DeleteCommitment.SetRange(DeleteCommitment."Document Type",DeleteCommitment."document type"::Requisition);
                          DeleteCommitment.SetRange(DeleteCommitment."Document No.","No.");
                          DeleteCommitment.DeleteAll;
                        //END;

                        //IF "Requisition Type"="Requisition Type"::Stationery THEN

                          // Commitment.CheckStaffClaim(Rec)
                           //ELSE
                          // ERROR('Please note that only Stationery Items are voted');

                           Committed:=true;
                           Modify;
                           Message('Budget Availability Checking Complete');
                    end;
                }
                separator(Action5)
                {
                }
                action("Cancel Budget Commitments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Budget Commitments';
                    Image = CancelLine;
                    Promoted = true;

                    trigger OnAction()
                    begin
                           TestField(Committed);
                           if not Confirm( 'Are you sure you want to Cancel All Commitments Done for this document',true) then
                                Error('Budget Availability Check and Commitment Aborted');

                          DeleteCommitment.Reset;
                          DeleteCommitment.SetRange(DeleteCommitment."Document Type",DeleteCommitment."document type"::Requisition);
                          DeleteCommitment.SetRange(DeleteCommitment."Document No.","No.");
                          DeleteCommitment.DeleteAll;
                          //Tag all the SRN entries as Uncommitted
                          Committed:=false;
                          Modify;
                        Message('Commitments Cancelled Successfully for Doc. No %1',"No.");
                    end;
                }
                separator(Action3)
                {
                }
                action("Print/Preview")
                {
                    ApplicationArea = Basic;
                    Caption = 'Print/Preview';
                    Image = PreviewChecks;
                    Promoted = true;

                    trigger OnAction()
                    begin
                        Reset;
                        SetFilter("No.","No.");
                        Report.Run(51271,true,true,Rec);
                        Reset;
                    end;
                }
                separator(Action1)
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
         SetFilter("User ID",UserId);
    end;

    var
        UserMgt: Codeunit "HMS Patient Treatment Mgt";
        ApprovalMgt: Codeunit "Export F/O Consolidation";
        ReqLine: Record UnknownRecord61724;
        InventorySetup: Record "Inventory Setup";
        GenJnline: Record "Item Journal Line";
        LineNo: Integer;
        Post: Boolean;
        JournlPosted: Codeunit PostCaferiaBatches;
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition;
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        FixedAsset: Record "Fixed Asset";
        MinorAssetsIssue: Record UnknownRecord61725;
        Commitment: Codeunit "Procurement Controls Handler";
        BCSetup: Record UnknownRecord61721;
        DeleteCommitment: Record UnknownRecord61722;
        Loc: Record Location;
        ApprovalEntries: Page "Approval Entries";


    procedure LinesExists(): Boolean
    var
        PayLines: Record UnknownRecord61724;
    begin
         HasLines:=false;
         PayLines.Reset;
         PayLines.SetRange(PayLines."Requistion No","No.");
          if PayLines.Find('-') then begin
             HasLines:=true;
             exit(HasLines);
          end;
    end;


    procedure UpdateControls()
    begin
        
            /* IF Status<>Status::Released THEN BEGIN
             CurrForm."Issue Date".EDITABLE:=FALSE;
             CurrForm.UPDATECONTROLS();
                 END ELSE BEGIN
             CurrForm."Issue Date".EDITABLE:=TRUE;
             CurrForm.UPDATECONTROLS();
             END;
                IF Status=Status::Open THEN BEGIN
             CurrForm."Global Dimension 1 Code".EDITABLE:=TRUE;
             CurrForm."Request date" .EDITABLE:=TRUE;
             CurrForm."Responsibility Center" .EDITABLE:=TRUE;
             CurrForm."Issuing Store" .EDITABLE:=TRUE;
             CurrForm."Request Description".EDITABLE:=TRUE;
             CurrForm."Shortcut Dimension 2 Code".EDITABLE:=TRUE;
             CurrForm."Request Description".EDITABLE:=TRUE;
             CurrForm."Shortcut Dimension 3 Code".EDITABLE:=TRUE;
             CurrForm."Shortcut Dimension 4 Code".EDITABLE:=TRUE;
             CurrForm."Required Date".EDITABLE:=TRUE;
             CurrForm.UPDATECONTROLS();
             END ELSE BEGIN
             CurrForm."Responsibility Center".EDITABLE:=FALSE;
             CurrForm."Global Dimension 1 Code".EDITABLE:=FALSE;
             CurrForm."Request Description".EDITABLE:=FALSE;
             CurrForm."Shortcut Dimension 2 Code".EDITABLE:=FALSE;
             CurrForm."Required Date".EDITABLE:=FALSE;
             CurrForm."Shortcut Dimension 3 Code".EDITABLE:=FALSE;
             CurrForm."Shortcut Dimension 4 Code".EDITABLE:=FALSE;
             CurrForm."Required Date".EDITABLE:=FALSE;
              CurrForm."Request date".EDITABLE:=FALSE;
             CurrForm.UPDATECONTROLS();
             END
             */

    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        UpdateControls();
    end;
}

