#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 10013 "Vendor Locations"
{
    Caption = 'Vendor Locations';
    DataCaptionFields = "Vendor No.";
    PageType = List;
    SourceTable = UnknownTable10013;

    layout
    {
        area(content)
        {
            repeater(Control1480000)
            {
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location code of the location for which this record is valid.';
                }
                field("Business Presence";"Business Presence")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the alternative tax area code to use when the vendor does not have a Business Presence at the location.';
                }
                field("Alt. Tax Area Code";"Alt. Tax Area Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the alternative tax area code to use when the vendor does not have a Business Presence at the location.';
                }
            }
        }
    }

    actions
    {
    }
}

