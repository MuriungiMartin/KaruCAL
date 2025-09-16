#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 363 "Electronic Document Format"
{
    ApplicationArea = Basic;
    Caption = 'Electronic Document Format';
    DelayedInsert = true;
    PageType = Worksheet;
    SourceTable = "Electronic Document Format";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(CodeFilter;ElectronicDocumentFormat.Code)
                {
                    ApplicationArea = Suite;
                    Caption = 'Code';
                    ToolTip = 'Specifies the electronic document format.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        TempElectronicDocumentFormat: Record "Electronic Document Format" temporary;
                        ElectronicDocumentFormatDefined: Record "Electronic Document Format";
                    begin
                        if not ElectronicDocumentFormatDefined.FindSet then
                          exit;

                        repeat
                          TempElectronicDocumentFormat.Init;
                          TempElectronicDocumentFormat.Code := ElectronicDocumentFormatDefined.Code;
                          TempElectronicDocumentFormat.Description := ElectronicDocumentFormatDefined.Description;
                          if TempElectronicDocumentFormat.Insert then;
                        until ElectronicDocumentFormatDefined.Next = 0;

                        if Page.RunModal(Page::"Electronic Document Formats",TempElectronicDocumentFormat) = Action::LookupOK then begin
                          ElectronicDocumentFormat.Code := TempElectronicDocumentFormat.Code;
                          SetRange(Code,ElectronicDocumentFormat.Code);
                          CurrPage.Update;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if ElectronicDocumentFormat.Code <> '' then
                          SetRange(Code,ElectronicDocumentFormat.Code)
                        else
                          SetRange(Code);

                        CurrPage.Update;
                    end;
                }
                field(UsageFilter;SelectedUsage)
                {
                    ApplicationArea = Suite;
                    Caption = 'Usage';
                    ToolTip = 'Specifies which types of documents the electronic document format is used for.';

                    trigger OnValidate()
                    begin
                        case SelectedUsage of
                          Selectedusage::" ":
                            SetRange(Usage);
                          Selectedusage::"Sales Invoice":
                            SetRange(Usage,Usage::"Sales Invoice");
                          Selectedusage::"Sales Credit Memo":
                            SetRange(Usage,Usage::"Sales Credit Memo");
                        end;

                        CurrPage.Update;
                    end;
                }
            }
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a code to identify the electronic document format in the system.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the electronic document format.';
                }
                field(Usage;Usage)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies if the electronic document format is used for sales invoices or sales credit memos.';
                }
                field("Codeunit ID";"Codeunit ID")
                {
                    ApplicationArea = Suite;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies which codeunit is used to manage electronic document sending for this document sending method.';
                }
                field("Codeunit Caption";"Codeunit Caption")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the name of the codeunit.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        ElectronicDocumentFormat.Init;
    end;

    var
        ElectronicDocumentFormat: Record "Electronic Document Format";
        SelectedUsage: Option " ","Sales Invoice","Sales Credit Memo";
}

