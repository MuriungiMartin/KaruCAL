#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1219 "Data Exch Mapping Part"
{
    Caption = 'Data Exchange Mapping';
    PageType = ListPart;
    SourceTable = "Data Exch. Mapping";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Table ID";"Table ID")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Table ID';
                    ToolTip = 'Specifies the table that holds the fields to or from which data is exchanged according to the mapping.';
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
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the ID of the No. field in the external file that is mapped to a field in Dynamics NAV.';
                }
                field("Data Exch. Line Field ID";"Data Exch. Line Field ID")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the ID of the Line field in the external file that is mapped to a field in Dynamics NAV.';
                }
            }
        }
    }

    actions
    {
    }
}

