#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68309 "CAT-Catering Requisition Line"
{
    PageType = List;
    SourceTable = UnknownTable61147;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Type No.";"Type No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        //retrieve the description
                            getDescription();
                        //retrieve the unit cost of the item from the database
                            getItemUnitDirectCost();
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Purpose;Purpose)
                {
                    ApplicationArea = Basic;
                }
                field("Remaining Qty";"Remaining Qty")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Qty;Qty)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        "Total Units Due":=Qty * "Units per Unit of Measure";
                        "Total Cost":="Total Units Due" * "Unit Direct Cost";
                    end;
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        //check if the type is item
                        if Type=Type::Item then
                            begin
                                if "Units per Unit of Measure"=0 then
                                     begin
                                         getItemUnitsPerUnitOfMeasure;
                                         "Total Units Due":=Qty * "Units per Unit of Measure";
                                         "Total Cost":="Total Units Due" * "Unit Direct Cost";
                                     end;
                            end;
                    end;
                }
                field("Units per Unit of Measure";"Units per Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Editable = true;

                    trigger OnValidate()
                    begin
                        "Total Units Due":=Qty * "Units per Unit of Measure";
                        "Total Cost":="Total Units Due" * "Unit Direct Cost";
                    end;
                }
                field("Unit Direct Cost";"Unit Direct Cost")
                {
                    ApplicationArea = Basic;
                    Editable = true;

                    trigger OnValidate()
                    begin
                        "Total Units Due":=Qty * "Units per Unit of Measure";
                        "Total Cost":="Total Units Due" * "Unit Direct Cost";
                    end;
                }
                field("Total Units Due";"Total Units Due")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Total Cost";"Total Cost")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
              exit(false);
    end;

    var
        "Item Unit of Measure": Record "Item Unit of Measure";
        Item: Record Item;
        GLAccount: Record "G/L Account";
        "Fixed Asset": Record "Fixed Asset";


    procedure getDescription()
    begin
        //check the type of item being requisitioned for
        if Type=Type::Item then
            begin
                Item.Reset;
                if Item.Get("Type No.") then
                    begin
                        Description:=Item.Description;
                    end;
            end
        else if Type=Type::"2" then
            begin
               "Fixed Asset".Reset;
               if "Fixed Asset".Get("Type No.") then
                   begin
                       Description:="Fixed Asset".Description;
                   end;
            end
        else if Type=Type::"1" then
            begin
                GLAccount.Reset;
                if GLAccount.Get("Type No.") then
                    begin
                        Description:=GLAccount.Name;
                    end;
            end;
    end;


    procedure getItemUnitsPerUnitOfMeasure()
    begin
        //reset the item unit of measure record
        "Item Unit of Measure".Reset;
        "Item Unit of Measure".SetRange("Item Unit of Measure"."Item No.","Type No.");
        "Item Unit of Measure".SetRange("Item Unit of Measure".Code,"Unit of Measure");

        if "Item Unit of Measure".Find('-') then
            begin
                "Units per Unit of Measure":="Item Unit of Measure"."Qty. per Unit of Measure"
            end
        else
            begin
                "Units per Unit of Measure":=0;
            end;
    end;


    procedure getItemUnitDirectCost()
    begin
        //get the item direct cost from the database
        Item.Reset;
        if Type=Type::Item then
            begin
                if Item.Get("Type No.") then "Unit Direct Cost":=Item."Unit Cost" else "Unit Direct Cost":=0;
            end;
    end;
}

