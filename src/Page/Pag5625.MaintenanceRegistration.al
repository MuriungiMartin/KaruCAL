#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5625 "Maintenance Registration"
{
    AutoSplitKey = true;
    Caption = 'Maintenance Registration';
    DataCaptionFields = "FA No.";
    PageType = List;
    SourceTable = "Maintenance Registration";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("FA No.";"FA No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the fixed asset number of the maintenance entry.';
                    Visible = false;
                }
                field("Service Date";"Service Date")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the date when the fixed asset is being serviced.';
                }
                field("Maintenance Vendor No.";"Maintenance Vendor No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the number of the vendor who services the fixed asset for this entry.';
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a comment for the service, repairs or maintenance to be performed on the fixed asset.';
                }
                field("Service Agent Name";"Service Agent Name")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the name of the service agent who is servicing the fixed asset.';
                }
                field("Service Agent Phone No.";"Service Agent Phone No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the phone number of the service agent who is servicing the fixed asset.';
                }
                field("Service Agent Mobile Phone";"Service Agent Mobile Phone")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the mobile phone number of the service agent who is servicing the fixed asset.';
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
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        FixedAsset: Record "Fixed Asset";
    begin
        FixedAsset.Get("FA No.");
        "Maintenance Vendor No." := FixedAsset."Maintenance Vendor No.";
    end;
}

