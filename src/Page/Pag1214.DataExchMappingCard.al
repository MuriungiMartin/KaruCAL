#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1214 "Data Exch Mapping Card"
{
    Caption = 'Field Mapping';
    DelayedInsert = true;
    PageType = Document;
    SourceTable = "Data Exch. Mapping";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Table ID";"Table ID")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Table ID';
                    ToolTip = 'Specifies the table that holds the fields to or from which data is exchanged according to the mapping.';

                    trigger OnValidate()
                    begin
                        PositivePayUpdateCodeunits;
                        CurrPage.Update;
                    end;
                }
                field("Use as Intermediate Table";"Use as Intermediate Table")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that the table that you select in the Table ID field is an intermediate table where the imported data is stored before it is mapped to the target table.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the data exchange mapping setup.';
                }
                field("Pre-Mapping Codeunit";"Pre-Mapping Codeunit")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the codeunit that prepares the mapping between fields in Microsoft Dynamics NAV and external data.';
                }
                field("Mapping Codeunit";"Mapping Codeunit")
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the codeunit that is used to map the specified columns or XML data elements to fields in Microsoft Dynamics NAV.';
                }
                field("Post-Mapping Codeunit";"Post-Mapping Codeunit")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the codeunit that completes the mapping between fields in Microsoft Dynamics NAV and the external data file or service.';
                }
                field("Data Exch. No. Field ID";"Data Exch. No. Field ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID. This field is intended only for internal use.';
                    Visible = false;
                }
                field("Data Exch. Line Field ID";"Data Exch. Line Field ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID. This field is intended only for internal use.';
                    Visible = false;
                }
            }
            part(Control10;"Data Exch Field Mapping Part")
            {
                ApplicationArea = All;
                Caption = 'Field Mapping';
                SubPageLink = "Data Exch. Def Code"=field("Data Exch. Def Code"),
                              "Data Exch. Line Def Code"=field("Data Exch. Line Def Code"),
                              "Table ID"=field("Table ID");
                Visible = not "Use as Intermediate Table";
            }
            part(Control12;"Generic Data Exch Fld Mapping")
            {
                ApplicationArea = All;
                Caption = 'Field Mapping';
                SubPageLink = "Data Exch. Def Code"=field("Data Exch. Def Code"),
                              "Data Exch. Line Def Code"=field("Data Exch. Line Def Code"),
                              "Table ID"=field("Table ID");
                Visible = "Use as Intermediate Table";
            }
        }
    }

    actions
    {
    }
}

