#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 65003 "Posted Direct Sales"
{
    ApplicationArea = Basic;
    CardPageID = "Posted Cafe Sales Header";
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Sales Shipment Header";
    SourceTableView = where("Cash Sale Order"=filter(true));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field("Order No.";"Order No.")
                {
                    ApplicationArea = Basic;
                }
                field("Amount Paid";"Amount Paid")
                {
                    ApplicationArea = Basic;
                }
                field("Period Month";"Period Month")
                {
                    ApplicationArea = Basic;
                }
                field("Paybill Amount";"Paybill Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Order Date";"Order Date")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Description";"Posting Description")
                {
                    ApplicationArea = Basic;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(PrintCopy)
            {
                ApplicationArea = Basic;
                Caption = 'Print Copy';
                Image = Copy;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Print Receipt
                    if Confirm('Print Copy?',true)=false then Error('Cancelled!');
                    SalesShipmentHeader.Reset;
                    SalesShipmentHeader.SetRange(SalesShipmentHeader."No.","No.");
                    if SalesShipmentHeader.Find('-') then begin
                       // Load and Print Receipt Here
                      Report.Run(65001,false,true,SalesShipmentHeader);
                      end;
                end;
            }
        }
    }

    var
        SalesShipmentHeader: Record "Sales Shipment Header";
}

