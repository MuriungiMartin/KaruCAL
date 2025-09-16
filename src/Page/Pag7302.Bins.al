#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7302 Bins
{
    Caption = 'Bins';
    DataCaptionExpression = GetCaption;
    DelayedInsert = true;
    PageType = List;
    SourceTable = Bin;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location from which you opened the Bins window.';
                    Visible = false;
                }
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code that uniquely describes the bin.';
                }
                field("Zone Code";"Zone Code")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies the code of the zone in which the bin is located.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the bin.';
                }
                field("Bin Type Code";"Bin Type Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the bin type that applies to the bin.';
                    Visible = false;
                }
                field("Warehouse Class Code";"Warehouse Class Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the warehouse class that applies to the bin.';
                    Visible = false;
                }
                field("Block Movement";"Block Movement")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how the movement of an item, or bin content, into or out of this bin, is blocked.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        if "Block Movement" <> xRec."Block Movement" then
                          if not Confirm(Text004,false) then
                            Error('');
                    end;
                }
                field("Special Equipment Code";"Special Equipment Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the equipment needed when working in the bin.';
                    Visible = false;
                }
                field("Bin Ranking";"Bin Ranking")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ranking of the bin. Items in the highest-ranking bins (with the highest number in the field) will be picked first.';
                    Visible = false;
                }
                field("Maximum Cubage";"Maximum Cubage")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the maximum cubage (volume) that the bin can hold.';
                    Visible = false;
                }
                field("Maximum Weight";"Maximum Weight")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the maximum weight that this bin can hold.';
                    Visible = false;
                }
                field(Empty;Empty)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the bin Specifies no items.';
                }
                field("Cross-Dock Bin";"Cross-Dock Bin")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the bin is considered a cross-dock bin.';
                    Visible = false;
                }
                field(Dedicated;Dedicated)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that quantities in the bin are protected from being picked for other demands.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Bin")
            {
                Caption = '&Bin';
                Image = Bins;
                action("&Contents")
                {
                    ApplicationArea = Basic;
                    Caption = '&Contents';
                    Image = BinContent;
                    RunObject = Page "Bin Content";
                    RunPageLink = "Location Code"=field("Location Code"),
                                  "Zone Code"=field("Zone Code"),
                                  "Bin Code"=field(Code);
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if GetFilter("Zone Code") <> '' then
          "Zone Code" := GetFilter("Zone Code");
        SetUpNewLine;
    end;

    var
        Text004: label 'Do you want to update the bin contents?';

    local procedure GetCaption(): Text[250]
    var
        ObjTransl: Record "Object Translation";
        FormCaption: Text[250];
        SourceTableName: Text[30];
    begin
        SourceTableName := ObjTransl.TranslateObject(ObjTransl."object type"::Table,14);
        FormCaption := StrSubstNo('%1 %2',SourceTableName,"Location Code");
        exit(FormCaption);
    end;
}

