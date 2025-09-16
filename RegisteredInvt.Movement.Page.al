#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7384 "Registered Invt. Movement"
{
    Caption = 'Registered Invt. Movement';
    Editable = false;
    PageType = Document;
    RefreshOnActivate = true;
    SaveValues = true;
    SourceTable = "Registered Invt. Movement Hdr.";

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
                    ToolTip = 'Specifies the number of the registered inventory movement.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the same as the field with the same name in the Registered Whse. Activity Hdr. table.';
                }
                field("Source Document";"Source Document")
                {
                    ApplicationArea = Basic;
                    OptionCaption = ' ,,,,,,,,,,,Prod. Consumption,,,,,,,,,Assembly Consumption';
                    ToolTip = 'Specifies the same as the field with the same name in the Registered Whse. Activity Hdr. table.';
                }
                field("Source No.";"Source No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the same as the field with the same name in the Registered Whse. Activity Hdr. table.';
                }
                field("Destination No.";"Destination No.")
                {
                    ApplicationArea = Basic;
                    CaptionClass = FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",0));
                    Editable = false;
                    ToolTip = 'Specifies the same as the field with the same name in the Registered Whse. Activity Hdr. table.';
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
                    ToolTip = 'Specifies the same as the field with the same name in the Registered Whse. Activity Hdr. table.';
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the same as the field with the same name in the Registered Whse. Activity Hdr. table.';
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic;
                    CaptionClass = FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",2));
                    ToolTip = 'Specifies the same as the field with the same name in the Registered Whse. Activity Hdr. table.';
                }
                field("External Document No.2";"External Document No.2")
                {
                    ApplicationArea = Basic;
                    CaptionClass = FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",3));
                    ToolTip = 'Specifies the same as the field with the same name in the Registered Whse. Activity Hdr. table.';
                }
            }
            part(WhseActivityLines;"Reg. Invt. Movement Subform")
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
            group("&Movement")
            {
                Caption = '&Movement';
                Image = CreateMovement;
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Warehouse Comment Sheet";
                    RunPageLink = "Table Name"=const("Registered Invt. Movement"),
                                  Type=const(" "),
                                  "No."=field("No.");
                }
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

