#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68596 "HMS Pharmacy Line"
{
    PageType = ListPart;
    SourceTable = UnknownTable61424;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Pharmacy No.";"Pharmacy No.")
                {
                    ApplicationArea = Basic;
                }
                field("Drugs Category";"Drugs Category")
                {
                    ApplicationArea = Basic;
                }
                field(Pharmacy;Pharmacy)
                {
                    ApplicationArea = Basic;
                }
                field("Drug No.";"Drug No.")
                {
                    ApplicationArea = Basic;
                }
                field("Drug Name";"Drug Name")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(Dosage1;Dosage)
                {
                    ApplicationArea = Basic;
                }
                field("Measuring Unit";"Measuring Unit")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Actual Qty";"Actual Qty")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Actual Price";"Actual Price")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Issued Quantity";"Issued Quantity")
                {
                    ApplicationArea = Basic;
                }
                field("Issued Units";"Issued Units")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Issued Price";"Issued Price")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field(Dosage;Dosage)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
                field("No Stock Drugs";"No Stock Drugs")
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

