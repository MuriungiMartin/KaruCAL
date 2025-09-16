#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68295 "CAT-Food Menu Card"
{
    PageType = Document;
    SourceTable = UnknownTable61167;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Items Cost";"Items Cost")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                          Amount:=("Unit Cost"*Quantity)+"Items Cost";
                    end;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                    Editable = false;

                    trigger OnValidate()
                    begin
                           Amount:="Unit Cost"+"Items Cost";
                    end;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                           Amount:=("Unit Cost"*Quantity)+"Items Cost";
                    end;
                }
                field("Units Of Measure";"Units Of Measure")
                {
                    ApplicationArea = Basic;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                part(Control1000000002;"CAT-Food Menu Line")
                {
                    Caption = 'Recipe';
                    SubPageLink = Menu=field(Code),
                                  Type=field(Type);
                }
            }
        }
    }

    actions
    {
    }

    trigger OnModifyRecord(): Boolean
    begin
           Amount:="Items Cost"+"Unit Cost";
    end;

    local procedure AmountOnInputChange(var Text: Text[1024])
    begin
          Amount:="Unit Cost"+"Items Cost";
    end;
}

