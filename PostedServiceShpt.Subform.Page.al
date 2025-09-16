#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5976 "Posted Service Shpt. Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Service Shipment Item Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of this line.';
                    Visible = false;
                }
                field("Service Item No.";"Service Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service item registered in the Service Item table and associated with the customer.';
                }
                field("Service Item Group Code";"Service Item Group Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the group associated with this service item.';
                }
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ship-to code of the service item associated with the service contract or service order.';
                    Visible = false;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item to which this posted service item is related.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the item variant on this line.';
                    Visible = false;
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the serial number of this service item.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the service item specified in the Service Item No. field on this line.';
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an additional description of this service item.';
                    Visible = false;
                }
                field("Fault Comment";"Fault Comment")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that there is a fault comment for this service item.';
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        ShowComments(1);
                    end;
                }
                field("Resolution Comment";"Resolution Comment")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that there is a resolution comment for this service item.';
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        ShowComments(2);
                    end;
                }
                field("Service Shelf No.";"Service Shelf No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service shelf where the service item is stored while it is in the repair shop.';
                    Visible = false;
                }
                field(Warranty;Warranty)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that there is a warranty on either parts or labor for this service item.';
                }
                field("Warranty Starting Date (Parts)";"Warranty Starting Date (Parts)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the warranty starts on the service item spare parts.';
                    Visible = false;
                }
                field("Warranty Ending Date (Parts)";"Warranty Ending Date (Parts)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the spare parts warranty expires for this service item.';
                    Visible = false;
                }
                field("Warranty % (Parts)";"Warranty % (Parts)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the percentage of spare parts costs covered by the warranty for this service item.';
                    Visible = false;
                }
                field("Warranty % (Labor)";"Warranty % (Labor)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the percentage of labor costs covered by the warranty on this service item.';
                    Visible = false;
                }
                field("Warranty Starting Date (Labor)";"Warranty Starting Date (Labor)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the labor warranty for the posted service item starts.';
                    Visible = false;
                }
                field("Warranty Ending Date (Labor)";"Warranty Ending Date (Labor)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the labor warranty expires on the posted service item.';
                    Visible = false;
                }
                field("Contract No.";"Contract No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the contract associated with the posted service item.';
                }
                field("Fault Reason Code";"Fault Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the fault reason code assigned to the posted service item.';
                    Visible = false;
                }
                field("Service Price Group Code";"Service Price Group Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the service price group associated with this service item.';
                    Visible = false;
                }
                field("Fault Area Code";"Fault Area Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code that identifies the area of the fault encountered with this service item.';
                    Visible = false;
                }
                field("Symptom Code";"Symptom Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code to identify the symptom of the service item fault.';
                    Visible = false;
                }
                field("Fault Code";"Fault Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code to identify the fault of the posted service item or the actions taken on the item.';
                    Visible = false;
                }
                field("Resolution Code";"Resolution Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the resolution code assigned to this item.';
                    Visible = false;
                }
                field(Priority;Priority)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the service priority for this posted service item.';
                }
                field("Response Time (Hours)";"Response Time (Hours)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the estimated hours between the creation of the service order, to the time when the repair status changes from Initial, to In Process.';
                }
                field("Response Date";"Response Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the estimated date when service starts on this service item.';
                }
                field("Response Time";"Response Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the time when service is expected to start on this service item.';
                }
                field("Loaner No.";"Loaner No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the loaner that has been lent to the customer to replace this service item.';
                }
                field("Vendor No.";"Vendor No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the vendor who sold this service item.';
                    Visible = false;
                }
                field("Vendor Item No.";"Vendor Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number assigned to this service item by the vendor.';
                    Visible = false;
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when service on this service item started.';
                    Visible = false;
                }
                field("Starting Time";"Starting Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the time when service on this service item started.';
                    Visible = false;
                }
                field("Finishing Date";"Finishing Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the time when service on this service item is finished.';
                    Visible = false;
                }
                field("Finishing Time";"Finishing Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the time when the service on the order is finished.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
                group("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    action(Faults)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Faults';
                        Image = Error;

                        trigger OnAction()
                        begin
                            ShowComments(1);
                        end;
                    }
                    action(Resolutions)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Resolutions';
                        Image = Completed;

                        trigger OnAction()
                        begin
                            ShowComments(2);
                        end;
                    }
                    action(Internal)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Internal';
                        Image = Comment;

                        trigger OnAction()
                        begin
                            ShowComments(4);
                        end;
                    }
                    action(Accessories)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Accessories';
                        Image = ServiceAccessories;

                        trigger OnAction()
                        begin
                            ShowComments(3);
                        end;
                    }
                    action("Lent Loaners")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Lent Loaners';

                        trigger OnAction()
                        begin
                            ShowComments(5);
                        end;
                    }
                }
                action("Service Item &Log")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Item &Log';
                    Image = Log;

                    trigger OnAction()
                    begin
                        ShowServItemEventLog;
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("&Receive Loaner")
                {
                    ApplicationArea = Basic;
                    Caption = '&Receive Loaner';
                    Image = ReceiveLoaner;

                    trigger OnAction()
                    begin
                        ReceiveLoaner;
                    end;
                }
            }
            group("&Shipment")
            {
                Caption = '&Shipment';
                Image = Shipment;
                action(ServiceShipmentLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Shipment Lines';
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction()
                    begin
                        ShowServShipmentLines;
                    end;
                }
            }
        }
    }

    var
        ServLoanerMgt: Codeunit ServLoanerManagement;
        Text000: label 'You can view the Service Item Log only for service item lines with the specified Service Item No.';

    local procedure ShowServShipmentLines()
    var
        ServShipmentLine: Record "Service Shipment Line";
        ServShipmentLines: Page "Posted Service Shipment Lines";
    begin
        TestField("No.");
        Clear(ServShipmentLine);
        ServShipmentLine.SetRange("Document No.","No.");
        ServShipmentLine.FilterGroup(2);
        Clear(ServShipmentLines);
        ServShipmentLines.Initialize("Line No.");
        ServShipmentLines.SetTableview(ServShipmentLine);
        ServShipmentLines.RunModal;
        ServShipmentLine.FilterGroup(0);
    end;


    procedure ReceiveLoaner()
    begin
        ServLoanerMgt.ReceiveLoanerShipment(Rec);
    end;

    local procedure ShowServItemEventLog()
    var
        ServItemLog: Record "Service Item Log";
    begin
        if "Service Item No." = '' then
          Error(Text000);
        Clear(ServItemLog);
        ServItemLog.SetRange("Service Item No.","Service Item No.");
        Page.RunModal(Page::"Service Item Log",ServItemLog);
    end;
}

