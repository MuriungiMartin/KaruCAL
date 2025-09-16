#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5650 "Total Value Insured Subform"
{
    Caption = 'Lines';
    DataCaptionFields = "FA No.";
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Total Value Insured";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("FA No.";"FA No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the number of the fixed asset.';
                    Visible = false;
                }
                field("Insurance No.";"Insurance No.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the number of the insurance policy that the entry is linked to.';
                }
                field(Description;Description)
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the description of the insurance policy.';
                }
                field("Total Value Insured";"Total Value Insured")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the amounts you posted to each insurance policy for the fixed asset.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnFindRecord(Which: Text): Boolean
    begin
        exit(FindFirst(Which));
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        exit(FindNext(Steps));
    end;


    procedure CreateTotalValue(FANo: Code[20])
    begin
        CreateInsTotValueInsured(FANo);
        CurrPage.Update;
    end;
}

