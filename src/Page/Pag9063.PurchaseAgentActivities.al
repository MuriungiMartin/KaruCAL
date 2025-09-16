#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9063 "Purchase Agent Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Purchase Cue";

    layout
    {
        area(content)
        {
            cuegroup("Pre-arrival Follow-up on Purchase Orders")
            {
                Caption = 'Pre-arrival Follow-up on Purchase Orders';
                field("To Send or Confirm";"To Send or Confirm")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Purchase Order List";
                    ToolTip = 'Specifies the number of documents to send or confirm that are displayed in the Purchase Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Upcoming Orders";"Upcoming Orders")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Purchase Order List";
                    ToolTip = 'Specifies the number of upcoming orders that are displayed in the Purchase Cue on the Role Center. The documents are filtered by today''s date.';
                }

                actions
                {
                    action("New Purchase Quote")
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Purchase Quote';
                        RunObject = Page "Purchase Quote";
                        RunPageMode = Create;
                        ToolTip = 'Create a new purchase quote.';
                    }
                    action("New Purchase Order")
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Purchase Order';
                        RunObject = Page "Purchase Order";
                        RunPageMode = Create;
                        ToolTip = 'Create a new purchase order.';
                    }
                    action("Edit Purchase Journal")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Edit Purchase Journal';
                        RunObject = Page "Purchase Journal";
                    }
                }
            }
            cuegroup("Post Arrival Follow-up")
            {
                Caption = 'Post Arrival Follow-up';
                field(OutstandingOrders;"Outstanding Purchase Orders")
                {
                    ApplicationArea = Basic;
                    Caption = 'Outstanding Purchase Orders';
                    DrillDownPageID = "Purchase Order List";
                    ToolTip = 'Specifies the number of outstanding purchase orders that are displayed in the Purchase Cue on the Role Center. The documents are filtered by today''s date.';

                    trigger OnDrillDown()
                    begin
                        ShowOrders(FieldNo("Outstanding Purchase Orders"));
                    end;
                }
                field("Purchase Return Orders - All";"Purchase Return Orders - All")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Purchase Return Order List";
                    ToolTip = 'Specifies the number of purchase return orders that are displayed in the Purchase Cue on the Role Center. The documents are filtered by today''s date.';
                }

                actions
                {
                    action(Navigate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Navigate';
                        Image = Navigate;
                        RunObject = Page Navigate;
                        ToolTip = 'View and link to all entries that exist for the document number on the selected line.';
                    }
                    action("New Purchase Return Order")
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Purchase Return Order';
                        RunObject = Page "Purchase Return Order";
                        RunPageMode = Create;
                        ToolTip = 'Create a new purchase return order.';
                    }
                }
            }
            cuegroup("Purchase Orders - Authorize for Payment")
            {
                Caption = 'Purchase Orders - Authorize for Payment';
                field(NotInvoiced;"Not Invoiced")
                {
                    ApplicationArea = Basic;
                    Caption = 'Not Invoiced';
                    DrillDownPageID = "Purchase Order List";
                    ToolTip = 'Specifies the orders that are not invoiced that are displayed in the Purchase Cue on the Role Center. The documents are filtered by today''s date.';

                    trigger OnDrillDown()
                    begin
                        ShowOrders(FieldNo("Not Invoiced"));
                    end;
                }
                field(PartiallyInvoiced;"Partially Invoiced")
                {
                    ApplicationArea = Basic;
                    Caption = 'Partially Invoiced';
                    DrillDownPageID = "Purchase Order List";
                    ToolTip = 'Specifies the number of partially invoiced orders that are displayed in the Purchase Cue on the Role Center. The documents are filtered by today''s date.';

                    trigger OnDrillDown()
                    begin
                        ShowOrders(FieldNo("Partially Invoiced"));
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        CalculateCueFieldValues;
    end;

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
          Init;
          Insert;
        end;

        SetRespCenterFilter;
        SetFilter("Date Filter",'>=%1',WorkDate);
    end;

    local procedure CalculateCueFieldValues()
    begin
        if FieldActive("Outstanding Purchase Orders") then
          "Outstanding Purchase Orders" := CountOrders(FieldNo("Outstanding Purchase Orders"));

        if FieldActive("Not Invoiced") then
          "Not Invoiced" := CountOrders(FieldNo("Not Invoiced"));

        if FieldActive("Partially Invoiced") then
          "Partially Invoiced" := CountOrders(FieldNo("Partially Invoiced"));
    end;
}

