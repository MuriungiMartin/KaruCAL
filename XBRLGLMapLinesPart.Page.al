#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 596 "XBRL G/L Map Lines Part"
{
    Caption = 'XBRL G/L Map Lines Part';
    PageType = ListPart;
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
                    Visible = false;
                }
                field("Amount Type";"Amount Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which general ledger entries will be included in the total calculated for export to the instance document.';
                    Visible = false;
                }
                field("Normal Balance";"Normal Balance")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies either debit or credit. This determines how the balance will be handled during calculation, allowing balances consistent with the Normal Balance type to be exported as positive values. For example, if you want the instance document to contain positive numbers, all G/L Accounts with a normal credit balance will need to have Credit selected for this field.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

