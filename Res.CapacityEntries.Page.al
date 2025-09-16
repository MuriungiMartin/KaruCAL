#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 224 "Res. Capacity Entries"
{
    ApplicationArea = Basic;
    Caption = 'Res. Capacity Entries';
    DataCaptionFields = "Resource No.","Resource Group No.";
    Editable = false;
    PageType = List;
    SourceTable = "Res. Capacity Entry";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date for which the capacity entry is valid.';
                }
                field("Resource No.";"Resource No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the corresponding resource.';
                }
                field("Resource Group No.";"Resource Group No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the corresponding resource group assigned to the resource.';
                }
                field(Capacity;Capacity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the capacity that is calculated and recorded. The capacity is in the unit of measure.';
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number given to the entry.';
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

