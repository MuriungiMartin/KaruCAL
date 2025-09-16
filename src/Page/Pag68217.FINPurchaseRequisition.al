#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68217 "FIN-Purchase Requisition"
{
    ApplicationArea = Basic;
    CardPageID = "PROC-Internal Requisitions U";
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Purchase Header";
    SourceTableView = where("Document Type"=filter(Quote),
                            DocApprovalType=filter(Requisition),
                            Status=filter(<>Released));
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
                field("Pay-to Vendor No.";"Pay-to Vendor No.")
                {
                    ApplicationArea = Basic;
                }
                field("Pay-to Name";"Pay-to Name")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Description";"Posting Description")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
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
            action("Make &Order")
            {
                ApplicationArea = Basic;
                Caption = 'Make &Order';
                Image = MakeOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    ApprovalMgt: Codeunit "Export F/O Consolidation";
                begin
                    if LinesCommitted then
                       Error('All Lines should be committed');

                    if ApprovalMgt.PrePostApprovalCheck(SalesHeader,Rec) then
                      Codeunit.Run(Codeunit::"Purch.-Quote to Order (Yes/No)",Rec);
                end;
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Send A&pproval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Export F/O Consolidation";
                    begin
                        BCSetup.Get;
                         if  BCSetup.Mandatory then begin
                            if LinesCommitted then
                             Error('All Lines should be committed');
                        end;

                        if ApprovalMgt.SendPurchaseApprovalRequest(Rec) then;
                    end;
                }
                action("Cancel Approval Re&quest")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Re&quest';
                    Image = CancelledEntries;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Export F/O Consolidation";
                    begin
                        if ApprovalMgt.CancelPurchaseApprovalRequest(Rec,true,true) then;
                    end;
                }
                separator(Action1000000012)
                {
                }
                action("Check Budget Availability")
                {
                    ApplicationArea = Basic;
                    Caption = 'Check Budget Availability';
                    Image = CheckLedger;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        BCSetup: Record UnknownRecord61721;
                    begin

                        BCSetup.Get;
                        if not BCSetup.Mandatory then
                           exit;

                        if Status=Status::Released then
                          Error('This document has already been released. This functionality is available for open documents only');
                        if not SomeLinesCommitted then begin
                           if not Confirm( 'Some or All the Lines Are already Committed do you want to continue',true, "Document Type") then
                                Error('Budget Availability Check and Commitment Aborted');
                          DeleteCommitment.Reset;
                          DeleteCommitment.SetRange(DeleteCommitment."Document Type",DeleteCommitment."document type"::LPO);
                          DeleteCommitment.SetRange(DeleteCommitment."Document No.","No.");
                          DeleteCommitment.DeleteAll;
                        end;
                           Commitment.CheckPurchase(Rec);
                           Message('Budget Availability Checking Complete');
                    end;
                }
                action("Cancel Budget Commitment")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Budget Commitment';
                    Image = CancelledEntries;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                           if not Confirm( 'Are you sure you want to Cancel All Commitments Done for this document',true, "Document Type") then
                                Error('Budget Availability Check and Commitment Aborted');

                          DeleteCommitment.Reset;
                          DeleteCommitment.SetRange(DeleteCommitment."Document Type",DeleteCommitment."document type"::LPO);
                          DeleteCommitment.SetRange(DeleteCommitment."Document No.","No.");
                          DeleteCommitment.DeleteAll;
                          //Tag all the Purchase Line entries as Uncommitted
                          PurchLine.Reset;
                          PurchLine.SetRange(PurchLine."Document Type","Document Type");
                          PurchLine.SetRange(PurchLine."Document No.","No.");
                          if PurchLine.Find('-') then begin
                             repeat
                                PurchLine.Committed:=false;
                                PurchLine.Modify;
                             until PurchLine.Next=0;
                          end;

                        Message('Commitments Cancelled Successfully for Doc. No %1',"No.");
                    end;
                }
                separator(Action1000000009)
                {
                }
                action("Re&lease")
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    var
                        ReleasePurchDoc: Codeunit "Release Purchase Document";
                    begin
                        if LinesCommitted then
                           Error('All Lines should be committed');

                        ReleasePurchDoc.PerformManualRelease(Rec);
                    end;
                }
                action("Re&open")
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&open';
                    Image = ReOpen;

                    trigger OnAction()
                    var
                        ReleasePurchDoc: Codeunit "Release Purchase Document";
                    begin
                        if LinesCommitted then
                           Error('All Lines should be committed');

                        ReleasePurchDoc.PerformManualReopen(Rec);
                    end;
                }
                separator(Action1000000006)
                {
                }
            }
            action("&Print")
            {
                ApplicationArea = Basic;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    BCSetup.Get;
                    if BCSetup.Mandatory then
                     if LinesCommitted then
                       Error('All Lines should be committed');

                      Reset;
                      SetRange("No.","No.");
                      Report.Run(51505,true,true,Rec);
                      Reset;
                    //DocPrint.PrintPurchHeader(Rec);
                end;
            }
        }
    }

    var
        PurchSetup: Record "Purchases & Payables Setup";
        CopyPurchDoc: Report "Copy Purchase Document";
        DocPrint: Codeunit "Document-Print";
        UserMgt: Codeunit "HMS Patient Treatment Mgt";
        ArchiveManagement: Codeunit ArchiveManagement;
        PurchInfoPaneMgmt: Codeunit "Purchases Info-Pane Management";
        Commitment: Codeunit "Procurement Controls Handler";
        BCSetup: Record UnknownRecord61721;
        DeleteCommitment: Record UnknownRecord61722;
        PurchLine: Record "Purchase Line";
        [InDataSet]
        PurchHistoryBtnVisible: Boolean;
        [InDataSet]
        PayToCommentPictVisible: Boolean;
        [InDataSet]
        PayToCommentBtnVisible: Boolean;
        [InDataSet]
        PurchHistoryBtn1Visible: Boolean;
        [InDataSet]
        PurchLinesEditable: Boolean;
        Text19023272: label 'Buy-from Vendor';
        Text19005663: label 'Pay-to Vendor';

    local procedure ApproveCalcInvDisc()
    begin
        //CurrPage.PurchLines.PAGE.ApproveCalcInvDisc;
    end;

    local procedure UpdateInfoPanel()
    var
        DifferBuyFromPayTo: Boolean;
    begin
        DifferBuyFromPayTo := "Buy-from Vendor No." <> "Pay-to Vendor No.";
        PurchHistoryBtnVisible := DifferBuyFromPayTo;
        PayToCommentPictVisible := DifferBuyFromPayTo;
        PayToCommentBtnVisible := DifferBuyFromPayTo;
        PurchHistoryBtn1Visible := PurchInfoPaneMgmt.DocExist(Rec,"Buy-from Vendor No.");
        if DifferBuyFromPayTo then
          PurchHistoryBtnVisible := PurchInfoPaneMgmt.DocExist(Rec,"Pay-to Vendor No.")
    end;


    procedure LinesCommitted() Exists: Boolean
    var
        PurchLines: Record "Purchase Line";
    begin
         if BCSetup.Get() then  begin
            if not BCSetup.Mandatory then begin
               Exists:=false;
               exit;
            end;
         end else begin
               Exists:=false;
               exit;
         end;
        if BCSetup.Get then begin
         Exists:=false;
         PurchLines.Reset;
         PurchLines.SetRange(PurchLines."Document Type","Document Type");
         PurchLines.SetRange(PurchLines."Document No.","No.");
         PurchLines.SetRange(PurchLines.Committed,false);
          if PurchLines.Find('-') then
             Exists:=true;
        end else
            Exists:=false;
    end;


    procedure SomeLinesCommitted() Exists: Boolean
    var
        PurchLines: Record "Purchase Line";
    begin
        if BCSetup.Get then begin
         Exists:=false;
         PurchLines.Reset;
         PurchLines.SetRange(PurchLines."Document Type","Document Type");
         PurchLines.SetRange(PurchLines."Document No.","No.");
         PurchLines.SetRange(PurchLines.Committed,true);
          if PurchLines.Find('-') then
             Exists:=true;
        end else
            Exists:=false;
    end;


    procedure UpdateControls()
    begin
              if Status<>Status::Open then begin
                PurchLinesEditable :=false;
              end else
                PurchLinesEditable :=true;
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        //CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        //CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure CurrencyCodeOnAfterValidate()
    begin
        //CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;

        UpdateControls;
    end;
}

