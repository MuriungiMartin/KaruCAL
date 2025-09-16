#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1109 "Cost Allocation Target Card"
{
    AutoSplitKey = true;
    Caption = 'Cost Allocation Target Card';
    PageType = Card;
    SourceTable = "Cost Allocation Target";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(ID;ID)
                {
                    ApplicationArea = Basic;
                }
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic;
                }
                field("Target Cost Type";"Target Cost Type")
                {
                    ApplicationArea = Basic;
                }
                field("Target Cost Center";"Target Cost Center")
                {
                    ApplicationArea = Basic;
                }
                field("Target Cost Object";"Target Cost Object")
                {
                    ApplicationArea = Basic;
                }
                field("Allocation Target Type";"Allocation Target Type")
                {
                    ApplicationArea = Basic;
                }
                field("Percent per Share";"Percent per Share")
                {
                    ApplicationArea = Basic;
                }
                field("Amount per Share";"Amount per Share")
                {
                    ApplicationArea = Basic;
                }
                field(Base;Base)
                {
                    ApplicationArea = Basic;
                }
                field("Static Base";"Static Base")
                {
                    ApplicationArea = Basic;
                }
                field("Static Weighting";"Static Weighting")
                {
                    ApplicationArea = Basic;
                }
                field(Share;Share)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(false);
                    end;
                }
                field(Percent;Percent)
                {
                    ApplicationArea = Basic;
                }
            }
            group("Dyn. Allocation")
            {
                Caption = 'Dyn. Allocation';
                field("No. Filter";"No. Filter")
                {
                    ApplicationArea = Basic;
                }
                field("Cost Center Filter";"Cost Center Filter")
                {
                    ApplicationArea = Basic;
                }
                field("Cost Object Filter";"Cost Object Filter")
                {
                    ApplicationArea = Basic;
                }
                field("Date Filter Code";"Date Filter Code")
                {
                    ApplicationArea = Basic;
                }
                field("Group Filter";"Group Filter")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Statistics)
            {
                Caption = 'Statistics';
                field("Share Updated on";"Share Updated on")
                {
                    ApplicationArea = Basic;
                }
                field("Last Date Modified";"Last Date Modified")
                {
                    ApplicationArea = Basic;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

