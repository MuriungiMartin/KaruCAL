#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7508 "Select Item Attribute Value"
{
    Caption = 'Select Item Attribute Value';
    DataCaptionExpression = '';
    PageType = StandardDialog;
    SourceTable = "Item Attribute Value";

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field(Value;Value)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the value of the option.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        Clear(DummySelectedItemAttributeValue);
        CurrPage.SetSelectionFilter(DummySelectedItemAttributeValue);
    end;

    var
        DummySelectedItemAttributeValue: Record "Item Attribute Value";


    procedure GetSelectedValue(var ItemAttributeValue: Record "Item Attribute Value")
    begin
        ItemAttributeValue.Copy(DummySelectedItemAttributeValue);
    end;
}

