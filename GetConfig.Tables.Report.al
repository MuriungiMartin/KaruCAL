#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 8614 "Get Config. Tables"
{
    Caption = 'Get Config. Tables';
    ProcessingOnly = true;

    dataset
    {
        dataitem(AllObj;AllObj)
        {
            DataItemTableView = where("Object Type"=const(Table),"Object ID"=filter(..1999999999|2000000004|2000000005));
            RequestFilterFields = "Object ID","Object Name";
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnPreDataItem()
            begin
                ConfigMgt.GetConfigTables(
                  AllObj,IncludeWithDataOnly,IncludeRelatedTables,IncludeDimensionTables,IncludeLicensedTablesOnly,true);
                CurrReport.Break;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(IncludeWithDataOnly;IncludeWithDataOnly)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Include With Data Only';
                    }
                    field(IncludeRelatedTables;IncludeRelatedTables)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Include Related Tables';
                        OptionCaption = 'Purchase,Sale,Positive Adjmt.,Negative Adjmt.';
                    }
                    field(IncludeDimensionTables;IncludeDimensionTables)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Include Dimension Tables';
                    }
                    field(IncludeLicensedTablesOnly;IncludeLicensedTablesOnly)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Include Licensed Tables Only';
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

    var
        ConfigMgt: Codeunit "Config. Management";
        IncludeRelatedTables: Boolean;
        IncludeDimensionTables: Boolean;
        IncludeWithDataOnly: Boolean;
        IncludeLicensedTablesOnly: Boolean;


    procedure InitializeRequest(NewIncludeWithDataOnly: Boolean;NewIncludeRelatedTables: Boolean;NewIncludeDimensionTables: Boolean;NewIncludeLicensedTablesOnly: Boolean)
    begin
        IncludeWithDataOnly := NewIncludeWithDataOnly;
        IncludeRelatedTables := NewIncludeRelatedTables;
        IncludeDimensionTables := NewIncludeDimensionTables;
        IncludeLicensedTablesOnly := NewIncludeLicensedTablesOnly;
    end;
}

