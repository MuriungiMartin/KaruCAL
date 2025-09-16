#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68763 "ACA-Student Charges Payments"
{
    PageType = List;
    SourceTable = UnknownTable61535;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Amount Paid";"Amount Paid")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Amount-""Amount Paid""";Amount-"Amount Paid")
                {
                    ApplicationArea = Basic;
                    Caption = 'Balance';
                    Editable = false;
                }
                field(Recognized;Recognized)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Recovered First";"Recovered First")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Apply to";"Apply to")
                {
                    ApplicationArea = Basic;
                    Caption = 'Apply To';
                }
                field("Applied Amount";"Applied Amount")
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

