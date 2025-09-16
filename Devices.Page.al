#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9813 Devices
{
    ApplicationArea = Basic;
    Caption = 'Devices';
    CardPageID = "Device Card";
    DelayedInsert = true;
    PageType = List;
    SourceTable = Device;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("MAC Address";"MAC Address")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the MAC Address for the device. MAC is an acronym for Media Access Control. A MAC Address is a unique identifier that is assigned to network interfaces for communications.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a name for the device.';
                }
                field("Device Type";"Device Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the device type.';
                }
                field(Enabled;Enabled)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether the device is enabled.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control8;Notes)
            {
            }
            systempart(Control9;Links)
            {
            }
        }
    }

    actions
    {
    }
}

