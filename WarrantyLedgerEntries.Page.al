#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5913 "Warranty Ledger Entries"
{
    ApplicationArea = Basic;
    Caption = 'Warranty Ledger Entries';
    DataCaptionFields = "Service Order No.","Service Item No. (Serviced)","Service Contract No.";
    Editable = false;
    PageType = List;
    SourceTable = "Warranty Ledger Entry";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number assigned to this entry.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document number of this entry.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the posting date on the service line linked to this entry.';
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer on the service order linked to this entry.';
                }
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ship-to code of the customer on the service order linked to this entry.';
                }
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer number of the customer on the service order linked to this entry.';
                }
                field("Item No. (Serviced)";"Item No. (Serviced)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the serviced item linked to this entry.';
                }
                field("Serial No. (Serviced)";"Serial No. (Serviced)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the serial number of the serviced item linked to this entry.';
                }
                field("Service Item Group (Serviced)";"Service Item Group (Serviced)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the service item group code of the serviced item linked to this entry.';
                }
                field("Service Order No.";"Service Order No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service order linked to this entry.';
                }
                field("Service Contract No.";"Service Contract No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service contract linked to this entry.';
                }
                field("Fault Reason Code";"Fault Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the fault reason code of the service line linked to this entry.';
                }
                field("Fault Code";"Fault Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the fault code of the service line linked to this entry.';
                }
                field("Symptom Code";"Symptom Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the symptom code of the service line linked to this entry.';
                }
                field("Resolution Code";"Resolution Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the resolution code of the service line linked to this entry.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of the service line linked to this entry.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item, resource or cost of the service line linked to this entry.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of item units, resource hours, or cost of the service line linked to this entry.';
                }
                field("Work Type Code";"Work Type Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the work type code of the service line linked to this entry.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code of the service line linked to this entry.';
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the warranty discount amount of the service line linked to this entry.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the item on this line.';
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Global Dimension 1 code on the service line linked to this entry.';
                    Visible = false;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Global Dimension 2 code on the service line linked to this entry.';
                    Visible = false;
                }
                field(Open;Open)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the warranty ledger entry is open.';
                }
                field("Vendor No.";"Vendor No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the vendor number of the serviced item linked to this entry.';
                }
                field("Vendor Item No.";"Vendor Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the vendor item number of the serviced item linked to this entry.';
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
            group("&Entry")
            {
                Caption = '&Entry';
                Image = Entry;
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
            }
        }
        area(processing)
        {
            action("&Navigate")
            {
                ApplicationArea = Basic;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Navigate.SetDoc("Posting Date","Document No.");
                    Navigate.Run;
                end;
            }
        }
    }

    var
        Navigate: Page Navigate;
}

