#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5901 "Service List"
{
    Caption = 'Service List';
    DataCaptionFields = "Document Type","No.";
    Editable = false;
    PageType = List;
    SourceTable = "Service Header";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the service order status, which reflects the repair or maintenance status of all service items on the service order.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of the service document on the line.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service document you are creating.';
                }
                field("Order Date";"Order Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the service order was created.';
                }
                field("Order Time";"Order Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the time when the service order was created.';
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer who owns the items in the service document.';
                }
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the customer'' s address where you will ship the service.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the customer to whom the items on the document will be shipped.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location (for example, warehouse or distribution center) of the items specified on the service item lines.';
                }
                field("Response Date";"Response Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the estimated date when work on the order should start, that is, when the service order status changes from Pending, to In Process.';
                    Visible = ResponseDateVisible;
                }
                field("Response Time";"Response Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the estimated time when work on the order starts, that is, when the service order status changes from Pending, to In Process.';
                    Visible = ResponseTimeVisible;
                }
                field(Priority;Priority)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the priority of the service order.';
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code for the dimension chosen as Global Dimension 1.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code for the dimension chosen as Global Dimension 2.';
                    Visible = false;
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
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
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    var
                        PageManagement: Codeunit "Page Management";
                    begin
                        PageManagement.PageRun(Rec);
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        ResponseTimeVisible := true;
        ResponseDateVisible := true;
    end;

    trigger OnOpenPage()
    begin
        if "Document Type" = "document type"::Order then begin
          ResponseDateVisible := true;
          ResponseTimeVisible := true;
        end else begin
          ResponseDateVisible := false;
          ResponseTimeVisible := false;
        end;

        CopyCustomerFilter;
    end;

    var
        [InDataSet]
        ResponseDateVisible: Boolean;
        [InDataSet]
        ResponseTimeVisible: Boolean;
}

