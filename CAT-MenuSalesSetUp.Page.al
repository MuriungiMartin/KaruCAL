#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68298 "CAT-Menu Sales SetUp"
{
    PageType = Card;
    SourceTable = UnknownTable61171;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Receipt No";"Receipt No")
                {
                    ApplicationArea = Basic;
                }
                field("Sales Template";"Sales Template")
                {
                    ApplicationArea = Basic;
                }
                field("Sales Batch";"Sales Batch")
                {
                    ApplicationArea = Basic;
                }
                field("Menu No. Series";"Menu No. Series")
                {
                    ApplicationArea = Basic;
                }
                field("Catering Income Account";"Catering Income Account")
                {
                    ApplicationArea = Basic;
                }
                field("Catering Control Account";"Catering Control Account")
                {
                    ApplicationArea = Basic;
                }
                field("Receiving Bank Account";"Receiving Bank Account")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnDeleteRecord(): Boolean
    begin
              exit(false);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
              exit(false);
    end;
}

