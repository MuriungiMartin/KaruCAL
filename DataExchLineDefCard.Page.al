#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1212 "Data Exch Line Def Card"
{
    Caption = 'Line Definitions';
    PageType = Document;
    SourceTable = "Data Exch. Line Def";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Data Exch. Def Code";"Data Exch. Def Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a code that identifies the data exchange definition.';
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
                field(Namespace;Namespace)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = IsXMLFileType and IsBankStatementImportType;
                    ToolTip = 'Specifies the namespace (uniform resource name (urn)) for a target document that is expected in the file for validation. You can leave the field blank if you do not want to enable namespace validation.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    var
        DataExchDef: Record "Data Exch. Def";
    begin
        DataExchDef.Get("Data Exch. Def Code");
        IsBankStatementImportType := DataExchDef.CheckEnableDisableIsBankStatementImportType;
        IsXMLFileType := not DataExchDef.CheckEnableDisableIsNonXMLFileType;
        if (not IsXMLFileType) or (not IsBankStatementImportType) then
          Namespace := '';
    end;

    var
        IsBankStatementImportType: Boolean;
        IsXMLFileType: Boolean;
}

