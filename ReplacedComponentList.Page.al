#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5987 "Replaced Component List"
{
    AutoSplitKey = true;
    Caption = 'Replaced Component List';
    DataCaptionFields = "Parent Service Item No.","Line No.";
    Editable = false;
    PageType = List;
    SourceTable = "Service Item Component";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Active;Active)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the component is in use.';
                }
                field("Parent Service Item No.";"Parent Service Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service item in which the component is included.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of an item or a service item, based on the value in the Type field.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the component type.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the component.';
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the serial number of the component.';

                    trigger OnAssistEdit()
                    begin
                        AssistEditSerialNo;
                    end;
                }
                field("Date Installed";"Date Installed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the component was installed.';
                }
                field("Service Order No.";"Service Order No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service order under which this component was replaced.';
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
        area(navigation)
        {
            group("&Component")
            {
                Caption = '&Component';
                Image = Components;
                action(Shipment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Shipment';
                    Image = Shipment;
                    RunObject = Page "Posted Service Shipments";
                    RunPageLink = "Order No."=field("Service Order No.");
                }
            }
        }
    }
}

