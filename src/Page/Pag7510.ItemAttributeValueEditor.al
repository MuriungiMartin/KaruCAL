#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7510 "Item Attribute Value Editor"
{
    Caption = 'Item Attribute Values';
    PageType = StandardDialog;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            part(ItemAttributeValueList;"Item Attribute Value List")
            {
                ApplicationArea = Basic,Suite;
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        CurrPage.ItemAttributeValueList.Page.LoadAttributes("No.");
    end;
}

