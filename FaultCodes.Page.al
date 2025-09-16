#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5927 "Fault Codes"
{
    ApplicationArea = Basic;
    Caption = 'Fault Codes';
    DataCaptionFields = "Fault Area Code","Symptom Code";
    PageType = List;
    SourceTable = "Fault Code";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Fault Area Code";"Fault Area Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the fault area associated with the fault code.';
                    Visible = FaultAreaCodeVisible;
                }
                field("Symptom Code";"Symptom Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the symptom linked to the fault code.';
                    Visible = SymptomCodeVisible;
                }
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for the fault.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the fault code.';
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

    trigger OnInit()
    begin
        SymptomCodeVisible := true;
        FaultAreaCodeVisible := true;
    end;

    trigger OnOpenPage()
    begin
        FaultAreaCodeVisible := not CurrPage.LookupMode;
        SymptomCodeVisible := not CurrPage.LookupMode;
    end;

    var
        [InDataSet]
        FaultAreaCodeVisible: Boolean;
        [InDataSet]
        SymptomCodeVisible: Boolean;
}

