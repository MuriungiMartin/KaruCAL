#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7330 "Posted Whse. Receipt"
{
    Caption = 'Posted Whse. Receipt';
    InsertAllowed = false;
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Posted Whse. Receipt Header";

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
                    ToolTip = 'Specifies the number of the posted warehouse receipt.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code of the location where the items were received.';
                }
                field("Zone Code";"Zone Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code of the zone on this posted receipt header.';
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code of the bin on the posted receipt header.';
                }
                field("Document Status";"Document Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the status of the posted warehouse receipt.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the posting date of the receipt.';
                }
                field("Vendor Shipment No.";"Vendor Shipment No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the vendor shipment no. of the posted warehouse receipt.';
                }
                field("Whse. Receipt No.";"Whse. Receipt No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the number of the warehouse receipt that the posted warehouse receipt concerns.';
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                }
                field("Assignment Date";"Assignment Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the date on which the receipt was assigned to the user.';
                }
                field("Assignment Time";"Assignment Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the time that the document was assigned to the user.';
                }
            }
            part(PostedWhseRcptLines;"Posted Whse. Receipt Subform")
            {
                SubPageLink = "No."=field("No.");
                SubPageView = sorting("No.","Line No.");
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
                        LookupPostedWhseRcptHeader(Rec);
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Warehouse Comment Sheet";
                    RunPageLink = "Table Name"=const("Posted Whse. Receipt"),
                                  Type=const(" "),
                                  "No."=field("No.");
                }
                action("Put-away Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Put-away Lines';
                    Image = PutawayLines;
                    RunObject = Page "Warehouse Activity Lines";
                    RunPageLink = "Whse. Document Type"=const(Receipt),
                                  "Whse. Document No."=field("No.");
                    RunPageView = sorting("Whse. Document No.","Whse. Document Type","Activity Type")
                                  where("Activity Type"=const("Put-away"));
                }
                action("Registered Put-away Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Registered Put-away Lines';
                    Image = RegisteredDocs;
                    RunObject = Page "Registered Whse. Act.-Lines";
                    RunPageLink = "Whse. Document Type"=const(Receipt),
                                  "Whse. Document No."=field("No.");
                    RunPageView = sorting("Whse. Document Type","Whse. Document No.","Whse. Document Line No.")
                                  where("Activity Type"=const("Put-away"));
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Create Put-away")
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Put-away';
                    Ellipsis = true;
                    Image = CreatePutAway;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        CurrPage.Update(true);
                        CurrPage.PostedWhseRcptLines.Page.PutAwayCreate;
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
                    WhseDocPrint.PrintPostedRcptHeader(Rec);
                end;
            }
        }
        area(reporting)
        {
            action("Put-away List")
            {
                ApplicationArea = Basic;
                Caption = 'Put-away List';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Put-away List";
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

