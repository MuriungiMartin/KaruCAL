#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7335 "Warehouse Shipment"
{
    Caption = 'Warehouse Shipment';
    PageType = Document;
    PopulateAllFields = true;
    RefreshOnActivate = true;
    SourceTable = "Warehouse Shipment Header";

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
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the warehouse shipment header that was created.';

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location from which the items are being shipped.';

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
                    ToolTip = 'Specifies the code of the zone on this shipment header.';
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates the bin code to place the items that are about to be shipped.';
                }
                field("Document Status";"Document Status")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the progress level of warehouse handling on lines in the warehouse shipment.';
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the status of the shipment and is filled in by the program.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a posting date. If you enter a date, the posting date of the source documents is updated during posting.';
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
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
                    ToolTip = 'Specifies the time that the document was assigned to the user.';
                }
                field("Sorting Method";"Sorting Method")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the method by which the shipments are sorted.';

                    trigger OnValidate()
                    begin
                        SortingMethodOnAfterValidate;
                    end;
                }
            }
            part(WhseShptLines;"Whse. Shipment Subform")
            {
                SubPageLink = "No."=field("No.");
                SubPageView = sorting("No.","Sorting Sequence No.");
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of an external document related to the warehouse shipment.';
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the shipment date of the warehouse shipment.';
                }
                field("Shipping Agent Code";"Shipping Agent Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the codes of the shipping agent being used for this warehouse shipment.';
                }
                field("Shipping Agent Service Code";"Shipping Agent Service Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code of the shipping agent service that applies to this warehouse shipment.';
                }
                field("Shipment Method Code";"Shipment Method Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the shipment method being used for this shipment.';
                }
            }
        }
        area(factboxes)
        {
            part(Control1901796907;"Item Warehouse FactBox")
            {
                Provider = WhseShptLines;
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
            group("&Shipment")
            {
                Caption = '&Shipment';
                Image = Shipment;
                action(List)
                {
                    ApplicationArea = Basic;
                    Caption = 'List';
                    Image = OpportunitiesList;
                    ShortCutKey = 'Shift+Ctrl+L';

                    trigger OnAction()
                    begin
                        LookupWhseShptHeader(Rec);
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Warehouse Comment Sheet";
                    RunPageLink = "Table Name"=const("Whse. Shipment"),
                                  Type=const(" "),
                                  "No."=field("No.");
                }
                action("Pick Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Pick Lines';
                    Image = PickLines;
                    RunObject = Page "Warehouse Activity Lines";
                    RunPageLink = "Whse. Document Type"=const(Shipment),
                                  "Whse. Document No."=field("No.");
                    RunPageView = sorting("Whse. Document No.","Whse. Document Type","Activity Type")
                                  where("Activity Type"=const(Pick));
                }
                action("Registered P&ick Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Registered P&ick Lines';
                    Image = RegisteredDocs;
                    RunObject = Page "Registered Whse. Act.-Lines";
                    RunPageLink = "Whse. Document No."=field("No.");
                    RunPageView = sorting("Whse. Document Type","Whse. Document No.","Whse. Document Line No.")
                                  where("Whse. Document Type"=const(Shipment));
                }
                action("Posted &Whse. Shipments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted &Whse. Shipments';
                    Image = PostedReceipt;
                    RunObject = Page "Posted Whse. Shipment List";
                    RunPageLink = "Whse. Shipment No."=field("No.");
                    RunPageView = sorting("Whse. Shipment No.");
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
                        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
                    begin
                        TestField(Status,Status::Open);
                        GetSourceDocOutbound.GetOutboundDocs(Rec);
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
                        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
                    begin
                        TestField(Status,Status::Open);
                        GetSourceDocOutbound.GetSingleOutboundDoc(Rec);
                    end;
                }
                separator(Action44)
                {
                }
                action("Re&lease")
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    var
                        ReleaseWhseShptDoc: Codeunit "Whse.-Shipment Release";
                    begin
                        CurrPage.Update(true);
                        if Status = Status::Open then
                          ReleaseWhseShptDoc.Release(Rec);
                    end;
                }
                action("Re&open")
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&open';
                    Image = ReOpen;

                    trigger OnAction()
                    var
                        ReleaseWhseShptDoc: Codeunit "Whse.-Shipment Release";
                    begin
                        ReleaseWhseShptDoc.Reopen(Rec);
                    end;
                }
                separator(Action17)
                {
                }
                action("Autofill Qty. to Ship")
                {
                    ApplicationArea = Basic;
                    Caption = 'Autofill Qty. to Ship';
                    Image = AutofillQtyToHandle;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        AutofillQtyToHandle;
                    end;
                }
                action("Delete Qty. to Ship")
                {
                    ApplicationArea = Basic;
                    Caption = 'Delete Qty. to Ship';
                    Image = DeleteQtyToHandle;

                    trigger OnAction()
                    begin
                        DeleteQtyToHandle;
                    end;
                }
                separator(Action51)
                {
                }
                action("Create Pick")
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Pick';
                    Ellipsis = true;
                    Image = CreateInventoryPickup;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CurrPage.Update(true);
                        CurrPage.WhseShptLines.Page.PickCreate;
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action("P&ost Shipment")
                {
                    ApplicationArea = Basic;
                    Caption = 'P&ost Shipment';
                    Ellipsis = true;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        PostShipmentYesNo;
                    end;
                }
                action("Post and &Print")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post and &Print';
                    Ellipsis = true;
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    begin
                        PostShipmentPrintYesNo;
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
                    WhseDocPrint.PrintShptHeader(Rec);
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

    local procedure AutofillQtyToHandle()
    begin
        CurrPage.WhseShptLines.Page.AutofillQtyToHandle;
    end;

    local procedure DeleteQtyToHandle()
    begin
        CurrPage.WhseShptLines.Page.DeleteQtyToHandle;
    end;

    local procedure PostShipmentYesNo()
    begin
        CurrPage.WhseShptLines.Page.PostShipmentYesNo;
    end;

    local procedure PostShipmentPrintYesNo()
    begin
        CurrPage.WhseShptLines.Page.PostShipmentPrintYesNo;
    end;

    local procedure SortingMethodOnAfterValidate()
    begin
        CurrPage.Update;
    end;
}

