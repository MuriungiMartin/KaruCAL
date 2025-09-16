#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77390 "Core_Banking Posted List"
{
    ApplicationArea = Basic;
    CardPageID = Core_Banking_Posted_Card;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Core_Banking Header";
    SourceTableView = where("Batch Is Posted"=filter(true));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Statement No";"Statement No")
                {
                    ApplicationArea = Basic;
                }
                field("Created By";"Created By")
                {
                    ApplicationArea = Basic;
                }
                field(Bank_Code;Bank_Code)
                {
                    ApplicationArea = Basic;
                }
                field("Bank Name";"Bank Name")
                {
                    ApplicationArea = Basic;
                }
                field("Date Created";"Date Created")
                {
                    ApplicationArea = Basic;
                }
                field("Time Created";"Time Created")
                {
                    ApplicationArea = Basic;
                }
                field("Total Amount";"Total Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Number of Transactions";"Number of Transactions")
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
            action(FundingCat)
            {
                ApplicationArea = Basic;
                Caption = 'Funding Categories';
                Image = AddAction;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Student Funding Categories";
            }
        }
    }
}

