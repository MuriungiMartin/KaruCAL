#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77078 "FIN-Budgetary Comparison List"
{
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable77077;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Budget Name";"Budget Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("G/L Account No.";"G/L Account No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Account Name";"Account Name")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Allocation;Allocation)
                {
                    ApplicationArea = Basic;
                }
                field(Utilized;Utilized)
                {
                    ApplicationArea = Basic;
                }
                field(Balance;Balance)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
Report "Budget Summary Update";

                trigger OnAction()
                begin
                    //Rec.CalculateBal();
                """end""";""

