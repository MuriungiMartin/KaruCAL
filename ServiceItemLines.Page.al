#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5903 "Service Item Lines"
{
    Caption = 'Service Item Lines';
    DataCaptionFields = "Document Type","Document No.","Fault Reason Code";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Service Item Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the service document is a service order or service quote.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service order linked to this service item line.';
                }
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the line.';
                }
                field("Service Item Group Code";"Service Item Group Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the service item group for this item.';
                }
                field("Service Item No.";"Service Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the service item number registered in the Service Item table.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of this service item.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item number linked to this service item.';
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the serial number of this item.';
                }
                field(Warranty;Warranty)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that warranty on either parts or labor exists for this item.';
                }
                field("Contract No.";"Contract No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service contract associated with the item or service on the line.';
                }
                field("Fault Reason Code";"Fault Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the fault reason code for the item.';
                }
                field("Fault Area Code";"Fault Area Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the fault area code for this item.';
                }
                field("Symptom Code";"Symptom Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the symptom code for this item.';
                }
                field("Resolution Code";"Resolution Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the resolution code for this item.';
                }
                field("Fault Code";"Fault Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the fault code for this item.';
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
            group("&Worksheet")
            {
                Caption = '&Worksheet';
                Image = Worksheet;
                group("Com&ments")
                {
                    Caption = 'Com&ments';
                    Image = ViewComments;
                    action(Faults)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Faults';
                        Image = Error;
                        RunObject = Page "Service Comment Sheet";
                        RunPageLink = "Table Name"=const("Service Header"),
                                      "Table Subtype"=field("Document Type"),
                                      "No."=field("Document No."),
                                      "Table Line No."=field("Line No."),
                                      Type=const(Fault);
                    }
                    action(Resolutions)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Resolutions';
                        Image = Completed;
                        RunObject = Page "Service Comment Sheet";
                        RunPageLink = "Table Name"=const("Service Header"),
                                      "Table Subtype"=field("Document Type"),
                                      "No."=field("Document No."),
                                      "Table Line No."=field("Line No."),
                                      Type=const(Resolution);
                    }
                    action(Internal)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Internal';
                        Image = Comment;
                        RunObject = Page "Service Comment Sheet";
                        RunPageLink = "Table Name"=const("Service Header"),
                                      "Table Subtype"=field("Document Type"),
                                      "No."=field("Document No."),
                                      "Table Line No."=field("Line No."),
                                      Type=const(Internal);
                    }
                    action(Accessories)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Accessories';
                        Image = ServiceAccessories;
                        RunObject = Page "Service Comment Sheet";
                        RunPageLink = "Table Name"=const("Service Header"),
                                      "Table Subtype"=field("Document Type"),
                                      "No."=field("Document No."),
                                      "Table Line No."=field("Line No."),
                                      Type=const(Accessory);
                    }
                    action(Loaners)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Loaners';
                        Image = Loaners;
                        RunObject = Page "Service Comment Sheet";
                        RunPageLink = "Table Name"=const("Service Header"),
                                      "Table Subtype"=field("Document Type"),
                                      "No."=field("Document No."),
                                      "Table Line No."=field("Line No."),
                                      Type=const("Service Item Loaner");
                    }
                }
                group("Service &Item")
                {
                    Caption = 'Service &Item';
                    Image = ServiceItem;
                    action(Card)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Card';
                        Image = EditLines;
                        RunObject = Page "Service Item Card";
                        RunPageLink = "No."=field("Service Item No.");
                        ShortCutKey = 'Shift+F5';
                    }
                    action("&Log")
                    {
                        ApplicationArea = Basic;
                        Caption = '&Log';
                        Image = Approve;
                        RunObject = Page "Service Item Log";
                        RunPageLink = "Service Item No."=field("Service Item No.");
                    }
                }
            }
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("Service Item Worksheet")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Item Worksheet';
                    Image = ServiceItemWorksheet;
                    RunObject = Page "Service Item Worksheet";
                    RunPageLink = "Document Type"=field("Document Type"),
                                  "Document No."=field("Document No."),
                                  "Line No."=field("Line No.");
                    ShortCutKey = 'Shift+F7';
                }
            }
        }
    }
}

