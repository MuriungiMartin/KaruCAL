#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 930 "Assembly Quote"
{
    Caption = 'Assembly Quote';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "Assembly Header";
    SourceTableView = sorting("Document Type","No.")
                      order(ascending)
                      where("Document Type"=const(Quote));

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
                    AssistEdit = true;
                    ToolTip = 'Specifies the number assigned to the assembly order from the number series that you set up in the Assembly Setup window.';

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    Editable = IsAsmToOrderEditable;
                    Importance = Promoted;
                    TableRelation = Item."No." where ("Assembly BOM"=const(true));
                    ToolTip = 'Specifies the number of the item that is being assembled with the assembly order.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the assembly item.';
                }
                group(Control33)
                {
                    field(Quantity;Quantity)
                    {
                        ApplicationArea = Basic;
                        Editable = IsAsmToOrderEditable;
                        Importance = Promoted;
                        ToolTip = 'Specifies how many units of the assembly item that you expect to assemble with the assembly order.';
                    }
                    field("Unit of Measure Code";"Unit of Measure Code")
                    {
                        ApplicationArea = Basic;
                        Editable = IsAsmToOrderEditable;
                        ToolTip = 'Specifies the unit of measure code of the assembly item.';
                    }
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date on which the assembly order is posted.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    Editable = IsAsmToOrderEditable;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date when the assembled item is due to be available for use.';
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the assembly order is expected to start.';
                }
                field("Ending Date";"Ending Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the assembly order is expected to finish.';
                }
                field("Assemble to Order";"Assemble to Order")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the assembly order is linked to a sales order, which indicates that the item is assembled to order.';

                    trigger OnDrillDown()
                    begin
                        ShowAsmToOrder;
                    end;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the document is open, waiting to be approved, invoiced for prepayment, or released to the next stage of processing.';
                }
            }
            part(Lines;"Assembly Quote Subform")
            {
                Caption = 'Lines';
                SubPageLink = "Document Type"=field("Document Type"),
                              "Document No."=field("No.");
            }
            group(Posting)
            {
                Caption = 'Posting';
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    Editable = IsAsmToOrderEditable;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code of the item variant of the item that is being assembled.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    Editable = IsAsmToOrderEditable;
                    Importance = Promoted;
                    ToolTip = 'Specifies the location to which you want to post output of the assembly item.';
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    Editable = IsAsmToOrderEditable;
                    ToolTip = 'Specifies the bin the assembly item is posted to as output and from where it is taken to storage or shipped if it is assembled to a sales order.';
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic;
                    Editable = IsUnitCostEditable;
                    ToolTip = 'Specifies the unit cost of the assembly item.';
                }
                field("Cost Amount";"Cost Amount")
                {
                    ApplicationArea = Basic;
                    Editable = IsUnitCostEditable;
                    ToolTip = 'Specifies the total unit cost of the assembly order.';
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control11;"Assembly Item - Details")
            {
                SubPageLink = "No."=field("Item No.");
            }
            part(Control44;"Component - Item Details")
            {
                Provider = Lines;
                SubPageLink = "No."=field("No.");
            }
            part(Control43;"Component - Resource Details")
            {
                Provider = Lines;
                SubPageLink = "No."=field("No.");
            }
            systempart(Control8;Links)
            {
            }
            systempart(Control9;Notes)
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
                RunPageOnRec = true;
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
            action("Assembly BOM")
            {
                ApplicationArea = Basic;
                Caption = 'Assembly BOM';
                Image = AssemblyBOM;

                trigger OnAction()
                begin
                    ShowAssemblyList;
                end;
            }
            action(Comments)
            {
                ApplicationArea = Basic;
                Caption = 'Comments';
                Image = ViewComments;
                RunObject = Page "Assembly Comment Sheet";
                RunPageLink = "Document Type"=field("Document Type"),
                              "Document No."=field("No."),
                              "Document Line No."=const(0);
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Update Unit Cost")
                {
                    ApplicationArea = Basic;
                    Caption = 'Update Unit Cost';
                    Enabled = IsUnitCostEditable;
                    Image = UpdateUnitCost;

                    trigger OnAction()
                    begin
                        UpdateUnitCost;
                    end;
                }
                action("Refresh Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Refresh Lines';
                    Image = RefreshLines;

                    trigger OnAction()
                    begin
                        RefreshBOM;
                        CurrPage.Update;
                    end;
                }
                action("Show Availability")
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Availability';
                    Image = ItemAvailbyLoc;

                    trigger OnAction()
                    begin
                        ShowAvailability;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IsUnitCostEditable := not IsStandardCostItem;
        IsAsmToOrderEditable := not IsAsmToOrder;
    end;

    trigger OnOpenPage()
    begin
        IsUnitCostEditable := true;
        IsAsmToOrderEditable := true;

        UpdateWarningOnLines;
    end;

    var
        [InDataSet]
        IsUnitCostEditable: Boolean;
        [InDataSet]
        IsAsmToOrderEditable: Boolean;
}

