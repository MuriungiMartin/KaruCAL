#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 90011 "Barcode Card"
{
    DataCaptionExpression = Value;
    PageType = Card;
    SourceTable = UnknownTable90010;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Value;Value)
                {
                    ApplicationArea = Basic;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
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
            group(Options)
            {
                group(Control1000000016)
                {
                    Visible = Type <> Type::QR;
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
                }
                group(Control1000000017)
                {
                    Visible = Type = Type::QR;
                    field("ECC Level";"ECC Level")
                    {
                        ApplicationArea = Basic;
                    }
                    field(Size;Size)
                    {
                        ApplicationArea = Basic;
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(GenerateBarCode)
            {
                ApplicationArea = Basic;
                Caption = 'Generate Bar Code';
                Image = BarCode;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    GenerateBarCode();
                end;
            }
        }
    }
}

