#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1238 "Transformation Rule Card"
{
    Caption = 'Transformation Rule Card';
    PageType = Card;
    SourceTable = "Transformation Rule";

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
                    ToolTip = 'Specifies rules for how text that was imported from an external file is transformed to a supported value that can be mapped to the specified field in Dynamics NAV.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies rules for how text that was imported from an external file is transformed to a supported value that can be mapped to the specified field in Dynamics NAV.';
                }
                field("Transformation Type";"Transformation Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies rules for how text that was imported from an external file is transformed to a supported value that can be mapped to the specified field in Dynamics NAV.';

                    trigger OnValidate()
                    begin
                        UpdateEnabled
                    end;
                }
                field("Next Transformation Rule";"Next Transformation Rule")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the transformation rule that takes the result of this rule and transforms the value.';

                    trigger OnAssistEdit()
                    begin
                        EditNextTransformationRule;
                    end;
                }
                group(Control19)
                {
                    Visible = FindValueVisibleExpr;
                    field("Find Value";"Find Value")
                    {
                        ApplicationArea = Basic;
                        ToolTip = 'Used in the Transformation Rule table to specify rules for how text that was imported from an external file is transformed to a supported value that can be mapped to the specified field in Microsoft Dynamics NAV.';
                    }
                }
                group(Control20)
                {
                    Visible = ReplaceValueVisibleExpr;
                    field("Replace Value";"Replace Value")
                    {
                        ApplicationArea = Basic;
                        ToolTip = 'Used in the Transformation Rule table to specify rules for how text that was imported from an external file is transformed to a supported value that can be mapped to the specified field in Microsoft Dynamics NAV.';
                    }
                }
                group(Control21)
                {
                    Visible = StartPositionVisibleExpr;
                    field("Start Position";"Start Position")
                    {
                        ApplicationArea = Basic;
                        ToolTip = 'Used in the Transformation Rule table to specify rules for how text that was imported from an external file is transformed to a supported value that can be mapped to the specified field in Microsoft Dynamics NAV.';
                    }
                    field("Starting Text";"Starting Text")
                    {
                        ApplicationArea = Basic;
                    }
                }
                group(Control22)
                {
                    Visible = LengthVisibleExpr;
                    field(Length;Length)
                    {
                        ApplicationArea = Basic;
                        ToolTip = 'Used in the Transformation Rule table to specify rules for how text that was imported from an external file is transformed to a supported value that can be mapped to the specified field in Microsoft Dynamics NAV.';
                    }
                    field("Ending Text";"Ending Text")
                    {
                        ApplicationArea = Basic;
                    }
                }
                group(Control23)
                {
                    Visible = DateFormatVisibleExpr;
                    field("Data Format";"Data Format")
                    {
                        ApplicationArea = Basic;
                        ToolTip = 'Used in the Transformation Rule table to specify rules for how text that was imported from an external file is transformed to a supported value that can be mapped to the specified field in Microsoft Dynamics NAV.';
                    }
                }
                group(Control24)
                {
                    Visible = DataFormattingCultureVisibleExpr;
                    field("Data Formatting Culture";"Data Formatting Culture")
                    {
                        ApplicationArea = Basic;
                        ToolTip = 'Used in the Transformation Rule table to specify rules for how text that was imported from an external file is transformed to a supported value that can be mapped to the specified field in Microsoft Dynamics NAV.';
                    }
                }
            }
            group(Test)
            {
                Caption = 'Test';
                field(TestText;TestText)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Test Text';
                    MultiLine = true;
                    ToolTip = 'Specifies rules for how text that was imported from an external file is transformed to a supported value that can be mapped to the specified field in Dynamics NAV.';
                }
                group(Control18)
                {
                    field(ResultText;ResultText)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Result';
                        Editable = false;
                        ToolTip = 'Specifies rules for how text that was imported from an external file is transformed to a supported value that can be mapped to the specified field in Dynamics NAV.';
                    }
                    field(UpdateResultLbl;UpdateResultLbl)
                    {
                        ApplicationArea = Basic,Suite;
                        Editable = false;
                        ShowCaption = false;

                        trigger OnDrillDown()
                        begin
                            ResultText := TransformText(TestText);
                        end;
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateEnabled;
    end;

    var
        FindValueVisibleExpr: Boolean;
        ReplaceValueVisibleExpr: Boolean;
        StartPositionVisibleExpr: Boolean;
        LengthVisibleExpr: Boolean;
        DateFormatVisibleExpr: Boolean;
        DataFormattingCultureVisibleExpr: Boolean;
        TestText: Text;
        ResultText: Text;
        UpdateResultLbl: label 'Update';

    local procedure UpdateEnabled()
    begin
        FindValueVisibleExpr :=
          "Transformation Type" in ["transformation type"::Replace,"transformation type"::"Regular Expression - Replace",
                                    "transformation type"::"Regular Expression - Match"];
        ReplaceValueVisibleExpr :=
          "Transformation Type" in ["transformation type"::"Regular Expression - Replace","transformation type"::Replace];
        StartPositionVisibleExpr :=
          "Transformation Type" in ["transformation type"::Substring];
        LengthVisibleExpr :=
          "Transformation Type" in ["transformation type"::Substring];
        DateFormatVisibleExpr :=
          "Transformation Type" in ["transformation type"::"Date and Time Formatting","transformation type"::"Decimal Formatting"];
        DataFormattingCultureVisibleExpr :=
          "Transformation Type" in ["transformation type"::"Date and Time Formatting","transformation type"::"Decimal Formatting"];
    end;
}

