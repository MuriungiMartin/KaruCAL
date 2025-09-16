#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69074 "CAT-Cafe. Meals Setup List"
{
    CardPageID = "CAT-Cafe. Meals Setup Card";
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable61768;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Discription;Discription)
                {
                    ApplicationArea = Basic;
                }
                field(Price;Price)
                {
                    ApplicationArea = Basic;
                }
                field(Category;Category)
                {
                    ApplicationArea = Basic;
                }
                field("Food Value";"Food Value")
                {
                    ApplicationArea = Basic;
                }
                field(Active;Active)
                {
                    ApplicationArea = Basic;
                }
                field("Exclude in Summary";"Exclude in Summary")
                {
                    ApplicationArea = Basic;
                }
                field("Recipe Cost";"Recipe Cost")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Recipe Price";"Recipe Price")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Recipe Setup")
            {
                ApplicationArea = Basic;
                Caption = 'Recipe Setup';
                Image = SetupPayment;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "CAT-Meal Recipe";
                RunPageLink = "Meal Code"=field(Code);
            }
            action("Update Meal Price from Recipe")
            {
                ApplicationArea = Basic;
                Caption = 'Update Meal Price from Recipe';
                Image = UpdateUnitCost;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('This will update the set prices with computed Prices from the Recipe, Continue?',false)=false then
                      Error('Cancelled by User!');

                    CalcFields("Recipe Cost","Recipe Price");
                    Price:="Recipe Price";
                    Modify;
                    CurrPage.Update;
                end;
            }
            action("Recipe Report")
            {
                ApplicationArea = Basic;
                Caption = 'Recipe Report';
                Image = AddWatch;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "CAT-Meals Recipe Report";
            }
        }
    }
}

