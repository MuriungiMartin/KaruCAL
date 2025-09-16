#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99906 "Meal-Proc. Batch Lines"
{
    AutoSplitKey = false;
    LinksAllowed = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = UnknownTable99901;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                FreezeColumn = Control1000000041;
                field("Item Code";"Item Code")
                {
                    ApplicationArea = Basic;
                }
                field("Item Description";"Item Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Production  Area";"Production  Area")
                {
                    ApplicationArea = Basic;
                }
                field("Required QTY";"Required QTY")
                {
                    ApplicationArea = Basic;
                }
                field("Requirered Unit of Measure";"Requirered Unit of Measure")
                {
                    ApplicationArea = Basic;
                }
                field("BOM Count";"BOM Count")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Batch Serial";"Batch Serial")
                {
                    ApplicationArea = Basic;
                }
                field("Date of Manufacture";"Date of Manufacture")
                {
                    ApplicationArea = Basic;
                }
                field("Expiry Date";"Expiry Date")
                {
                    ApplicationArea = Basic;
                }
                field(Approve;Approve)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Reject;Reject)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Reject Reason";"Reject Reason")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(ActionGroup1000000012)
            {
                action("Create Transfer Order")
                {
                    ApplicationArea = Basic;
                    Image = TransferOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //TESTFIELD(Status,Status::Posted);
                        //"Transfer Order Created":="Transfer Order Created"::"1";
                        //CreateTransferOrder;
                    end;
                }
            }
        }
    }

    var
        ProductionCustProdSource: Record UnknownRecord99902;
}

