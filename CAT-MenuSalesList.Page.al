#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68304 "CAT-Menu Sales List"
{
    CardPageID = "CAT-Menu Sales Header";
    PageType = List;
    SourceTable = UnknownTable61170;
    SourceTableView = where(Posted=const(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Receipt No";"Receipt No")
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field("Cashier No";"Cashier No")
                {
                    ApplicationArea = Basic;
                }
                field("Customer Type";"Customer Type")
                {
                    ApplicationArea = Basic;
                }
                field("Customer No";"Customer No")
                {
                    ApplicationArea = Basic;
                }
                field("Customer Name";"Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field("Receiving Bank";"Receiving Bank")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field(Department;Department)
                {
                    ApplicationArea = Basic;
                }
                field("Contact Staff";"Contact Staff")
                {
                    ApplicationArea = Basic;
                }
                field("Sales Point";"Sales Point")
                {
                    ApplicationArea = Basic;
                }
                field("Paid Amount";"Paid Amount")
                {
                    ApplicationArea = Basic;
                }
                field(Balance;Balance)
                {
                    ApplicationArea = Basic;
                }
                field(Posted;Posted)
                {
                    ApplicationArea = Basic;
                }
                field("Cashier Name";"Cashier Name")
                {
                    ApplicationArea = Basic;
                }
                field("Sales Type";"Sales Type")
                {
                    ApplicationArea = Basic;
                }
                field("Prepayment Balance";"Prepayment Balance")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
           SetFilter("Cashier Name",UserId);
    end;
}

