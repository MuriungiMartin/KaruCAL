#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 8631 "Config. Areas"
{
    Caption = 'Config. Areas';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Config. Line";
    SourceTableView = where("Line Type"=filter(<>Table));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                IndentationColumn = NameIndent;
                IndentationControls = Name;
                field("Line Type";"Line Type")
                {
                    ApplicationArea = Basic,Suite;
                    Style = Strong;
                    StyleExpr = NameEmphasize;
                    ToolTip = 'Specifies the type of the configuration package line.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    Style = Strong;
                    StyleExpr = NameEmphasize;
                    ToolTip = 'Specifies the name of the line type.';
                }
                field(GetNoTables;GetNoTables)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'No. of Tables';
                    ToolTip = 'Specifies how many tables the configuration package contains.';
                }
                field(Completion;Progress)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Completion';
                    ExtendedDatatype = Ratio;
                    MaxValue = 100;
                    MinValue = 0;
                    ToolTip = 'Specifies how much of the table configuration is completed.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        NameIndent := 0;
        case "Line Type" of
          "line type"::Group:
            NameIndent := 1;
        end;

        NameEmphasize := (NameIndent = 0);

        Progress := GetProgress;
    end;

    var
        NameIndent: Integer;
        NameEmphasize: Boolean;
        Progress: Integer;
}

