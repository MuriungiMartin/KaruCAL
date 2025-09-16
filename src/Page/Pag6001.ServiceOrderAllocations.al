#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6001 "Service Order Allocations"
{
    Caption = 'Service Order Allocations';
    DataCaptionFields = "Document Type","Document No.";
    Editable = false;
    PageType = List;
    SourceTable = "Service Order Allocation";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of the document (Order or Quote) from which the allocation entry was created.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service order associated with this entry.';
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the status of the entry, such as active, non-active, or canceled.';
                }
                field("Service Item Line No.";"Service Item Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service item line linked to this entry.';
                }
                field("Service Item No.";"Service Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service item.';
                    Visible = false;
                }
                field("Allocation Date";"Allocation Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the resource allocation should start.';
                }
                field("Resource No.";"Resource No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the resource allocated to the service task in this entry.';
                }
                field("Resource Group No.";"Resource Group No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the resource group allocated to the service task in this entry.';
                    Visible = false;
                }
                field("Allocated Hours";"Allocated Hours")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the hours allocated to the resource or resource group for the service task in this entry.';
                }
                field("Starting Time";"Starting Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the time when you want the allocation to start.';
                }
                field("Finishing Time";"Finishing Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the time when you want the allocation to finish.';
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the reason code for the service order allocation entry.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description for the service order allocation.';
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number assigned to this entry.';
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
}

