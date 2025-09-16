#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 90010 "Barcode List"
{
    CardPageID = "Barcode Card";
    PageType = List;
    SourceTable = UnknownTable90010;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Value;Value)
                {
                    ApplicationArea = Basic;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field(Width;Width)
                {
                    ApplicationArea = Basic;
                }
                field(Height;Height)
                {
                    ApplicationArea = Basic;
                }
                field("Include Text";"Include Text")
                {
                    ApplicationArea = Basic;
                }
                field(Border;Border)
                {
                    ApplicationArea = Basic;
                }
                field("Reverse Colors";"Reverse Colors")
                {
                    ApplicationArea = Basic;
                }
                field("ECC Level";"ECC Level")
                {
                    ApplicationArea = Basic;
                }
                field(Size;Size)
                {
                    ApplicationArea = Basic;
                }
                field("Image Type";"Image Type")
                {
                    ApplicationArea = Basic;
                }
                field(Image;Image)
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

