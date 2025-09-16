#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1215 "Data Exch Line Def Part"
{
    Caption = 'Line Definitions';
    CardPageID = "Data Exch Mapping Card";
    PageType = ListPart;
    SourceTable = "Data Exch. Line Def";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Group';
                field("Line Type";"Line Type")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Line Type';
                    ToolTip = 'Specifies the type of the line in the file.';
                }
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the line in the file.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the mapping setup.';
                }
                field("Column Count";"Column Count")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies how many columns the line in the bank statement file has.';
                }
                field("Data Line Tag";"Data Line Tag")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the position in the related XML schema of the element that represents the main entry of the data file.';
                }
                field(Namespace;Namespace)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = IsXMLFileType;
                    ToolTip = 'Specifies the namespace (uniform resource name (urn)) for a target document that is expected in the file for validation. You can leave the field blank if you do not want to enable namespace validation.';
                }
                field("Parent Code";"Parent Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the parent of the child that is specified in the Code field in cases where the data exchange setup is for files with parent and children entries, such as a document header and lines.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Field Mapping")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Field Mapping';
                Image = MapAccounts;
                Promoted = false;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;
                RunObject = Page "Data Exch Mapping Card";
                RunPageLink = "Data Exch. Def Code"=field("Data Exch. Def Code"),
                              "Data Exch. Line Def Code"=field(Code);
                RunPageMode = Edit;
                ToolTip = 'Associates columns in the data file with fields in Dynamics NAV.';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        DataExchDef: Record "Data Exch. Def";
    begin
        if "Data Exch. Def Code" <> '' then begin
          DataExchDef.Get("Data Exch. Def Code");
          IsXMLFileType := not DataExchDef.CheckEnableDisableIsNonXMLFileType;
        end;
    end;

    var
        IsXMLFileType: Boolean;
}

