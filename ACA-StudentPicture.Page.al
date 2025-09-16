#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68855 "ACA-Student Picture"
{
    PageType = Card;
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            group("Student Picture")
            {
                field(Picture;Picture)
                {
                    ApplicationArea = Basic;
                }
            }
            group(Control1000000004)
            {
                field("Barcode Picture";"Barcode Picture")
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

