#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5300 "Outlook Synch. Change Log Set."
{
    Caption = 'Outlook Synch. Change Log Set.';
    ProcessingOnly = true;

    dataset
    {
        dataitem(OSynchEntity;"Outlook Synch. Entity")
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code";
            column(ReportForNavId_6770; 6770)
            {
            }
            dataitem(OSynchEntityElement;"Outlook Synch. Entity Element")
            {
                DataItemLink = "Synch. Entity Code"=field(Code);
                DataItemTableView = sorting("Synch. Entity Code","Element No.") order(ascending) where("Element No."=filter(<>0));
                column(ReportForNavId_4710; 4710)
                {
                }
                dataitem(OSynchFilterElement;"Outlook Synch. Filter")
                {
                    DataItemLink = "Record GUID"=field("Record GUID");
                    DataItemTableView = sorting("Record GUID","Filter Type","Line No.") order(ascending) where("Filter Type"=const("Table Relation"));
                    column(ReportForNavId_6868; 6868)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        RegisterChangeLogFilter(OSynchFilterElement);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    RegisterChangeLogPrimaryKey("Table No.");
                end;
            }
            dataitem(OSynchField;"Outlook Synch. Field")
            {
                DataItemLink = "Synch. Entity Code"=field(Code);
                DataItemTableView = sorting("Synch. Entity Code","Element No.","Line No.");
                column(ReportForNavId_2890; 2890)
                {
                }

                trigger OnAfterGetRecord()
                var
                    OSynchFilter: Record "Outlook Synch. Filter";
                    OSynchEntityElement: Record "Outlook Synch. Entity Element";
                begin
                    if "Table No." <> 0 then begin
                      OSynchFilter.Reset;
                      OSynchFilter.SetRange("Record GUID","Record GUID");
                      OSynchFilter.SetRange("Filter Type",OSynchFilter."filter type"::"Table Relation");
                      OSynchFilter.SetRange(Type,OSynchFilter.Type::Field);
                      if not OSynchFilter.FindFirst then begin
                        CalcFields("Table Caption");
                        if "Element No." = 0 then
                          Error(Text001,"Table Caption",OSynchEntity.TableCaption,OSynchEntity.Code);

                        OSynchEntityElement.Get("Synch. Entity Code","Element No.");
                        OSynchEntityElement.CalcFields("Table Caption");
                        Error(
                          Text005,
                          "Table Caption",
                          OSynchEntityElement."Table Caption",
                          OSynchEntityElement."Outlook Collection",
                          OSynchEntity.Code);
                      end;

                      Field.Get("Table No.","Field No.");
                      Field.TestField(Enabled,true);
                      RegisterChangeLogField("Table No.","Field No.");

                      FieldID := OSynchFilter."Master Table Field No.";
                    end else
                      FieldID := "Field No.";

                    Field.Get("Master Table No.",FieldID);
                    Field.TestField(Enabled,true);

                    RegisterChangeLogField("Master Table No.",FieldID);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                RegisterChangeLogPrimaryKey("Table No.");
            end;
        }
        dataitem(OSynchFilterEntity;"Outlook Synch. Filter")
        {
            DataItemLink = "Record GUID"=field("Record GUID");
            DataItemLinkReference = OSynchEntity;
            DataItemTableView = sorting("Record GUID","Filter Type","Line No.") order(ascending);
            column(ReportForNavId_7744; 7744)
            {
            }

            trigger OnAfterGetRecord()
            begin
                RegisterChangeLogFilter(OSynchFilterEntity);
            end;
        }
        dataitem(OSynchUserSetup;"Outlook Synch. User Setup")
        {
            DataItemLink = "Synch. Entity Code"=field(Code);
            DataItemLinkReference = OSynchEntity;
            DataItemTableView = sorting("User ID","Synch. Entity Code") order(ascending);
            column(ReportForNavId_9398; 9398)
            {
            }
            dataitem(OSynchFilterUserSetup;"Outlook Synch. Filter")
            {
                DataItemLink = "Record GUID"=field("Record GUID");
                DataItemTableView = sorting("Record GUID","Filter Type","Line No.") order(ascending);
                column(ReportForNavId_3638; 3638)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    RegisterChangeLogFilter(OSynchFilterUserSetup);
                end;
            }
        }
        dataitem(OSynchDependency;"Outlook Synch. Dependency")
        {
            DataItemLink = "Synch. Entity Code"=field(Code);
            DataItemLinkReference = OSynchEntity;
            DataItemTableView = sorting("Synch. Entity Code","Element No.","Depend. Synch. Entity Code") order(ascending);
            column(ReportForNavId_1658; 1658)
            {
            }
            dataitem(OSynchFilterDependency;"Outlook Synch. Filter")
            {
                DataItemLink = "Record GUID"=field("Record GUID");
                DataItemTableView = sorting("Record GUID","Filter Type","Line No.") order(ascending);
                column(ReportForNavId_7267; 7267)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    RegisterChangeLogFilter(OSynchFilterDependency);
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    var
        ChangeLogSetup: Record "Change Log Setup";
    begin
        if not ChangeLogSetup.Get then
          ChangeLogSetup.Insert;
        if not ChangeLogSetup."Change Log Activated" then begin
          ChangeLogSetup."Change Log Activated" := true;
          ChangeLogSetup.Modify;
          Message(Text002);
        end else
          Message(Text003);
    end;

    trigger OnPreReport()
    begin
        if not OSynchEntity.FindFirst then
          Error(Text004);
    end;

    var
        "Field": Record "Field";
        FieldID: Integer;
        Text001: label 'The relation between the %1 table and %2 table in the %3 entity cannot be determined. Please verify your synchronization settings for this entity.';
        Text002: label 'The change log settings have been registered successfully. You must close and reopen the company for the new change log settings to take effect.';
        Text003: label 'The change log settings have been registered successfully.';
        Text004: label 'The entity cannot be found. Make sure that you have typed its name correctly.';
        Text005: label 'The relation between the %1 table and %2 table in the %3 collection from the %4 entity cannot be determined. Verify your synchronization settings for this entity.';

    local procedure RegisterChangeLogField(TableID: Integer;FieldID: Integer)
    var
        ChangeLogSetupTable: Record "Change Log Setup (Table)";
        ChangeLogSetupField: Record "Change Log Setup (Field)";
        NeedToBeUpdated: Boolean;
    begin
        with ChangeLogSetupTable do begin
          Reset;
          if not Get(TableID) then begin
            Init;
            "Table No." := TableID;
            Validate("Log Insertion","log insertion"::"Some Fields");
            Validate("Log Modification","log modification"::"Some Fields");
            Validate("Log Deletion","log modification"::"Some Fields");
            Insert;
            NeedToBeUpdated := true;
          end else begin
            NeedToBeUpdated :=
              ("Log Insertion" <> "log insertion"::"All Fields") or
              ("Log Modification" <> "log modification"::"All Fields") or
              ("Log Deletion" <> "log deletion"::"All Fields");

            if "Log Insertion" <> "log insertion"::"All Fields" then
              "Log Insertion" := "log insertion"::"Some Fields";

            if "Log Modification" <> "log modification"::"All Fields" then
              "Log Modification" := "log insertion"::"Some Fields";

            if "Log Deletion" <> "log deletion"::"All Fields" then
              "Log Deletion" := "log deletion"::"Some Fields";

            if NeedToBeUpdated then
              Modify;
          end;
        end;

        if not NeedToBeUpdated then
          exit;

        with ChangeLogSetupField do begin
          Reset;
          if not Get(TableID,FieldID) then begin
            Init;
            "Table No." := TableID;
            "Field No." := FieldID;
            "Log Insertion" := true;
            "Log Modification" := true;
            "Log Deletion" := true;
            Insert;
          end else begin
            "Log Insertion" := true;
            "Log Modification" := true;
            "Log Deletion" := true;
            Modify;
          end;
        end;
    end;

    local procedure RegisterChangeLogPrimaryKey(TableID: Integer)
    var
        RecRef: RecordRef;
        I: Integer;
    begin
        RecRef.Open(TableID,true);
        for I := 1 to RecRef.KeyIndex(1).FieldCount do
          RegisterChangeLogField(TableID,RecRef.KeyIndex(1).FieldIndex(I).Number);
        RecRef.Close;
    end;

    local procedure RegisterChangeLogFilter(OSynchFilter1: Record "Outlook Synch. Filter")
    begin
        if Field.Get(OSynchFilter1."Table No.",OSynchFilter1."Field No.") then begin
          Field.TestField(Enabled,true);
          RegisterChangeLogField(OSynchFilter1."Table No.",OSynchFilter1."Field No.");
        end;
        if Field.Get(OSynchFilter1."Master Table No.",OSynchFilter1."Master Table Field No.") then begin
          Field.TestField(Enabled,true);
          RegisterChangeLogField(OSynchFilter1."Master Table No.",OSynchFilter1."Master Table Field No.");
        end;
    end;
}

