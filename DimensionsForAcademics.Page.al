#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77731 "Dimensions For Academics"
{
    Caption = 'Dimensions';
    PageType = List;
    SourceTable = Dimension;
    SourceTableView = where(Code=filter('DEPARTMENT'|'DEPARTMENTS'));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for the dimension.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the name of the dimension code.';
                }
                field("Code Caption";"Code Caption")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the caption of the dimension code. This is displayed as the name of dimension code fields.';
                }
                field("Filter Caption";"Filter Caption")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the caption of the dimension code when used as a filter. This is displayed as the name of dimension filter fields.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a description of the dimension code.';
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies that entries with this dimension cannot be posted.';
                }
                field("Map-to IC Dimension Code";"Map-to IC Dimension Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which intercompany dimension corresponds to the dimension on the line.';
                    Visible = false;
                }
                field("Consolidation Code";"Consolidation Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code that is used for consolidation.';
                    Visible = false;
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
        area(navigation)
        {
            group("&Dimension")
            {
                Caption = '&Dimension';
                Image = Dimensions;
                action("Dimension &Values")
                {
                    ApplicationArea = Suite;
                    Caption = 'Dimension &Values';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "Dimension Values";
                    RunPageLink = "Dimension Code"=field(Code);
                    ToolTip = 'View or edit the dimension values for the current dimension.';
                }
                action("Account Type De&fault Dim.")
                {
                    ApplicationArea = Suite;
                    Caption = 'Account Type De&fault Dim.';
                    Image = DefaultDimension;
                    RunObject = Page "Account Type Default Dim.";
                    RunPageLink = "Dimension Code"=field(Code),
                                  "No."=const('');
                    ToolTip = 'Specify default dimension settings for the relevant account types such as customers, vendors, or items. For example, you can make a dimension required.';
                }
                action(Translations)
                {
                    ApplicationArea = Suite;
                    Caption = 'Translations';
                    Image = Translations;
                    RunObject = Page "Dimension Translations";
                    RunPageLink = Code=field(Code);
                    ToolTip = 'View or edit translated dimensions. Translated item descriptions are automatically inserted on documents according to the language code.';
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(MapToICDimWithSameCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Map to IC Dim. with Same Code';
                    Image = MapDimensions;

                    trigger OnAction()
                    var
                        Dimension: Record Dimension;
                        ICMapping: Codeunit "IC Mapping";
                    begin
                        CurrPage.SetSelectionFilter(Dimension);
                        if Dimension.Find('-') and Confirm(Text000) then
                          repeat
                            ICMapping.MapOutgoingICDimensions(Dimension);
                          until Dimension.Next = 0;
                    end;
                }
            }
        }
    }

    var
        Text000: label 'Are you sure you want to map the selected lines?';
}

