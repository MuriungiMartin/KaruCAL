#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69078 "CAT-Cafe. Item Inventory List2"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61782;
    SourceTableView = where("Quantity in Store"=filter(>0));

    layout
    {
        area(content)
        {
            group(DateFilter)
            {
                Caption = 'Date Filter                            (The Meals Inventory is filtered per date.)';
                field(menudate;menudate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Menu Date';
                }
            }
            repeater(Group)
            {
                field("Menu Date";"Menu Date")
                {
                    ApplicationArea = Basic;
                }
                field("Cafeteria Section";"Cafeteria Section")
                {
                    ApplicationArea = Basic;
                }
                field("Item No";"Item No")
                {
                    ApplicationArea = Basic;
                }
                field("Item Description";"Item Description")
                {
                    ApplicationArea = Basic;
                }
                field(Category;Category)
                {
                    ApplicationArea = Basic;
                }
                field("Price Per Item";"Price Per Item")
                {
                    ApplicationArea = Basic;
                }
                field("Quantity in Store";"Quantity in Store")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Journal)
            {
                Caption = 'Cafe Item Journal';
                Description = 'Posting Meal Items for sale';
                Image = Transactions;
                action(Journal_Lines)
                {
                    ApplicationArea = Basic;
                    Caption = 'View Journal Lines';
                    Image = AddAction;
                    Promoted = true;
                    RunObject = Page "CAT-Cafe. Meal Journal Line";
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
         menudate:=Today;
         //Rec.RESET;
         Rec.SetFilter("Menu Date",'=%1',Today);
        // IF Rec.FIND('-') THEN BEGIN
        // END;
    end;

    trigger OnOpenPage()
    begin
         menudate:=Today;
         //Rec.RESET;
         Rec.SetFilter("Menu Date",'=%1',Today);
        // IF Rec.FIND('-') THEN BEGIN
        // END;
    end;

    var
        menudate: Date;
}

