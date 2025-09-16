#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 560 "Dimension Value List"
{
    Caption = 'Dimension Value List';
    DataCaptionExpression = GetFormCaption;
    Editable = true;
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
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the purpose of the dimension value.';
                    Visible = false;
                }
                field(Totaling;Totaling)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a dimension value interval or a list of dimension values.';
                    Visible = false;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that entries with this dimension value cannot be posted.';
                    Visible = false;
                }
                field("Consolidation Code";"Consolidation Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code that is used for consolidation.';
                    Visible = false;
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
    }

    trigger OnAfterGetRecord()
    begin
        NameIndent := 0;
        FormatLines;
    end;

    trigger OnOpenPage()
    begin
        GLSetup.Get;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        Text000: label 'Shortcut Dimension %1';
        [InDataSet]
        Emphasize: Boolean;
        [InDataSet]
        NameIndent: Integer;


    procedure GetSelectionFilter(): Text
    var
        DimVal: Record "Dimension Value";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(DimVal);
        exit(SelectionFilterManagement.GetSelectionFilterForDimensionValue(DimVal));
    end;


    procedure SetSelection(var DimVal: Record "Dimension Value")
    begin
        CurrPage.SetSelectionFilter(DimVal);
    end;

    local procedure GetFormCaption(): Text[250]
    begin
        if GetFilter("Dimension Code") <> '' then
          exit(GetFilter("Dimension Code"));

        if GetFilter("Global Dimension No.") = '1' then
          exit(GLSetup."Global Dimension 1 Code");

        if GetFilter("Global Dimension No.") = '2' then
          exit(GLSetup."Global Dimension 2 Code");

        exit(StrSubstNo(Text000,"Global Dimension No."));
    end;

    local procedure FormatLines()
    begin
        Emphasize := "Dimension Value Type" <> "dimension value type"::Standard;
        NameIndent := Indentation;
    end;
}

