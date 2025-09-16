#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6052 "Service Contract Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Service Contract Line";
    SourceTableView = where("Contract Type"=filter(Contract));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Service Item No.";"Service Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service item that is subject to the service contract.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ServContractMgt: Codeunit ServContractManagement;
                    begin
                        ServContractMgt.LookupServItemNo(Rec);
                        if xRec.Get("Contract Type","Contract No.","Line No.") then;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the service item that is subject to the contract.';
                }
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ship-to code for the customer associated with the service contract or service item.';
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the unit of measure used when the service item was sold.';
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the serial number of the service item that is subject to the contract.';

                    trigger OnAssistEdit()
                    begin
                        Clear(ItemLedgerEntry);
                        ItemLedgerEntry.SetRange("Item No.","Item No.");
                        ItemLedgerEntry.SetRange("Variant Code","Variant Code");
                        ItemLedgerEntry.SetRange("Serial No.","Serial No.");
                        Page.Run(Page::"Item Ledger Entries",ItemLedgerEntry);
                    end;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item No.';
                    ToolTip = 'Specifies the number of the item linked to the service item in the service contract.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code that specifies the variant of the service item on this line.';
                    Visible = false;
                }
                field("Response Time (Hours)";"Response Time (Hours)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the response time for the service item associated with the service contract.';
                }
                field("Line Cost";"Line Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the calculated cost of the service item line in the service contract or contract quote.';
                }
                field("Line Value";"Line Value")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the service item line in the contract or contract quote.';
                }
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the line discount percentage that will be provided on the service item line.';
                }
                field("Line Discount Amount";"Line Discount Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the amount of the discount that will be provided on the service contract line.';
                    Visible = false;
                }
                field("Line Amount";"Line Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the net amount (excluding the invoice discount amount) of the service item line.';
                }
                field(Profit;Profit)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the profit, expressed as the difference between the Line Amount and Line Cost fields on the service contract line.';
                }
                field("Service Period";"Service Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the period of time that must pass between each servicing of an item.';
                }
                field("Next Planned Service Date";"Next Planned Service Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date of the next planned service on the item included in the contract.';
                }
                field("Last Planned Service Date";"Last Planned Service Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date of the last planned service on this item.';
                    Visible = false;
                }
                field("Last Preventive Maint. Date";"Last Preventive Maint. Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the last time preventative service was performed on this item.';
                    Visible = false;
                }
                field("Last Service Date";"Last Service Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the service item on the line was last serviced.';
                    Visible = false;
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the starting date of the service contract.';
                }
                field("Contract Expiration Date";"Contract Expiration Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when an item should be removed from the contract.';
                }
                field("Credit Memo Date";"Credit Memo Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when you can create a credit memo for the service item that needs to be removed from the service contract.';
                }
                field(Credited;Credited)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the service contract line has been credited.';
                    Visible = false;
                }
                field("New Line";"New Line")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the service contract line is new or existing.';
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
                action("&Comments")
                {
                    ApplicationArea = Basic;
                    Caption = '&Comments';
                    Image = ViewComments;

                    trigger OnAction()
                    begin
                        ShowComments;
                    end;
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        if "Contract Status" = "contract status"::Signed then begin
          ServContractLine.CopyFilters(Rec);
          CurrPage.SetSelectionFilter(ServContractLine);
          NoOfSelectedLines := ServContractLine.Count;
          if NoOfSelectedLines = 1 then
            CreateCreditfromContractLines.SetSelectionFilterNo(NoOfSelectedLines);
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetupNewLine;
    end;

    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ServContractLine: Record "Service Contract Line";
        CreateCreditfromContractLines: Codeunit CreateCreditfromContractLines;
        NoOfSelectedLines: Integer;
}

