#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 8628 "Config. Selection"
{
    Caption = 'Config. Selection';
    PageType = List;
    SourceTable = "Config. Selection";
    SourceTableTemporary = true;
    SourceTableView = sorting("Vertical Sorting");

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                IndentationColumn = NameIndent;
                IndentationControls = Name;
                field(Selected;Selected)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether the configuration package has been selected.';
                }
                field("Line Type";"Line Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of the configuration package part. The part can be one of the following types:';
                }
                field("Table ID";"Table ID")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the ID of the table that is used in the configuration selection.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    Style = Strong;
                    StyleExpr = NameEmphasize;
                    ToolTip = 'Specifies the name of the of the configuration package.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Select All")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Select All';
                Image = AllLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Select all lines.';

                trigger OnAction()
                begin
                    ModifyAll(Selected,true);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        NameIndent := 0;
        case "Line Type" of
          "line type"::Group:
            NameIndent := 1;
          "line type"::Table:
            NameIndent := 2;
        end;

        NameEmphasize := (NameIndent in [0,1]);
    end;

    var
        NameIndent: Integer;
        NameEmphasize: Boolean;


    procedure Set(var TempConfigSelection: Record "Config. Selection" temporary)
    begin
        if TempConfigSelection.FindSet then
          repeat
            Init;
            "Line No." := TempConfigSelection."Line No.";
            "Table ID" := TempConfigSelection."Table ID";
            Name := TempConfigSelection.Name;
            "Line Type" := TempConfigSelection."Line Type";
            "Parent Line No." := TempConfigSelection."Parent Line No.";
            "Vertical Sorting" := TempConfigSelection."Vertical Sorting";
            Selected := TempConfigSelection.Selected;
            Insert;
          until TempConfigSelection.Next = 0;
    end;


    procedure Get(var TempConfigSelection: Record "Config. Selection" temporary): Integer
    var
        Counter: Integer;
    begin
        Counter := 0;
        TempConfigSelection.DeleteAll;
        if FindSet then
          repeat
            TempConfigSelection.Init;
            TempConfigSelection."Line No." := "Line No.";
            TempConfigSelection."Table ID" := "Table ID";
            TempConfigSelection.Name := Name;
            TempConfigSelection."Line Type" := "Line Type";
            TempConfigSelection."Parent Line No." := "Parent Line No.";
            TempConfigSelection."Vertical Sorting" := "Vertical Sorting";
            TempConfigSelection.Selected := Selected;
            if Selected then
              Counter += 1;
            TempConfigSelection.Insert;
          until Next = 0;

        exit(Counter);
    end;
}

