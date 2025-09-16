#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7337 "Posted Whse. Shipment"
{
    Caption = 'Posted Whse. Shipment';
    InsertAllowed = false;
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Posted Whse. Shipment Header";

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
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the posted warehouse shipment document header that was created.';
                }
                field("Whse. Shipment No.";"Whse. Shipment No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the warehouse shipment that the posted warehouse shipment originates from.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code of the location from which the items were shipped.';
                }
                field("Zone Code";"Zone Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code of the zone on this posted shipment header.';
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code of the bin on the posted warehouse shipment header.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the posting date of the posted warehouse shipment.';
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
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
            }
            part(WhseShptLines;"Posted Whse. Shipment Subform")
            {
                SubPageLink = "No."=field("No.");
                SubPageView = sorting("No.","Line No.");
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies an external document number. If you enter a value, the source document is updated with this number during posting.';
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the shipment date that was on the header of the warehouse shipment when it was posted.';
                }
                field("Shipping Agent Code";"Shipping Agent Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code of the shipping agent used for the warehouse shipment.';
                }
                field("Shipping Agent Service Code";"Shipping Agent Service Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code of the shipping agent service used for the warehouse shipment.';
                }
                field("Shipment Method Code";"Shipment Method Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code of the shipment method used for the warehouse shipment.';
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
                action(List)
                {
                    ApplicationArea = Basic;
                    Caption = 'List';
                    Image = OpportunitiesList;
                    ShortCutKey = 'Shift+Ctrl+L';

                    trigger OnAction()
                    begin
                        LookupPostedWhseShptHeader(Rec);
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Warehouse Comment Sheet";
                    RunPageLink = "Table Name"=const("Posted Whse. Shipment"),
                                  Type=const(" "),
                                  "No."=field("No.");
                }
            }
        }
        area(processing)
        {
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
                    WhseDocPrint.PrintPostedShptHeader(Rec);
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
}

