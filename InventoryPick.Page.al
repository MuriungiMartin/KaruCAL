#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7377 "Inventory Pick"
{
    Caption = 'Inventory Pick';
    PageType = Document;
    RefreshOnActivate = true;
    SaveValues = true;
    SourceTable = "Warehouse Activity Header";
    SourceTableView = where(Type=const("Invt. Pick"));

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
                    ToolTip = 'Specifies the number of the warehouse header.';

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the location where the warehouse activity takes place.';
                }
                field(Control15;"Source Document")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    Lookup = false;
                    ToolTip = 'Specifies the type of document to which the line relates, including sales order, purchase order, or transfer order.';
                }
                field("Source No.";"Source No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the source document from which the activity originated.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Codeunit.Run(Codeunit::"Create Inventory Pick/Movement",Rec);
                        CurrPage.Update;
                        CurrPage.WhseActivityLines.Page.UpdateForm;
                    end;

                    trigger OnValidate()
                    begin
                        SourceNoOnAfterValidate;
                    end;
                }
                field("Destination No.";"Destination No.")
                {
                    ApplicationArea = Basic;
                    CaptionClass = FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",0));
                    Editable = false;
                    ToolTip = 'Specifies the number or the code of the customer or vendor that the line is linked to.';
                }
                field("WMSMgt.GetDestinationName(""Destination Type"",""Destination No."")";WMSMgt.GetDestinationName("Destination Type","Destination No."))
                {
                    ApplicationArea = Basic;
                    CaptionClass = FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",1));
                    Caption = 'Name';
                    Editable = false;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the warehouse activity should be recorded as being posted.';
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the date on which the items are expected to be shipped.';
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic;
                    CaptionClass = FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",2));
                    ToolTip = 'Specifies the external document number for the source document to which the warehouse activity is related.';
                }
                field("External Document No.2";"External Document No.2")
                {
                    ApplicationArea = Basic;
                    CaptionClass = FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",3));
                    ToolTip = 'Specifies an additional external document number for the inventory put-away or inventory pick.';
                }
            }
            part(WhseActivityLines;"Invt. Pick Subform")
            {
                SubPageLink = "Activity Type"=field(Type),
                              "No."=field("No.");
                SubPageView = sorting("Activity Type","No.","Sorting Sequence No.")
                              where(Breakbulk=const(false));
            }
        }
        area(factboxes)
        {
            part(Control4;"Lot Numbers by Bin FactBox")
            {
                Provider = WhseActivityLines;
                SubPageLink = "Item No."=field("Item No."),
                              "Variant Code"=field("Variant Code"),
                              "Location Code"=field("Location Code");
                Visible = false;
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
            group("P&ick")
            {
                Caption = 'P&ick';
                Image = CreateInventoryPickup;
                action(List)
                {
                    ApplicationArea = Basic;
                    Caption = 'List';
                    Image = OpportunitiesList;
                    ShortCutKey = 'Shift+Ctrl+L';

                    trigger OnAction()
                    begin
                        LookupActivityHeader("Location Code",Rec);
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Warehouse Comment Sheet";
                    RunPageLink = "Table Name"=const("Whse. Activity Header"),
                                  Type=field(Type),
                                  "No."=field("No.");
                }
                action("Posted Picks")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Picks';
                    Image = PostedInventoryPick;
                    RunObject = Page "Posted Invt. Pick List";
                    RunPageLink = "Invt Pick No."=field("No.");
                    RunPageView = sorting("Invt Pick No.");
                }
                action("Source Document")
                {
                    ApplicationArea = Basic;
                    Caption = 'Source Document';
                    Image = "Order";

                    trigger OnAction()
                    var
                        WMSMgt: Codeunit "WMS Management";
                    begin
                        WMSMgt.ShowSourceDocCard("Source Type","Source Subtype","Source No.");
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("&Get Source Document")
                {
                    ApplicationArea = Basic;
                    Caption = '&Get Source Document';
                    Ellipsis = true;
                    Image = GetSourceDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+F7';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Create Inventory Pick/Movement",Rec);
                    end;
                }
                action(AutofillQtyToHandle)
                {
                    ApplicationArea = Basic;
                    Caption = 'Autofill Qty. to Handle';
                    Image = AutofillQtyToHandle;

                    trigger OnAction()
                    begin
                        AutofillQtyToHandle;
                    end;
                }
                action("Delete Qty. to Handle")
                {
                    ApplicationArea = Basic;
                    Caption = 'Delete Qty. to Handle';
                    Image = DeleteQtyToHandle;

                    trigger OnAction()
                    begin
                        DeleteQtyToHandle;
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action("P&ost")
                {
                    ApplicationArea = Basic;
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        PostPickYesNo;
                    end;
                }
                action(PostAndPrint)
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
                        PostAndPrint;
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
                    WhseActPrint.PrintInvtPickHeader(Rec,false);
                end;
            }
        }
        area(reporting)
        {
            action("Picking List")
            {
                ApplicationArea = Basic;
                Caption = 'Picking List';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Picking List";
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.Update;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        exit(FindFirstAllowedRec(Which));
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Location Code" := GetUserLocation;
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
        WhseActPrint: Codeunit "Warehouse Document-Print";
        WMSMgt: Codeunit "WMS Management";

    local procedure AutofillQtyToHandle()
    begin
        CurrPage.WhseActivityLines.Page.AutofillQtyToHandle;
    end;

    local procedure DeleteQtyToHandle()
    begin
        CurrPage.WhseActivityLines.Page.DeleteQtyToHandle;
    end;

    local procedure PostPickYesNo()
    begin
        CurrPage.WhseActivityLines.Page.PostPickYesNo;
    end;

    local procedure PostAndPrint()
    begin
        CurrPage.WhseActivityLines.Page.PostAndPrint;
    end;

    local procedure SourceNoOnAfterValidate()
    begin
        CurrPage.Update;
        CurrPage.WhseActivityLines.Page.UpdateForm;
    end;
}

