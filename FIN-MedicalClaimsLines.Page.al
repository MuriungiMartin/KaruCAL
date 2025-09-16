#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 90026 "FIN-Medical Claims Lines"
{
    PageType = ListPart;
    SourceTable = UnknownTable90026;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Staff No.";"Staff No.")
                {
                    ApplicationArea = Basic;
                }
                field("Refferal Code";"Refferal Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Referal Description";"Referal Description")
                {
                    ApplicationArea = Basic;
                    Caption = 'Claim Description';
                }
                field("Referal Date";"Referal Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Claim Category";"Claim Category")
                {
                    ApplicationArea = Basic;
                }
                field("Claim Amount";"Claim Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Period Balance";"Period Balance")
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

