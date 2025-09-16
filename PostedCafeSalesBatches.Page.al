#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99426 "Posted Cafe Sales Batches"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Cafeteria Sales Batches";
    SourceTableView = where("Batch Status"=filter(Posted));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(User_Id;User_Id)
                {
                    ApplicationArea = Basic;
                }
                field(Batch_Date;Batch_Date)
                {
                    ApplicationArea = Basic;
                }
                field(Batch_Id;Batch_Id)
                {
                    ApplicationArea = Basic;
                }
                field("Batch Status";"Batch Status")
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
            action(PostBatch)
            {
                ApplicationArea = Basic;
                Caption = 'Post Batch';
                Image = PostBatch;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;

                trigger OnAction()
                var
                    POSSalesHeader: Record "POS Sales Header";
                begin
                    if Rec."Batch Status" <> Rec."batch status"::New then Error('Batch is not open.');
                    Rec.CalcFields("Un-posted Receipts");
                    if Rec."Un-posted Receipts" = 0 then Error('No receipts associated with this batch');
                    if Confirm('Post receipt Batches?',true) = false then Error('Cancelled by user!');
                    POSSalesHeader.PostReceiptToJournal(Rec);
                    CurrPage.Update;
                end;
            }
            action("Up-Posted Receipts")
            {
                ApplicationArea = Basic;
                Caption = 'Up-Posted Receipts';
                Image = UntrackedQuantity;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "POS Receipts Header Lst";
                RunPageLink = "Posting date"=field(Batch_Date),
                              Cashier=field(User_Id),
                              Batch_Id=field(Batch_Id);
                RunPageView = where("Receipt Posted to Ledger"=filter(false),
                                    Posted=filter(true),
                                    "Receipt Amount"=filter(<>0));
            }
            action("Posted Receipts")
            {
                ApplicationArea = Basic;
                Caption = 'Posted Receipts';
                Image = CompareContacts;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "POS Receipts Header Lst";
                RunPageLink = "Posting date"=field(Batch_Date),
                              Cashier=field(User_Id),
                              Batch_Id=field(Batch_Id);
                RunPageView = where("Receipt Posted to Ledger"=filter(true),
                                    Posted=filter(true),
                                    "Receipt Amount"=filter(<>0));
            }
            action("All Receipts")
            {
                ApplicationArea = Basic;
                Caption = 'All Receipts';
                Image = AddToHome;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "POS Receipts Header Lst";
                RunPageLink = "Posting date"=field(Batch_Date),
                              Cashier=field(User_Id),
                              Batch_Id=field(Batch_Id);
                RunPageView = where(Posted=filter(true),
                                    "Receipt Amount"=filter(>0));
            }
        }
    }
}

