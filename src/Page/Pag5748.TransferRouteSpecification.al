#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5748 "Transfer Route Specification"
{
    Caption = 'Trans. Route Spec.';
    PageType = Card;
    SourceTable = "Transfer Route";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("In-Transit Code";"In-Transit Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location set up to be used as an in-transit location.';
                }
                field("Shipping Agent Code";"Shipping Agent Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the shipping agent who you usually use for this transfer route.';
                }
                field("Shipping Agent Service Code";"Shipping Agent Service Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the shipping agent service you usually use for this transfer route.';
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
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnClosePage()
    begin
        if Get("Transfer-from Code","Transfer-to Code") then begin
          if ("Shipping Agent Code" = '') and
             ("Shipping Agent Service Code" = '') and
             ("In-Transit Code" = '')
          then
            Delete;
        end;
    end;

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

