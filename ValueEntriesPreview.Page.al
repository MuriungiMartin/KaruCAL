#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5807 "Value Entries Preview"
{
    Caption = 'Value Entries Preview';
    Editable = false;
    PageType = List;
    SourceTable = "Value Entry";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the posting date of this entry.';
                }
                field("Valuation Date";"Valuation Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the valuation date from which the entry is included in the average cost calculation.';
                    Visible = false;
                }
                field("Item Ledger Entry Type";"Item Ledger Entry Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of item ledger entry that caused this value entry.';
                }
                field("Entry Type";"Entry Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of value described in this entry.';
                }
                field("Variance Type";"Variance Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the type of variance described in this entry.';
                    Visible = false;
                }
                field(Adjustment;Adjustment)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if this entry has been cost adjusted.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies what type of document was posted to create the value entry.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the document number of the entry.';
                }
                field("Document Line No.";"Document Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the line number of the line on the posted document that corresponds to the value entry.';
                    Visible = false;
                }
                field("Item Charge No.";"Item Charge No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the item charge number of the value entry.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the entry.';
                }
                field("Return Reason Code";"Return Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains a code that explains why the item is returned.';
                    Visible = false;
                }
                field("Sales Amount (Expected)";"Sales Amount (Expected)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the expected price of the item for a sales entry, which means that it has not been invoiced yet.';
                    Visible = false;
                }
                field("Sales Amount (Actual)";"Sales Amount (Actual)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the price of the item for a sales entry.';
                }
                field("Cost Amount (Expected)";"Cost Amount (Expected)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the expected cost of the items, which is calculated by multiplying the Cost per Unit by the Valued Quantity.';
                }
                field("Cost Amount (Actual)";"Cost Amount (Actual)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the cost of invoiced items.';
                }
                field("Cost Amount (Non-Invtbl.)";"Cost Amount (Non-Invtbl.)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the non-inventoriable cost, that is an item charge assigned to an outbound entry.';
                }
                field("Cost Posted to G/L";"Cost Posted to G/L")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the amount that has been posted to the general ledger.';
                }
                field("Expected Cost Posted to G/L";"Expected Cost Posted to G/L")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the expected cost amount that has been posted to the interim account in the general ledger.';
                    Visible = false;
                }
                field("Cost Amount (Expected) (ACY)";"Cost Amount (Expected) (ACY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the expected cost of the items in the additional reporting currency.';
                    Visible = false;
                }
                field("Cost Amount (Actual) (ACY)";"Cost Amount (Actual) (ACY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the cost of the items that have been invoiced, if you post in an additional reporting currency.';
                    Visible = false;
                }
                field("Cost Amount (Non-Invtbl.)(ACY)";"Cost Amount (Non-Invtbl.)(ACY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the non-inventoriable cost, that is an item charge assigned to an outbound entry in the additional reporting currency.';
                    Visible = false;
                }
                field("Cost Posted to G/L (ACY)";"Cost Posted to G/L (ACY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the amount that has been posted to the general ledger if you post in an additional reporting currency.';
                    Visible = false;
                }
                field("Item Ledger Entry Quantity";"Item Ledger Entry Quantity")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the average cost calculation.';
                }
                field("Valued Quantity";"Valued Quantity")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the quantity that the adjusted cost and the amount of the entry belongs to.';
                }
                field("Invoiced Quantity";"Invoiced Quantity")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies how many units of the item are invoiced by the posting that the value entry line represents.';
                }
                field("Cost per Unit";"Cost per Unit")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the cost for one base unit of the item in the entry.';
                }
                field("Cost per Unit (ACY)";"Cost per Unit (ACY)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the cost of one unit of the item in the entry.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the item that this value entry is linked to.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the code for the location of the item that the entry is linked to.';
                    Visible = false;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the type of value entry when it relates to a capacity entry.';
                    Visible = false;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the number of a work center or a machine center, depending on the entry in the Type field.';
                    Visible = false;
                }
                field("Discount Amount";"Discount Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the total discount amount of this value entry.';
                    Visible = false;
                }
                field("Salespers./Purch. Code";"Salespers./Purch. Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which salesperson or purchaser is linked to the entry.';
                    Visible = false;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the ID of the user who is associated with the entry.';
                    Visible = false;
                }
                field("Source Posting Group";"Source Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the posting group for the item, customer, or vendor for the item entry that this value entry is linked to.';
                    Visible = false;
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the source code that is linked to the entry.';
                    Visible = false;
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the general business posting group that applies to the entry.';
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for the general product posting group that applies to the entry.';
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the dimension value code for the dimension that has been chosen as Global Dimension 1.';
                    Visible = false;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the dimension value code for the dimension that has been chosen as Global Dimension 2.';
                    Visible = false;
                }
                field("Source Type";"Source Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the source type that applies to the source number that is shown in the Source No. field.';
                }
                field("Source No.";"Source No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies where the entry originated.';
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the date on the document that provides the basis for this value entry.';
                    Visible = false;
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the external document number that provides the basis for this value entry.';
                }
                field("Order Type";"Order Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies which type of transaction the entry is created from.';
                }
                field("Order No.";"Order No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the number of the order that created the entry.';
                    Visible = false;
                }
                field("Valued By Average Cost";"Valued By Average Cost")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the adjusted cost for the inventory decrease is calculated by the average cost of the item at the valuation date.';
                }
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the job that the value entry relates to.';
                    Visible = false;
                }
                field("Job Task No.";"Job Task No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the job task that is associated with the value entry.';
                    Visible = false;
                }
                field("Job Ledger Entry No.";"Job Ledger Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the job ledger entry that the value entry relates to.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }


    procedure Set(var TempValueEntry: Record "Value Entry" temporary)
    begin
        if TempValueEntry.Find('-') then
          repeat
            Rec := TempValueEntry;
            Insert;
          until TempValueEntry.Next = 0;
    end;
}

