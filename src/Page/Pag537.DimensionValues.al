#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 537 "Dimension Values"
{
    Caption = 'Dimension Values';
    DataCaptionFields = "Dimension Code";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Dimension Value";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                IndentationColumn = NameIndent;
                IndentationControls = Name;
                field("Code";Code)
                {
                    ApplicationArea = Suite;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the code for the dimension value.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Suite;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies a descriptive name for the dimension value.';
                }
                field("Dimension Value Type";"Dimension Value Type")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the purpose of the dimension value.';
                }
                field(Totaling;Totaling)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a dimension value interval or a list of dimension values.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        DimVal: Record "Dimension Value";
                        DimValList: Page "Dimension Value List";
                    begin
                        DimVal := Rec;
                        DimVal.SetRange("Dimension Code","Dimension Code");
                        DimValList.SetTableview(DimVal);
                        DimValList.LookupMode := true;
                        if DimValList.RunModal = Action::LookupOK then begin
                          DimValList.GetRecord(DimVal);
                          Text := DimVal.Code;
                          exit(true);
                        end;
                        exit(false);
                    end;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies that entries with this dimension value cannot be posted.';
                }
                field("Map-to IC Dimension Value Code";"Map-to IC Dimension Value Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which intercompany dimension value corresponds to the dimension value on the line.';
                    Visible = false;
                }
                field("Consolidation Code";"Consolidation Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code that is used for consolidation.';
                    Visible = false;
                }
                field("Global Dimension No.";"Global Dimension No.")
                {
                    ApplicationArea = Basic;
                }
                field("HOD Names";"HOD Names")
                {
                    ApplicationArea = Basic;
                }
                field(Titles;Titles)
                {
                    ApplicationArea = Basic;
                }
                field(Signature;Signature)
                {
                    ApplicationArea = Basic;
                }
                field("Faculty Name";"Faculty Name")
                {
                    ApplicationArea = Basic;
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
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Indent Dimension Values")
                {
                    ApplicationArea = Suite;
                    Caption = 'Indent Dimension Values';
                    Image = Indent;
                    RunObject = Codeunit "Dimension Value-Indent";
                    RunPageOnRec = true;
                    ToolTip = 'Indent dimension values between a Begin-Total and the matching End-Total one level to make the list easier to read.';
                }
                action("Department Signature")
                {
                    ApplicationArea = Basic;
                    Caption = 'Department Signature';
                    Image = Picture;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "Dimension Signatories";
                    RunPageLink = "Dimension Code"=field("Dimension Code"),
                                  Code=field(Code);
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        NameIndent := 0;
        FormatLine;
    end;

    trigger OnOpenPage()
    var
        DimensionCode: Code[20];
    begin
        if GetFilter("Dimension Code") <> '' then
          DimensionCode := GetRangeMin("Dimension Code");
        if DimensionCode <> '' then begin
          FilterGroup(2);
          SetRange("Dimension Code",DimensionCode);
          FilterGroup(0);
        end;
    end;

    var
        [InDataSet]
        Emphasize: Boolean;
        [InDataSet]
        NameIndent: Integer;

    local procedure FormatLine()
    begin
        Emphasize := "Dimension Value Type" <> "dimension value type"::Standard;
        NameIndent := Indentation;
    end;
}

