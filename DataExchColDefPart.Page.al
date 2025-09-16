#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1216 "Data Exch Col Def Part"
{
    Caption = 'Column Definitions';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Data Exch. Column Def";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Column No.";"Column No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number that reflects the column''s position on the line in the file.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the column.';
                }
                field("Data Type";"Data Type")
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = true;
                    ToolTip = 'Specifies if the data to be exchanged is of type Text, Date, or Decimal.';

                    trigger OnValidate()
                    begin
                        DataFormatRequired := IsDataFormatRequired;
                        DataFormattingCultureRequired := IsDataFormattingCultureRequired;
                    end;
                }
                field("Data Format";"Data Format")
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = DataFormatRequired;
                    ToolTip = 'Specifies the format of the data, if any. For example, MM-dd-yyyy if the data type is Date.';
                }
                field("Data Formatting Culture";"Data Formatting Culture")
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = DataFormattingCultureRequired;
                    ToolTip = 'Specifies the culture of the data format, if any. For example, en-US if the data type is Decimal to ensure that comma is used as the .000 separator, according to the US format. This field is only relevant for import.';
                }
                field(Length;Length)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the length of the fixed-width line that holds the column if the file is of type Fixed Text.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the column, for informational purposes.';
                }
                field(Path;Path)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the position of the element in the related XML schema.';
                }
                field("Negative-Sign Identifier";"Negative-Sign Identifier")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the value that is used in the data file to identify negative amounts, in data files that cannot contain negative signs. This identifier is then used to reverse the identified amounts to negative signs during import.';
                }
                field(Constant;Constant)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies any data that you want to export in this column, such as extra information about the payment type.';
                }
                field(Show;Show)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'There is no Help for the fields in this table. This object supports the Microsoft Dynamics NAV infrastructure and is intended only for internal use.';
                    Visible = false;
                }
                field("Text Padding Required";"Text Padding Required")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that the data must include text padding.';
                }
                field("Pad Character";"Pad Character")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that text padding.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(GetFileStructure)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Get File Structure';
                Ellipsis = true;
                ToolTip = 'Prefill the lines of the column definitions according to the structure of a data file on your computer or network.';

                trigger OnAction()
                begin
                    GetStructure;
                end;
            }
        }
    }

    var
        DataFormatRequired: Boolean;
        DataFormattingCultureRequired: Boolean;

    local procedure GetStructure()
    var
        DataExchLineDef: Record "Data Exch. Line Def";
        GetFileStructure: Report "Get File Structure";
    begin
        DataExchLineDef.Get("Data Exch. Def Code","Data Exch. Line Def Code");
        GetFileStructure.Initialize(DataExchLineDef);
        GetFileStructure.RunModal;
    end;
}

