#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5309 "Outlook Synch. Table Fields"
{
    Caption = 'Outlook Synch. Table Fields';
    DataCaptionExpression = GetFormCaption;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Field";
    SourceTableView = sorting(TableNo,"No.")
                      where(Enabled=const(true),
                            Class=filter(<>FlowFilter));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(TableNo;TableNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Table No.';
                    Visible = false;
                }
                field(TableName;TableName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Table Name';
                    Visible = false;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'No.';
                }
                field("Field Caption";"Field Caption")
                {
                    ApplicationArea = Basic;
                    Caption = 'Field Caption';
                }
                field(FieldName;FieldName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Field Name';
                    Visible = false;
                }
                field(Class;Class)
                {
                    ApplicationArea = Basic;
                    Caption = 'Class';
                }
                field("Type Name";"Type Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Type Name';
                }
                field(RelationTableNo;RelationTableNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Relation Table No.';
                    Visible = false;
                }
                field(RelationFieldNo;RelationFieldNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Relation Field No.';
                    Visible = false;
                }
                field(SQLDataType;SQLDataType)
                {
                    ApplicationArea = Basic;
                    Caption = 'SQL Data Type';
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
    }


    procedure GetFormCaption(): Text[80]
    begin
        exit(StrSubstNo('%1 %2',TableNo,TableName));
    end;
}

