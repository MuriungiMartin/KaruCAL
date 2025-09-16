#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7161 "Analysis Dim. Selection-Level"
{
    Caption = 'Analysis Dim. Selection-Level';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Analysis Dim. Selection Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Level;Level)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'This field is used internally.';

                    trigger OnValidate()
                    var
                        xAnalysisDimSelBuf: Record "Analysis Dim. Selection Buffer";
                        HasError: Boolean;
                    begin
                        if Level <> Level::" " then begin
                          xAnalysisDimSelBuf.Copy(Rec);
                          Reset;
                          SetFilter(Code,'<>%1',xAnalysisDimSelBuf.Code);
                          SetRange(Level,xAnalysisDimSelBuf.Level);
                          HasError := not IsEmpty;
                          Copy(xAnalysisDimSelBuf);
                          if HasError then
                            Error(Text000,FieldCaption(Level));
                        end;
                    end;
                }
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'This field is used internally.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'This field is used internally.';
                }
                field("Dimension Value Filter";"Dimension Value Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'This field is used internally.';
                }
            }
        }
    }

    actions
    {
    }

    var
        Text000: label 'This %1 already exists.';


    procedure GetDimSelBuf(var AnalysisDimSelBuf: Record "Analysis Dim. Selection Buffer")
    begin
        AnalysisDimSelBuf.DeleteAll;
        if FindSet then
          repeat
            AnalysisDimSelBuf := Rec;
            AnalysisDimSelBuf.Insert;
          until Next = 0;
    end;


    procedure InsertDimSelBuf(NewSelected: Boolean;NewCode: Text[30];NewDescription: Text[30];NewDimValueFilter: Text[250];NewLevel: Option)
    var
        Dim: Record Dimension;
    begin
        if NewDescription = '' then
          if Dim.Get(NewCode) then
            NewDescription := Dim.GetMLName(GlobalLanguage);

        Init;
        Selected := NewSelected;
        Code := NewCode;
        Description := NewDescription;
        if NewSelected then begin
          "Dimension Value Filter" := NewDimValueFilter;
          Level := NewLevel;
        end;
        Insert;
    end;
}

