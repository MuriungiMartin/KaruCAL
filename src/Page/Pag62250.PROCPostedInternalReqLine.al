#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 62250 "PROC-Posted Internal Req. Line"
{
    ApplicationArea = Basic;
    Caption = 'Internal Requisition';
    CardPageID = "PROC-Posted Internal Reqs U";
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Purchase Header";
    SourceTableView = where("Document Type"=filter(Quote),
                            DocApprovalType=filter(Requisition),
                            Status=const(Released));
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field("Requested Receipt Date";"Requested Receipt Date")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Description";"Posting Description")
                {
                    ApplicationArea = Basic;
                }
                field("No. of Archived Versions";"No. of Archived Versions")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field("Procurement Type Code";"Procurement Type Code")
                {
                    ApplicationArea = Basic;
                }
                field("Order Date";"Order Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Quote")
            {
                Caption = '&Quote';
                Visible = false;
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    begin
                        CalcInvDiscForHeader;
                        Commit;
                        Page.RunModal(Page::"Purchase Statistics",Rec);
                    end;
                }
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Vendor Card";
                    RunPageLink = "No."=field("Buy-from Vendor No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Purch. Comment Sheet";
                    RunPageLink = "Document Type"=field("Document Type"),
                                  "No."=field("No."),
                                  "Document Line No."=const(0);
                }
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;

                    trigger OnAction()
                    begin
                        Rec.ShowDocDim;
                    end;
                }
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        ApprovalEntries.Setfilters(Database::"Purchase Header","Document Type","No.");
                        ApprovalEntries.Run;
                    end;
                }
            }
            group("&Line")
            {
                Caption = '&Line';
                Visible = false;
                group("Item Availability by")
                {
                    Caption = 'Item Availability by';
                    action(Period)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Period';

                        trigger OnAction()
                        begin
                            //CurrPage.PurchLines.PAGE.ItemAvailability(0);
                        end;
                    }
                    action(Variant)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Variant';

                        trigger OnAction()
                        begin
                            //CurrPage.PurchLines.PAGE.ItemAvailability(1);
                        end;
                    }
                    action(Location)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Location';

                        trigger OnAction()
                        begin
                            //CurrPage.PurchLines.PAGE.ItemAvailability(2);
                        end;
                    }
                }
                action(Action112)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        //CurrPage.PurchLines.PAGE.ShowDimensions;
                    end;
                }
                action("Item Charge &Assignment")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Charge &Assignment';

                    trigger OnAction()
                    begin
                        //CurrPage.PurchLines.PAGE.ItemChargeAssgnt;
                    end;
                }
                action("Item &Tracking Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction()
                    begin
                        //CurrPage.PurchLines.PAGE.OpenItemTrackingLines;
                    end;
                }
            }
        }
        area(processing)
        {
            action("Make &Order")
            {
                ApplicationArea = Basic;
                Caption = 'Make &Order';
                Image = MakeOrder;
                Promoted = true;
                PromotedCategory = Process;
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
                Visible = false;
                action("Calculate &Invoice Discount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Calculate &Invoice Discount';
                    Image = CalculateInvoiceDiscount;

                    trigger OnAction()
                    begin
                        ApproveCalcInvDisc;
                    end;
                }
                separator(Action144)
                {
                }
                action("E&xplode BOM")
                {
                    ApplicationArea = Basic;
                    Caption = 'E&xplode BOM';
                    Image = ExplodeBOM;

                    trigger OnAction()
                    begin
                        //CurrPage.PurchLines.PAGE.ExplodeBOM;
                    end;
                }
                action("Insert &Ext. Texts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Insert &Ext. Texts';

                    trigger OnAction()
                    begin
                        //CurrPage.PurchLines.PAGE.InsertExtendedText(TRUE);
                    end;
                }
                separator(Action145)
                {
                }
                action("Get St&d. Vend. Purchase Codes")
                {
                    ApplicationArea = Basic;
                    Caption = 'Get St&d. Vend. Purchase Codes';
                    Ellipsis = true;

                    trigger OnAction()
                    var
                        StdVendPurchCode: Record "Standard Vendor Purchase Code";
                    begin
                        StdVendPurchCode.InsertPurchLines(Rec);
                    end;
                }
                separator(Action146)
                {
                }
                action("Copy Document")
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy Document';
                    Ellipsis = true;
                    Image = CopyDocument;

                    trigger OnAction()
                    begin
                        CopyPurchDoc.SetPurchHeader(Rec);
                        CopyPurchDoc.RunModal;
                        Clear(CopyPurchDoc);
                    end;
                }
                action("Archi&ve Document")
                {
                    ApplicationArea = Basic;
                    Caption = 'Archi&ve Document';

                    trigger OnAction()
                    begin
                        ArchiveManagement.ArchivePurchDocument(Rec);
                        CurrPage.Update(false);
                    end;
                }
                separator(Action147)
                {
                }
                action("Send A&pproval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Export F/O Consolidation";
                    begin
                        if LinesCommitted then
                           Error('All Lines should be committed');

                        if ApprovalMgt.SendPurchaseApprovalRequest(Rec) then;
                    end;
                }
                action("Cancel Approval Re&quest")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Re&quest';

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Export F/O Consolidation";
                    begin
                        if ApprovalMgt.CancelPurchaseApprovalRequest(Rec,true,true) then;
                    end;
                }
                separator(Action148)
                {
                }
                action("Check Budget Availability")
                {
                    ApplicationArea = Basic;
                    Caption = 'Check Budget Availability';

                    trigger OnAction()
                    begin
                        if Status=Status::Released then
                          Error('This document has already been released. This functionality is available for open documents only');
                        if not LinesCommitted then begin
                           if not Confirm( 'Some or All the Lines Are already Committed do you want to continue',true, "Document Type") then
                                Error('Budget Availability Check and Commitment Aborted');
                          DeleteCommitment.Reset;
                          DeleteCommitment.SetRange(DeleteCommitment."Document Type",DeleteCommitment."document type"::Requisition);
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

                    trigger OnAction()
                    begin
                           if not Confirm( 'Are you sure you want to Cancel All Commitments Done for this document',true, "Document Type") then
                                Error('Budget Availability Check and Commitment Aborted');

                          DeleteCommitment.Reset;
                          DeleteCommitment.SetRange(DeleteCommitment."Document Type",DeleteCommitment."document type"::Requisition);
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
                separator(Action1102755004)
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
                separator(Action610)
                {
                }
                action("&Send BizTalk Rqst. for Purch. Quote")
                {
                    ApplicationArea = Basic;
                    Caption = '&Send BizTalk Rqst. for Purch. Quote';

                    trigger OnAction()
                    var
                        SalesHeader: Record "Sales Header";
                        ApprovalMgt: Codeunit "Export F/O Consolidation";
                    begin
                        if ApprovalMgt.PrePostApprovalCheck(SalesHeader,Rec) then
;
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

                trigger OnAction()
                begin
                    //IF LinesCommitted THEN
                      // ERROR('All Lines should be committed');

                      //RESET;
                     // SETRANGE("No.","No.");
                      //REPORT.RUN(39005703,TRUE,TRUE,Rec);
                      //RESET;

                    DocPrint.PrintPurchHeader(Rec);
                end;
            }
            action(PurchHistoryBtn)
            {
                ApplicationArea = Basic;
                Caption = 'Purchase H&istory';
                Promoted = true;
                PromotedCategory = Process;
                Visible = PurchHistoryBtnVisible;

                trigger OnAction()
                begin
                    //PurchInfoPaneMgmt.LookupVendPurchaseHistory(Rec,"Pay-to Vendor No.",TRUE);
                end;
            }
            action("&Contacts")
            {
                ApplicationArea = Basic;
                Caption = '&Contacts';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    PurchInfoPaneMgmt.LookupContacts(Rec);
                end;
            }
            action("Order &Addresses")
            {
                ApplicationArea = Basic;
                Caption = 'Order &Addresses';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    PurchInfoPaneMgmt.LookupOrderAddr(Rec);
                end;
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SaveRecord;
        exit(ConfirmDeletion);
    end;

    trigger OnInit()
    begin
        PurchHistoryBtn1Visible := true;
        PayToCommentBtnVisible := true;
        PayToCommentPictVisible := true;
        PurchHistoryBtnVisible := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Responsibility Center" := UserMgt.GetPurchasesFilter();
        DocApprovalType:=Docapprovaltype::Requisition;
        "Assigned User ID":=UserId;
    end;

    trigger OnOpenPage()
    begin
        if UserMgt.GetPurchasesFilter() <> '' then begin
          FilterGroup(2);
          SetRange("Responsibility Center",UserMgt.GetPurchasesFilter());
          FilterGroup(0);
        end;
    end;

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
        Text19023272: label 'Buy-from Vendor';
        Text19005663: label 'Pay-to Vendor';
        ChangeExchangeRate: Page "Change Exchange Rate";

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
}

