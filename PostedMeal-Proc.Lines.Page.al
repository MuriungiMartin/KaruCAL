#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99912 "Posted Meal-Proc. Lines"
{
    AutoSplitKey = false;
    LinksAllowed = false;
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
                field("BOM Count";"BOM Count")
                {
                    ApplicationArea = Basic;
                    Editable = false;
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

    var
        ProductionCustProdSource: Record UnknownRecord99902;
}

