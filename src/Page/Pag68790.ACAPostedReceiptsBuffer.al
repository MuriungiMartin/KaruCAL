#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68790 "ACA-Posted Receipts Buffer"
{
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable61552;
    SourceTableView = where(Posted=const(Yes));

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Transaction Code";"Transaction Code")
                {
                    ApplicationArea = Basic;
                }
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field(Posted;Posted)
                {
                    ApplicationArea = Basic;
                }
                field("Receipt No";"Receipt No")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Receipting)
            {
                Caption = 'Receipting';
            }
        }
    }

    var
        StudPayments: Record UnknownRecord61536;
        RcptBuffer: Integer;
}

