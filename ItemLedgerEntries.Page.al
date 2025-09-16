#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 38 "Item Ledger Entries"
{
    ApplicationArea = Basic;
    Caption = 'Item Ledger Entries';
    DataCaptionExpression = GetCaption;
    DataCaptionFields = "Item No.";
    Editable = false;
    PageType = List;
    SourceTable = "Item Ledger Entry";
    SourceTableView = sorting("Entry No.")
                      order(descending);
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the posting date for the entry.';
                }
                field("Entry Type";"Entry Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies which type of transaction that the entry is created from.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies what type of document was posted to create the item ledger entry.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the document number on the entry. The document is the voucher that the entry was based on, for example, a receipt.';
                }
                field("Document Line No.";"Document Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the line on the posted document that corresponds to the item ledger entry.';
                    Visible = false;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the item in the entry.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant code for the items.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the entry.';
                }
                field("Return Reason Code";"Return Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code that explains why the item is returned.';
                    Visible = false;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code that the entry is linked to.';
                    Visible = false;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code that the entry is linked to.';
                    Visible = false;
                }
                field("Expiration Date";"Expiration Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the last date that the item on the line can be used.';
                    Visible = false;
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a serial number if the posted item carries such a number.';
                    Visible = false;
                }
                field("Lot No.";"Lot No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a lot number if the posted item carries such a number.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the location that the entry is linked to.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of units of the item in the item entry.';
                }
                field("Invoiced Quantity";"Invoiced Quantity")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies how many units of the item on the line have been invoiced.';
                    Visible = true;
                }
                field("Remaining Quantity";"Remaining Quantity")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the quantity that remains in inventory in the Quantity field if the entry is an increase (a purchase or positive adjustment).';
                    Visible = true;
                }
                field("Shipped Qty. Not Returned";"Shipped Qty. Not Returned")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity for this item ledger entry that was shipped and has not yet been returned.';
                    Visible = false;
                }
                field("Reserved Quantity";"Reserved Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the item on the line have been reserved.';
                    Visible = false;
                }
                field("Qty. per Unit of Measure";"Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity per item unit of measure.';
                    Visible = false;
                }
                field("Sales Amount (Expected)";"Sales Amount (Expected)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the expected sales amount, in $.';
                    Visible = false;
                }
                field("Sales Amount (Actual)";"Sales Amount (Actual)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the sales amount, in $.';
                }
                field("Cost Amount (Expected)";"Cost Amount (Expected)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the expected cost, in $, of the quantity posting.';
                    Visible = false;
                }
                field("Cost Amount (Actual)";"Cost Amount (Actual)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the adjusted cost, in $, of the quantity posting.';
                }
                field("Cost Amount (Non-Invtbl.)";"Cost Amount (Non-Invtbl.)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the adjusted non-inventoriable cost, that is an item charge assigned to an outbound entry.';
                }
                field("Cost Amount (Expected) (ACY)";"Cost Amount (Expected) (ACY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the expected cost, in ACY, of the quantity posting.';
                    Visible = false;
                }
                field("Cost Amount (Actual) (ACY)";"Cost Amount (Actual) (ACY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the adjusted cost of the entry, in the additional reporting currency.';
                    Visible = false;
                }
                field("Cost Amount (Non-Invtbl.)(ACY)";"Cost Amount (Non-Invtbl.)(ACY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the adjusted non-inventoriable cost, that is, an item charge assigned to an outbound entry in the additional reporting currency.';
                    Visible = false;
                }
                field("Completely Invoiced";"Completely Invoiced")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the entry has been fully invoiced or if more posted invoices are expected. Only completely invoiced entries can be revalued.';
                    Visible = false;
                }
                field(Open;Open)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether the entry has been fully applied to.';
                }
                field("Drop Shipment";"Drop Shipment")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the items on the line have been shipped directly to the customer.';
                    Visible = false;
                }
                field("Assemble to Order";"Assemble to Order")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the posting represents an assemble-to-order sale.';
                    Visible = false;
                }
                field("Applied Entry to Adjust";"Applied Entry to Adjust")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether there is one or more applied entries, which need to be adjusted.';
                    Visible = false;
                }
                field("Order Type";"Order Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies which type of order that the entry was created in.';
                }
                field("Order No.";"Order No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the order that created the entry.';
                    Visible = false;
                }
                field("Order Line No.";"Order Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the line number of the order that created the entry.';
                    Visible = false;
                }
                field("Prod. Order Comp. Line No.";"Prod. Order Comp. Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the line number of the production order component.';
                    Visible = false;
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the entry number for the entry.';
                }
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the job associated with the entry.';
                    Visible = false;
                }
                field("Job Task No.";"Job Task No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the job task associated with the entry.';
                    Visible = false;
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
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                Image = Entry;
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
                action("&Value Entries")
                {
                    ApplicationArea = Basic;
                    Caption = '&Value Entries';
                    Image = ValueLedger;
                    RunObject = Page "Value Entries";
                    RunPageLink = "Item Ledger Entry No."=field("Entry No.");
                    RunPageView = sorting("Item Ledger Entry No.");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View all amounts relating to an item.';
                }
            }
            group("&Application")
            {
                Caption = '&Application';
                Image = Apply;
                action("Applied E&ntries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Applied E&ntries';
                    Image = Approve;
                    ToolTip = 'View the ledger entries that have been applied to this record.';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Show Applied Entries",Rec);
                    end;
                }
                action("Reservation Entries")
                {
                    AccessByPermission = TableData Item=R;
                    ApplicationArea = Basic;
                    Caption = 'Reservation Entries';
                    Image = ReservationLedger;
                    ToolTip = 'View the entries for every reservation that is made, either manually or automatically.';

                    trigger OnAction()
                    begin
                        ShowReservationEntries(true);
                    end;
                }
                action("Application Worksheet")
                {
                    ApplicationArea = Basic;
                    Caption = 'Application Worksheet';
                    Image = ApplicationWorksheet;
                    ToolTip = 'View item applications that are automatically created between item ledger entries during item transactions.';

                    trigger OnAction()
                    var
                        Worksheet: Page "Application Worksheet";
                    begin
                        Clear(Worksheet);
                        Worksheet.SetRecordToShow(Rec);
                        Worksheet.Run;
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Order &Tracking")
                {
                    ApplicationArea = Basic;
                    Caption = 'Order &Tracking';
                    Image = OrderTracking;
                    ToolTip = 'Tracks the connection of a supply to its corresponding demand. This can help you find the original demand that created a specific production order or purchase order.';

                    trigger OnAction()
                    var
                        TrackingForm: Page "Order Tracking";
                    begin
                        TrackingForm.SetItemLedgEntry(Rec);
                        TrackingForm.RunModal;
                    end;
                }
            }
            action("&Navigate")
            {
                ApplicationArea = Basic,Suite;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';

                trigger OnAction()
                begin
                    Navigate.SetDoc("Posting Date","Document No.");
                    Navigate.Run;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if FindFirst then;
    end;

    var
        Navigate: Page Navigate;

    local procedure GetCaption(): Text
    var
        GLSetup: Record "General Ledger Setup";
        ObjTransl: Record "Object Translation";
        Item: Record Item;
        ProdOrder: Record "Production Order";
        Cust: Record Customer;
        Vend: Record Vendor;
        Dimension: Record Dimension;
        DimValue: Record "Dimension Value";
        SourceTableName: Text;
        SourceFilter: Text;
        Description: Text[100];
    begin
        Description := '';

        case true of
          GetFilter("Item No.") <> '':
            begin
              SourceTableName := ObjTransl.TranslateObject(ObjTransl."object type"::Table,27);
              SourceFilter := GetFilter("Item No.");
              if MaxStrLen(Item."No.") >= StrLen(SourceFilter) then
                if Item.Get(SourceFilter) then
                  Description := Item.Description;
            end;
          (GetFilter("Order No.") <> '') and ("Order Type" = "order type"::Production):
            begin
              SourceTableName := ObjTransl.TranslateObject(ObjTransl."object type"::Table,5405);
              SourceFilter := GetFilter("Order No.");
              if MaxStrLen(ProdOrder."No.") >= StrLen(SourceFilter) then
                if ProdOrder.Get(ProdOrder.Status::Released,SourceFilter) or
                   ProdOrder.Get(ProdOrder.Status::Finished,SourceFilter)
                then begin
                  SourceTableName := StrSubstNo('%1 %2',ProdOrder.Status,SourceTableName);
                  Description := ProdOrder.Description;
                end;
            end;
          GetFilter("Source No.") <> '':
            case "Source Type" of
              "source type"::Customer:
                begin
                  SourceTableName :=
                    ObjTransl.TranslateObject(ObjTransl."object type"::Table,18);
                  SourceFilter := GetFilter("Source No.");
                  if MaxStrLen(Cust."No.") >= StrLen(SourceFilter) then
                    if Cust.Get(SourceFilter) then
                      Description := Cust.Name;
                end;
              "source type"::Vendor:
                begin
                  SourceTableName :=
                    ObjTransl.TranslateObject(ObjTransl."object type"::Table,23);
                  SourceFilter := GetFilter("Source No.");
                  if MaxStrLen(Vend."No.") >= StrLen(SourceFilter) then
                    if Vend.Get(SourceFilter) then
                      Description := Vend.Name;
                end;
            end;
          GetFilter("Global Dimension 1 Code") <> '':
            begin
              GLSetup.Get;
              Dimension.Code := GLSetup."Global Dimension 1 Code";
              SourceFilter := GetFilter("Global Dimension 1 Code");
              SourceTableName := Dimension.GetMLName(GlobalLanguage);
              if MaxStrLen(DimValue.Code) >= StrLen(SourceFilter) then
                if DimValue.Get(GLSetup."Global Dimension 1 Code",SourceFilter) then
                  Description := DimValue.Name;
            end;
          GetFilter("Global Dimension 2 Code") <> '':
            begin
              GLSetup.Get;
              Dimension.Code := GLSetup."Global Dimension 2 Code";
              SourceFilter := GetFilter("Global Dimension 2 Code");
              SourceTableName := Dimension.GetMLName(GlobalLanguage);
              if MaxStrLen(DimValue.Code) >= StrLen(SourceFilter) then
                if DimValue.Get(GLSetup."Global Dimension 2 Code",SourceFilter) then
                  Description := DimValue.Name;
            end;
          GetFilter("Document Type") <> '':
            begin
              SourceTableName := GetFilter("Document Type");
              SourceFilter := GetFilter("Document No.");
              Description := GetFilter("Document Line No.");
            end;
        end;
        exit(StrSubstNo('%1 %2 %3',SourceTableName,SourceFilter,Description));
    end;
}

