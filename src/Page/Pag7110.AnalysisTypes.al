#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7110 "Analysis Types"
{
    ApplicationArea = Basic;
    Caption = 'Analysis Types';
    DataCaptionFields = "Code";
    PageType = List;
    SourceTable = "Analysis Type";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the analysis type.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the analysis type.';
                }
                field("Value Type";"Value Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value type that the analysis type is based on.';
                }
                field("Item Ledger Entry Type Filter";"Item Ledger Entry Type Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a filter on the type of item ledger entry.';
                }
                field("Value Entry Type Filter";"Value Entry Type Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a filter on the type of item value entry.';
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
            action("&Reset Default Analysis Types")
            {
                ApplicationArea = Basic;
                Caption = '&Reset Default Analysis Types';
                Image = ResetStatus;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Revert to use the default analysis types that exist in the system.';

                trigger OnAction()
                begin
                    ResetDefaultAnalysisTypes(true);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ItemLedgerEntryTypeFilterOnFor(Format("Item Ledger Entry Type Filter"));
        ValueEntryTypeFilterOnFormat(Format("Value Entry Type Filter"));
    end;

    var
        AnalysisRepMgmt: Codeunit "Analysis Report Management";

    local procedure ItemLedgerEntryTypeFilterOnFor(Text: Text[250])
    begin
        AnalysisRepMgmt.ValidateFilter(Text,Database::"Analysis Type",FieldNo("Item Ledger Entry Type Filter"),false);
        "Item Ledger Entry Type Filter" := Text;
    end;

    local procedure ValueEntryTypeFilterOnFormat(Text: Text[250])
    begin
        AnalysisRepMgmt.ValidateFilter(Text,Database::"Analysis Type",FieldNo("Value Entry Type Filter"),false);
        "Value Entry Type Filter" := Text;
    end;
}

