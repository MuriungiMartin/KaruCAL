#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5931 "Service Register"
{
    ApplicationArea = Basic;
    Caption = 'Service Register';
    Editable = false;
    PageType = List;
    SourceTable = "Service Register";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a sequence number of the service register entry.';
                }
                field("Creation Date";"Creation Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the entries in the register were created.';
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user who posted a service invoice, service credit memo, or service order.';
                }
                field("From Entry No.";"From Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the first sequence number from the range of service ledger entries created for this register line.';
                }
                field("To Entry No.";"To Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the last sequence number from the range of service ledger entries created for this register line.';
                }
                field("From Warranty Entry No.";"From Warranty Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the first sequence number from the range of warranty ledger entries created for this register line.';
                }
                field("To Warranty Entry No.";"To Warranty Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the last sequence number from the range of warranty ledger entries created for this register line.';
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
            group("&Register")
            {
                Caption = '&Register';
                Image = Register;
                action("Service Ledger")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Ledger';
                    Image = ServiceLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Serv Reg.-Show Ledger Entries";
                }
                action("Warranty Ledger")
                {
                    ApplicationArea = Basic;
                    Caption = 'Warranty Ledger';
                    Image = WarrantyLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Serv Reg.-Show WarrLdgEntries";
                }
            }
        }
    }
}

