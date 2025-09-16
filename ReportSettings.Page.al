#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1560 "Report Settings"
{
    // // RENAME does not work when primary key contains an option field, in this case "Object Type".
    // // Therefore DELETE / INSERT is needed as "User Name" is part of the primary key.

    ApplicationArea = Basic;
    Caption = 'Report Settings';
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Manage';
    ShowFilter = false;
    SourceTable = "Object Options";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name;"Parameter Name")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Name';
                    ToolTip = 'Specifies the name of the settings entry.';
                }
                field("Report ID";"Object ID")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Report ID';
                    MinValue = 1;
                    TableRelation = if ("Object Type"=const(Report)) "Report Metadata".ID;
                    ToolTip = 'Specifies the ID of the report that uses the settings.';

                    trigger OnValidate()
                    begin
                        ValidateObjectID;
                        LookupObjectName("Object ID","Object Type");
                    end;
                }
                field("Report Name";ReportName)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Report Name';
                    Editable = false;
                    ToolTip = 'Specifies the name of the report that uses the settings.';
                }
                field("User Name";"User Name")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Assigned to';
                    Enabled = notLastUsed;
                    TableRelation = User."User Name";
                    ToolTip = 'Specifies who can use the report settings. If the field is blank, the settings are available to all users.';

                    trigger OnValidate()
                    begin
                        if "User Name" <> '' then
                          "Public Visible" := false
                        else
                          "Public Visible" := true;
                    end;
                }
                field("Created By";"Created By")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Created by';
                    Editable = false;
                    TableRelation = User."User Name";
                    ToolTip = 'Specifies the name of the user who created the settings.';
                }
                field("Public Visible";"Public Visible")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Shared with all users';
                    Enabled = notLastUsed;
                    ToolTip = 'Specifies whether the report settings are available to all users or only the user assigned to the settings.';

                    trigger OnValidate()
                    begin
                        if "User Name" = '' then
                          "User Name" := "Created By"
                        else
                          "User Name" := '';
                    end;
                }
                field("Company Name";"Company Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the company to which the settings belong.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Copy)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Copy';
                Image = Copy;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedOnly = true;
                ToolTip = 'Make a copy the selected report settings.';

                trigger OnAction()
                var
                    ObjectOptions: Record "Object Options";
                begin
                    if "Option Data".Hasvalue then
                      CalcFields("Option Data");

                    ObjectOptions.TransferFields(Rec);
                    ObjectOptions."Parameter Name" := StrSubstNo(CopyTxt,"Parameter Name");
                    ObjectOptions.Insert;
                end;
            }
            action(Modify)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Modify';
                Enabled = notLastUsed;
                Image = Edit;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedOnly = true;
                ToolTip = 'Change the options and filters that are defined for the selected report settings.';

                trigger OnAction()
                var
                    InStream: InStream;
                    OutStream: OutStream;
                    xmlString: Text;
                begin
                    if "Option Data".Hasvalue then begin
                      CalcFields("Option Data");
                      "Option Data".CreateInstream(InStream,Textencoding::UTF8);
                      InStream.ReadText(xmlString);
                    end;

                    xmlString := Report.RunRequestPage("Object ID",xmlString);
                    if xmlString <> '' then begin
                      Clear("Option Data");
                      "Option Data".CreateOutstream(OutStream);
                      OutStream.WriteText(xmlString);
                      Modify;
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        notLastUsed := "Parameter Name" <> LastUsedTxt;
    end;

    trigger OnAfterGetRecord()
    begin
        LookupObjectName("Object ID","Object Type");
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Object Type" := "object type"::Report;
        "Company Name" := COMPANYNAME;
        "User Name" := UserId;
        "Created By" := UserId;
    end;

    var
        CopyTxt: label 'Copy of %1', Comment='%1 is the Parameter Name field from the Object Options record';
        LastUsedTxt: label 'Last used options and filters', Comment='Translation must match RequestPageLatestSavedSettingsName from Lang.resx';
        notLastUsed: Boolean;
        ObjectIdValidationErr: label 'The specified object ID is not valid; the object must exist in the application.';
        ReportName: Text;

    local procedure ValidateObjectID()
    var
        ObjectMetadata: Record "Object Metadata";
    begin
        if ("Object ID" = 0) or (not ObjectMetadata.Get("Object Type","Object ID")) then
          Error(ObjectIdValidationErr);
    end;

    local procedure LookupObjectName(ObjectID: Integer;ObjectType: Option)
    var
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        AllObjWithCaption.SetRange("Object ID",ObjectID);
        AllObjWithCaption.SetRange("Object Type",ObjectType);
        if AllObjWithCaption.FindFirst then
          ReportName := AllObjWithCaption."Object Caption";
    end;


    procedure GetLastUsedTxt(): Text
    begin
        exit(LastUsedTxt);
    end;
}

