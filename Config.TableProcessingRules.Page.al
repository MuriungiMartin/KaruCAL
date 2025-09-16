#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 8640 "Config. Table Processing Rules"
{
    AutoSplitKey = true;
    Caption = 'Config. Table Processing Rules';
    DataCaptionFields = "Table ID","Package Code";
    DelayedInsert = true;
    PageType = List;
    PopulateAllFields = true;
    ShowFilter = false;
    SourceTable = "Config. Table Processing Rule";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Action";Action)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies an action that is related to the custom processing rule.';

                    trigger OnValidate()
                    begin
                        CustomCodeunitIdEditable := Action = Action::Custom;
                    end;
                }
                field(FilterInfo;GetFilterInfo)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Filter';
                    Editable = false;
                }
                field("Custom Processing Codeunit ID";"Custom Processing Codeunit ID")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Editable = CustomCodeunitIdEditable;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Filter")
            {
                Caption = 'Filter';
                action(ProcessingFilters)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Processing Filters';
                    Image = "Filter";
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'View or edit the filters that are used to process data.';

                    trigger OnAction()
                    begin
                        ShowFilters;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CustomCodeunitIdEditable := Action = Action::Custom;
    end;

    var
        CustomCodeunitIdEditable: Boolean;
}

