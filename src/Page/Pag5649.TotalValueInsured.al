#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5649 "Total Value Insured"
{
    Caption = 'Total Value Insured';
    Editable = false;
    PageType = Document;
    SourceTable = "Fixed Asset";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies a number for the fixed asset.';
                }
                field(Description;Description)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies a description of the fixed asset.';
                }
                field("FASetup.""Insurance Depr. Book""";FASetup."Insurance Depr. Book")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Insurance Depr. Book';
                    ToolTip = 'Specifies the depreciation book code that is specified in the Fixed Asset Setup window.';
                }
                field("FADeprBook.""Acquisition Cost""";FADeprBook."Acquisition Cost")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Acquisition Cost';
                    ToolTip = 'Specifies the total percentage of acquisition cost that can be allocated when acquisition cost is posted.';
                }
            }
            part(TotalValue;"Total Value Insured Subform")
            {
                ApplicationArea = FixedAssets;
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

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.TotalValue.Page.CreateTotalValue("No.");
        FASetup.Get;
        FADeprBook.Init;
        if FASetup."Insurance Depr. Book" <> '' then
          if FADeprBook.Get("No.",FASetup."Insurance Depr. Book") then
            FADeprBook.CalcFields("Acquisition Cost");
    end;

    var
        FASetup: Record "FA Setup";
        FADeprBook: Record "FA Depreciation Book";
}

