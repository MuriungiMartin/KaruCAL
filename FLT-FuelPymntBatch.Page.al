#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69143 "FLT-Fuel Pymnt Batch"
{
    PageType = Card;
    SourceTable = UnknownTable61821;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Batch No";"Batch No")
                {
                    ApplicationArea = Basic;
                }
                field("Date Created";"Date Created")
                {
                    ApplicationArea = Basic;
                }
                field("Created by";"Created by")
                {
                    ApplicationArea = Basic;
                }
                field("Vendor No";"Vendor No")
                {
                    ApplicationArea = Basic;
                }
                field("Date Closed";"Date Closed")
                {
                    ApplicationArea = Basic;
                }
                field("Closed By";"Closed By")
                {
                    ApplicationArea = Basic;
                }
                field("Total Payable";"Total Payable")
                {
                    ApplicationArea = Basic;
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Basic;
                }
                field(Closed;Closed)
                {
                    ApplicationArea = Basic;
                }
                field("Vendor Name";"Vendor Name")
                {
                    ApplicationArea = Basic;
                }
                field(From;From)
                {
                    ApplicationArea = Basic;
                }
                field(DTo;DTo)
                {
                    ApplicationArea = Basic;
                }
                field(Invoiced;Invoiced)
                {
                    ApplicationArea = Basic;
                }
                field("Invoice No.";"Invoice No.")
                {
                    ApplicationArea = Basic;
                }
                field("Invoiced By";"Invoiced By")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control18;"FLT-Fuel Lines")
            {
                Caption = 'Line';
                Editable = false;
                SubPageLink = "Payment Batch No"=field("Batch No");
            }
        }
    }

    actions
    {
    }
}

