#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7392 "Posted Invt. Pick"
{
    Caption = 'Posted Invt. Pick';
    Editable = false;
    PageType = Document;
    RefreshOnActivate = true;
    SaveValues = true;
    SourceTable = "Posted Invt. Pick Header";

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
                    ToolTip = 'Specifies the posted inventory pick number.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location code for where the posted inventory pick occurred.';
                }
                field("Source No.";"Source No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the posted source document that the inventory pick is based upon.';
                }
                field("Destination No.";"Destination No.")
                {
                    ApplicationArea = Basic;
                    CaptionClass = FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",0));
                    Editable = false;
                    ToolTip = 'Specifies the number or the code of the customer, vendor, location, item, family, or sales order linked to the posted inventory pick.';
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
                    ToolTip = 'Specifies the posting date from the inventory pick.';
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date on which the items on the posted inventory pick were expected to be shipped.';
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic;
                    CaptionClass = FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",2));
                    ToolTip = 'Specifies the external document number from the source document associated with the posted inventory pick.';
                }
                field("External Document No.2";"External Document No.2")
                {
                    ApplicationArea = Basic;
                    CaptionClass = FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",3));
                    ToolTip = 'Specifies a second external document number to be used for reference.';
                }
            }
            part(WhseActivityLines;"Posted Invt. Pick Subform")
            {
                SubPageLink = "No."=field("No.");
                SubPageView = sorting("No.","Sorting Sequence No.");
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
            group("P&ick")
            {
                Caption = 'P&ick';
                Image = CreateInventoryPickup;
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Warehouse Comment Sheet";
                    RunPageLink = "Table Name"=const("Posted Invt. Pick"),
                                  Type=const(" "),
                                  "No."=field("No.");
                }
            }
        }
        area(processing)
        {
            action("&Navigate")
            {
                ApplicationArea = Basic;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Navigate;
                end;
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.Update;
    end;

    var
        WMSMgt: Codeunit "WMS Management";
}

