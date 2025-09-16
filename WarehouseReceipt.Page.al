#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5768 "Warehouse Receipt"
{
    Caption = 'Warehouse Receipt';
    PageType = Document;
    PopulateAllFields = true;
    RefreshOnActivate = true;
    SourceTable = "Warehouse Receipt Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the warehouse receipt header number, which is generated according to the No. Series specified in the Warehouse Mgt. Setup window.';

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location in which the items are being received.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        CurrPage.SaveRecord;
                        LookupLocation(Rec);
                        CurrPage.Update(true);
                    end;
                }
                field("Zone Code";"Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the zone in which the items are being received if you are using directed put-away and pick.';
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates the code of the bin in which you will place the items being received.';
                }
                field("Document Status";"Document Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the status of the warehouse receipt.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the posting date of the warehouse receipt.';
                }
                field("Vendor Shipment No.";"Vendor Shipment No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the vendor shipment number.';
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                }
                field("Assignment Date";"Assignment Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the date on which the document was assigned to the user.';
                }
                field("Assignment Time";"Assignment Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the time at which the document was assigned to the user.';
                }
                field("Sorting Method";"Sorting Method")
                {
                    ApplicationArea = Basic;
                    OptionCaption = ' ,Item,Document,Shelf or Bin,Due Date ';
                    ToolTip = 'Specifies the method by which the receipts are sorted.';

                    trigger OnValidate()
                    begin
                        SortingMethodOnAfterValidate;
                    end;
                }
            }
            part(WhseReceiptLines;"Whse. Receipt Subform")
            {
                SubPageLink = "No."=field("No.");
                SubPageView = sorting("No.","Sorting Sequence No.");
            }
        }
        area(factboxes)
        {
            part(Control1901796907;"Item Warehouse FactBox")
            {
                Provider = WhseReceiptLines;
                SubPageLink = "No."=field("Item No.");
                Visible = true;
            }
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Receipt")
            {
                Caption = '&Receipt';
                Image = Receipt;
                action(List)
                {
                    ApplicationArea = Basic;
                    Caption = 'List';
                    Image = OpportunitiesList;
                    ShortCutKey = 'Shift+Ctrl+L';

                    trigger OnAction()
                    begin
                        LookupWhseRcptHeader(Rec);
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Warehouse Comment Sheet";
                    RunPageLink = "Table Name"=const("Whse. Receipt"),
                                  Type=const(" "),
                                  "No."=field("No.");
                }
                action("Posted &Whse. Receipts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted &Whse. Receipts';
                    Image = PostedReceipts;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Posted Whse. Receipt List";
                    RunPageLink = "Whse. Receipt No."=field("No.");
                    RunPageView = sorting("Whse. Receipt No.");
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Use Filters to Get Src. Docs.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Use Filters to Get Src. Docs.';
                    Ellipsis = true;
                    Image = UseFilters;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
                    begin
                        GetSourceDocInbound.GetInboundDocs(Rec);
                        "Document Status" := GetHeaderStatus(0);
                        Modify;
                    end;
                }
                action("Get Source Documents")
                {
                    ApplicationArea = Basic;
                    Caption = 'Get Source Documents';
                    Ellipsis = true;
                    Image = GetSourceDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+F11';

                    trigger OnAction()
                    var
                        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
                    begin
                        GetSourceDocInbound.GetSingleInboundDoc(Rec);
                        "Document Status" := GetHeaderStatus(0);
                        Modify;
                    end;
                }
                separator(Action24)
                {
                    Caption = '';
                }
                action("Autofill Qty. to Receive")
                {
                    ApplicationArea = Basic;
                    Caption = 'Autofill Qty. to Receive';
                    Image = AutofillQtyToHandle;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        AutofillQtyToReceive;
                    end;
                }
                action("Delete Qty. to Receive")
                {
                    ApplicationArea = Basic;
                    Caption = 'Delete Qty. to Receive';
                    Image = DeleteQtyToHandle;

                    trigger OnAction()
                    begin
                        DeleteQtyToReceive;
                    end;
                }
                separator(Action40)
                {
                }
                action(CalculateCrossDock)
                {
                    ApplicationArea = Basic;
                    Caption = 'Calculate Cross-Dock';
                    Image = CalculateCrossDock;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        CrossDockOpp: Record "Whse. Cross-Dock Opportunity";
                        CrossDockMgt: Codeunit "Whse. Cross-Dock Management";
                    begin
                        CrossDockMgt.CalculateCrossDockLines(CrossDockOpp,'',"No.","Location Code");
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action("Post Receipt")
                {
                    ApplicationArea = Basic;
                    Caption = 'P&ost Receipt';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        WhsePostRcptYesNo;
                    end;
                }
                action("Post and &Print")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    begin
                        WhsePostRcptPrintPostedRcpt;
                    end;
                }
                action("Post and Print P&ut-away")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post and Print P&ut-away';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+Ctrl+F9';

                    trigger OnAction()
                    begin
                        WhsePostRcptPrint;
                    end;
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
                    WhseDocPrint.PrintRcptHeader(Rec);
                end;
            }
        }
    }

    trigger OnFindRecord(Which: Text): Boolean
    begin
        exit(FindFirstAllowedRec(Which));
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        exit(FindNextAllowedRec(Steps));
    end;

    trigger OnOpenPage()
    begin
        ErrorIfUserIsNotWhseEmployee;
    end;

    var
        WhseDocPrint: Codeunit "Warehouse Document-Print";

    local procedure AutofillQtyToReceive()
    begin
        CurrPage.WhseReceiptLines.Page.AutofillQtyToReceive;
    end;

    local procedure DeleteQtyToReceive()
    begin
        CurrPage.WhseReceiptLines.Page.DeleteQtyToReceive;
    end;

    local procedure WhsePostRcptYesNo()
    begin
        CurrPage.WhseReceiptLines.Page.WhsePostRcptYesNo;
    end;

    local procedure WhsePostRcptPrint()
    begin
        CurrPage.WhseReceiptLines.Page.WhsePostRcptPrint;
    end;

    local procedure WhsePostRcptPrintPostedRcpt()
    begin
        CurrPage.WhseReceiptLines.Page.WhsePostRcptPrintPostedRcpt;
    end;

    local procedure SortingMethodOnAfterValidate()
    begin
        CurrPage.Update;
    end;
}

