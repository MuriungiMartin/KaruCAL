#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 7310 "Calculate Bins"
{
    Caption = 'Calculate Bins';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Rack2;"Integer")
        {
            DataItemTableView = sorting(Number);
            column(ReportForNavId_6034; 6034)
            {
            }
            dataitem(Section2;"Integer")
            {
                DataItemTableView = sorting(Number);
                column(ReportForNavId_6247; 6247)
                {
                }
                dataitem(Level2;"Integer")
                {
                    DataItemTableView = sorting(Number);
                    column(ReportForNavId_6891; 6891)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if IncStr(Level) = Level then
                          CurrReport.Break;
                        if Level > ToLevel then
                          CurrReport.Break;
                        if StrLen(Level) > StrLen(ToLevel) then
                          CurrReport.Break;

                        BinCreateWksh;

                        Level := IncStr(Level);
                    end;

                    trigger OnPostDataItem()
                    begin
                        Section := IncStr(Section);
                    end;

                    trigger OnPreDataItem()
                    begin
                        Level := FromLevel;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if IncStr(Section) = Section then
                      CurrReport.Break;
                    if Section > ToSection then
                      CurrReport.Break;
                    if StrLen(Section) > StrLen(ToSection) then
                      CurrReport.Break;

                    if (FromLevel = '') and (ToLevel = '') then
                      BinCreateWksh;
                end;

                trigger OnPostDataItem()
                begin
                    Rack := IncStr(Rack);
                end;

                trigger OnPreDataItem()
                begin
                    Section := FromSection;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if IncStr(Rack) = Rack then
                  CurrReport.Break;
                if Rack > ToRack then
                  CurrReport.Break;
                if StrLen(Rack) > StrLen(ToRack) then
                  CurrReport.Break;

                if (FromSection = '') and (ToSection = '') then
                  BinCreateWksh;
            end;

            trigger OnPreDataItem()
            begin
                Rack := FromRack;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(BinTemplateCode;BinCreateFilter.Code)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Bin Template Code';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if CurrLocationCode <> '' then begin
                              BinCreateFilter.FilterGroup := 2;
                              BinCreateFilter.SetRange("Location Code",CurrLocationCode);
                              BinCreateFilter.FilterGroup := 0;
                            end;
                            Clear(BinTemplateForm);
                            BinTemplateForm.SetTableview(BinCreateFilter);
                            BinTemplateForm.Editable(false);
                            BinTemplateForm.LookupMode(true);
                            if BinTemplateForm.RunModal = Action::LookupOK then begin
                              BinTemplateForm.GetRecord(BinCreateFilter);
                              BinCreateFilter.Validate(Code);
                              BinCreateFilter.TestField("Location Code");
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            if  BinCreateFilter.Code <> '' then begin
                              BinCreateFilter.Get(BinCreateFilter.Code);
                              BinCreateFilter.TestField("Location Code");
                            end else begin
                              BinCreateFilter.Code := '';
                              BinCreateFilter.Description := '';
                              BinCreateFilter."Location Code" := '';
                              BinCreateFilter."Zone Code" := '';
                            end;
                        end;
                    }
                    field("BinCreateFilter.Description";BinCreateFilter.Description)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Description';
                    }
                    field("BinCreateFilter.""Location Code""";BinCreateFilter."Location Code")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Location Code';
                        Editable = false;
                    }
                    field("BinCreateFilter.""Zone Code""";BinCreateFilter."Zone Code")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Zone Code';
                        Editable = false;
                    }
                    group(Rack)
                    {
                        Caption = 'Rack';
                        field(RackFromNo;FromRack)
                        {
                            ApplicationArea = Basic;
                            Caption = 'From No.';

                            trigger OnValidate()
                            begin
                                if (FromRack <> '') and
                                   (ToRack <> '') and
                                   (StrLen(FromRack) <> StrLen(ToRack))
                                then
                                  Error(Text004);
                            end;
                        }
                        field(RackToNo;ToRack)
                        {
                            ApplicationArea = Basic;
                            Caption = 'To No.';

                            trigger OnValidate()
                            begin
                                if (FromRack <> '') and
                                   (ToRack <> '') and
                                   (StrLen(FromRack) <> StrLen(ToRack))
                                then
                                  Error(Text004);
                            end;
                        }
                    }
                    group(Section)
                    {
                        Caption = 'Section';
                        field(SelectionFromNo;FromSection)
                        {
                            ApplicationArea = Basic;
                            Caption = 'From No.';

                            trigger OnValidate()
                            begin
                                if (FromSection <> '') and
                                   (ToSection <> '') and
                                   (StrLen(FromSection) <> StrLen(ToSection))
                                then
                                  Error(Text004);
                            end;
                        }
                        field(SelectionToNo;ToSection)
                        {
                            ApplicationArea = Basic;
                            Caption = 'To No.';

                            trigger OnValidate()
                            begin
                                if (FromSection <> '') and
                                   (ToSection <> '') and
                                   (StrLen(FromSection) <> StrLen(ToSection))
                                then
                                  Error(Text004);
                            end;
                        }
                    }
                    group(Level)
                    {
                        Caption = 'Level';
                        field(LevelFromNo;FromLevel)
                        {
                            ApplicationArea = Basic;
                            Caption = 'From No.';

                            trigger OnValidate()
                            begin
                                if (FromLevel <> '') and
                                   (ToLevel <> '') and
                                   (StrLen(FromLevel) <> StrLen(ToLevel))
                                then
                                  Error(Text004);
                            end;
                        }
                        field(LevelToNo;ToLevel)
                        {
                            ApplicationArea = Basic;
                            Caption = 'To No.';

                            trigger OnValidate()
                            begin
                                if (FromLevel <> '') and
                                   (ToLevel <> '') and
                                   (StrLen(FromLevel) <> StrLen(ToLevel))
                                then
                                  Error(Text004);
                            end;
                        }
                    }
                    field(FieldSeparator;FieldSeparator)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Field Separator';
                    }
                    field(CheckOnBin;CheckOnBin)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Check on Existing Bin';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        BinCreateFilter.TestField(Code);
        if BinCreateFilter.Get(BinCreateFilter.Code) then;
        BinCreateWkshLine.SetRange("Worksheet Template Name",CurrTemplateName);
        BinCreateWkshLine.SetRange(Name,CurrWorksheetName);
        BinCreateWkshLine.SetRange("Location Code",CurrLocationCode);
        if BinCreateWkshLine.FindLast then
          LineNo := BinCreateWkshLine."Line No." + 10000
        else
          LineNo := 10000;
        BinCreateWkshLine.Init;
        with BinCreateWkshLine do begin
          "Worksheet Template Name" := CurrTemplateName;
          Name := CurrWorksheetName;
          "Location Code" := CurrLocationCode;
          Dedicated := BinCreateFilter.Dedicated;
          "Zone Code" := BinCreateFilter."Zone Code";
          Description := BinCreateFilter."Bin Description";
          "Bin Type Code" := BinCreateFilter."Bin Type Code";
          "Warehouse Class Code" := BinCreateFilter."Warehouse Class Code";
          "Block Movement" := BinCreateFilter."Block Movement";
          "Special Equipment Code" := BinCreateFilter."Special Equipment Code";
          "Bin Ranking" := BinCreateFilter."Bin Ranking";
          "Maximum Cubage" := BinCreateFilter."Maximum Cubage";
          "Maximum Weight" := BinCreateFilter."Maximum Weight";
        end;
    end;

    var
        Bin: Record Bin;
        BinCreateFilter: Record "Bin Template";
        BinCreateWkshLine: Record "Bin Creation Worksheet Line";
        BinTemplateForm: Page "Bin Templates";
        CurrTemplateName: Code[10];
        CurrWorksheetName: Code[10];
        CurrLocationCode: Code[10];
        FromRack: Code[20];
        FromSection: Code[20];
        FromLevel: Code[20];
        ToRack: Code[20];
        ToSection: Code[20];
        ToLevel: Code[20];
        FieldSeparator: Code[1];
        Rack: Code[20];
        Section: Code[20];
        Level: Code[20];
        CheckOnBin: Boolean;
        Text000: label 'The length of From Rack+From Section+From Level is greater than the maximum length of Bin Code (%1).';
        LenFieldSeparator: Integer;
        LineNo: Integer;
        Text004: label 'The length of the strings inserted in From No. and To No. must be identical.';

    local procedure BinCreateWksh()
    begin
        LenFieldSeparator := 0;
        if FieldSeparator <> '' then
          LenFieldSeparator := 2;

        if (StrLen(Rack + Section + Level) + LenFieldSeparator) > MaxStrLen(BinCreateWkshLine."Bin Code") then
          Error(Text000,MaxStrLen(BinCreateWkshLine."Bin Code"));

        BinCreateWkshLine."Line No." := LineNo;
        BinCreateWkshLine."Bin Code" := Rack + FieldSeparator + Section + FieldSeparator + Level;
        if not CheckOnBin then
          BinCreateWkshLine.Insert(true)
        else begin
          if Bin.Get(BinCreateWkshLine."Location Code",BinCreateWkshLine."Bin Code") then
            exit
            ;
          BinCreateWkshLine.Insert(true);
        end;
        LineNo := LineNo + 10000;
    end;


    procedure SetTemplAndWorksheet(TemplateName: Code[10];WorksheetName: Code[10];LocationCode: Code[10])
    begin
        CurrTemplateName := TemplateName;
        CurrWorksheetName := WorksheetName;
        CurrLocationCode := LocationCode;
    end;
}

