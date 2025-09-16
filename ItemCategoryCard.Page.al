#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5733 "Item Category Card"
{
    Caption = 'Item Category Card';
    DeleteAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Item Category";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    NotBlank = true;
                    ToolTip = 'Specifies the item category.';

                    trigger OnValidate()
                    begin
                        if (xRec.Code <> '') and (xRec.Code <> Code) then
                          CurrPage.Attributes.Page.SaveAttributes(Code);
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the item category.';
                }
                field("Parent Category";"Parent Category")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the item category that this item category belongs to. Item attributes that are assigned to a parent item category also apply to the child item category.';

                    trigger OnValidate()
                    var
                        NewParentCategoryCode: Code[20];
                    begin
                        if Code <> '' then begin
                          NewParentCategoryCode := "Parent Category";
                          Get(Code);
                          if "Parent Category" <> NewParentCategoryCode then begin
                            "Parent Category" := NewParentCategoryCode;
                            Modify;
                          end;
                          PersistCategoryAttributes;
                        end;
                    end;
                }
            }
            part(Attributes;"Item Category Attributes")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Attributes';
                ShowFilter = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Delete)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Delete';
                Enabled = (not "Has Children");
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Delete the item category.';

                trigger OnAction()
                begin
                    if Confirm(StrSubstNo(DeleteQst,Code)) then
                      Delete(true);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Code <> '' then begin
          CalcFields("Has Children");
          CurrPage.Attributes.Page.LoadAttributes(Code);
        end;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CurrPage.Attributes.Page.SetItemCategoryCode(Code);
    end;

    trigger OnOpenPage()
    begin
        if Code <> '' then
          CurrPage.Attributes.Page.LoadAttributes(Code);
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if Code <> '' then begin
          ItemCategoryManagement.UpdatePresentationOrder;
          CurrPage.Attributes.Page.SaveAttributes(Code);
        end;
    end;

    var
        ItemCategoryManagement: Codeunit "Item Category Management";
        DeleteQst: label 'Delete %1?', Comment='%1 - item category name';

    local procedure PersistCategoryAttributes()
    begin
        CurrPage.Attributes.Page.SaveAttributes(Code);
        CurrPage.Attributes.Page.LoadAttributes(Code);
        CurrPage.Update(true);
    end;
}

