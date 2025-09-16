#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 740 "VAT Report"
{
    Caption = 'Tax Report';
    PageType = Document;
    SourceTable = "VAT Report Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the unique number for the tax report.';

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field("VAT Report Config. Code";"VAT Report Config. Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the appropriate configuration code.';
                }
                field("VAT Report Type";"VAT Report Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the tax report is a standard report, or if it is related to a previously submitted tax report.';
                }
                field("Original Report No.";"Original Report No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the original tax report if the Tax Report Type field is set to a value other than Standard.';
                }
                field("Start Date";"Start Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the start date of the report period for the Tax report.';
                }
                field("End Date";"End Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the end date of the report period for the Tax report.';
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the status of the Tax report.';
                }
            }
            part(VATReportLines;"VAT Report Subform")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "VAT Report No."=field("No.");
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
                action(SuggestLines)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Suggest Lines';
                    Image = SuggestLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Suggest Tax lines.';

                    trigger OnAction()
                    begin
                        VATReportMediator.GetLines(Rec);
                    end;
                }
                separator(Action23)
                {
                }
                action("&Release")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Release';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+F9';
                    ToolTip = 'Release the Tax report to indicate that it has been printed or exported. The status then changes to Released.';

                    trigger OnAction()
                    begin
                        VATReportMediator.Release(Rec);
                    end;
                }
                action("Mark as Su&bmitted")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Mark as Su&bmitted';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Mark the lines for submission to the Tax authorities.';

                    trigger OnAction()
                    begin
                        VATReportMediator.Submit(Rec);
                    end;
                }
                action("Re&open")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Re&open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Reopen the Tax report to indicate that it must be printed or exported again, for example because it has been corrected.';

                    trigger OnAction()
                    begin
                        VATReportMediator.Reopen(Rec);
                    end;
                }
                separator(Action26)
                {
                }
                action("&Export")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Export';
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Export the Tax report.';

                    trigger OnAction()
                    begin
                        VATReportMediator.Export(Rec);
                    end;
                }
            }
            action("&Print")
            {
                ApplicationArea = Basic,Suite;
                Caption = '&Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                begin
                    VATReportMediator.Print(Rec);
                end;
            }
        }
    }

    var
        VATReportMediator: Codeunit "VAT Report Mediator";
}

