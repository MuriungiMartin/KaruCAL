#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 586 "XBRL G/L Map Lines"
{
    AutoSplitKey = true;
    Caption = 'XBRL G/L Map Lines';
    DataCaptionExpression = GetCaption;
    PageType = List;
    SourceTable = "XBRL G/L Map Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("G/L Account Filter";"G/L Account Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the general ledger accounts that will be used to generate the exported data contained in the instance document. Only posting accounts will be used.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        GLAccList: Page "G/L Account List";
                    begin
                        GLAccList.LookupMode(true);
                        if not (GLAccList.RunModal = Action::LookupOK) then
                          exit(false);

                        Text := GLAccList.GetSelectionFilter;
                        exit(true);
                    end;
                }
                field("Business Unit Filter";"Business Unit Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the business units that will be used to generate the exported data that is contained in the instance document.';
                    Visible = false;
                }
                field("Global Dimension 1 Filter";"Global Dimension 1 Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimensions that will be used to generate the exported data that is contained in the instance document.';
                    Visible = false;
                }
                field("Global Dimension 2 Filter";"Global Dimension 2 Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimensions that will be used to generate the exported data that is contained in the instance document.';
                    Visible = false;
                }
                field("Timeframe Type";"Timeframe Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies, along with the starting date, period length, and number of periods, what date range will be applied to the general ledger data exported for this line.';
                }
                field("Amount Type";"Amount Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which general ledger entries will be included in the total calculated for export to the instance document.';
                }
                field("Normal Balance";"Normal Balance")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies either debit or credit. This determines how the balance will be handled during calculation, allowing balances consistent with the Normal Balance type to be exported as positive values. For example, if you want the instance document to contain positive numbers, all G/L Accounts with a normal credit balance will need to have Credit selected for this field.';
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

    local procedure GetCaption(): Text[250]
    var
        XBRLLine: Record "XBRL Taxonomy Line";
    begin
        if not XBRLLine.Get("XBRL Taxonomy Name","XBRL Taxonomy Line No.") then
          exit('');

        Copyfilter("Label Language Filter",XBRLLine."Label Language Filter");
        XBRLLine.CalcFields(Label);
        if XBRLLine.Label = '' then
          XBRLLine.Label := XBRLLine.Name;
        exit(XBRLLine.Label);
    end;
}

