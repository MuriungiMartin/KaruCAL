#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99402 "POS Items"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = "POS Items";
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
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Unit Of measure";"Unit Of measure")
                {
                    ApplicationArea = Basic;
                }
                field("Student Price";"Student Price")
                {
                    ApplicationArea = Basic;
                }
                field("Staff Price";"Staff Price")
                {
                    ApplicationArea = Basic;
                }
                field(Inventory;Inventory)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
Page "Pos Unit of measure";
                ""
