#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99907 "Meal-Proc. Order Details"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = UnknownTable99902;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Parent Item";"Parent Item")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                    Visible = false;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Production  Area";"Production  Area")
                {
                    ApplicationArea = Basic;
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                }
                field("Item Quantity";"Item Quantity")
                {
                    ApplicationArea = Basic;
                }
                field("Control Unit of Measure";"Control Unit of Measure")
                {
                    ApplicationArea = Basic;
                }
                field("BOM Design Quantity";"BOM Design Quantity")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
                field("Consumption Quantiry";"Consumption Quantiry")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        editableStatus:=true;
        Rec.CalcFields(Approve);
        Rec.CalcFields(Reject);
        if ((Approve) or (Reject)) then editableStatus:=false;
    end;

    var
        editableStatus: Boolean;
}

