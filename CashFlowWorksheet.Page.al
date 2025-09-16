#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 841 "Cash Flow Worksheet"
{
    ApplicationArea = Basic;
    AutoSplitKey = true;
    Caption = 'Cash Flow Worksheet';
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Cash Flow Worksheet Line";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Control1000)
            {
                field("Cash Flow Date";"Cash Flow Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the cash flow date that the entry is posted to.';
                }
                field(Overdue;Overdue)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the document that represents the forecast entry.';
                }
                field("Cash Flow Forecast No.";"Cash Flow Forecast No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a number for the cash flow forecast.';

                    trigger OnValidate()
                    begin
                        CFName := CashFlowManagement.CashFlowName("Cash Flow Forecast No.");
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the worksheet.';
                }
                field("Source Type";"Source Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the source type that applies to the source number that is shown in the Source No. field.';
                }
                field("Source No.";"Source No.")
                {
                    ApplicationArea = Basic,Suite;
                    Enabled = SourceNumEnabled;
                    ToolTip = 'Specifies where the entry originated.';
                }
                field("Cash Flow Account No.";"Cash Flow Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the cash flow account.';

                    trigger OnValidate()
                    begin
                        CFAccName := CashFlowManagement.CashFlowAccountName("Cash Flow Account No.");
                    end;
                }
                field("Amount (LCY)";"Amount (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the amount of the worksheet line in $. Revenues are entered without a plus or minus sign. Expenses are entered with a minus sign.';
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2.';
                    Visible = false;
                }
                field("ShortcutDimCode[3]";ShortcutDimCode[3])
                {
                    ApplicationArea = Suite;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(3),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(3,ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]";ShortcutDimCode[4])
                {
                    ApplicationArea = Suite;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(4),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(4,ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]";ShortcutDimCode[5])
                {
                    ApplicationArea = Suite;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(5),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(5,ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]";ShortcutDimCode[6])
                {
                    ApplicationArea = Suite;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(6),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(6,ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]";ShortcutDimCode[7])
                {
                    ApplicationArea = Suite;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(7),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(7,ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]";ShortcutDimCode[8])
                {
                    ApplicationArea = Suite;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(8),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(8,ShortcutDimCode[8]);
                    end;
                }
            }
            group(Control1046)
            {
                part(ErrorMessagesPart;"Error Messages Part")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Errors and Warnings';
                }
                fixed(Control1907160701)
                {
                    group("Cash Flow Forecast Description")
                    {
                        Caption = 'Cash Flow Forecast Description';
                        field(CFName;CFName)
                        {
                            ApplicationArea = Basic,Suite;
                            Editable = false;
                            ShowCaption = false;
                        }
                    }
                    group("Cash Flow Account Name")
                    {
                        Caption = 'Cash Flow Account Name';
                        field(CFAccName;CFAccName)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Cash Flow Account Name';
                            Editable = false;
                            ToolTip = 'Specifies the name of the cash flow forecast.';
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                        CurrPage.SaveRecord;
                    end;
                }
            }
            group("&Cash Flow")
            {
                Caption = '&Cash Flow';
                Image = CashFlow;
                action(Card)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Cash Flow Forecast Card";
                    RunPageLink = "No."=field("Cash Flow Forecast No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or edit detailed information for the cash flow forecast. ';
                }
                action(Entries)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Entries';
                    Image = Entries;
                    RunObject = Page "Cash Flow Forecast Entries";
                    RunPageLink = "Cash Flow Forecast No."=field("Cash Flow Forecast No.");
                    RunPageView = sorting("Cash Flow Forecast No.","Cash Flow Date");
                    ShortCutKey = 'Ctrl+F7';
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(SuggestWorksheetLines)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Suggest Worksheet Lines';
                    Ellipsis = true;
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+Ctrl+F';
                    ToolTip = 'Transfer information from the areas of general ledger, purchasing, sales, service, fixed assets, manual revenues, and manual expenses to the cash flow worksheet. You use the batch job to make a cash flow forecast.';

                    trigger OnAction()
                    begin
                        DeleteErrors;
                        SuggestWkshLines.RunModal;
                        Clear(SuggestWkshLines);
                    end;
                }
            }
            group(ActionGroup1051)
            {
                Caption = 'Register';
                Image = Approve;
                action(Register)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Register';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Cash Flow Wksh. - Register",Rec);
                        CurrPage.Update(false);
                    end;
                }
            }
            action(ShowSource)
            {
                ApplicationArea = Basic,Suite;
                Caption = '&Show';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunPageMode = View;
                ToolTip = 'View the actual cash flow forecast entries.';

                trigger OnAction()
                begin
                    ShowSource;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        ShowErrors;
        CFName := CashFlowManagement.CashFlowName("Cash Flow Forecast No.");
        CFAccName := CashFlowManagement.CashFlowAccountName("Cash Flow Account No.");
    end;

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
        SourceNumEnabled := "Source Type" <> "source type"::Tax;
    end;

    trigger OnClosePage()
    begin
        DeleteErrors;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        CFName := '';
        CFAccName := '';
    end;

    trigger OnOpenPage()
    begin
        DeleteErrors;
    end;

    var
        SuggestWkshLines: Report "Suggest Worksheet Lines";
        CashFlowManagement: Codeunit "Cash Flow Management";
        ShortcutDimCode: array [8] of Code[20];
        CFName: Text[50];
        CFAccName: Text[50];
        SourceNumEnabled: Boolean;

    local procedure ShowErrors()
    var
        CashFlowSetup: Record "Cash Flow Setup";
        ErrorMessage: Record "Error Message";
        TempErrorMessage: Record "Error Message" temporary;
    begin
        if CashFlowSetup.Get then begin
          ErrorMessage.SetRange("Context Record ID",CashFlowSetup.RecordId);
          ErrorMessage.CopyToTemp(TempErrorMessage);
          CurrPage.ErrorMessagesPart.Page.SetRecords(TempErrorMessage);
          CurrPage.ErrorMessagesPart.Page.Update;
        end;
    end;

    local procedure DeleteErrors()
    var
        CashFlowSetup: Record "Cash Flow Setup";
        ErrorMessage: Record "Error Message";
    begin
        if CashFlowSetup.Get then begin
          ErrorMessage.SetRange("Context Record ID",CashFlowSetup.RecordId);
          if ErrorMessage.FindFirst then
            ErrorMessage.DeleteAll(true);
          Commit;
        end;
    end;
}

