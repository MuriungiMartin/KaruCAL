#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 312 "Gen. Business Posting Groups"
{
    ApplicationArea = Basic;
    Caption = 'Gen. Business Posting Groups';
    PageType = List;
    SourceTable = "Gen. Business Posting Group";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a code for the business group.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description for the general business posting group.';
                }
                field("Def. VAT Bus. Posting Group";"Def. VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a default tax business group code.';

                    trigger OnValidate()
                    begin
                        if "Def. VAT Bus. Posting Group" <> xRec."Def. VAT Bus. Posting Group" then
                          if not Confirm(Text000,false,Code,xRec."Def. VAT Bus. Posting Group") then
                            Error('');
                    end;
                }
                field("Auto Insert Default";"Auto Insert Default")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether to automatically insert the Def. Tax Bus. Posting Group when the corresponding Code is inserted on new customer and vendor cards.';
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
            action("&Setup")
            {
                ApplicationArea = Basic,Suite;
                Caption = '&Setup';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "General Posting Setup";
                RunPageLink = "Gen. Bus. Posting Group"=field(Code);
                ToolTip = 'View or edit how you want to set up combinations of general business and general product posting groups.';
            }
        }
    }

    var
        Text000: label 'This will change all occurrences of Tax Bus. Posting Group in G/L Account, Customer, and Vendor tables\where Gen. Bus. Posting Group is %1\and Tax Bus. Posting Group is %2. Are you sure that you want to continue?';
}

