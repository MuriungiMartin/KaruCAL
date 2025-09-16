#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 920 "Posted Assembly Order"
{
    Caption = 'Posted Assembly Order';
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Document;
    SourceTable = "Posted Assembly Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document number of the posted assembly order.';
                }
                field("Order No.";"Order No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the assembly order that the posted assembly order line originates from.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the posted assembly item.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the posted assembly item.';
                }
                group(Control8)
                {
                    field(Quantity;Quantity)
                    {
                        ApplicationArea = Basic;
                        ToolTip = 'Specifies how many units of the assembly item were posted with this posted assembly order.';
                    }
                    field("Unit of Measure Code";"Unit of Measure Code")
                    {
                        ApplicationArea = Basic;
                        ToolTip = 'Specifies the unit of measure code of the posted assembly item.';
                    }
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the assembly order was posted.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the assembled item is due to be available for use.';
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date on which the posted assembly order started.';
                }
                field("Ending Date";"Ending Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the posted assembly order finished, which means the date on which all assembly items were output.';
                }
                field("Assemble to Order";"Assemble to Order")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the posted assembly order was linked to a sales order, which indicates that the item was assembled to order.';

                    trigger OnDrillDown()
                    begin
                        ShowAsmToOrder;
                    end;
                }
                field(Reversed;Reversed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the posted assembly order has been undone.';
                }
            }
            part(Lines;"Posted Assembly Order Subform")
            {
                SubPageLink = "Document No."=field("No.");
            }
            group(Posting)
            {
                Caption = 'Posting';
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the item variant of the posted assembly item.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies to which location the assembly item was output from this posted assembly order header.';
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies to which bin the assembly item was posted as output on the posted assembly order header.';
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit cost of assembly item on this posted assembly item.';
                }
                field("Cost Amount";"Cost Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the total unit cost of the posted assembly order.';
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user to whom the posted assembly order was assigned.';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control21;Links)
            {
            }
            systempart(Control22;Notes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Statistics)
            {
                ApplicationArea = Basic;
                Caption = 'Statistics';
                Image = Statistics;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'F7';

                trigger OnAction()
                begin
                    ShowStatistics;
                end;
            }
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
            action("Item &Tracking Lines")
            {
                ApplicationArea = Basic;
                Caption = 'Item &Tracking Lines';
                Image = ItemTrackingLines;
                ShortCutKey = 'Shift+Ctrl+I';

                trigger OnAction()
                begin
                    ShowItemTrackingLines;
                end;
            }
            action(Comments)
            {
                ApplicationArea = Basic;
                Caption = 'Co&mments';
                Image = ViewComments;
                RunObject = Page "Assembly Comment Sheet";
                RunPageLink = "Document Type"=const("Posted Assembly"),
                              "Document No."=field("No."),
                              "Document Line No."=const(0);
            }
        }
        area(processing)
        {
            action(Print)
            {
                ApplicationArea = Basic;
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PostedAssemblyHeader: Record "Posted Assembly Header";
                begin
                    CurrPage.SetSelectionFilter(PostedAssemblyHeader);
                    PostedAssemblyHeader.PrintRecords(true);
                end;
            }
            action(Navigate)
            {
                ApplicationArea = Basic;
                Caption = 'Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Navigate;
                end;
            }
            action("Undo Post")
            {
                ApplicationArea = Basic;
                Caption = 'Undo Assembly';
                Enabled = UndoPostEnabledExpr;
                Image = Undo;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Codeunit.Run(Codeunit::"Pstd. Assembly - Undo (Yes/No)",Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UndoPostEnabledExpr := not Reversed and not IsAsmToOrder;
    end;

    var
        [InDataSet]
        UndoPostEnabledExpr: Boolean;
}

