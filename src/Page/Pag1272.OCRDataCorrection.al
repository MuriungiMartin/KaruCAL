#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1272 "OCR Data Correction"
{
    Caption = 'OCR Data Correction';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "Incoming Document";

    layout
    {
        area(content)
        {
            group(Control35)
            {
                grid(Control2)
                {
                    group(Control16)
                    {
                        field("Vendor Name";"Vendor Name")
                        {
                            ApplicationArea = Basic,Suite;
                            ShowMandatory = true;
                            ToolTip = 'Specifies the name of the vendor on the incoming document. The field may be filled automatically.';
                        }
                        field("Vendor VAT Registration No.";"Vendor VAT Registration No.")
                        {
                            ApplicationArea = Basic,Suite;
                            ToolTip = 'Specifies the tax registration number of the vendor, if the document contains that number. The field may be filled automatically.';
                        }
                        field("Vendor IBAN";"Vendor IBAN")
                        {
                            ApplicationArea = Basic,Suite;
                            ToolTip = 'Specifies the new value that you want the OCR service to produce for this field going forward.';
                        }
                        field("Vendor Bank Branch No.";"Vendor Bank Branch No.")
                        {
                            ApplicationArea = Basic,Suite;
                            ToolTip = 'Specifies the new value that you want the OCR service to produce for this field going forward.';
                        }
                        field("Vendor Bank Account No.";"Vendor Bank Account No.")
                        {
                            ApplicationArea = Basic,Suite;
                            ToolTip = 'Specifies the new value that you want the OCR service to produce for this field going forward.';
                        }
                        field("Vendor Phone No.";"Vendor Phone No.")
                        {
                            ApplicationArea = Basic,Suite;
                            ToolTip = 'Specifies the new value that you want the OCR service to produce for this field going forward.';
                        }
                        field("Vendor Invoice No.";"Vendor Invoice No.")
                        {
                            ApplicationArea = Basic,Suite;
                            ToolTip = 'Specifies the invoice number, if the document contains that number. The field may be filled automatically.';
                        }
                        field("Order No.";"Order No.")
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Vendor Order No.';
                            ToolTip = 'Specifies the order number, if the document contains that number. The field may be filled automatically.';
                        }
                        field("Document Date";"Document Date")
                        {
                            ApplicationArea = Basic,Suite;
                            ToolTip = 'Specifies the date that is printed on the incoming document. This is the date when the vendor created the invoice, for example. The field may be filled automatically.';
                        }
                        field("Due Date";"Due Date")
                        {
                            ApplicationArea = Basic,Suite;
                            ToolTip = 'Specifies the date when the vendor document must be paid. The field may be filled automatically.';
                        }
                        field("Currency Code";"Currency Code")
                        {
                            ApplicationArea = Suite;
                            ToolTip = 'Specifies the currency code, if the document contains that code. The field may be filled automatically.';
                        }
                        field("Amount Incl. VAT";"Amount Incl. VAT")
                        {
                            ApplicationArea = Basic,Suite;
                            ToolTip = 'Specifies the amount including tax for the whole document. The field may be filled automatically.';
                        }
                        field("Amount Excl. VAT";"Amount Excl. VAT")
                        {
                            ApplicationArea = Basic,Suite;
                            ToolTip = 'Specifies the amount excluding tax for the whole document. The field may be filled automatically.';
                        }
                        field("VAT Amount";"VAT Amount")
                        {
                            ApplicationArea = Basic,Suite;
                            ToolTip = 'Specifies the total tax on the purchase document represented by the incoming document record.';
                        }
                    }
                    group(Control18)
                    {
                        field("TempOriginalIncomingDocument.""Vendor Name""";TempOriginalIncomingDocument."Vendor Name")
                        {
                            ApplicationArea = Basic,Suite;
                            Editable = false;
                            ToolTip = 'Specifies the existing value that the OCR service produces for this field.';
                        }
                        field("TempOriginalIncomingDocument.""Vendor VAT Registration No.""";TempOriginalIncomingDocument."Vendor VAT Registration No.")
                        {
                            ApplicationArea = Basic,Suite;
                            Editable = false;
                            ToolTip = 'Specifies the existing value that the OCR service produces for this field.';
                        }
                        field("TempOriginalIncomingDocument.""Vendor IBAN""";TempOriginalIncomingDocument."Vendor IBAN")
                        {
                            ApplicationArea = Basic,Suite;
                            Editable = false;
                            ToolTip = 'Specifies the existing value that the OCR service produces for this field.';
                        }
                        field("TempOriginalIncomingDocument.""Vendor Bank Branch No.""";TempOriginalIncomingDocument."Vendor Bank Branch No.")
                        {
                            ApplicationArea = Basic,Suite;
                            Editable = false;
                            ToolTip = 'Specifies the existing value that the OCR service produces for this field.';
                        }
                        field("TempOriginalIncomingDocument.""Vendor Bank Account No.""";TempOriginalIncomingDocument."Vendor Bank Account No.")
                        {
                            ApplicationArea = Basic,Suite;
                            Editable = false;
                            ToolTip = 'Specifies the existing value that the OCR service produces for this field.';
                        }
                        field("TempOriginalIncomingDocument.""Vendor Phone No.""";TempOriginalIncomingDocument."Vendor Phone No.")
                        {
                            ApplicationArea = Basic,Suite;
                            ToolTip = 'Specifies the existing value that the OCR service produces for this field.';
                        }
                        field("TempOriginalIncomingDocument.""Vendor Invoice No.""";TempOriginalIncomingDocument."Vendor Invoice No.")
                        {
                            ApplicationArea = Basic,Suite;
                            Editable = false;
                            ToolTip = 'Specifies the existing value that the OCR service produces for this field.';
                        }
                        field("TempOriginalIncomingDocument.""Order No.""";TempOriginalIncomingDocument."Order No.")
                        {
                            ApplicationArea = Basic,Suite;
                            Editable = false;
                            ToolTip = 'Specifies the existing value that the OCR service produces for this field.';
                        }
                        field("TempOriginalIncomingDocument.""Document Date""";TempOriginalIncomingDocument."Document Date")
                        {
                            ApplicationArea = Basic,Suite;
                            Editable = false;
                            ToolTip = 'Specifies the existing value that the OCR service produces for this field.';
                        }
                        field("TempOriginalIncomingDocument.""Due Date""";TempOriginalIncomingDocument."Due Date")
                        {
                            ApplicationArea = Basic,Suite;
                            Editable = false;
                            ToolTip = 'Specifies the existing value that the OCR service produces for this field.';
                        }
                        field("TempOriginalIncomingDocument.""Currency Code""";TempOriginalIncomingDocument."Currency Code")
                        {
                            ApplicationArea = Suite;
                            Editable = false;
                            ToolTip = 'Specifies the existing value that the OCR service produces for this field.';
                        }
                        field("TempOriginalIncomingDocument.""Amount Incl. VAT""";TempOriginalIncomingDocument."Amount Incl. VAT")
                        {
                            ApplicationArea = Basic,Suite;
                            Editable = false;
                            ToolTip = 'Specifies the existing value that the OCR service produces for this field.';
                        }
                        field("TempOriginalIncomingDocument.""Amount Excl. VAT""";TempOriginalIncomingDocument."Amount Excl. VAT")
                        {
                            ApplicationArea = Basic,Suite;
                            Editable = false;
                            ToolTip = 'Specifies the existing value that the OCR service produces for this field.';
                        }
                        field("TempOriginalIncomingDocument.""VAT Amount""";TempOriginalIncomingDocument."VAT Amount")
                        {
                            ApplicationArea = Basic,Suite;
                            Editable = false;
                            ToolTip = 'Specifies the existing value that the OCR service produces for this field.';
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Reset OCR Data")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Reset OCR Data';
                Image = Reuse;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Undo corrections that you have made since you opened the OCR Data Correction window.';

                trigger OnAction()
                begin
                    ResetOriginalOCRData
                end;
            }
            action("Send OCR Feedback")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Send OCR Feedback';
                Image = Undo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Send the corrections to the OCR service. The corrections will be included PDF or image files that contain the data the next time the service processes.';

                trigger OnAction()
                begin
                    if UploadCorrectedOCRData then
                      CurrPage.Close;
                end;
            }
            action(ShowFile)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Show File';
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Open the PDF or image file to see the corrections that you have made.';

                trigger OnAction()
                begin
                    ShowMainAttachment
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        TempOriginalIncomingDocument := Rec;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        "OCR Data Corrected" := true;
        Modify;
        exit(false)
    end;

    var
        TempOriginalIncomingDocument: Record "Incoming Document" temporary;
}

