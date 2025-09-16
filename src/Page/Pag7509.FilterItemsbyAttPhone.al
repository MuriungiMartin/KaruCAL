#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7509 "Filter Items by Att. Phone"
{
    Caption = 'Filter Items by Attribute';
    DataCaptionExpression = '';
    PageType = List;
    SourceTable = "Filter Item Attributes Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field(Attribute;Attribute)
                {
                    ApplicationArea = Basic,Suite;
                    TableRelation = "Item Attribute".Name;
                    ToolTip = 'Specifies the name of the attribute to filter on.';
                }
                field(Value;Value)
                {
                    ApplicationArea = Basic,Suite;
                    AssistEdit = true;
                    ToolTip = 'Specifies the value of the filter. You can use single values or filter expressions, such as >,<,>=,<=,|,&, and 1..100.';

                    trigger OnAssistEdit()
                    begin
                        ValueAssistEdit;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        SetRange(Value,'');
        DeleteAll;
    end;
}

