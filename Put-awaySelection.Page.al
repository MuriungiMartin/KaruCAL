#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7334 "Put-away Selection"
{
    Caption = 'Put-away Selection';
    Editable = false;
    PageType = List;
    SourceTable = "Whse. Put-away Request";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of document that created the warehouse put-away request.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the warehouse document that should be put away.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location in which the request is occurring.';
                }
                field("Zone Code";"Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the zone code where the bin on the request is located.';
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the bin on the put-away request.';
                }
                field("Completely Put Away";"Completely Put Away")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that all the items on the warehouse source document have been put away.';
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
                Visible = false;
            }
        }
    }

    actions
    {
    }


    procedure GetResult(var WhsePutAwayRqst: Record "Whse. Put-away Request")
    begin
        CurrPage.SetSelectionFilter(WhsePutAwayRqst);
    end;
}

