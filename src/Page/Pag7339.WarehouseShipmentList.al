#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7339 "Warehouse Shipment List"
{
    ApplicationArea = Basic;
    Caption = 'Warehouse Shipment List';
    CardPageID = "Warehouse Shipment";
    DataCaptionFields = "No.";
    Editable = false;
    PageType = List;
    SourceTable = "Warehouse Shipment Header";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the warehouse shipment header that was created.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location from which the items are being shipped.';
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                }
                field("Sorting Method";"Sorting Method")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the method by which the shipments are sorted.';
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the status of the shipment and is filled in by the program.';
                }
                field("Zone Code";"Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the zone on this shipment header.';
                    Visible = false;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates the bin code to place the items that are about to be shipped.';
                    Visible = false;
                }
                field("Document Status";"Document Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the progress level of warehouse handling on lines in the warehouse shipment.';
                    Visible = false;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a posting date. If you enter a date, the posting date of the source documents is updated during posting.';
                    Visible = false;
                }
                field("Assignment Date";"Assignment Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date on which the document was assigned to the user.';
                    Visible = false;
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shipment date of the warehouse shipment.';
                    Visible = false;
                }
                field("Shipping Agent Code";"Shipping Agent Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the codes of the shipping agent being used for this warehouse shipment.';
                    Visible = false;
                }
                field("Shipping Agent Service Code";"Shipping Agent Service Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the shipping agent service that applies to this warehouse shipment.';
                    Visible = false;
                }
                field("Shipment Method Code";"Shipment Method Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the shipment method being used for this shipment.';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
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
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        Page.Run(Page::"Warehouse Shipment",Rec);
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
                action("Re&lease")
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
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
}

