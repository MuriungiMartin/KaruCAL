#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 747 "VAT Clauses"
{
    ApplicationArea = Basic;
    Caption = 'Tax Clauses';
    PageType = List;
    SourceTable = "VAT Clause";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for a tax clause, which is used to provide a tax description associated with a sales line on a sales invoice, credit memo, or other sales document.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the descriptive text that is associated with a tax clause.';
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies an additional description of a tax clause.';
                }
            }
            systempart(Control6;Links)
            {
                Visible = false;
            }
            systempart(Control7;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Setup")
            {
                ApplicationArea = Basic,Suite;
                Caption = '&Setup';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "VAT Posting Setup";
                RunPageLink = "VAT Clause Code"=field(Code);
                ToolTip = 'View or edit combinations of Tax business posting groups and Tax product posting groups.';
            }
            action("T&ranslation")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'T&ranslation';
                Image = Translation;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "VAT Clause Translations";
                RunPageLink = "VAT Clause Code"=field(Code);
                ToolTip = 'View or edit translations for each Tax clause description in different languages.';
            }
        }
    }
}

