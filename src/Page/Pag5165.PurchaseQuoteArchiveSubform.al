#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5165 "Purchase Quote Archive Subform"
{
    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Purchase Line Archive";
    SourceTableView = where("Document Type"=filter(Quote));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field("Cross-Reference No.";"Cross-Reference No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Nonstock;Nonstock)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Direct Unit Cost";"Direct Unit Cost")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field("Indirect Cost %";"Indirect Cost %")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Unit Cost (LCY)";"Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Unit Price (LCY)";"Unit Price (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Tax Liable";"Tax Liable")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Tax Area Code";"Tax Area Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Tax Group Code";"Tax Group Code")
                {
                    ApplicationArea = Basic;
                }
                field("Use Tax";"Use Tax")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Line Amount";"Line Amount")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field("Line Discount Amount";"Line Discount Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Allow Invoice Disc.";"Allow Invoice Disc.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Allow Item Charge Assignment";"Allow Item Charge Assignment")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Prod. Order No.";"Prod. Order No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Blanket Order No.";"Blanket Order No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Blanket Order Line No.";"Blanket Order Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Appl.-to Item Entry";"Appl.-to Item Entry")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
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
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;

                    trigger OnAction()
                    begin
                        ShowLineComments;
                    end;
                }
            }
        }
    }
}

