#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 36 "Assembly BOM"
{
    AutoSplitKey = true;
    Caption = 'Assembly BOM';
    DataCaptionFields = "Parent Item No.";
    PageType = List;
    SourceTable = "BOM Component";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the assembly BOM component is an item or a resource.';

                    trigger OnValidate()
                    begin
                        IsEmptyOrItem := Type in [Type::" ",Type::Item];
                    end;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item or resource that is part of the assembly BOM.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Inserts a variant code in this field if the BOM component is an item variant.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the assembly BOM component.';
                }
                field("Assembly BOM";"Assembly BOM")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies Yes if the assembly BOM component is an assembly BOM.';
                }
                field("Quantity per";"Quantity per")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the assembly BOM component are required in the assembly BOM.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the assembly BOM component''s unit of measure.';
                }
                field("Installed in Item No.";"Installed in Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which service item the component on the line is used in.';
                }
                field(Position;Position)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the component''s position in the assembly BOM structure.';
                }
                field("Position 2";"Position 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the component''s position in the assembly BOM structure.';
                    Visible = false;
                }
                field("Position 3";"Position 3")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the component''s position in the assembly BOM structure.';
                    Visible = false;
                }
                field("Machine No.";"Machine No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a machine that should be used when processing the component on this line of the assembly BOM.';
                    Visible = false;
                }
                field("Lead-Time Offset";"Lead-Time Offset")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the total number of days required to assemble the item on the assembly BOM line.';
                    Visible = false;
                }
                field("Resource Usage Type";"Resource Usage Type")
                {
                    ApplicationArea = Basic;
                    Editable = not IsEmptyOrItem;
                    HideValue = IsEmptyOrItem;
                    ToolTip = 'Specifies how the cost of the resource on the assembly BOM is allocated during assembly.';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control18;"Assembly Item - Details")
            {
                SubPageLink = "No."=field("Parent Item No.");
            }
            systempart(Control17;Links)
            {
                Visible = false;
            }
            systempart(Control11;Notes)
            {
                Visible = false;
            }
            part(Control13;"Component - Item Details")
            {
                SubPageLink = "No."=field("No.");
            }
            part(Control9;"Component - Resource Details")
            {
                SubPageLink = "No."=field("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("E&xplode BOM")
            {
                ApplicationArea = Basic;
                Caption = 'E&xplode BOM';
                Image = ExplodeBOM;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Codeunit "BOM-Explode BOM";
            }
            action(CalcStandardCost)
            {
                ApplicationArea = Basic;
                Caption = 'Calc. Standard Cost';
                Image = CalculateCost;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    CalcStdCost: Codeunit "Calculate Standard Cost";
                begin
                    CalcStdCost.CalcItem("Parent Item No.",true)
                end;
            }
            action(CalcUnitPrice)
            {
                ApplicationArea = Basic;
                Caption = 'Calc. Unit Price';
                Image = SuggestItemPrice;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    CalcStdCost: Codeunit "Calculate Standard Cost";
                begin
                    CalcStdCost.CalcAssemblyItemPrice("Parent Item No.")
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        IsEmptyOrItem := Type in [Type::" ",Type::Item];
    end;

    trigger OnAfterGetRecord()
    begin
        IsEmptyOrItem := Type in [Type::" ",Type::Item];
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        IsEmptyOrItem := Type in [Type::" ",Type::Item];
    end;

    var
        [InDataSet]
        IsEmptyOrItem: Boolean;
}

