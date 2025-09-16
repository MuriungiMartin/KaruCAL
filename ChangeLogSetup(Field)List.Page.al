#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 594 "Change Log Setup (Field) List"
{
    Caption = 'Change Log Setup (Field) List';
    DataCaptionExpression = PageCaption;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Field";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'No.';
                    Editable = false;
                    Lookup = false;
                }
                field("Field Caption";"Field Caption")
                {
                    ApplicationArea = Basic;
                    Caption = 'Field Caption';
                    DrillDown = false;
                    Editable = false;
                }
                field("Log Insertion";LogIns)
                {
                    ApplicationArea = Basic;
                    Caption = 'Log Insertion';
                    Visible = LogInsertionVisible;

                    trigger OnValidate()
                    begin
                        if not InsVisible then begin
                          LogInsertionVisible := false;
                          Error(CannotChangeColumnErr);
                        end;
                        UpdateRec;
                    end;
                }
                field("Log Modification";LogMod)
                {
                    ApplicationArea = Basic;
                    Caption = 'Log Modification';
                    Visible = LogModificationVisible;

                    trigger OnValidate()
                    begin
                        if not ModVisible then begin
                          LogModificationVisible := false;
                          Error(CannotChangeColumnErr);
                        end;
                        UpdateRec;
                    end;
                }
                field("Log Deletion";LogDel)
                {
                    ApplicationArea = Basic;
                    Caption = 'Log Deletion';
                    Visible = LogDeletionVisible;

                    trigger OnValidate()
                    begin
                        if not DelVisible then begin
                          LogDeletionVisible := false;
                          Error(CannotChangeColumnErr);
                        end;
                        UpdateRec;
                    end;
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

    trigger OnAfterGetCurrRecord()
    begin
        GetRec;
        TransFromRec;
    end;

    trigger OnAfterGetRecord()
    begin
        GetRec;
        TransFromRec;
    end;

    trigger OnInit()
    begin
        LogDeletionVisible := true;
        LogModificationVisible := true;
        LogInsertionVisible := true;
    end;

    trigger OnOpenPage()
    begin
        FilterGroup(2);
        SetRange(Class,Class::Normal);
        FilterGroup(0);
        PageCaption := Format(TableNo) + ' ' + TableName;
    end;

    var
        ChangeLogSetupField: Record "Change Log Setup (Field)";
        CannotChangeColumnErr: label 'You cannot change this column.';
        LogIns: Boolean;
        LogMod: Boolean;
        LogDel: Boolean;
        InsVisible: Boolean;
        ModVisible: Boolean;
        DelVisible: Boolean;
        [InDataSet]
        LogInsertionVisible: Boolean;
        [InDataSet]
        LogModificationVisible: Boolean;
        [InDataSet]
        LogDeletionVisible: Boolean;
        PageCaption: Text[250];


    procedure SelectColumn(NewInsVisible: Boolean;NewModVisible: Boolean;NewDelVisible: Boolean)
    begin
        InsVisible := NewInsVisible;
        ModVisible := NewModVisible;
        DelVisible := NewDelVisible;

        LogInsertionVisible := InsVisible;
        LogModificationVisible := ModVisible;
        LogDeletionVisible := DelVisible;
    end;

    local procedure UpdateRec()
    begin
        GetRec;
        TransToRec;
        with ChangeLogSetupField do
          if not ("Log Insertion" or "Log Modification" or "Log Deletion") then begin
            if Delete then;
          end else
            if not Modify then
              Insert;
    end;

    local procedure GetRec()
    begin
        if not ChangeLogSetupField.Get(TableNo,"No.") then begin
          ChangeLogSetupField.Init;
          ChangeLogSetupField."Table No." := TableNo;
          ChangeLogSetupField."Field No." := "No.";
        end;
    end;

    local procedure TransFromRec()
    begin
        LogIns := ChangeLogSetupField."Log Insertion";
        LogMod := ChangeLogSetupField."Log Modification";
        LogDel := ChangeLogSetupField."Log Deletion";
    end;

    local procedure TransToRec()
    begin
        ChangeLogSetupField."Log Insertion" := LogIns;
        ChangeLogSetupField."Log Modification" := LogMod;
        ChangeLogSetupField."Log Deletion" := LogDel;
    end;
}

