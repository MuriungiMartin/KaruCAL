#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 914 "Assemble-to-Order Lines"
{
    AutoSplitKey = true;
    Caption = 'Assemble-to-Order Lines';
    DataCaptionExpression = GetCaption;
    DelayedInsert = true;
    PageType = Worksheet;
    PopulateAllFields = true;
    SourceTable = "Assembly Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Avail. Warning";"Avail. Warning")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    DrillDown = true;
                    ToolTip = 'Specifies Yes if the assembly component is not available in the quantity and on the due date of the assembly order line.';

                    trigger OnDrillDown()
                    begin
                        ShowAvailabilityWarning;
                    end;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the assembly order line is of type Item or Resource.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item or resource that is represented by the assembly order line.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the assembly component.';
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the second description of the assembly component.';
                    Visible = false;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the item variant of the assembly component.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location from which you want to post consumption of the assembly component.';
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure in which the assembly component is consumed on the assembly order.';
                }
                field("Quantity per";"Quantity per")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the assembly component are required to assemble one assembly item.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the assembly component are expected to be consumed.';
                }
                field("Reserved Quantity";"Reserved Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the assembly component have been reserved for this assembly order line.';
                }
                field("Consumed Quantity";"Consumed Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the assembly component have been posted as consumed during the assembly.';
                    Visible = false;
                }
                field("Qty. Picked";"Qty. Picked")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the assembly component have been moved or picked for the assembly order line.';
                    Visible = false;
                }
                field("Pick Qty.";"Pick Qty.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the assembly component are currently on warehouse pick lines.';
                    Visible = false;
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the assembly component must be available for consumption by the assembly order.';
                    Visible = false;
                }
                field("Lead-Time Offset";"Lead-Time Offset")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the lead-time offset that is defined for the assembly component on the assembly BOM.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the shortcut dimension 1 value that the assembly order line is linked to.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the shortcut dimension 2 value that the assembly order line is linked to.';
                    Visible = false;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the bin where assembly components must be placed prior to assembly and from where they are posted as consumed.';
                    Visible = false;
                }
                field("Inventory Posting Group";"Inventory Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the inventory posting group to which the item on this assembly order line is posted.';
                    Visible = false;
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit cost of the assembly component.';
                    Visible = false;
                }
                field("Cost Amount";"Cost Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the cost of the assembly order line.';
                }
                field("Qty. per Unit of Measure";"Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity per unit of measure of the component item on the assembly order line.';
                    Visible = false;
                }
                field("Resource Usage Type";"Resource Usage Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how the cost of the resource on the assembly order line is allocated to the assembly item.';
                }
                field("Appl.-to Item Entry";"Appl.-to Item Entry")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of a particular item ledger entry that the assembly order line is applied to.';
                    Visible = false;
                }
                field("Appl.-from Item Entry";"Appl.-from Item Entry")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item ledger entry that the assembly order line is applied from.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Reserve")
            {
                ApplicationArea = Basic;
                Caption = '&Reserve';
                Ellipsis = true;
                Image = LineReserve;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ShowReservation;
                end;
            }
            action("Select Item Substitution")
            {
                ApplicationArea = Basic;
                Caption = 'Select Item Substitution';
                Image = SelectItemSubstitution;

                trigger OnAction()
                begin
                    ShowItemSub;
                    CurrPage.Update;
                end;
            }
            action("Explode BOM")
            {
                ApplicationArea = Basic;
                Caption = 'Explode BOM';
                Image = ExplodeBOM;

                trigger OnAction()
                begin
                    ExplodeAssemblyList;
                    CurrPage.Update;
                end;
            }
            action("Assembly BOM")
            {
                ApplicationArea = Basic;
                Caption = 'Assembly BOM';
                Image = BulletList;

                trigger OnAction()
                begin
                    ShowAssemblyList;
                end;
            }
            action("Create Inventor&y Movement")
            {
                ApplicationArea = Basic;
                Caption = 'Create Inventor&y Movement';
                Ellipsis = true;
                Image = CreatePutAway;

                trigger OnAction()
                var
                    AssemblyHeader: Record "Assembly Header";
                    ATOMovementsCreated: Integer;
                    TotalATOMovementsToBeCreated: Integer;
                begin
                    AssemblyHeader.Get("Document Type","Document No.");
                    AssemblyHeader.CreateInvtMovement(false,false,false,ATOMovementsCreated,TotalATOMovementsToBeCreated);
                end;
            }
        }
        area(navigation)
        {
            action("Show Document")
            {
                ApplicationArea = Basic;
                Caption = 'Show Document';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ATOLink: Record "Assemble-to-Order Link";
                    SalesLine: Record "Sales Line";
                begin
                    ATOLink.Get("Document Type","Document No.");
                    SalesLine.Get(ATOLink."Document Type",ATOLink."Document No.",ATOLink."Document Line No.");
                    ATOLink.ShowAsm(SalesLine);
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
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'Shift+Ctrl+I';

                trigger OnAction()
                begin
                    OpenItemTrackingLines;
                end;
            }
            group("Item Availability by")
            {
                Caption = 'Item Availability by';
                Image = ItemAvailability;
                action("Event")
                {
                    ApplicationArea = Basic;
                    Caption = 'Event';
                    Image = "Event";

                    trigger OnAction()
                    begin
                        ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec,ItemAvailFormsMgt.ByEvent);
                    end;
                }
                action(Period)
                {
                    ApplicationArea = Basic;
                    Caption = 'Period';
                    Image = Period;

                    trigger OnAction()
                    begin
                        ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec,ItemAvailFormsMgt.ByPeriod);
                    end;
                }
                action(Variant)
                {
                    ApplicationArea = Basic;
                    Caption = 'Variant';
                    Image = ItemVariant;

                    trigger OnAction()
                    begin
                        ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec,ItemAvailFormsMgt.ByVariant);
                    end;
                }
                action(Location)
                {
                    AccessByPermission = TableData Location=R;
                    ApplicationArea = Basic;
                    Caption = 'Location';
                    Image = Warehouse;

                    trigger OnAction()
                    begin
                        ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec,ItemAvailFormsMgt.ByLocation);
                    end;
                }
                action("BOM Level")
                {
                    ApplicationArea = Basic;
                    Caption = 'BOM Level';
                    Image = BOMLevel;

                    trigger OnAction()
                    begin
                        ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec,ItemAvailFormsMgt.ByBOM);
                    end;
                }
            }
            action(Comments)
            {
                ApplicationArea = Basic;
                Caption = 'Comments';
                Image = ViewComments;
                RunObject = Page "Assembly Comment Sheet";
                RunPageLink = "Document Type"=field("Document Type"),
                              "Document No."=field("Document No."),
                              "Document Line No."=field("Line No.");
            }
            action(ShowWarning)
            {
                ApplicationArea = Basic;
                Caption = 'Show Warning';
                Image = ShowWarning;

                trigger OnAction()
                begin
                    ShowAvailabilityWarning;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateAvailWarning;
    end;

    trigger OnDeleteRecord(): Boolean
    var
        AssemblyLineReserve: Codeunit "Assembly Line-Reserve";
    begin
        if (Quantity <> 0) and ItemExists("No.") then begin
          Commit;
          if not AssemblyLineReserve.DeleteLineConfirm(Rec) then
            exit(false);
          AssemblyLineReserve.DeleteLine(Rec);
        end;
    end;

    var
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";

    local procedure GetCaption(): Text[250]
    var
        ObjTransln: Record "Object Translation";
        AsmHeader: Record "Assembly Header";
        SourceTableName: Text[250];
        SourceFilter: Text[200];
        Description: Text[100];
    begin
        Description := '';

        if AsmHeader.Get("Document Type","Document No.") then begin
          SourceTableName := ObjTransln.TranslateObject(ObjTransln."object type"::Table,27);
          SourceFilter := AsmHeader."Item No.";
          Description := AsmHeader.Description;
        end;
        exit(StrSubstNo('%1 %2 %3',SourceTableName,SourceFilter,Description));
    end;
}

