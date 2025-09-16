#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6015 "Resource Locations"
{
    Caption = 'Resource Locations';
    DataCaptionFields = "Location Code","Location Name";
    DelayedInsert = true;
    PageType = List;
    PopulateAllFields = true;
    SourceTable = "Resource Location";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Resource No.";"Resource No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the resource in the location.';
                    Visible = false;
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the resource becomes available in this location.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location code of the resource.';
                }
                field("Resource Name";"Resource Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the resource.';
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
}

