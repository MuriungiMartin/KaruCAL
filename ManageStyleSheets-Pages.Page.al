#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 697 "Manage Style Sheets - Pages"
{
    ApplicationArea = Basic;
    Caption = 'Manage Style Sheets';
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = "Style Sheet";
    SourceTableView = sorting("Object Type","Object ID","Program ID")
                      order(ascending);
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(AppliesTo;AppliesTo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show';
                    OptionCaption = 'All style sheets,Style sheets common to all pages,Style sheets for a specific page';

                    trigger OnValidate()
                    begin
                        if AppliesTo = Appliesto::"Style sheets for a specific page" then
                          StylesheetsfortAppliesToOnVali;
                        if AppliesTo = Appliesto::"Style sheets common to all pages" then
                          StylesheetscommAppliesToOnVali;
                        if AppliesTo = Appliesto::"All style sheets" then
                          AllstylesheetsAppliesToOnValid;
                    end;
                }
                field(PageNo;ObjectID)
                {
                    ApplicationArea = Basic;
                    Caption = 'Page No.';
                    Enabled = PageNoEnable;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Objects: Page Objects;
                    begin
                        AllObjWithCaption.SetRange("Object Type",AllObjWithCaption."object type"::Page);
                        Objects.SetTableview(AllObjWithCaption);
                        if ObjectID <> 0 then begin
                          AllObjWithCaption.Get(AllObjWithCaption."object type"::Page,ObjectID);
                          Objects.SetRecord(AllObjWithCaption);
                        end;
                        Objects.LookupMode := true;
                        if Objects.RunModal = Action::LookupOK then begin
                          Objects.GetRecord(AllObjWithCaption);
                          ObjectID := AllObjWithCaption."Object ID";
                          SetObjectFilters;
                          Text := Format(ObjectID);
                          exit(true);
                        end;
                        exit(false);
                    end;

                    trigger OnValidate()
                    begin
                        SetObjectFilters;
                        ObjectIDOnAfterValidate;
                    end;
                }
                field(PageName;ObjectName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Page Name';
                    Editable = false;
                    Enabled = PageNameEnable;
                }
            }
            repeater(Control1)
            {
                field("Object ID";"Object ID")
                {
                    ApplicationArea = Basic;
                    Caption = 'Object No.';
                    Editable = false;
                    ToolTip = 'Specifies the ID of the object that the style sheet applies to.';
                    Visible = false;
                }
                field("AllObjWithCaption.""Object Caption""";AllObjWithCaption."Object Caption")
                {
                    ApplicationArea = Basic;
                    Caption = 'Object Name';
                    Editable = false;
                }
                field(SendToProgramName;SendToProgramName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Send-to Program';
                    Editable = false;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    Caption = 'Style Sheet Name';
                    Editable = false;
                    ToolTip = 'Specifies the name of the style sheet that you want to import to another program.';
                }
                field(HasStyleSheet;"Style Sheet".Hasvalue)
                {
                    ApplicationArea = Basic;
                    Caption = 'Has Style Sheet';
                    Editable = false;
                    Visible = false;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the date that a style sheet was added to the table.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(Import)
                {
                    ApplicationArea = Basic;
                    Caption = 'Import';
                    Ellipsis = true;
                    Image = Import;

                    trigger OnAction()
                    begin
                        AddStyleSheet;
                    end;
                }
                action("E&xport")
                {
                    ApplicationArea = Basic;
                    Caption = 'E&xport';
                    Ellipsis = true;
                    Image = Export;

                    trigger OnAction()
                    var
                        AppLaunchMgt: Codeunit "Application Launch Management";
                    begin
                        AppLaunchMgt.ExportStylesheet(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if SendToProgram."Program ID" <> "Program ID" then
          if SendToProgram.Get("Program ID") then;
        SendToProgramName := SendToProgram.Name;

        if "Object ID" = 0 then begin
          AllObjWithCaption."Object ID" := 0;
          AllObjWithCaption."Object Caption" := Text001;
        end else
          if not AllObjWithCaption.Get(AllObjWithCaption."object type"::Page,"Object ID") then;
    end;

    trigger OnInit()
    begin
        PageNameEnable := true;
        PageNoEnable := true;
    end;

    trigger OnOpenPage()
    begin
        if ObjectID = 0 then
          AppliesTo := Appliesto::"All style sheets"
        else
          AppliesTo := Appliesto::"Style sheets for a specific page";
        SetObjectFilters;
    end;

    var
        SendToProgram: Record "Send-To Program";
        AllObjWithCaption: Record AllObjWithCaption;
        ObjectID: Integer;
        ObjectName: Text[80];
        SendToProgramName: Text[250];
        Text001: label '<Common to all objects>';
        Text002: label 'No style sheet has been selected.';
        Text003: label 'No application has been selected.';
        AppliesTo: Option "All style sheets","Style sheets common to all pages","Style sheets for a specific page";
        Text004: label 'You must select either Style sheets for this object only or Style sheets common to all objects.';
        [InDataSet]
        PageNoEnable: Boolean;
        [InDataSet]
        PageNameEnable: Boolean;


    procedure SetObject(NewObjectID: Integer)
    begin
        ObjectID := NewObjectID;
    end;

    local procedure SetObjectFilters()
    begin
        PageNoEnable := AppliesTo = Appliesto::"Style sheets for a specific page";
        PageNameEnable := PageNoEnable;

        FilterGroup(2);
        SetRange("Object Type","object type"::Page);
        case AppliesTo of
          Appliesto::"All style sheets":
            SetRange("Object ID");
          Appliesto::"Style sheets common to all pages":
            SetRange("Object ID",0);
          Appliesto::"Style sheets for a specific page":
            SetRange("Object ID",ObjectID);
        end;
        FilterGroup(0);
    end;

    local procedure AddStyleSheet()
    var
        StyleSheet: Record "Style Sheet";
        ImportStyleSheet: Page "Import Style Sheet";
    begin
        case AppliesTo of
          Appliesto::"Style sheets for a specific page":
            ImportStyleSheet.SetObjectID("object type"::Page,ObjectID,"Program ID");
          Appliesto::"Style sheets common to all pages":
            ImportStyleSheet.SetObjectID("object type"::Page,0,"Program ID");
          Appliesto::"All style sheets":
            Error(Text004);
        end;

        if ImportStyleSheet.RunModal = Action::OK then begin
          ImportStyleSheet.GetStyleSheet(StyleSheet);
          if IsNullGuid(StyleSheet."Program ID") then
            Error(Text003);
          StyleSheet.Insert;
          StyleSheet.CalcFields("Style Sheet");
          if not StyleSheet."Style Sheet".Hasvalue then
            Error(Text002);
        end;
    end;

    local procedure AllstylesheetsAppliesToOnAfter()
    begin
        CurrPage.Update;
    end;

    local procedure StylesheetscommAppliesToOnAfte()
    begin
        CurrPage.Update;
    end;

    local procedure StylesheetsfortAppliesToOnAfte()
    begin
        CurrPage.Update;
    end;

    local procedure ObjectIDOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure AllstylesheetsAppliesToOnValid()
    begin
        SetObjectFilters;
        AllstylesheetsAppliesToOnAfter;
    end;

    local procedure StylesheetscommAppliesToOnVali()
    begin
        SetObjectFilters;
        StylesheetscommAppliesToOnAfte;
    end;

    local procedure StylesheetsfortAppliesToOnVali()
    begin
        SetObjectFilters;
        StylesheetsfortAppliesToOnAfte;
    end;
}

