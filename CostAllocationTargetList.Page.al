#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1114 "Cost Allocation Target List"
{
    Caption = 'Cost Allocation Target List';
    CardPageID = "Cost Allocation Target Card";
    PageType = List;
    SourceTable = "Cost Allocation Target";

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Target Cost Type";"Target Cost Type")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    var
                        TmpCostAllocTarget: Record "Cost Allocation Target";
                    begin
                        TmpCostAllocTarget.CopyFilters(Rec);
                        if not TmpCostAllocTarget.FindFirst then
                          CurrPage.SaveRecord;
                    end;
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
                field("Static Base";"Static Base")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Static Weighting";"Static Weighting")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Share;Share)
                {
                    ApplicationArea = Basic;
                    BlankZero = true;

                    trigger OnValidate()
                    begin
                        UpdatePage;
                    end;
                }
                field(Percent;Percent)
                {
                    ApplicationArea = Basic;
                }
                field(Base;Base)
                {
                    ApplicationArea = Basic;
                }
                field("No. Filter";"No. Filter")
                {
                    ApplicationArea = Basic;
                }
                field("Date Filter Code";"Date Filter Code")
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
                field("Group Filter";"Group Filter")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    local procedure UpdatePage()
    begin
        CurrPage.Update(false);
    end;
}

